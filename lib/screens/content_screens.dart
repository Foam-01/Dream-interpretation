import 'package:flutter/material.dart';

import '../models.dart';
import '../theme.dart';
import '../widgets/common.dart';

/// Expandable article list for remedies, luck seeking, prayers and rules.
class ContentListScreen extends StatelessWidget {
  final String title;
  final String? intro;
  final Future<List<ContentItem>> Function() load;
  const ContentListScreen({super.key, required this.title, required this.load, this.intro});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: AsyncView<List<ContentItem>>(
        load: load,
        isEmpty: (d) => d.isEmpty,
        builder: (_, items) => ListView(padding: const EdgeInsets.all(AppSpacing.md), children: [
          if (intro != null)
            Padding(
              padding: const EdgeInsets.only(bottom: AppSpacing.md),
              child: Text(intro!, style: const TextStyle(color: AppColors.textMuted, height: 1.5)),
            ),
          for (final item in items)
            Padding(
              padding: const EdgeInsets.only(bottom: AppSpacing.sm),
              child: Card(
                clipBehavior: Clip.antiAlias,
                child: ExpansionTile(
                  iconColor: AppColors.gold,
                  collapsedIconColor: AppColors.textMuted,
                  title: Text(item.title,
                      style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.goldSoft)),
                  subtitle: item.subtitle == null
                      ? null
                      : Text(item.subtitle!, style: const TextStyle(color: AppColors.textMuted)),
                  childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                  expandedCrossAxisAlignment: CrossAxisAlignment.start,
                  children: [SelectableText(item.body, style: const TextStyle(height: 1.7, fontSize: 16))],
                ),
              ),
            ),
        ]),
      ),
    );
  }
}

/// Searchable number ↔ name grid (animal index, Pae Kong index).
class NumberIndexScreen extends StatefulWidget {
  final String title;
  final Future<List<IndexEntry>> Function() load;
  const NumberIndexScreen({super.key, required this.title, required this.load});

  @override
  State<NumberIndexScreen> createState() => _NumberIndexScreenState();
}

class _NumberIndexScreenState extends State<NumberIndexScreen> {
  String _q = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.title)),
      body: Column(children: [
        Padding(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: TextField(
            onChanged: (v) => setState(() => _q = v.trim()),
            decoration: const InputDecoration(hintText: 'ค้นหาเลขหรือชื่อ', prefixIcon: Icon(Icons.search)),
          ),
        ),
        Expanded(
          child: AsyncView<List<IndexEntry>>(
            load: widget.load,
            isEmpty: (d) => d.isEmpty,
            builder: (_, all) {
              final list = all.where((e) => e.number.contains(_q) || e.name.contains(_q)).toList();
              if (list.isEmpty) {
                return StateMessage(icon: Icons.search_off, title: 'ไม่พบ "$_q"');
              }
              return GridView.builder(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
                gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                    maxCrossAxisExtent: 120, mainAxisSpacing: 10, crossAxisSpacing: 10, childAspectRatio: 0.95),
                itemCount: list.length,
                itemBuilder: (_, i) => InfoCard(
                  child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                    Text(list[i].number,
                        style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: AppColors.gold)),
                    const SizedBox(height: AppSpacing.xs),
                    Text(list[i].name, textAlign: TextAlign.center, maxLines: 2, overflow: TextOverflow.ellipsis),
                    if (list[i].note != null)
                      Text(list[i].note!,
                          textAlign: TextAlign.center,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(fontSize: 10, color: AppColors.textMuted)),
                  ]),
                ),
              );
            },
          ),
        ),
      ]),
    );
  }
}
