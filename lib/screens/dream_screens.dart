import 'dart:async';

import 'package:flutter/material.dart';

import '../data/repository.dart';
import '../models.dart';
import '../theme.dart';
import '../widgets/common.dart';

final _repo = DreamRepository.instance;

class DreamSearchScreen extends StatefulWidget {
  final String initialQuery;
  const DreamSearchScreen({super.key, this.initialQuery = ''});

  @override
  State<DreamSearchScreen> createState() => _DreamSearchScreenState();
}

class _DreamSearchScreenState extends State<DreamSearchScreen> {
  late final _controller = TextEditingController(text: widget.initialQuery);
  Timer? _debounce;
  bool _loading = false;
  bool _error = false;
  List<Dream>? _results;

  @override
  void initState() {
    super.initState();
    if (widget.initialQuery.isNotEmpty) _run(widget.initialQuery);
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _controller.dispose();
    super.dispose();
  }

  void _onChanged(String q) {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 300), () => _run(q));
  }

  Future<void> _run(String q) async {
    if (q.trim().isEmpty) {
      setState(() => _results = null);
      return;
    }
    setState(() {
      _loading = true;
      _error = false;
    });
    try {
      final r = await _repo.search(q);
      if (mounted) setState(() => _results = r);
    } catch (_) {
      if (mounted) setState(() => _error = true);
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget body;
    if (_loading) {
      body = const Center(child: CircularProgressIndicator());
    } else if (_error) {
      body = StateMessage(
        icon: Icons.cloud_off,
        title: 'ค้นหาไม่สำเร็จ',
        action: FilledButton(onPressed: () => _run(_controller.text), child: const Text('ลองใหม่')),
      );
    } else if (_results == null) {
      body = const StateMessage(
        icon: Icons.nights_stay_outlined,
        title: 'พิมพ์สิ่งที่ฝันเห็น',
        message: 'เช่น งู ช้าง ปลา หรือพิมพ์เลขเพื่อค้นหาย้อนกลับ',
      );
    } else if (_results!.isEmpty) {
      body = StateMessage(
        icon: Icons.search_off,
        title: 'ไม่พบคำทำนายสำหรับ "${_controller.text}"',
        message: 'ลองใช้คำที่สั้นลง หรือเลือกดูจากหมวดหมู่',
        action: OutlinedButton(
          onPressed: () => Navigator.pushNamed(context, '/categories'),
          child: const Text('ดูหมวดหมู่'),
        ),
      );
    } else {
      body = ListView.separated(
        padding: const EdgeInsets.all(AppSpacing.md),
        itemCount: _results!.length,
        separatorBuilder: (_, _) => const SizedBox(height: AppSpacing.sm),
        itemBuilder: (_, i) => DreamTile(_results![i]),
      );
    }
    return Scaffold(
      appBar: AppBar(title: const Text('ค้นหาความฝัน')),
      body: Column(children: [
        Padding(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: TextField(
            controller: _controller,
            autofocus: widget.initialQuery.isEmpty,
            onChanged: _onChanged,
            onSubmitted: _run,
            textInputAction: TextInputAction.search,
            decoration: InputDecoration(
              hintText: 'ฝันเห็นอะไร...',
              prefixIcon: const Icon(Icons.search),
              suffixIcon: IconButton(
                tooltip: 'ล้างคำค้นหา',
                icon: const Icon(Icons.clear),
                onPressed: () {
                  _controller.clear();
                  _run('');
                },
              ),
            ),
          ),
        ),
        Expanded(child: body),
      ]),
    );
  }
}

class DreamTile extends StatelessWidget {
  final Dream dream;
  const DreamTile(this.dream, {super.key});

  @override
  Widget build(BuildContext context) {
    return InfoCard(
      onTap: () => Navigator.pushNamed(context, '/dream', arguments: dream),
      child: Row(children: [
        Expanded(
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text('ฝันเห็น${dream.keyword}',
                style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: AppColors.goldSoft)),
            const SizedBox(height: AppSpacing.xs),
            Text(dream.meaning, maxLines: 2, overflow: TextOverflow.ellipsis,
                style: const TextStyle(color: AppColors.textMuted)),
            const SizedBox(height: AppSpacing.sm),
            Text('เลข: ${dream.numbers.join(' · ')}',
                style: const TextStyle(color: AppColors.gold, fontWeight: FontWeight.w600)),
          ]),
        ),
        const Icon(Icons.chevron_right, color: AppColors.textMuted),
      ]),
    );
  }
}

class DreamDetailScreen extends StatelessWidget {
  final Dream dream;
  const DreamDetailScreen({super.key, required this.dream});

  @override
  Widget build(BuildContext context) {
    final two = dream.numbers.where((n) => n.length == 2).toList();
    final three = dream.numbers.where((n) => n.length == 3).toList();
    return Scaffold(
      appBar: AppBar(title: Text('ฝันเห็น${dream.keyword}')),
      body: ListView(padding: const EdgeInsets.all(AppSpacing.md), children: [
        DreamImage(url: dream.imageUrl),
        const SectionTitle('คำทำนาย'),
        InfoCard(child: Text(dream.meaning, style: const TextStyle(height: 1.6, fontSize: 16))),
        if (two.isNotEmpty) ...[const SectionTitle('เลขเด็ด 2 ตัว'), NumberWrap(two, large: true)],
        if (three.isNotEmpty) ...[const SectionTitle('เลขเด็ด 3 ตัว'), NumberWrap(three, large: true)],
        const SectionTitle('แหล่งที่มา'),
        Text(dream.source, style: const TextStyle(color: AppColors.textMuted)),
        const SizedBox(height: AppSpacing.lg),
        OutlinedButton.icon(
          onPressed: () => Navigator.pushNamed(context, '/remedies'),
          icon: const Icon(Icons.healing),
          label: const Text('วิธีแก้ฝันร้าย'),
        ),
        const SizedBox(height: AppSpacing.lg),
        const Text('คำทำนายเป็นความเชื่อตามตำรา ใช้เพื่อความบันเทิงเท่านั้น',
            textAlign: TextAlign.center, style: TextStyle(color: AppColors.textMuted, fontSize: 12)),
      ]),
    );
  }
}

class CategoriesScreen extends StatelessWidget {
  const CategoriesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('หมวดหมู่ความฝัน')),
      body: AsyncView<List<DreamCategory>>(
        load: _repo.categories,
        isEmpty: (d) => d.isEmpty,
        builder: (context, cats) => GridView.builder(
          padding: const EdgeInsets.all(AppSpacing.md),
          gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
            maxCrossAxisExtent: 180, mainAxisSpacing: 12, crossAxisSpacing: 12, childAspectRatio: 1.1),
          itemCount: cats.length,
          itemBuilder: (_, i) => InfoCard(
            onTap: () => Navigator.pushNamed(context, '/category', arguments: cats[i]),
            child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              Text(cats[i].icon, style: const TextStyle(fontSize: 40)),
              const SizedBox(height: AppSpacing.sm),
              Text(cats[i].name, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
            ]),
          ),
        ),
      ),
    );
  }
}

class CategoryDreamsScreen extends StatelessWidget {
  final DreamCategory category;
  const CategoryDreamsScreen({super.key, required this.category});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('หมวด${category.name}')),
      body: AsyncView<List<Dream>>(
        load: () => _repo.byCategory(category.id),
        isEmpty: (d) => d.isEmpty,
        emptyMessage: 'ยังไม่มีคำทำนายในหมวดนี้',
        builder: (_, list) => ListView.separated(
          padding: const EdgeInsets.all(AppSpacing.md),
          itemCount: list.length,
          separatorBuilder: (_, _) => const SizedBox(height: AppSpacing.sm),
          itemBuilder: (_, i) => DreamTile(list[i]),
        ),
      ),
    );
  }
}
