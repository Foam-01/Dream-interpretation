// I2: ApiDreamRepository + JSON parsing against the backend contract
// (backend/src/dreams/dto/dream-response.dto.ts). Uses a fake transport, or a
// loopback HttpServer for the dart:io transport; never the internet.
import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:maha_dream/data/api_dream_repository.dart';
import 'package:maha_dream/data/dream_repository.dart';
import 'package:maha_dream/data/http_transport.dart';

class FakeTransport implements HttpTransport {
  final requests = <Uri>[];
  FutureOr<HttpResult> Function(Uri uri) handler;
  bool closed = false;
  FakeTransport(this.handler);

  @override
  Future<HttpResult> get(Uri uri) async {
    requests.add(uri);
    return handler(uri);
  }

  @override
  void close() => closed = true;
}

HttpResult json(int status, Object body) => HttpResult(status, jsonEncode(body), mimeType: 'application/json');

Map<String, Object?> summary({
  String id = 'tooth-falling-out',
  Object? two = const ['08', '80'],
  Object? three = const ['098', '809'],
}) => {
  'id': id,
  'name': 'ฟันหลุด',
  'category': {'id': 'body', 'name': 'ร่างกาย'},
  'short': 'ระวังเรื่องญาติผู้ใหญ่ สุขภาพ',
  'isGoodOmen': false,
  'numbers': {'twoDigit': two, 'threeDigit': three},
  'contentStatus': 'SAMPLE',
};

Map<String, Object?> detail({Map<String, Object?>? luck}) => {
  ...summary(),
  'meaning': 'ฝันว่าฟันหลุด ตำราว่าเป็นลางเตือน',
  'advice': 'ตื่นเช้าให้บ้วนน้ำลายลงดิน',
  'digits': ['0', '8'],
  'luckForecast': luck ?? {'money': 45, 'love': 40, 'health': 58},
};

Map<String, Object?> page(List<Object?> data, {int page = 1, int limit = 20, int? total, int? totalPages}) {
  final t = total ?? data.length;
  return {
    'data': data,
    'meta': <String, Object?>{
      'page': page,
      'limit': limit,
      'total': t,
      'totalPages': totalPages ?? (t == 0 ? 0 : (t + limit - 1) ~/ limit),
    },
  };
}

final base = Uri.parse('http://10.0.2.2:3000/api/v1');

ApiDreamRepository repoWith(FakeTransport t) => ApiDreamRepository(base, transport: t);

Matcher fails(DreamRepositoryErrorKind kind, {String? code, int? status}) => throwsA(
  isA<DreamRepositoryException>()
      .having((e) => e.kind, 'kind', kind)
      .having((e) => e.code, 'code', code)
      .having((e) => e.statusCode, 'statusCode', status),
);

void main() {
  group('requests', () {
    test('list builds the URL under the versioned base with encoded query', () async {
      final t = FakeTransport((_) => json(200, page([])));
      final repo = repoWith(t);
      await repo.list();
      await repo.list(q: '  งู ใหญ่ ', categoryId: 'animal', page: 2, limit: 5);
      expect(t.requests[0].toString(), 'http://10.0.2.2:3000/api/v1/dreams');
      final u = t.requests[1];
      expect(u.path, '/api/v1/dreams');
      expect(u.queryParameters, {'page': '2', 'limit': '5', 'q': 'งู ใหญ่', 'category': 'animal'});
      expect(u.toString(), contains('q=%E0%B8%87%E0%B8%B9+%E0%B9%83%E0%B8%AB%E0%B8%8D%E0%B9%88'));
    });

    test('blank query is not sent', () async {
      final t = FakeTransport((_) => json(200, page([])));
      await repoWith(t).list(q: '   ');
      expect(t.requests.single.hasQuery, isFalse);
    });

    test('detail encodes the id as one path segment', () async {
      final t = FakeTransport(
        (_) => json(404, {
          'error': {'code': 'DREAM_NOT_FOUND', 'message': 'x'},
        }),
      );
      final repo = repoWith(t);
      await repo.byId('tooth-falling-out');
      await repo.byId('a/../b?c#d');
      expect(t.requests[0].path, '/api/v1/dreams/tooth-falling-out');
      expect(t.requests[1].pathSegments, ['api', 'v1', 'dreams', 'a/../b?c#d']);
      expect(t.requests[1].hasQuery, isFalse);
      expect(t.requests[1].toString(), 'http://10.0.2.2:3000/api/v1/dreams/a%2F..%2Fb%3Fc%23d');
    });

    test('a trailing slash in the base URL does not double the separator', () async {
      final t = FakeTransport((_) => json(200, {'data': []}));
      await ApiDreamRepository(Uri.parse('https://api.example.test/api/v1/'), transport: t).categories();
      expect(t.requests.single.toString(), 'https://api.example.test/api/v1/dream-categories');
    });

    test('rejects unusable base URLs', () {
      for (final bad in [
        '10.0.2.2:3000/api/v1',
        'ftp://h/api/v1',
        '/api/v1',
        'http://h/api/v1?x=1',
        'http://u:p@h/api/v1',
      ]) {
        expect(
          () => ApiDreamRepository(Uri.parse(bad), transport: FakeTransport((_) => json(200, {}))),
          throwsFormatException,
          reason: bad,
        );
      }
    });
  });

  group('parsing', () {
    test('categories keep ids, Thai names and order; cached after success', () async {
      final t = FakeTransport(
        (_) => json(200, {
          'data': [
            {'id': 'animal', 'name': 'สัตว์'},
            {'id': 'body', 'name': 'ร่างกาย', 'extra': 1},
          ],
        }),
      );
      final repo = repoWith(t);
      expect(await repo.categories(), const [DreamCategory('animal', 'สัตว์'), DreamCategory('body', 'ร่างกาย')]);
      await repo.categories();
      expect(t.requests, hasLength(1));
    });

    test('a failed category request is not cached', () async {
      var fail = true;
      final t = FakeTransport(
        (_) => fail
            ? json(503, {
                'error': {'code': 'SERVICE_UNAVAILABLE', 'message': 'x'},
              })
            : json(200, {'data': []}),
      );
      final repo = repoWith(t);
      await expectLater(
        repo.categories(),
        fails(DreamRepositoryErrorKind.server, code: 'SERVICE_UNAVAILABLE', status: 503),
      );
      fail = false;
      expect(await repo.categories(), isEmpty);
    });

    test('list: pagination, Thai text and leading zeros', () async {
      final t = FakeTransport(
        (_) => json(
          200,
          page(
            [
              summary(),
              summary(id: 'dead-person', two: ['09', '90'], three: ['090', '900']),
            ],
            page: 3,
            limit: 4,
            total: 10,
          ),
        ),
      );
      final p = await repoWith(t).list(page: 3, limit: 4);
      expect((p.page, p.limit, p.total, p.totalPages), (3, 4, 10, 3));
      final tooth = p.items[0];
      expect(tooth.id, 'tooth-falling-out');
      expect(tooth.name, 'ฟันหลุด');
      expect(tooth.category, const DreamCategory('body', 'ร่างกาย'));
      expect(tooth.cat, 'ร่างกาย');
      expect(tooth.numbers.twoDigit, ['08', '80']);
      expect(tooth.numbers.threeDigit, ['098', '809']);
      expect(tooth.firstTwo, '08');
      expect(tooth.good, isFalse);
      expect(tooth.contentStatus, ContentStatus.sample);
      expect(p.items[1].numbers.threeDigit, ['090', '900']);
    });

    test('empty results', () async {
      final p = await repoWith(FakeTransport((_) => json(200, page([])))).list(q: 'ไม่มี');
      expect(p.items, isEmpty);
      expect((p.total, p.totalPages), (0, 0));
    });

    test('detail maps every field', () async {
      final d = (await repoWith(FakeTransport((_) => json(200, {'data': detail()}))).byId('tooth-falling-out'))!;
      expect(d.id, 'tooth-falling-out');
      expect(d.cat, 'ร่างกาย');
      expect(d.two, '08 · 80');
      expect(d.three, '098 · 809');
      expect(d.digits, ['0', '8']);
      expect(d.meaning, startsWith('ฝันว่าฟันหลุด'));
      expect(d.advice, startsWith('ตื่นเช้า'));
      expect((d.luckForecast.money, d.luckForecast.love, d.luckForecast.health), (45, 40, 58));
      expect(d.good, isFalse);
      expect(() => d.numbers.twoDigit.add('11'), throwsUnsupportedError);
      expect(() => d.digits.add('1'), throwsUnsupportedError);
    });

    test('unknown fields are ignored', () async {
      final body = page([
        {
          ...summary(),
          'imageUrl': 'x',
          'numbers': {
            'twoDigit': ['08'],
            'threeDigit': ['098'],
            'fourDigit': ['0980'],
          },
        },
      ]);
      (body['meta'] as Map)['next'] = null;
      body['links'] = {};
      final p = await repoWith(FakeTransport((_) => json(200, body))).list();
      expect(p.items.single.numbers.twoDigit, ['08']);
    });

    final badSummaries = <String, Map<String, Object?>>{
      'numeric two-digit value': summary(two: [8, 80]),
      'numeric three-digit value': summary(three: [98, 809]),
      'two-digit too short': summary(two: ['8']),
      'three-digit too long': summary(three: ['0980']),
      'empty numbers': summary(two: <String>[]),
      'Thai digits': summary(two: ['๐๘']),
      'missing id': {...summary()}..remove('id'),
      'missing name': {...summary()}..remove('name'),
      'missing category': {...summary()}..remove('category'),
      'empty short': {...summary(), 'short': ' '},
      'id not a slug': {...summary(), 'id': 'Bad Id'},
      'isGoodOmen as string': {...summary(), 'isGoodOmen': 'false'},
      'unknown contentStatus': {...summary(), 'contentStatus': 'DRAFT'},
      'numbers not an object': {
        ...summary(),
        'numbers': ['08'],
      },
    };
    for (final MapEntry(:key, :value) in badSummaries.entries) {
      test('rejects list item: $key', () {
        expect(
          repoWith(FakeTransport((_) => json(200, page([value])))).list(),
          fails(DreamRepositoryErrorKind.badResponse, status: 200),
        );
      });
    }

    final badDetails = <String, Map<String, Object?>>{
      'score above 100': detail(luck: {'money': 101, 'love': 40, 'health': 58}),
      'negative score': detail(luck: {'money': 45, 'love': -1, 'health': 58}),
      'score as string': detail(luck: {'money': '45', 'love': 40, 'health': 58}),
      'score as double': detail(luck: {'money': 45.5, 'love': 40, 'health': 58}),
      'missing forecast': {...detail()}..remove('luckForecast'),
      'missing meaning': {...detail()}..remove('meaning'),
      'numeric digit': {
        ...detail(),
        'digits': [0, 8],
      },
      'two-character digit': {
        ...detail(),
        'digits': ['08'],
      },
    };
    for (final MapEntry(:key, :value) in badDetails.entries) {
      test('rejects detail: $key', () {
        expect(
          repoWith(FakeTransport((_) => json(200, {'data': value}))).byId('tooth-falling-out'),
          fails(DreamRepositoryErrorKind.badResponse, status: 200),
        );
      });
    }

    test('rejects inconsistent paging metadata', () {
      final t = FakeTransport((_) => json(200, page([summary()], total: 10, limit: 4, totalPages: 2)));
      expect(repoWith(t).list(), fails(DreamRepositoryErrorKind.badResponse, status: 200));
      final missing = FakeTransport((_) => json(200, {'data': []}));
      expect(repoWith(missing).list(), fails(DreamRepositoryErrorKind.badResponse, status: 200));
    });

    test('rejects malformed JSON and non-JSON bodies', () {
      final broken = FakeTransport((_) => const HttpResult(200, '{"data": [', mimeType: 'application/json'));
      expect(repoWith(broken).categories(), fails(DreamRepositoryErrorKind.badResponse, status: 200));
      final html = FakeTransport((_) => const HttpResult(200, '<html></html>', mimeType: 'text/html'));
      expect(repoWith(html).categories(), fails(DreamRepositoryErrorKind.badResponse, status: 200));
      final wrongRoot = FakeTransport((_) => json(200, ['animal']));
      expect(repoWith(wrongRoot).categories(), fails(DreamRepositoryErrorKind.badResponse, status: 200));
    });
  });

  group('errors', () {
    Map<String, Object?> envelope(String code) => {
      'error': {
        'code': code,
        'message': 'Invalid request',
        'details': ['x'],
      },
    };

    test('400 → invalidRequest with the API error code', () {
      final t = FakeTransport((_) => json(400, envelope('VALIDATION_ERROR')));
      expect(
        repoWith(t).list(limit: 101),
        fails(DreamRepositoryErrorKind.invalidRequest, code: 'VALIDATION_ERROR', status: 400),
      );
    });

    test('404 DREAM_NOT_FOUND → null; other 404 → notFound', () async {
      expect(await repoWith(FakeTransport((_) => json(404, envelope('DREAM_NOT_FOUND')))).byId('unicorn'), isNull);
      final route = FakeTransport((_) => json(404, envelope('NOT_FOUND')));
      expect(repoWith(route).byId('unicorn'), fails(DreamRepositoryErrorKind.notFound, code: 'NOT_FOUND', status: 404));
      expect(repoWith(route).list(), fails(DreamRepositoryErrorKind.notFound, code: 'NOT_FOUND', status: 404));
    });

    test('500/503 → server, with or without an envelope', () {
      expect(
        repoWith(FakeTransport((_) => json(500, envelope('INTERNAL_ERROR')))).list(),
        fails(DreamRepositoryErrorKind.server, code: 'INTERNAL_ERROR', status: 500),
      );
      expect(
        repoWith(FakeTransport((_) => const HttpResult(502, 'Bad Gateway', mimeType: 'text/plain'))).list(),
        fails(DreamRepositoryErrorKind.server, status: 502),
      );
    });

    test('other statuses → unexpected', () {
      expect(
        repoWith(FakeTransport((_) => json(429, envelope('TOO_MANY')))).list(),
        fails(DreamRepositoryErrorKind.unexpected, code: 'TOO_MANY', status: 429),
      );
    });

    test('error message never contains the URL or body', () async {
      final t = FakeTransport((_) => const HttpResult(500, 'db password=secret', mimeType: 'text/plain'));
      try {
        await repoWith(t).list(q: 'งู');
        fail('expected an error');
      } on DreamRepositoryException catch (e) {
        expect(e.toString(), isNot(contains('secret')));
        expect(e.toString(), isNot(contains('10.0.2.2')));
      }
    });

    test('transport timeout and network failures are typed', () {
      expect(
        repoWith(FakeTransport((_) => throw const TransportException(TransportFailure.timeout, 't'))).list(),
        fails(DreamRepositoryErrorKind.timeout),
      );
      expect(
        repoWith(FakeTransport((_) => throw const TransportException(TransportFailure.network, 'n'))).list(),
        fails(DreamRepositoryErrorKind.network),
      );
      expect(
        repoWith(FakeTransport((_) => throw const FormatException('utf8'))).list(),
        fails(DreamRepositoryErrorKind.badResponse),
      );
      expect(repoWith(FakeTransport((_) => throw StateError('x'))).list(), fails(DreamRepositoryErrorKind.unexpected));
    });

    test('close() closes the transport', () {
      final t = FakeTransport((_) => json(200, {}));
      repoWith(t).close();
      expect(t.closed, isTrue);
    });
  });

  group('IoHttpTransport (loopback server)', () {
    late HttpServer server;
    late Uri root;
    Duration delay = Duration.zero;

    setUp(() async {
      delay = Duration.zero;
      server = await HttpServer.bind(InternetAddress.loopbackIPv4, 0);
      root = Uri.parse('http://127.0.0.1:${server.port}/api/v1');
      server.listen((req) async {
        await Future<void>.delayed(delay);
        req.response.headers.contentType = ContentType.json;
        if (req.uri.path == '/api/v1/dream-categories') {
          req.response.write(
            jsonEncode({
              'data': [
                {'id': 'animal', 'name': 'สัตว์'},
              ],
            }),
          );
        } else {
          req.response.statusCode = 404;
          req.response.write(
            jsonEncode({
              'error': {'code': 'DREAM_NOT_FOUND', 'message': 'x'},
            }),
          );
        }
        await req.response.close();
      });
    });

    tearDown(() => server.close(force: true));

    test('reads UTF-8 JSON end to end', () async {
      final repo = ApiDreamRepository(root);
      expect(await repo.categories(), const [DreamCategory('animal', 'สัตว์')]);
      expect(await repo.byId('nope'), isNull);
      repo.close();
    });

    test('response timeout', () async {
      delay = const Duration(seconds: 2);
      final repo = ApiDreamRepository(
        root,
        transport: IoHttpTransport(responseTimeout: const Duration(milliseconds: 200)),
      );
      await expectLater(repo.categories(), fails(DreamRepositoryErrorKind.timeout));
      repo.close();
    });

    test('connection refused → network', () async {
      final port = server.port;
      await server.close(force: true);
      final repo = ApiDreamRepository(Uri.parse('http://127.0.0.1:$port/api/v1'));
      await expectLater(repo.categories(), fails(DreamRepositoryErrorKind.network));
      repo.close();
    });

    test('a closed transport refuses new requests', () async {
      final repo = ApiDreamRepository(root)..close();
      await expectLater(repo.categories(), fails(DreamRepositoryErrorKind.unexpected));
    });
  });
}
