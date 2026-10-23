// I3: Home, Search and Result read dreams through the repository. In API mode
// (a remote repository) they show loading, error/retry and empty states, ignore
// stale responses and never fall back to the bundled sample data.
// Responses are controlled with Completers; no real time or network is used.
import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:maha_dream/app_shell.dart';
import 'package:maha_dream/data/design_data.dart';
import 'package:maha_dream/data/dream_repository.dart';
import 'package:maha_dream/main.dart';
import 'package:maha_dream/screens/search_screen.dart' show searchDebounce;

class Call {
  final String method;
  final Map<String, Object?> args;
  final Completer<Object?> completer = Completer<Object?>();
  Call(this.method, this.args);
  void complete(Object? v) => completer.complete(v);
  void fail(DreamRepositoryErrorKind kind) => completer.completeError(DreamRepositoryException(kind, 'test'));
}

/// Remote repository whose answers the test releases explicitly.
class ControlledRepository implements DreamRepository {
  final calls = <Call>[];

  @override
  bool get isRemote => true;

  Future<T> _call<T>(String method, Map<String, Object?> args) {
    final c = Call(method, args);
    calls.add(c);
    return c.completer.future.then((v) => v as T);
  }

  List<Call> of(String method) => calls.where((c) => c.method == method).toList();

  @override
  Future<List<DreamCategory>> categories() => _call('categories', {});

  @override
  Future<DreamPage> list({String? q, String? categoryId, int page = 1, int limit = DreamRepository.defaultPageSize}) =>
      _call('list', {'q': q, 'category': categoryId, 'page': page, 'limit': limit});

  @override
  Future<Dream?> byId(String id) => _call('byId', {'id': id});

  @override
  void close() {}
}

const animal = DreamCategory('animal', 'สัตว์');
const body = DreamCategory('body', 'ร่างกาย');

/// A dream that does not exist in the bundled sample data, so seeing it proves
/// the screen shows remote data.
DreamSummary remote(String id, String name, {String two = '08', DreamCategory category = body}) => DreamSummary(
  id: id,
  name: name,
  category: category,
  short: 'สรุป$name',
  numbers: LuckyNumbers.copy(twoDigit: [two], threeDigit: ['0${two}0'.substring(0, 3)]),
  good: true,
  contentStatus: ContentStatus.verified,
);

DreamPage pageOf(List<DreamSummary> items) => DreamPage(items: items, page: 1, limit: 100, total: items.length);

final toothDetail = Dream(
  'tooth-falling-out',
  'ฟันหลุดจากเซิร์ฟเวอร์',
  'ร่างกาย',
  LuckyNumbers.copy(twoDigit: ['08', '80'], threeDigit: ['098', '809']),
  const ['0', '8'],
  'สรุป',
  'คำทำนายจากเซิร์ฟเวอร์',
  const LuckForecast(money: 45, love: 40, health: 58),
  false,
  'คำแนะนำ',
);

Future<ControlledRepository> pumpApp(WidgetTester tester) async {
  tester.view.physicalSize = const Size(390, 2400);
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.reset);
  final repo = ControlledRepository();
  await tester.pumpWidget(MahaDreamApp(repository: repo));
  return repo;
}

AppController controller(WidgetTester tester) =>
    tester.element(find.byType(Scaffold).first).getInheritedWidgetOfExactType<AppScope>()!.notifier!;

final spinner = find.byType(CircularProgressIndicator);
final retry = find.text('ลองใหม่');

void main() {
  group('Home (API mode)', () {
    testWidgets('loading, then remote hot dreams', (tester) async {
      final repo = await pumpApp(tester);
      expect(spinner, findsOneWidget);
      final call = repo.of('list').single;
      expect(call.args['limit'], 5);
      call.complete(pageOf([remote('a', 'แมวเซิร์ฟเวอร์'), remote('b', 'นกเซิร์ฟเวอร์', two: '09')]));
      await tester.pump();
      expect(spinner, findsNothing);
      expect(find.text('ฝันเห็นแมวเซิร์ฟเวอร์'), findsOneWidget);
      expect(find.text('09'), findsOneWidget);
      expect(find.text('ฝันเห็นงู'), findsNothing, reason: 'no sample data in API mode');
    });

    testWidgets('error shows retry (no sample fallback); retry succeeds', (tester) async {
      final repo = await pumpApp(tester);
      repo.of('list').single.fail(DreamRepositoryErrorKind.network);
      await tester.pump();
      expect(find.text('เชื่อมต่อเซิร์ฟเวอร์ไม่ได้ กรุณาตรวจสอบอินเทอร์เน็ต'), findsOneWidget);
      expect(find.text('ฝันเห็นงู'), findsNothing);
      await tester.tap(retry);
      await tester.pump();
      expect(spinner, findsOneWidget);
      expect(repo.of('list'), hasLength(2));
      repo.of('list').last.complete(pageOf([remote('a', 'แมวเซิร์ฟเวอร์')]));
      await tester.pump();
      expect(find.text('ฝันเห็นแมวเซิร์ฟเวอร์'), findsOneWidget);
    });

    testWidgets('empty result', (tester) async {
      final repo = await pumpApp(tester);
      repo.of('list').single.complete(pageOf([]));
      await tester.pump();
      expect(find.text('ยังไม่มีความฝันยอดฮิต'), findsOneWidget);
    });

    testWidgets('rebuilds do not refetch', (tester) async {
      final repo = await pumpApp(tester);
      repo.of('list').single.complete(pageOf([remote('a', 'แมวเซิร์ฟเวอร์')]));
      await tester.pump();
      controller(tester).toggleSave('x'); // notifies AppScope → rebuild
      await tester.pump();
      expect(repo.of('list'), hasLength(1));
    });
  });

  group('Search (API mode)', () {
    Future<ControlledRepository> openSearch(WidgetTester tester) async {
      final repo = await pumpApp(tester);
      repo.of('list').single.complete(pageOf([])); // home
      await tester.pump();
      controller(tester).goSearch();
      await tester.pump();
      return repo;
    }

    testWidgets('loads categories and all results; chips use Thai labels', (tester) async {
      final repo = await openSearch(tester);
      expect(spinner, findsOneWidget);
      repo.of('categories').single.complete([animal, body]);
      final search = repo.of('list').last;
      expect(search.args, {'q': '', 'category': null, 'page': 1, 'limit': 100});
      search.complete(pageOf([remote('a', 'แมวเซิร์ฟเวอร์', category: animal)]));
      await tester.pump();
      expect(find.text('ทั้งหมด'), findsOneWidget);
      expect(find.text('ร่างกาย'), findsOneWidget);
      expect(find.text('พบ 1 รายการ'), findsOneWidget);
      expect(find.text('ฝันเห็นแมวเซิร์ฟเวอร์'), findsOneWidget);
    });

    testWidgets('typing is debounced; only the last query is sent', (tester) async {
      final repo = await openSearch(tester);
      repo.of('categories').single.complete([animal, body]);
      repo.of('list').last.complete(pageOf([]));
      await tester.pump();
      final before = repo.of('list').length;
      await tester.enterText(find.byType(TextField), 'ง');
      await tester.pump(const Duration(milliseconds: 100));
      await tester.enterText(find.byType(TextField), 'งู');
      await tester.pump(searchDebounce - const Duration(milliseconds: 1));
      expect(repo.of('list'), hasLength(before), reason: 'still waiting');
      expect(spinner, findsOneWidget);
      await tester.pump(const Duration(milliseconds: 1));
      expect(repo.of('list'), hasLength(before + 1));
      expect(repo.of('list').last.args['q'], 'งู');
    });

    testWidgets('a slow older response never overwrites a newer one', (tester) async {
      final repo = await openSearch(tester);
      repo.of('categories').single.complete([animal, body]);
      final initial = repo.of('list').last;
      await tester.enterText(find.byType(TextField), 'งู');
      await tester.pump(searchDebounce);
      final newer = repo.of('list').last;
      expect(newer.args['q'], 'งู');
      newer.complete(pageOf([remote('snake', 'งูเซิร์ฟเวอร์')]));
      await tester.pump();
      initial.complete(pageOf([remote('old', 'ผลเก่า')]));
      await tester.pump();
      expect(find.text('ฝันเห็นงูเซิร์ฟเวอร์'), findsOneWidget);
      expect(find.text('ฝันเห็นผลเก่า'), findsNothing);
    });

    testWidgets('category tap searches at once with the category id', (tester) async {
      final repo = await openSearch(tester);
      repo.of('categories').single.complete([animal, body]);
      repo.of('list').last.complete(pageOf([]));
      await tester.pump();
      await tester.tap(find.text('สัตว์'));
      await tester.pump(); // categories() is cached by the repository; here it is asked again
      repo.of('categories').last.complete([animal, body]);
      await tester.pump();
      final call = repo.of('list').last;
      expect(call.args['category'], 'animal');
      call.complete(pageOf([remote('cat', 'เสือเซิร์ฟเวอร์', category: animal)]));
      await tester.pump();
      expect(find.text('ฝันเห็นเสือเซิร์ฟเวอร์'), findsOneWidget);
    });

    testWidgets('no results vs. connection error are distinct; retry', (tester) async {
      final repo = await openSearch(tester);
      repo.of('categories').single.complete([animal, body]);
      repo.of('list').last.fail(DreamRepositoryErrorKind.timeout);
      await tester.pump();
      expect(find.text('เซิร์ฟเวอร์ตอบช้าเกินไป'), findsOneWidget);
      expect(find.text('ไม่พบความฝันนี้ ลองคำอื่น'), findsNothing);
      await tester.tap(retry);
      await tester.pump();
      repo.of('list').last.complete(pageOf([]));
      await tester.pump();
      expect(find.text('ไม่พบความฝันนี้ ลองคำอื่น'), findsOneWidget);
      expect(find.text('พบ 0 รายการ'), findsOneWidget);
    });

    testWidgets('leaving the screen cancels the debounce and ignores late responses', (tester) async {
      final repo = await openSearch(tester);
      final pending = repo.of('list').last;
      await tester.enterText(find.byType(TextField), 'งู');
      controller(tester).goTab('home');
      await tester.pump(); // search screen is disposed in this frame
      await tester.pump(const Duration(seconds: 1));
      final lists = repo.of('list').where((c) => c.args['q'] == 'งู');
      expect(lists, isEmpty, reason: 'debounced search must not fire after dispose');
      pending.complete(pageOf([]));
      repo.of('categories').single.complete([animal]);
      await tester.pump();
      expect(tester.takeException(), isNull);
    });
  });

  group('Result (API mode)', () {
    Future<ControlledRepository> openDream(WidgetTester tester, String id) async {
      final repo = await pumpApp(tester);
      repo.of('list').single.complete(pageOf([]));
      await tester.pump();
      controller(tester).openDream(id);
      await tester.pump();
      return repo;
    }

    testWidgets('loading, then detail with leading zeros', (tester) async {
      final repo = await openDream(tester, 'tooth-falling-out');
      expect(spinner, findsOneWidget);
      expect(repo.of('byId').single.args['id'], 'tooth-falling-out');
      repo.of('byId').single.complete(toothDetail);
      await tester.pump();
      expect(find.text('ฝันเห็นฟันหลุดจากเซิร์ฟเวอร์'), findsOneWidget);
      expect(find.text('08 · 80'), findsOneWidget);
      expect(find.text('098 · 809'), findsOneWidget);
      expect(find.text('0'), findsOneWidget);
      expect(find.text('คำทำนายจากเซิร์ฟเวอร์'), findsOneWidget);
    });

    testWidgets('not found', (tester) async {
      final repo = await openDream(tester, 'unicorn');
      repo.of('byId').single.complete(null);
      await tester.pump();
      expect(find.text('ไม่พบความฝันนี้'), findsOneWidget);
    });

    testWidgets('error then retry; never shows the sample dream', (tester) async {
      final repo = await openDream(tester, 'snake');
      repo.of('byId').single.fail(DreamRepositoryErrorKind.server);
      await tester.pump();
      expect(find.text('เซิร์ฟเวอร์ขัดข้องชั่วคราว'), findsOneWidget);
      expect(find.text('ฝันเห็นงู'), findsNothing);
      await tester.tap(retry);
      await tester.pump();
      expect(repo.of('byId'), hasLength(2));
      expect(repo.of('byId').last.args['id'], 'snake');
      repo.of('byId').last.complete(toothDetail);
      await tester.pump();
      expect(find.text('08 · 80'), findsOneWidget);
    });

    testWidgets('a late answer for a previous dream is ignored', (tester) async {
      final repo = await openDream(tester, 'snake');
      final first = repo.of('byId').single;
      controller(tester).openDream('tooth-falling-out');
      await tester.pump();
      repo.of('byId').last.complete(toothDetail);
      await tester.pump();
      first.complete(dreamById('snake'));
      await tester.pump();
      expect(find.text('ฝันเห็นฟันหลุดจากเซิร์ฟเวอร์'), findsOneWidget);
      expect(find.text('ฝันเห็นงู'), findsNothing);
      expect(tester.takeException(), isNull);
    });
  });

  group('sample mode', () {
    testWidgets('makes no HTTP connections', (tester) async {
      var created = 0;
      await HttpOverrides.runZoned(
        () async {
          await tester.pumpWidget(const MahaDreamApp());
          controller(tester).goSearch();
          await tester.pump();
          controller(tester).openDream('tooth-falling-out');
          await tester.pump();
        },
        createHttpClient: (_) {
          created++;
          throw StateError('network used in sample mode');
        },
      );
      expect(created, 0);
      expect(find.text('08 · 80'), findsOneWidget);
      expect(spinner, findsNothing);
    });

    testWidgets('search updates immediately (no debounce, no spinner)', (tester) async {
      await tester.pumpWidget(const MahaDreamApp());
      controller(tester).goSearch();
      await tester.pump();
      await tester.enterText(find.byType(TextField), 'งู');
      await tester.pump();
      expect(spinner, findsNothing);
      expect(find.text('พบ 1 รายการ'), findsOneWidget);
    });
  });
}
