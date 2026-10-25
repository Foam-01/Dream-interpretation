// M1.3.2: locks the sample dream data before/after the typed-model migration.
// Expected values are literals copied from lib/data/design_data.dart at
// b2875fc; they are NOT derived from the model under test.
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:maha_dream/app_shell.dart';
import 'package:maha_dream/data/design_data.dart';
import 'package:maha_dream/screens/result_screen.dart';
import 'package:maha_dream/theme.dart';

import 'fixtures/legacy_sample_data.dart';

/// id -> (two display, three display, firstTwo)
const _numbers = <String, (String, String, String)>{
  'snake': ('56 · 65', '567 · 556', '56'),
  'elephant': ('91 · 19', '919 · 199', '91'),
  'tooth-falling-out': ('08 · 80', '098 · 809', '08'),
  'flood': ('27 · 72', '277 · 720', '27'),
  'fish': ('84 · 48', '844 · 468', '84'),
  'fire': ('34 · 43', '347 · 430', '34'),
  'monk': ('89 · 98', '889 · 908', '89'),
  'dead-person': ('09 · 90', '090 · 900', '09'),
  'gold': ('59 · 95', '559 · 959', '59'),
  'tiger': ('37 · 73', '373 · 737', '37'),
};

/// id -> (money, love, health)
const _luck = <String, (int, int, int)>{
  'snake': (84, 90, 62),
  'elephant': (92, 70, 75),
  'tooth-falling-out': (45, 40, 58),
  'flood': (88, 65, 70),
  'fish': (80, 60, 72),
  'fire': (78, 55, 66),
  'monk': (75, 80, 85),
  'dead-person': (60, 55, 82),
  'gold': (90, 68, 70),
  'tiger': (70, 50, 65),
};

void main() {
  test('all 10 legacySampleDreams keep their stable ids in order', () {
    expect(legacySampleDreams.map((d) => d.id).toList(), _numbers.keys.toList());
  });

  test('two / three / firstTwo display strings are unchanged', () {
    for (final MapEntry(key: id, value: (two, three, first)) in _numbers.entries) {
      final d = dreamById(id, legacySampleDreams)!;
      expect(d.two, two, reason: id);
      expect(d.three, three, reason: id);
      expect(d.firstTwo, first, reason: id);
    }
  });

  test('luck scores (money, love, health) are unchanged', () {
    for (final MapEntry(key: id, value: (money, love, health)) in _luck.entries) {
      final f = dreamById(id, legacySampleDreams)!.luckForecast!; // all sample legacySampleDreams have a forecast
      expect((f.money, f.love, f.health), (money, love, health), reason: id);
    }
  });

  test('twoDigit / threeDigit hold the literal strings, leading zeros intact', () {
    final n = dreamById('tooth-falling-out', legacySampleDreams)!.numbers;
    expect(n.twoDigit, ['08', '80']);
    expect(n.threeDigit, ['098', '809']);
    final m = dreamById('dead-person', legacySampleDreams)!.numbers;
    expect(m.twoDigit, ['09', '90']);
    expect(m.threeDigit, ['090', '900']);
    expect(m.twoDigit.first, isA<String>());
  });

  test('display uses exactly " · " (space, U+00B7, space)', () {
    expect(LuckyNumbers.separator.codeUnits, [0x20, 0xB7, 0x20]);
    expect(dreamById('snake', legacySampleDreams)!.two.codeUnits, '56 · 65'.codeUnits);
  });

  test('LuckyNumbers supports more than two values', () {
    const n = LuckyNumbers(twoDigit: ['01', '10', '11'], threeDigit: ['001', '010', '100', '111']);
    expect(n.twoDisplay, '01 · 10 · 11');
    expect(n.threeDisplay, '001 · 010 · 100 · 111');
    expect(n.firstTwo, '01');
    expect(n.validate(), isEmpty);
  });

  test('number lists are read-only', () {
    final n = dreamById('snake', legacySampleDreams)!.numbers;
    expect(() => n.twoDigit.add('99'), throwsUnsupportedError);
    expect(() => n.threeDigit[0] = '000', throwsUnsupportedError);
    final mutable = ['12', '21'];
    final m = LuckyNumbers(twoDigit: mutable, threeDigit: const ['123']);
    expect(() => m.twoDigit.clear(), throwsUnsupportedError);
  });

  group('LuckyNumbers.copy (defensive copy)', () {
    test('later changes to the input lists do not affect the object', () {
      final two = ['08', '80'];
      final three = ['098', '809'];
      final n = LuckyNumbers.copy(twoDigit: two, threeDigit: three);
      expect(n.twoDisplay, '08 · 80');
      expect(n.threeDisplay, '098 · 809');

      two.add('99');
      two[0] = '11';
      three.removeAt(0);
      three.add('000');
      two.clear();

      expect(n.twoDisplay, '08 · 80');
      expect(n.threeDisplay, '098 · 809');
      expect(n.twoDigit, ['08', '80']);
      expect(n.threeDigit, ['098', '809']);
      expect(n.firstTwo, '08');
      expect(n.validate(), isEmpty);
    });

    test('getters return lists that cannot be modified', () {
      final n = LuckyNumbers.copy(twoDigit: ['09', '90'], threeDigit: ['090', '900']);
      expect(() => n.twoDigit.add('99'), throwsUnsupportedError);
      expect(() => n.twoDigit[0] = '11', throwsUnsupportedError);
      expect(() => n.threeDigit.removeLast(), throwsUnsupportedError);
      expect(() => n.threeDigit[1] = '111', throwsUnsupportedError);
      expect(n.twoDisplay, '09 · 90');
      expect(n.threeDisplay, '090 · 900');
    });

    test('copy keeps leading zeros and supports more than two values', () {
      final n = LuckyNumbers.copy(twoDigit: ['01', '10', '00'], threeDigit: ['001', '010', '000']);
      expect(n.twoDisplay, '01 · 10 · 00');
      expect(n.threeDisplay, '001 · 010 · 000');
      expect(n.firstTwo, '01');
    });

    test('const constructor stores lists as-is (documented; use copy for mutable input)', () {
      final two = ['12', '21'];
      final n = LuckyNumbers(twoDigit: two, threeDigit: const ['123']);
      two.add('99');
      expect(n.twoDisplay, '12 · 21 · 99');
    });
  });

  group('validation', () {
    test('all sample legacySampleDreams are valid', () {
      for (final d in legacySampleDreams) {
        expect(d.numbers.validate(), isEmpty, reason: d.id);
      }
      expect(debugValidateDreams(), isTrue);
    });

    test('reports empty lists and wrong digit counts without fixing data', () {
      // Both lists empty = "ไม่ควรเสี่ยง" (LuckyNumbers.none), which is valid. Two-digit numbers are required
      // otherwise; an empty three-digit list is valid (the source gives only two-digit numbers).
      const none = LuckyNumbers(twoDigit: [], threeDigit: []);
      expect(none.validate(), isEmpty);
      expect(none.isNone, isTrue);
      expect((none.twoDisplay, none.threeDisplay, none.firstTwo), ('ไม่ควรเสี่ยง', 'ไม่ควรเสี่ยง', 'ไม่ควรเสี่ยง'));
      expect(const LuckyNumbers(twoDigit: [], threeDigit: ['123']).validate(), ['twoDigit is empty']);
      const twoOnly = LuckyNumbers(twoDigit: ['33'], threeDigit: []);
      expect(twoOnly.validate(), isEmpty);
      expect((twoOnly.isNone, twoOnly.twoDisplay, twoOnly.firstTwo), (false, '33', '33'));
      const bad = LuckyNumbers(twoDigit: ['8', '123', 'ab'], threeDigit: ['12', '1234']);
      expect(bad.validate(), hasLength(5));
      expect(bad.twoDigit, ['8', '123', 'ab']); // untouched
    });

    test('debugValidateDreams throws a clear error for invalid data', () {
      const broken = Dream('broken', 'x', 'x', LuckyNumbers(twoDigit: ['8'], threeDigit: ['123']), ['8'], 'x', 'x',
          LuckForecast(money: 1, love: 1, health: 1), true, 'x');
      expect(() => debugValidateDreams([broken]),
          throwsA(isA<StateError>().having((e) => e.message, 'message', contains('broken'))));
    });

    test('LuckForecast rejects scores outside 0-100', () {
      int score(int v) => v; // non-const so the assert runs at runtime
      expect(() => LuckForecast(money: score(101), love: 0, health: 0), throwsAssertionError);
      expect(() => LuckForecast(money: 0, love: score(-1), health: 0), throwsAssertionError);
      expect(() => LuckForecast(money: 0, love: 0, health: score(150)), throwsAssertionError);
      expect(LuckForecast(money: score(0), love: score(100), health: score(50)).health, 50);
    });
  });

  testWidgets('detail luck bars pair each label with its named score', (tester) async {
    tester.view.physicalSize = const Size(390, 1600);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    final c = AppController(repository: legacySampleRepository);
    addTearDown(c.dispose);
    await tester.pumpWidget(MaterialApp(
      theme: buildTheme(),
      home: AppScope(controller: c, child: const Scaffold(body: ResultScreen(dreamId: 'snake'))),
    ));
    Finder rowOf(String label) => find.ancestor(of: find.text(label), matching: find.byType(Row)).first;
    for (final (label, value) in const [('การเงิน', '84'), ('ความรัก', '90'), ('สุขภาพ', '62')]) {
      expect(find.descendant(of: rowOf(label), matching: find.text(value)), findsOneWidget, reason: label);
    }
    expect(find.text('56 · 65'), findsOneWidget);
    expect(find.text('567 · 556'), findsOneWidget);
  });

  group('M1.3.3 contract hardening', () {
    test('LuckyNumbers rejects empty strings, spaces, non-digits and Thai digits', () {
      const n = LuckyNumbers(
        twoDigit: ['', ' 8', '8 ', '0 8', 'a1', '๐๘', '08\n', '-1'],
        threeDigit: ['', '09 8', 'abc', '๐๙๘', '1.0'],
      );
      final problems = n.validate();
      expect(problems, hasLength(13)); // every value above is reported
      expect(problems, contains('twoDigit "" is not 2 digits'));
      expect(problems, contains('twoDigit "๐๘" is not 2 digits'));
      expect(problems, contains('threeDigit "abc" is not 3 digits'));
    });

    test('LuckyNumbers accepts any number of valid values (no fixed count of 2)', () {
      const one = LuckyNumbers(twoDigit: ['08'], threeDigit: ['098']);
      expect(one.validate(), isEmpty);
      final many = LuckyNumbers.copy(twoDigit: List.filled(5, '09'), threeDigit: List.filled(4, '090'));
      expect(many.validate(), isEmpty);
    });

    test('LuckForecast.check accepts the 0 and 100 boundaries', () {
      expect(LuckForecast.check(money: 0, love: 100, health: 50), isEmpty);
    });

    test('LuckForecast.check reports each out-of-range field separately, without clamping', () {
      expect(LuckForecast.check(money: 101, love: 50, health: 50), ['money 101 is outside 0-100']);
      expect(LuckForecast.check(money: 50, love: -1, health: 50), ['love -1 is outside 0-100']);
      expect(LuckForecast.check(money: 50, love: 50, health: 120), ['health 120 is outside 0-100']);
      expect(LuckForecast.check(money: -5, love: 200, health: 101), [
        'money -5 is outside 0-100',
        'love 200 is outside 0-100',
        'health 101 is outside 0-100',
      ]);
    });

    test('every sample forecast passes runtime validation', () {
      for (final d in legacySampleDreams) {
        expect(d.luckForecast!.validate(), isEmpty, reason: d.id);
        expect(d.validate(), isEmpty, reason: d.id);
      }
    });

    test('Dream.validate prefixes problems by part and debugValidateDreams names the dream id', () {
      const broken = Dream('broken-sample', 'x', 'x', LuckyNumbers(twoDigit: ['8'], threeDigit: []), ['8'], 'x', 'x',
          LuckForecast(money: 1, love: 1, health: 1), true, 'x');
      expect(broken.validate(), ['numbers: twoDigit "8" is not 2 digits']);
      expect(
          () => debugValidateDreams([legacySampleDreams.first, broken]),
          throwsA(isA<StateError>().having((e) => e.message, 'message',
              allOf(contains('"broken-sample"'), contains('numbers: twoDigit "8"'), isNot(contains('snake'))))));
    });

    test('validation has no side effects on the data', () {
      final before = [for (final d in legacySampleDreams) '${d.id}|${d.two}|${d.three}|${d.luckForecast!.money}'];
      for (var i = 0; i < 3; i++) {
        debugValidateDreams();
      }
      expect([for (final d in legacySampleDreams) '${d.id}|${d.two}|${d.three}|${d.luckForecast!.money}'], before);
    });
  });
}
