import 'dart:convert';

import 'design_data.dart';
import 'dream_json_parser.dart';
import 'dream_repository.dart';
import 'http_transport.dart';

/// [DreamRepository] backed by the NestJS API.
///
/// [baseUrl] is the versioned API root, e.g. `http://10.0.2.2:3000/api/v1`;
/// resource paths (`dreams`, `dream-categories`) are appended to it.
/// Failures are never replaced by sample data.
class ApiDreamRepository implements DreamRepository {
  ApiDreamRepository(Uri baseUrl, {HttpTransport? transport})
    : baseUrl = checkBaseUrl(baseUrl),
      _transport = transport ?? IoHttpTransport();

  final Uri baseUrl;
  final HttpTransport _transport;
  List<DreamCategory>? _categories;

  /// Validates an API base URL: absolute http(s) with a host, no query or
  /// fragment, no credentials, and a path ending in `/api/v1` with `/api/v1`
  /// appearing only once. Returns it without a trailing slash.
  static Uri checkBaseUrl(Uri url) {
    if (!(url.isScheme('http') || url.isScheme('https')) || url.host.isEmpty) {
      throw const FormatException('API_BASE_URL must be an absolute http(s) URL with a host');
    }
    if (url.hasQuery || url.hasFragment || url.userInfo.isNotEmpty) {
      throw const FormatException('API_BASE_URL must not contain a query, fragment or credentials');
    }
    final segments = url.pathSegments.where((s) => s.isNotEmpty).toList();
    var versions = 0;
    for (var i = 0; i + 1 < segments.length; i++) {
      if (segments[i] == 'api' && segments[i + 1] == 'v1') versions++;
    }
    final endsWithVersion = segments.length >= 2 && segments[segments.length - 2] == 'api' && segments.last == 'v1';
    if (!endsWithVersion || versions != 1) {
      throw const FormatException('API_BASE_URL must end with /api/v1 (and contain it only once)');
    }
    return url.replace(pathSegments: segments);
  }

  @override
  bool get isRemote => true;

  Uri _uri(List<String> path, [Map<String, String>? query]) => baseUrl.replace(
    pathSegments: [...baseUrl.pathSegments, ...path],
    queryParameters: query == null || query.isEmpty ? null : query,
  );

  /// Categories rarely change; a successful answer is kept for the app's lifetime.
  @override
  Future<List<DreamCategory>> categories() async =>
      _categories ??= List.unmodifiable(await _get(_uri(['dream-categories']), parseCategoryList));

  @override
  Future<DreamPage> list({String? q, String? categoryId, int page = 1, int limit = DreamRepository.defaultPageSize}) {
    final query = q?.trim() ?? '';
    return _get(
      _uri(
        ['dreams'],
        {
          if (page != 1) 'page': '$page',
          if (limit != DreamRepository.defaultPageSize) 'limit': '$limit',
          if (query.isNotEmpty) 'q': query,
          'category': ?categoryId,
        },
      ),
      parseDreamPage,
    );
  }

  @override
  Future<Dream?> byId(String id) async {
    try {
      return await _get(_uri(['dreams', id]), parseDreamDetail);
    } on DreamRepositoryException catch (e) {
      if (e.code == 'DREAM_NOT_FOUND') return null;
      rethrow;
    }
  }

  @override
  void close() => _transport.close();

  Future<T> _get<T>(Uri uri, T Function(Object? json) parse) async {
    final HttpResult res;
    try {
      res = await _transport.get(uri);
    } on TransportException catch (e) {
      throw DreamRepositoryException(
        e.failure == TransportFailure.timeout ? DreamRepositoryErrorKind.timeout : DreamRepositoryErrorKind.network,
        e.message,
      );
    } on FormatException {
      throw const DreamRepositoryException(DreamRepositoryErrorKind.badResponse, 'response is not valid UTF-8');
    } catch (e) {
      throw DreamRepositoryException(DreamRepositoryErrorKind.unexpected, e.runtimeType.toString());
    }

    final status = res.statusCode;
    Object? json;
    var isJson = false;
    if (res.mimeType == 'application/json') {
      try {
        json = jsonDecode(res.body);
        isJson = true;
      } on FormatException {
        isJson = false;
      }
    }
    if (status >= 200 && status < 300) {
      if (!isJson) {
        throw DreamRepositoryException(
          DreamRepositoryErrorKind.badResponse,
          'expected JSON (got ${res.mimeType ?? 'no content type'})',
          statusCode: status,
        );
      }
      try {
        return parse(json);
      } on DreamJsonException catch (e) {
        throw DreamRepositoryException(DreamRepositoryErrorKind.badResponse, e.toString(), statusCode: status);
      }
    }
    final code = isJson ? parseErrorCode(json) : null;
    final kind = switch (status) {
      400 || 422 => DreamRepositoryErrorKind.invalidRequest,
      404 => DreamRepositoryErrorKind.notFound,
      408 => DreamRepositoryErrorKind.timeout,
      >= 500 => DreamRepositoryErrorKind.server,
      _ => DreamRepositoryErrorKind.unexpected,
    };
    throw DreamRepositoryException(kind, 'HTTP $status', statusCode: status, code: code);
  }
}
