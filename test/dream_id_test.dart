// M1.2: legacySampleDreams are referenced by a stable String id, never by list index.
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:maha_dream/app_shell.dart';
import 'package:maha_dream/data/design_data.dart';
import 'package:maha_dream/screens/result_screen.dart';
import 'package:maha_dream/theme.dart';

import 'fixtures/legacy_sample_data.dart';

void main() {
  group('Dream ids', () {
    test('all ids are non-empty and unique', () {
      final ids = legacySampleDreams.map((d) => d.id).toList();
      expect(ids, hasLength(10));
      expect(ids.every((id) => id.trim().isNotEmpty), isTrue);
      expect(ids.toSet(), hasLength(ids.length));
    });

    test('ids are the fixed slugs assigned to each dream (locked)', () {
      expect({for (final d in legacySampleDreams) d.name: d.id}, {
        'งู': 'snake',
        'ช้าง': 'elephant',
        'ฟันหลุด': 'tooth-falling-out',
        'น้ำท่วม': 'flood',
        'ปลา': 'fish',
        'ไฟไหม้': 'fire',
        'พระ': 'monk',
        'คนตาย': 'dead-person',
        'ทองคำ': 'gold',
        'เสือ': 'tiger',
      });
    });

    test('dreamById finds the right dream and returns null for unknown ids', () {
      expect(dreamById('tooth-falling-out', legacySampleDreams)!.name, 'ฟันหลุด');
      expect(dreamById('tooth-falling-out', legacySampleDreams)!.two, '08 · 80');
      expect(dreamById('no-such-dream', legacySampleDreams), isNull);
      expect(dreamById('', legacySampleDreams), isNull);
    });

    test('lookup does not depend on list order', () {
      final reordered = legacySampleDreams.reversed.toList();
      for (final d in legacySampleDreams) {
        expect(identical(dreamById(d.id, reordered), d), isTrue, reason: d.id);
      }
    });
  });

  group('AppController with ids', () {
    test('openDream opens the detail page for that id', () {
      final c = AppController();
      c.openDream('tiger');
      expect(c.tab, 'dream');
      expect((c.page as ResultPage).dreamId, 'tiger');
    });

    test('toggleSave saves and unsaves by id without touching other legacySampleDreams', () {
      final c = AppController();
      c.toggleSave('snake');
      expect(c.saved, {'snake'});
      c.toggleSave('elephant');
      expect(c.saved, {'snake', 'elephant'});
      c.toggleSave('snake');
      expect(c.saved, {'elephant'});
    });
  });

  group('ResultScreen by id', () {
    Future<void> pumpResult(WidgetTester tester, String id) async {
      final c = AppController(repository: legacySampleRepository);
      addTearDown(c.dispose);
      await tester.pumpWidget(MaterialApp(
        theme: buildTheme(),
        home: AppScope(controller: c, child: Scaffold(body: ResultScreen(dreamId: id))),
      ));
    }

    testWidgets('shows the dream for a known id', (tester) async {
      await pumpResult(tester, 'tooth-falling-out');
      expect(find.text('ฝันเห็นฟันหลุด'), findsOneWidget);
      expect(find.text('098 · 809'), findsOneWidget);
    });

    testWidgets('unknown id shows not-found instead of another dream', (tester) async {
      await pumpResult(tester, 'no-such-dream');
      expect(find.text('ไม่พบความฝันนี้'), findsOneWidget);
      for (final d in legacySampleDreams) {
        expect(find.text('ฝันเห็น${d.name}'), findsNothing, reason: d.id);
      }
      expect(tester.takeException(), isNull);
    });
  });
}
