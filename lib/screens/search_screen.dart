import 'dart:async';

import 'package:flutter/material.dart';

import '../app_shell.dart';
import '../data/dream_images_k.dart';
import '../data/dream_repository.dart';
import '../state/load_request.dart';
import '../theme.dart';
import '../widgets/ui.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});
  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

/// Category filter value meaning "no category filter".
const _allCats = 'ทั้งหมด';

/// Wait after the last keystroke before searching a remote repository.
const searchDebounce = Duration(milliseconds: 300);

/// All matches are shown on one page (the catalogue is small).
const _resultLimit = DreamRepository.maxPageSize;

class _SearchScreenState extends State<SearchScreen> {
  TextEditingController? _controller;
  AppController? _app;
  final _categories = LoadRequest<List<DreamCategory>>();
  final _results = LoadRequest<DreamPage>();
  Timer? _debounce;
  (String, String)? _searched;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _controller ??= TextEditingController(text: AppScope.of(context).query);
    if (_app != null) return;
    final app = _app = AppScope.of(context);
    _categories.run(app.repository.categories);
    _search();
    // Listen only after the first synchronous results are in place.
    app.addListener(_appChanged);
    _categories.addListener(_changed);
    _results.addListener(_changed);
  }

  void _changed() => setState(() {});

  /// Query or category changed: search again (debounced for remote data).
  void _appChanged() {
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
      return _results.complete(DreamPage(items: const [], page: 1, limit: _resultLimit, total: 0));
    }
    if (cat == _allCats) return _results.run(() => repo.list(q: q, limit: _resultLimit));
    _results.run(
      () => repo.categories().then((cats) {
        final match = cats.where((c) => c.name == cat).firstOrNull;
        if (match == null) {
          throw DreamRepositoryException(DreamRepositoryErrorKind.invalidRequest, 'unknown category');
        }
        return repo.list(q: q, categoryId: match.id, limit: _resultLimit);
      }),
    );
  }

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
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final app = AppScope.of(context);
    final cats = [_allCats, for (final c in _categories.value ?? const <DreamCategory>[]) c.name];
    final page = _results.value;

    return Column(children: [
      Container(
        width: double.infinity,
        color: C.red,
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text('ค้นหาความฝัน', style: serif(20, color: C.goldLight)),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 2),
            decoration: BoxDecoration(
              color: C.input,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: C.gold, width: 1.5),
            ),
            child: Row(children: [
              const Icon(Icons.search, size: 18, color: C.redBright),
              const SizedBox(width: 8),
              Expanded(
                child: TextField(
                  controller: _controller,
                  onChanged: app.setQuery,
                  textInputAction: TextInputAction.search,
                  style: sans(16),
                  decoration: InputDecoration(
                    hintText: 'พิมพ์ เช่น งู ช้าง ฟันหลุด',
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
            height: 34,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: cats.length,
              separatorBuilder: (_, _) => const SizedBox(width: 8),
              itemBuilder: (_, i) => SelectPill(
                text: cats[i],
                selected: app.cat == cats[i],
                onTap: () => app.setCat(cats[i]),
                selectedBg: C.gold,
                selectedFg: C.redDeep,
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
        child: ListView(padding: const EdgeInsets.fromLTRB(16, 12, 16, 24), children: [
          if (_results.isLoading || _results.status == LoadStatus.idle)
            const GoldLoading()
          else if (_results.status == LoadStatus.failure || page == null)
            LoadErrorView(message: loadErrorMessage(_results.error), onRetry: _retry)
          else ...[
            Text('พบ ${page.total} รายการ', style: sans(13, color: C.caption)),
            const SizedBox(height: 12),
            if (page.items.isEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 40),
                child: Text('ไม่พบความฝันนี้ ลองคำอื่น', textAlign: TextAlign.center, style: sans(14, color: C.caption)),
              ),
            for (final d in page.items)
              Padding(padding: const EdgeInsets.only(bottom: 10), child: _ResultRow(dream: d)),
          ],
        ]),
      ),
    ]);
  }
}

class _ResultRow extends StatelessWidget {
  final DreamSummary dream;
  const _ResultRow({required this.dream});

  @override
  Widget build(BuildContext context) {
    final d = dream;
    return CreamCard(
      radius: 14,
      padding: const EdgeInsets.all(10),
      onTap: () => AppScope.of(context).openDream(d.id),
      child: Row(children: [
        DreamImageView(
            image: dreamImageFor(d.id, d.image), placeholderLabel: 'ภาพ', width: 60, height: 60, radius: 10, fontSize: 9),
        const SizedBox(width: 12),
        Expanded(
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(d.name, style: sans(16, weight: FontWeight.w600)),
            Text(d.short, maxLines: 1, overflow: TextOverflow.ellipsis, style: sans(13, color: C.inkMuted)),
          ]),
        ),
        const SizedBox(width: 8),
        Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
          d.numbers.isNone
              ? Text(d.firstTwo, style: sans(13, weight: FontWeight.w600, color: C.redBright, height: 1.6))
              : Text(d.firstTwo, style: serif(20, weight: FontWeight.w800, color: C.redBright, height: 1.3)),
          Text(d.cat, style: sans(11, color: C.caption)),
        ]),
      ]),
    );
  }
}
