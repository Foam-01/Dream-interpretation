import 'package:flutter/material.dart';

import '../app_shell.dart';
import '../data/design_data.dart';
import '../data/dream_images_k.dart';
import '../data/dream_repository.dart';
import '../state/load_request.dart';
import '../theme.dart';
import '../widgets/ui.dart';

/// Body of a letter-category page (e.g. หมวด ก): the category's dreams, each row with its own picture
/// (or the placeholder). A broken image never affects the list.
class LetterCategorySection extends StatefulWidget {
  final String categoryId;
  const LetterCategorySection({super.key, required this.categoryId});

  @override
  State<LetterCategorySection> createState() => _LetterCategorySectionState();
}

class _LetterCategorySectionState extends State<LetterCategorySection> {
  final _request = LoadRequest<DreamPage>();
  bool _started = false;
  bool _remote = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_started) return;
    _started = true;
    final repo = AppScope.of(context).repository;
    _remote = repo.isRemote;
    // The API sorts ก–ฮ with ICU; the bundled data keeps the source order (Dart has no Thai collation).
    _request.run(
      // Every page: a category may hold more than one API page (maxPageSize).
      () => repo.listAll(categoryId: widget.categoryId, sort: _remote ? DreamSort.name : DreamSort.catalogue),
    );
    _request.addListener(_changed);
  }

  void _changed() => setState(() {});

  @override
  void dispose() {
    _request.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(padding: const EdgeInsets.fromLTRB(16, 14, 16, 24), child: _list());
  }

  Widget _list() {
    switch (_request.status) {
      case LoadStatus.idle || LoadStatus.loading:
        return const GoldLoading();
      case LoadStatus.failure:
        return LoadErrorView(message: loadErrorMessage(_request.error), onRetry: _request.retry);
      case LoadStatus.success:
    }
    final page = _request.value!;
    if (page.items.isEmpty) return _Message('ยังไม่มีคำทำนายที่ผ่านการตรวจสอบในหมวดนี้');
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('พบ ${page.total} รายการ', style: sans(13, color: C.caption)),
        const SizedBox(height: 12),
        for (final d in page.items)
          Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: _DreamRow(dream: d),
          ),
      ],
    );
  }
}

class _DreamRow extends StatelessWidget {
  final DreamSummary dream;
  const _DreamRow({required this.dream});

  @override
  Widget build(BuildContext context) {
    final d = dream;
    final two = d.numbers.twoDigit;
    return CreamCard(
      radius: 14,
      padding: const EdgeInsets.fromLTRB(14, 10, 14, 10),
      onTap: () => AppScope.of(context).openDream(d.id),
      child: Row(
        children: [
          DreamImageView(
            image: dreamImageFor(d.id, d.image),
            placeholderLabel: 'ภาพ',
            width: 60,
            height: 60,
            radius: 10,
            fontSize: 9,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(d.name, style: sans(16, weight: FontWeight.w600)),
                Text(
                  d.short,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: sans(13, color: C.inkMuted),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          if (two.isNotEmpty)
            Text(two.first, style: serif(20, weight: FontWeight.w800, color: C.redBright, height: 1.3))
          else
            Text(
              LuckyNumbers.noLuckyNumbersText,
              style: sans(13, weight: FontWeight.w600, color: C.redBright, height: 1.6),
            ),
        ],
      ),
    );
  }
}

class _Message extends StatelessWidget {
  final String text;
  const _Message(this.text);

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 24),
    child: Text(
      text,
      textAlign: TextAlign.center,
      style: sans(14, color: C.caption),
    ),
  );
}
