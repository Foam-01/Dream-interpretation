import 'package:flutter/material.dart';

import '../app_shell.dart';
import '../data/design_data.dart';
import '../theme.dart';
import '../widgets/ui.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});
  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  TextEditingController? _controller;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _controller ??= TextEditingController(text: AppScope.of(context).query);
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final app = AppScope.of(context);
    final q = app.query.trim();
    final results = [
      for (final d in dreams)
        if ((app.cat == 'ทั้งหมด' || d.cat == app.cat) && (q.isEmpty || d.name.contains(q) || d.short.contains(q))) d,
    ];

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
              itemCount: dreamCats.length,
              separatorBuilder: (_, _) => const SizedBox(width: 8),
              itemBuilder: (_, i) => SelectPill(
                text: dreamCats[i],
                selected: app.cat == dreamCats[i],
                onTap: () => app.setCat(dreamCats[i]),
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
          Text('พบ ${results.length} รายการ', style: sans(13, color: C.caption)),
          const SizedBox(height: 12),
          if (results.isEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 40),
              child: Text('ไม่พบความฝันนี้ ลองคำอื่น', textAlign: TextAlign.center, style: sans(14, color: C.caption)),
            ),
          for (final d in results)
            Padding(padding: const EdgeInsets.only(bottom: 10), child: _ResultRow(dreamId: d.id)),
        ]),
      ),
    ]);
  }
}

class _ResultRow extends StatelessWidget {
  final String dreamId;
  const _ResultRow({required this.dreamId});

  @override
  Widget build(BuildContext context) {
    final d = dreamById(dreamId);
    if (d == null) return const SizedBox.shrink();
    return CreamCard(
      radius: 14,
      padding: const EdgeInsets.all(10),
      onTap: () => AppScope.of(context).openDream(d.id),
      child: Row(children: [
        const ImagePlaceholder('ภาพ', width: 60, height: 60, radius: 10, fontSize: 9),
        const SizedBox(width: 12),
        Expanded(
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text('ฝันเห็น${d.name}', style: sans(16, weight: FontWeight.w600)),
            Text(d.short, maxLines: 1, overflow: TextOverflow.ellipsis, style: sans(13, color: C.inkMuted)),
          ]),
        ),
        const SizedBox(width: 8),
        Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
          Text(d.firstTwo, style: serif(20, weight: FontWeight.w800, color: C.redBright, height: 1.3)),
          Text(d.cat, style: sans(11, color: C.caption)),
        ]),
      ]),
    );
  }
}
