// The API caps a page at DreamRepository.maxPageSize (100). Lists with more dreams must not stop there:
// letter pages fetch every page; search shows 20 per page with a pager bar (first/previous/next/last).
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:maha_dream/app_shell.dart';
import 'package:maha_dream/data/design_data.dart';
import 'package:maha_dream/data/dream_repository.dart';
import 'package:maha_dream/data/sample_dream_repository.dart';
import 'package:maha_dream/main.dart';

AppController controllerOf(WidgetTester tester) =>
    tester.element(find.byType(Scaffold).first).getInheritedWidgetOfExactType<AppScope>()!.notifier!;

/// Bundled data, but remote (async) and recording the pages asked for.
class _PagedRepo implements DreamRepository {
  final pages = <int>[];
  final _local = const SampleDreamRepository();
  @override
  bool get isRemote => true;
  @override
  Future<List<DreamCategory>> categories() async => _local.categories();
  @override
  Future<DreamPage> list({
    String? q,
    String? categoryId,
    int page = 1,
    int limit = DreamRepository.defaultPageSize,
    DreamSort sort = DreamSort.catalogue,
  }) async {
    pages.add(page);
    return _local.list(q: q, categoryId: categoryId, page: page, limit: limit);
  }

  @override
  Future<Dream?> byId(String id) async => _local.byId(id);
  @override
  void close() {}
}

void main() {
  test('the bundled catalogue is larger than one API page', () {
    expect(dreams.length, greaterThan(DreamRepository.maxPageSize));
  });

  test('listAll joins every page and stays synchronous for bundled data', () {
    final future = const SampleDreamRepository().listAll();
    expect(future, isA<SynchronousFuture<DreamPage>>());
    DreamPage? page;
    future.then((p) => page = p);
    expect(page!.items.map((d) => d.id), dreams.map((d) => d.id));
    expect(page!.total, dreams.length);
  });

  test('listAll fetches page by page from a remote repository', () async {
    final repo = _PagedRepo();
    final page = await repo.listAll();
    expect(page.items, hasLength(dreams.length));
    expect(repo.pages, [for (var i = 1; i <= (dreams.length + 99) ~/ 100; i++) i]);
  });

  Future<void> openSearch(WidgetTester tester, DreamRepository? repo) async {
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    await tester.pumpWidget(repo == null ? const MahaDreamApp() : MahaDreamApp(repository: repo));
    await tester.pumpAndSettle();
    controllerOf(tester).goSearch(resetCat: true);
    await tester.pumpAndSettle(const Duration(seconds: 1));
  }

  Future<void> tapButton(WidgetTester tester, String label) async {
    await tester.tap(find.bySemanticsLabel(label));
    await tester.pumpAndSettle();
  }

  final results = find.byKey(const ValueKey('search-results'));
  final pages = (dreams.length + 19) ~/ 20;

  for (final remote in [false, true]) {
    final mode = remote ? 'API' : 'bundled';

    testWidgets('search shows 20 per page; scrolling never loads more ($mode)', (tester) async {
      final repo = remote ? _PagedRepo() : null;
      await openSearch(tester, repo);
      expect(find.text('พบ ${dreams.length} รายการ'), findsOneWidget);
      expect(find.text('หน้า 1 / $pages'), findsOneWidget);
      await tester.scrollUntilVisible(
        find.text(dreams[19].name),
        600,
        scrollable: find.descendant(of: results, matching: find.byType(Scrollable)),
      );
      await tester.drag(results, const Offset(0, -3000));
      await tester.pumpAndSettle();
      expect(find.text(dreams[20].name, skipOffstage: false), findsNothing);
      expect(find.text('หน้า 1 / $pages'), findsOneWidget);
      if (repo != null) expect(repo.pages.where((p) => p > 1), isEmpty);
    });

    testWidgets('pager: first/previous/next/last jump between pages ($mode)', (tester) async {
      final repo = remote ? _PagedRepo() : null;
      await openSearch(tester, repo);

      await tapButton(tester, 'ไปหน้าถัดไป');
      expect(find.text('หน้า 2 / $pages'), findsOneWidget);
      expect(find.text(dreams[20].name), findsOneWidget);
      expect(find.text(dreams[0].name, skipOffstage: false), findsNothing);

      await tapButton(tester, 'ไปหน้าสุดท้าย');
      expect(find.text('หน้า $pages / $pages'), findsOneWidget);
      expect(find.text(dreams[(pages - 1) * 20].name), findsOneWidget);

      await tapButton(tester, 'ไปหน้าก่อนหน้า');
      expect(find.text('หน้า ${pages - 1} / $pages'), findsOneWidget);

      await tapButton(tester, 'ไปหน้าแรก');
      expect(find.text('หน้า 1 / $pages'), findsOneWidget);
      expect(find.text(dreams[0].name), findsOneWidget);
    });
  }

  testWidgets('a new search starts again at page 1; a short result has no pager', (tester) async {
    await openSearch(tester, null);
    final ctl = controllerOf(tester);
    await tapButton(tester, 'ไปหน้าสุดท้าย');
    ctl.setCat('หมวด ฉ');
    await tester.pumpAndSettle();
    expect(find.text('พบ 3 รายการ'), findsOneWidget);
    expect(find.textContaining('หน้า '), findsNothing);
    ctl.setCat('ทั้งหมด');
    await tester.pumpAndSettle();
    expect(find.text('หน้า 1 / $pages'), findsOneWidget);
  });
}
