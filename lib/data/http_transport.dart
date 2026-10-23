// Minimal HTTP GET transport on dart:io (no third-party dependency).
// Kept separate from JSON parsing so the API repository can be tested with a
// fake transport and no network.
import 'dart:async';
import 'dart:convert';
import 'dart:io';

/// A fully read HTTP response.
class HttpResult {
  final int statusCode;

  /// MIME type without parameters, lower-case (e.g. `application/json`), or null.
  final String? mimeType;
  final String body;
  const HttpResult(this.statusCode, this.body, {this.mimeType});
}

/// Why a request produced no response.
enum TransportFailure { network, timeout }

class TransportException implements Exception {
  final TransportFailure failure;

  /// Developer-facing detail (exception type only; never the URL or query).
  final String message;
  const TransportException(this.failure, this.message);

  @override
  String toString() => 'TransportException(${failure.name}): $message';
}

abstract interface class HttpTransport {
  /// GETs [uri] and reads the whole body as UTF-8. Fails with
  /// [TransportException] when no complete response arrives, and with
  /// [FormatException] when the body is not valid UTF-8.
  Future<HttpResult> get(Uri uri);

  void close();
}

/// [HttpTransport] backed by [HttpClient].
///
/// Two separate limits:
/// - [connectTimeout]: establishing the TCP/TLS connection
///   ([HttpClient.connectionTimeout]).
/// - [responseTimeout]: from sending the request until the whole body is read
///   (covers a server that accepts the connection but answers slowly).
class IoHttpTransport implements HttpTransport {
  IoHttpTransport({
    HttpClient? client,
    this.connectTimeout = const Duration(seconds: 5),
    this.responseTimeout = const Duration(seconds: 10),
  }) : _client = client ?? HttpClient() {
    _client.connectionTimeout = connectTimeout;
  }

  final HttpClient _client;
  final Duration connectTimeout, responseTimeout;
  bool _closed = false;

  @override
  Future<HttpResult> get(Uri uri) async {
    if (_closed) throw StateError('IoHttpTransport is closed');
    HttpClientRequest? request;
    try {
      request = await _client.getUrl(uri);
      request.headers.set(HttpHeaders.acceptHeader, 'application/json');
      final pending = request;
      return await () async {
        final response = await pending.close();
        final body = await response.transform(utf8.decoder).join();
        return HttpResult(response.statusCode, body, mimeType: response.headers.contentType?.mimeType.toLowerCase());
      }().timeout(responseTimeout);
    } on TimeoutException {
      request?.abort();
      throw const TransportException(TransportFailure.timeout, 'no response in time');
    } on SocketException catch (e) {
      // Connection timeouts surface as SocketException as well.
      final timedOut = e.message.toLowerCase().contains('timed out');
      throw TransportException(timedOut ? TransportFailure.timeout : TransportFailure.network, 'SocketException');
    } on HandshakeException {
      throw const TransportException(TransportFailure.network, 'HandshakeException');
    } on HttpException {
      throw const TransportException(TransportFailure.network, 'HttpException');
    }
  }

  @override
  void close() {
    if (_closed) return;
    _closed = true;
    _client.close(force: true);
  }
}
