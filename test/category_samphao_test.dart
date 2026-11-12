// หมวด ภ: 2 predictions (import file), bundled in the app and listed on their own page (feature '35').
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:maha_dream/app_shell.dart';
import 'package:maha_dream/data/category_samphao.dart';
import 'package:maha_dream/data/design_data.dart';
import 'package:maha_dream/data/dream_images_k.dart';
import 'package:maha_dream/data/dream_images_samphao.dart';
import 'package:maha_dream/data/dreams_samphao.dart';
import 'package:maha_dream/data/sample_dream_repository.dart';
import 'package:maha_dream/main.dart';
import 'package:maha_dream/widgets/ui.dart';

const incoming = 'backend/content/incoming/category-23-samphao';

List<Map<String, Object?>> importDreams() =>
    ((jsonDecode(File('$incoming/dreams.json').readAsStringSync()) as Map)['dreams'] as List)
        .cast<Map<String, Object?>>();

AppController controllerOf(WidgetTester tester) =>
    tester.element(find.byType(Scaffold).first).getInheritedWidgetOfExactType<AppScope>()!.notifier!;

Future<void> openApp(WidgetTester tester) async {
  tester.view.physicalSize = const Size(390, 3000);
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.reset);
  await tester.pumpWidget(const MahaDreamApp());
}

void main() {
  group('import file (2 predictions)', () {
    test('has exactly 2 DRAFT records of หมวด ภ with unique ids and names', () {
      final dreams = importDreams();
      expect(dreams.map((d) => d['name']), ['ภรรยา', 'ภูเขา']);
      expect(dreams.map((d) => d['id']).toSet(), hasLength(2));
      expect(dreams.every((d) => d['categoryId'] == letterSamphaoCategoryId), isTrue);
      expect(dreams.every((d) => d['contentStatus'] == 'DRAFT'), isTrue, reason: 'never VERIFIED without review');
      expect(dreams.every((d) => d['source'] == null && d['image'] == null), isTrue);
      expect(dreams.where((d) => d['noLuckyNumbers'] == true), hasLength(1));
    });

    test('names, words and numbers are verbatim from the source file plus the approved corrections', () {
      var source = File('$incoming/dreams-source.md').readAsStringSync().replaceAll('\r\n', '\n');
      final fixes = ((jsonDecode(File('$incoming/corrections.json').readAsStringSync()) as Map)['corrections'] as List)
          .cast<Map<String, Object?>>();
      expect(fixes, hasLength(0));
      for (final f in fixes) {
        final from = f['from'] as String;
        expect(from.allMatches(source), hasLength(1), reason: from);
        source = source.replaceFirst(from, f['to'] as String);
      }
      for (final d in importDreams()) {
        final id = d['id'] as String;
        expect(source.contains('${d['name']} '), isTrue, reason: id);
        var from = 0;
        for (final w in (d['meaning'] as String).split(' ')) {
          from = source.indexOf(w, from);
          expect(from, isNonNegative, reason: '$id: "$w"');
        }
        final n = d['numbers'] as Map<String, Object?>;
        final all = [...(n['twoDigit'] as List), ...(n['threeDigit'] as List)];
        final ok = d['noLuckyNumbers'] == true
            ? RegExp('เลขเสี่ยงโชค (ไม่ควรเสี่ยง|ยังไม่มีโชคในการเสี่ยง)\n').hasMatch(source)
            : source.contains('เลขเสี่ยงโชค ${all.join(', ')}\n');
        expect(ok, isTrue, reason: id);
      }
    });
  });

  group('bundled หมวด ภ', () {
    test('lib/data/dreams_samphao.dart is in sync with the import file', () {
      final json = importDreams();
      expect(dreamsSamphao, hasLength(json.length));
      for (var i = 0; i < json.length; i++) {
        final j = json[i];
        final d = dreamsSamphao[i];
        final n = j['numbers'] as Map;
        final id = j['id'] as String;
        expect(
          (d.id, d.name, d.meaning, d.short, d.cat),
          (j['id'], j['name'], j['meaning'], j['short'], 'หมวด ภ'),
          reason: id,
        );
        expect(d.numbers.isNone, j['noLuckyNumbers'] == true, reason: id);
        expect(d.numbers.twoDigit, n['twoDigit'], reason: id);
        expect(d.numbers.threeDigit, n['threeDigit'], reason: id);
        expect((d.advice, d.good, d.luckForecast, d.image, d.source), (null, null, null, null, null));
      }
    });

    test('is part of the app data, in one block right after หมวด ฟ; all bundled data validates', () {
      final start = dreams.indexWhere((d) => d.id == dreamsSamphao.first.id);
      expect(dreams.skip(start).take(dreamsSamphao.length).map((d) => d.id), dreamsSamphao.map((d) => d.id));
      expect(dreams[start - 1].cat, 'หมวด ฟ');
      expect(dreams.map((d) => d.id).toSet(), hasLength(dreams.length), reason: 'ids unique across categories');
      expect(debugValidateDreams(), isTrue);
    });

    test('category matches the backend content categories and the app chips', () {
      final ts = File('backend/prisma/seed-data.ts').readAsStringSync();
      final start = ts.indexOf('export const contentCategories');
      final block = ts.substring(start, ts.indexOf('];', start));
      expect(block, contains("{ id: 'letter-samphao', name: 'หมวด ภ', sortOrder: 28 }"));
      expect(letterSamphaoCategoryId, 'letter-samphao');
      expect(sampleCategories.map((c) => (c.id, c.name)), contains(('letter-samphao', 'หมวด ภ')));
      expect(dreamCats.skip(1), sampleCategories.map((c) => c.name));
    });
  });

  group('dream pictures (per dream)', () {
    test('2 checked pictures — every dream has one, bundled and registered', () {
      expect(dreamImagesSamphao.keys, dreamsSamphao.map((d) => d.id));
      final onDisk = Directory('assets/dreams').listSync().whereType<File>().map((f) => f.uri.pathSegments.last);
      expect(onDisk.where((f) => f.startsWith('samphao-')).toSet(), {
        for (final id in dreamImagesSamphao.keys) '$id.jpg',
      });
      for (final MapEntry(:key, :value) in dreamImagesSamphao.entries) {
        expect(value.url, 'assets/dreams/$key.jpg');
        expect(value.isAsset, isTrue);
        expect(value.attribution, isNull, reason: 'no invented credit or licence');
        expect(value.alt, 'ภาพประกอบ: ${dreamsSamphao.firstWhere((d) => d.id == key).name}');
      }
      expect(dreamsSamphao.where((d) => dreamImageFor(d.id) == null).map((d) => d.id), isEmpty);
    });
  });

  group('หมวด ภ page', () {
    test('is listed in the ตำราทำนาย menu after หมวด ฟ and maps to the book tab', () {
      final keys = menus['book']!.items.map((i) => i.key).toList();
      expect(keys.indexOf('35'), keys.indexOf('34') + 1);
      expect(tabOf('35'), 'book');
      expect(feats['35']!.title, 'ทำนายฝันหมวด ภ');
      expect(feats['35']!.type, FeatType.letter);
      expect(featureIcon('35'), featureIcon('13'));
    });

    testWidgets('offline (bundled) mode: lists the 2', (tester) async {
      await openApp(tester);
      controllerOf(tester).openFeat('35');
      await tester.pump();
      expect(find.text('พบ 2 รายการ'), findsOneWidget);
      expect(find.text('ไม่ควรเสี่ยง'), findsNWidgets(1));
      expect(find.text('ภูเขา'), findsOneWidget);
      expect(find.text('กบ'), findsNothing);
    });

    testWidgets('detail opens with the category name', (tester) async {
      await openApp(tester);
      controllerOf(tester).openDream('samphao-wife');
      await tester.pump();
      expect(find.text('หมวด ภ'), findsOneWidget);
      expect(find.text('ภรรยา'), findsWidgets);
    });
  });
}
