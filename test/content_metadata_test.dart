// Content metadata from the API: image + attribution, source citation, aliases and optional
// fields (advice, omen, digits, forecast) that sourced content may not have. Missing data is
// hidden, never invented; images that fail to load fall back to the placeholder.
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:maha_dream/app_shell.dart';
import 'package:maha_dream/data/api_dream_repository.dart';
import 'package:maha_dream/data/design_data.dart';
import 'package:maha_dream/data/dream_repository.dart';
import 'package:maha_dream/data/http_transport.dart';
import 'package:maha_dream/data/sample_dream_repository.dart';
import 'package:maha_dream/main.dart';
import 'package:maha_dream/widgets/ui.dart';

class _Transport implements HttpTransport {
  final Object body;
  _Transport(this.body);
  @override
  Future<HttpResult> get(Uri uri) async => HttpResult(200, jsonEncode(body), mimeType: 'application/json');
  @override
  void close() {}
}

Map<String, Object?> detailJson({Map<String, Object?> over = const {}}) => {
  'id': 'crow',
  'name': 'กา',
  'category': {'id': 'animal', 'name': 'สัตว์'},
  'short': 'สรุป',
  'isGoodOmen': null,
  'numbers': {
    'twoDigit': ['01'],
    'threeDigit': ['001'],
  },
  'image': {
    'url': 'https://images.example.org/crow.jpg',
    'alt': 'ภาพกา',
    'credit': 'ผู้ถ่ายภาพ',
    'license': 'CC BY 4.0',
    'sourceUrl': null,
  },
  'contentStatus': 'VERIFIED',
  'meaning': 'คำทำนายจากตำรา',
  'advice': null,
  'digits': <String>[],
  'luckForecast': null,
  'aliases': ['อีกา'],
  'source': {
    'id': 'tamra',
    'title': 'ชื่อตำรา',
    'author': 'ผู้แต่ง',
    'publisher': null,
    'edition': null,
    'year': 2510,
    'url': null,
    'locator': 'หน้า 12',
  },
  ...over,
};

Future<Dream?> parse(Map<String, Object?> data) => ApiDreamRepository(
  Uri.parse('https://api.example.test/api/v1'),
  transport: _Transport({'data': data}),
).byId('crow');

Matcher badResponse() =>
    throwsA(isA<DreamRepositoryException>().having((e) => e.kind, 'kind', DreamRepositoryErrorKind.badResponse));

/// Remote repository returning [dream] for any id and an empty list otherwise.
class _OneDreamRepo implements DreamRepository {
  final Dream dream;
  _OneDreamRepo(this.dream);
  @override
  bool get isRemote => true;
  @override
  Future<List<DreamCategory>> categories() async => const [];
  @override
  Future<DreamPage> list({
    String? q,
    String? categoryId,
    int page = 1,
    int limit = DreamRepository.defaultPageSize,
    DreamSort sort = DreamSort.catalogue,
  }) async => DreamPage(items: const [], page: 1, limit: limit, total: 0);
  @override
  Future<Dream?> byId(String id) async => dream;
  @override
  void close() {}
}

void main() {
  group('parsing', () {
    test('maps image, source, aliases and absent optional fields', () async {
      final d = (await parse(detailJson()))!;
      expect(d.image!.url, 'https://images.example.org/crow.jpg');
      expect(d.image!.attribution, 'ภาพ: ผู้ถ่ายภาพ · CC BY 4.0');
      expect(d.source!.citation, 'ชื่อตำรา · ผู้แต่ง · 2510 · หน้า 12');
      expect(d.aliases, ['อีกา']);
      expect((d.advice, d.good, d.luckForecast), (null, null, null));
      expect(d.digits, isEmpty);
      expect(d.numbers.twoDigit, ['01']);
    });

    test('responses from the first API version (no image/source/aliases) still parse', () async {
      final old = Map<String, Object?>.of(detailJson())
        ..remove('image')
        ..remove('source')
        ..remove('aliases');
      final d = (await parse(old))!;
      expect((d.image, d.source), (null, null));
      expect(d.aliases, isEmpty);
    });

    test('a field that must be present may be null but not missing', () async {
      final noAdvice = Map<String, Object?>.of(detailJson())..remove('advice');
      await expectLater(parse(noAdvice), badResponse());
      final noOmen = Map<String, Object?>.of(detailJson())..remove('isGoodOmen');
      await expectLater(parse(noOmen), badResponse());
    });

    for (final (label, over) in [
      (
        'http image',
        {
          'image': {'url': 'http://images.example.org/a.jpg', 'credit': 'c', 'license': 'l'},
        },
      ),
      (
        'image without credit',
        {
          'image': {'url': 'https://images.example.org/a.jpg', 'license': 'l'},
        },
      ),
      ('image as a string', {'image': 'https://images.example.org/a.jpg'}),
      (
        'source without title',
        {
          'source': {'id': 'x'},
        },
      ),
      (
        'numeric alias',
        {
          'aliases': [1],
        },
      ),
      (
        'blank alias',
        {
          'aliases': [' '],
        },
      ),
      ('omen as a string', {'isGoodOmen': 'true'}),
      (
        'partial forecast',
        {
          'luckForecast': {'money': 1},
        },
      ),
    ]) {
      test('rejects $label', () => expect(parse(detailJson(over: over)), badResponse()));
    }
  });

  group('result screen with sourced content', () {
    final crow = Dream(
      'crow',
      'กา',
      'สัตว์',
      LuckyNumbers.copy(twoDigit: ['01'], threeDigit: ['001']),
      const [],
      'สรุป',
      'คำทำนายจากตำรา',
      null,
      null,
      null,
      image: const DreamImage(url: 'https://images.example.org/crow.jpg', credit: 'ผู้ถ่ายภาพ', license: 'CC BY 4.0'),
      source: const DreamSource(id: 'tamra', title: 'ชื่อตำรา', year: 2510, locator: 'หน้า 12'),
    );

    Future<void> open(WidgetTester tester) async {
      tester.view.physicalSize = const Size(390, 2400);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.reset);
      await tester.pumpWidget(MahaDreamApp(repository: _OneDreamRepo(crow)));
      await tester.pump();
      final ctl = tester.element(find.byType(Scaffold).first).getInheritedWidgetOfExactType<AppScope>()!.notifier!;
      ctl.openDream('crow');
      await tester.pump();
      await tester.pump();
    }

    testWidgets('shows source and image credit, hides what the source does not give', (tester) async {
      await open(tester);
      expect(find.text('หมวดสัตว์ · ชื่อตำรา'), findsOneWidget);
      expect(find.text('ที่มา: ชื่อตำรา · 2510 · หน้า 12'), findsOneWidget);
      expect(find.text('ภาพ: ผู้ถ่ายภาพ · CC BY 4.0'), findsOneWidget);
      expect(find.text('01'), findsOneWidget);
      expect(find.text('พยากรณ์โชคชะตา'), findsNothing);
      expect(find.text('อ่านบทสวด ›'), findsNothing);
      expect(find.byType(DigitBox), findsNothing);
      expect(find.text('ตำราโบราณ'), findsNothing);
    });

    testWidgets('an image that fails to load falls back to the placeholder', (tester) async {
      await open(tester);
      // flutter_test answers every HTTP request with 400, so the image load fails.
      await tester.runAsync(() => Future<void>.delayed(const Duration(milliseconds: 200)));
      await tester.pump();
      expect(find.text('ภาพประกอบ: กา'), findsOneWidget);
      expect(tester.takeException(), isNull);
    });
  });

  group('DreamImageView', () {
    Widget host(DreamImage? image) => MaterialApp(
      home: Scaffold(
        body: DreamImageView(image: image, placeholderLabel: 'ภาพ', width: 60, height: 60),
      ),
    );

    testWidgets('no image → placeholder, no network', (tester) async {
      await tester.pumpWidget(host(null));
      expect(find.text('ภาพ'), findsOneWidget);
      expect(find.byType(Image), findsNothing);
    });

    testWidgets('a non-https URL is never requested', (tester) async {
      await tester.pumpWidget(host(const DreamImage(url: 'http://x.example/a.jpg', credit: 'c', license: 'l')));
      expect(find.byType(Image), findsNothing);
      expect(find.text('ภาพ'), findsOneWidget);
    });

    testWidgets('an https URL is loaded with the placeholder as loading and error state', (tester) async {
      await tester.pumpWidget(host(const DreamImage(url: 'https://x.example/a.jpg', credit: 'c', license: 'l')));
      expect(find.byType(Image), findsOneWidget);
      await tester.runAsync(() => Future<void>.delayed(const Duration(milliseconds: 200)));
      await tester.pump();
      expect(find.text('ภาพ'), findsOneWidget);
      expect(tester.takeException(), isNull);
    });
  });

  group('noLuckyNumbers ("ไม่ควรเสี่ยง")', () {
    Map<String, Object?> noNumbers({Object? flag = true, Object? two = const <String>[]}) => detailJson(
      over: {
        'noLuckyNumbers': flag,
        'numbers': {'twoDigit': two, 'threeDigit': <String>[]},
      },
    );

    test('flag with empty numbers → LuckyNumbers.none, displayed as ไม่ควรเสี่ยง', () async {
      final d = (await parse(noNumbers()))!;
      expect(d.numbers.isNone, isTrue);
      expect((d.two, d.three, d.firstTwo), ('ไม่ควรเสี่ยง', 'ไม่ควรเสี่ยง', 'ไม่ควรเสี่ยง'));
    });

    test('empty numbers without the flag, or numbers with it, are rejected', () async {
      await expectLater(parse(noNumbers(flag: false)), badResponse());
      await expectLater(parse(noNumbers(two: ['01'])), badResponse());
      await expectLater(parse(noNumbers(flag: 'yes')), badResponse());
    });

    test('absent flag (first API version) with numbers still parses', () async {
      final d = (await parse(detailJson()))!;
      expect(d.numbers.isNone, isFalse);
    });
  });

  group('sort', () {
    test('API repository sends sort=name only when asked', () async {
      final uris = <Uri>[];
      final t = _RecordingTransport(uris);
      final repo = ApiDreamRepository(Uri.parse('https://api.example.test/api/v1'), transport: t);
      await repo.list();
      await repo.list(sort: DreamSort.name, page: 2);
      expect(uris[0].queryParameters, isEmpty);
      expect(uris[1].queryParameters, {'page': '2', 'sort': 'name'});
    });

    test('sample repository refuses Thai sorting instead of approximating it', () async {
      await expectLater(
        const SampleDreamRepository().list(sort: DreamSort.name),
        throwsA(isA<DreamRepositoryException>().having((e) => e.kind, 'kind', DreamRepositoryErrorKind.invalidRequest)),
      );
    });
  });
}

class _RecordingTransport implements HttpTransport {
  final List<Uri> uris;
  _RecordingTransport(this.uris);
  @override
  Future<HttpResult> get(Uri uri) async {
    uris.add(uri);
    return HttpResult(
      200,
      jsonEncode({
        'data': [],
        'meta': {'page': 1, 'limit': 20, 'total': 0, 'totalPages': 0},
      }),
      mimeType: 'application/json',
    );
  }

  @override
  void close() {}
}
