import 'dart:async';

import 'package:flutter/material.dart';

import '../state/app_controller.dart';
import '../data/dream_images_k.dart';
import '../data/dream_repository.dart';
import '../state/load_request.dart';
import '../theme.dart';
import '../widgets/ui.dart';


/// Hint examples: dreams people commonly have, each one a dream name in the bundled book.
const searchHintExamples = ['งู', 'ฟันหัก', 'คนตาย'];
class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});
  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

/// Category filter value meaning "no category filter".
const _allCats = 'ทั้งหมด';

/// Wait after the last keystroke before searching a remote repository.
const searchDebounce = Duration(milliseconds: 300);

/// Results per page; the pager at the end of the list moves between pages.
const searchPageSize = 20;

class _SearchScreenState extends State<SearchScreen> {
  TextEditingController? _controller;
  AppController? _app;
  final _categories = LoadRequest<List<DreamCategory>>();
  final _results = LoadRequest<DreamPage>();
  Timer? _debounce;
  (String, String)? _searched;

  final _scroll = ScrollController();
  final _focus = FocusNode();

  /// Came from Home's search box: put the cursor in the box after this frame (opens the keyboard).
  void _focusIfAsked() {
    if (_app!.takeSearchFocus()) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) _focus.requestFocus();
      });
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _controller ??= TextEditingController(text: AppScope.of(context).query);
    if (_app != null) return;
    _focus.addListener(_focusChanged);
    final app = _app = AppScope.of(context);
    _categories.run(app.repository.categories);
    _search();
    _focusIfAsked();
    // Listen only after the first synchronous results are in place.
    app.addListener(_appChanged);
    _categories.addListener(_changed);
    _results.addListener(_changed);
  }

  void _changed() => setState(() {});

  /// Query or category changed: search again (debounced for remote data).
  void _appChanged() {
    _focusIfAsked();
    final app = _app!;
    final key = (app.query.trim(), app.cat);
    if (key == _searched) return; // other state (tab, saved, ...) changed
    _debounce?.cancel();
    if (!app.repository.isRemote) return _search();
    final categoryChanged = key.$2 != _searched?.$2;
    _searched = key;
    // Results on screen no longer match the input; older responses are ignored.
    _results.markLoading();
    // A category tap searches at once; typing waits for a pause.
    if (categoryChanged) return _search();
    _debounce = Timer(searchDebounce, _search);
  }

  void _search() {
    final app = _app!;
    final repo = app.repository;
    final q = app.query.trim();
    final cat = app.cat;
    _searched = (q, cat);
    if (q.length > DreamRepository.maxQueryLength) {
      // Longer than any name or summary; the API would reject it (400).
      return _results.complete(DreamPage(items: const [], page: 1, limit: searchPageSize, total: 0));
    }
    _results.run(() => _fetch(repo, q, cat, 1));
  }

  Future<DreamPage> _fetch(DreamRepository repo, String q, String cat, int page) {
    if (cat == _allCats) return repo.list(q: q, page: page, limit: searchPageSize);
    return repo.categories().then((cats) {
      final match = cats.where((c) => c.name == cat).firstOrNull;
      if (match == null) {
        throw DreamRepositoryException(DreamRepositoryErrorKind.invalidRequest, 'unknown category');
      }
      return repo.list(q: q, categoryId: match.id, page: page, limit: searchPageSize);
    });
  }

  /// Shows [page] of the current search and scrolls back to the first result.
  void _goToPage(int page) {
    final (q, cat) = _searched!;
    final repo = _app!.repository;
    _results.run(() => _fetch(repo, q, cat, page));
    if (_scroll.hasClients) _scroll.jumpTo(0);
  }


  void _focusChanged() => setState(() {});

  void _retry() {
    if (_categories.status == LoadStatus.failure) _categories.retry();
    _search();
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _app?.removeListener(_appChanged);
    _categories.dispose();
    _results.dispose();
    _scroll.dispose();
    _focus.dispose();
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final app = AppScope.of(context);
    final cats = [_allCats, for (final c in _categories.value ?? const <DreamCategory>[]) c.name];
    final page = _results.value;

    return Column(children: [
      PageHeader(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text('ค้นหาความฝัน', style: serif(24, weight: FontWeight.w800, color: C.goldLight)),
          const SizedBox(height: 12),
          Container(
            constraints: const BoxConstraints(minHeight: 52),
            padding: const EdgeInsets.fromLTRB(16, 2, 4, 2),
            decoration: BoxDecoration(
              color: C.input,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: _focus.hasFocus ? C.aqua : C.gold, width: 1.5),
            ),
            child: Row(children: [
              const Icon(Icons.search, size: 20, color: C.gold),
              const SizedBox(width: 10),
              Expanded(
                child: TextField(
                  key: const ValueKey('dream-search'),
                  controller: _controller,
                  focusNode: _focus,
                  onChanged: app.setQuery,
                  textInputAction: TextInputAction.search,
                  style: sans(16),
                  decoration: InputDecoration(
                    hintText: 'พิมพ์ เช่น ${searchHintExamples.join(' ')}',
                    hintStyle: sans(16, color: C.placeholder),
                    border: InputBorder.none,
                    isDense: true,
                    contentPadding: const EdgeInsets.symmetric(vertical: 10),
                  ),
                ),
              ),
              if (app.query.isNotEmpty)
                IconButton(
                  tooltip: 'ล้างคำค้นหา',
                  visualDensity: VisualDensity.compact,
                  icon: const Icon(Icons.close, size: 18, color: C.placeholder),
                  onPressed: () {
                    _controller!.clear();
                    app.setQuery('');
                  },
                ),
            ]),
          ),
          const SizedBox(height: 12),
          SizedBox(
            // Grows with the phone's text size so the chip labels are never cut off.
            height: 40 * MediaQuery.textScalerOf(context).scale(14) / 14,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: cats.length,
              separatorBuilder: (_, _) => const SizedBox(width: 8),
              itemBuilder: (_, i) => SelectPill(
                text: cats[i],
                selected: app.cat == cats[i],
                onTap: () => app.setCat(cats[i]),
                selectedBg: C.gold,
                selectedFg: C.onGold,
                bg: Colors.transparent,
                fg: C.goldLight,
                border: C.gold,
                radius: 20,
                fontSize: 14,
                weight: FontWeight.w400,
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
              ),
            ),
          ),
        ]),
      ),
      Expanded(
        child: ListView(
            key: const ValueKey('search-results'),
            // Scrolling the results puts the keyboard away so they get the whole screen.
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
            controller: _scroll,
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
            children: [
          if (_results.isLoading || _results.status == LoadStatus.idle)
            const GoldLoading()
          else if (_results.status == LoadStatus.failure || page == null)
            LoadErrorView(message: loadErrorMessage(_results.error), onRetry: _retry)
          else ...[
            Text('พบ ${page.total} รายการ', style: sans(13, color: C.caption)),
            const SizedBox(height: 12),
            if (page.items.isEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 24),
                child: _NoResultTip(),
              ),
            if (page.items.isNotEmpty) _BookPage(dreams: page.items),
            // At the end of the list: seen only after scrolling past the last result.
            if (page.totalPages > 1) Pager(page: page.page, pages: page.totalPages, onPage: _goToPage),
          ],
        ]),
      ),
    ]);
  }

}

/// Results laid out like a printed dream-book page: one parchment sheet with a
/// double-ruled frame, entries separated by thin rules instead of separate cards.
class _BookPage extends StatelessWidget {
  final List<DreamSummary> dreams;
  const _BookPage({required this.dreams});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: C.input,
        border: Border.all(color: C.goldDeep, width: 1.5),
        boxShadow: const [BoxShadow(color: C.shadow, blurRadius: 6, offset: Offset(2, 3))],
      ),
      child: Container(
        padding: const EdgeInsets.fromLTRB(14, 4, 14, 12),
        decoration: BoxDecoration(border: Border.all(color: C.goldBorder, width: 0.8)),
        child: Column(children: [
          for (var i = 0; i < dreams.length; i++) ...[
            if (i > 0) const Divider(height: 1, thickness: 0.6, color: C.goldBorder),
            _ResultRow(dream: dreams[i]),
          ],
          const SizedBox(height: 10),
          Text('❖', style: sans(12, color: C.goldMuted)),
        ]),
      ),
    );
  }
}

class _ResultRow extends StatelessWidget {
  final DreamSummary dream;
  const _ResultRow({required this.dream});

  @override
  Widget build(BuildContext context) {
    final d = dream;
    return InkWell(
      onTap: () => AppScope.of(context).openDream(d.id),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Container(
            decoration: BoxDecoration(border: Border.all(color: C.goldBorder, width: 0.8)),
            child: DreamImageView(
                image: dreamImageFor(d.id, d.image), placeholderLabel: 'ภาพ', width: 64, height: 64, radius: 0, fontSize: 9),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(d.name, style: serif(18, color: C.text)),
              const SizedBox(height: 2),
              Text(d.short,
                  maxLines: 2, overflow: TextOverflow.ellipsis, style: sans(13, color: C.textSoft, height: 1.45)),
            ]),
          ),
          const SizedBox(width: 10),
          // Capped so "ไม่ควรเสี่ยง" and long category names wrap on small phones with large text.
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 84),
            child: Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
              d.numbers.isNone
                  ? Text(d.firstTwo,
                      textAlign: TextAlign.right,
                      style: sans(13, weight: FontWeight.w600, color: C.warning, height: 1.4))
                  : Text(d.firstTwo, style: serif(22, weight: FontWeight.w800, color: C.number, height: 1.2)),
              Text(d.cat, textAlign: TextAlign.right, style: sans(12, color: C.caption)),
            ]),
          ),
        ]),
      ),
    );
  }
}

/// Empty result: says so, then how to search better (shorter word, other category).
class _NoResultTip extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: C.caption.withValues(alpha: .35)),
        ),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text('ไม่พบความฝันนี้ ลองคำอื่น', style: sans(15, weight: FontWeight.w600, color: C.textBody)),
          const SizedBox(height: 4),
          Text('ลองพิมพ์คำสั้นลง เช่น “งู” แทน “งูเหลือมตัวใหญ่” หรือเลือกหมวด “ทั้งหมด”',
              style: sans(14, color: C.textSoft, height: 1.6)),
        ]),
      );
}
