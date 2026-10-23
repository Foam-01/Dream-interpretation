import 'package:flutter/material.dart';

import '../data/repository.dart';
import '../models.dart';
import '../theme.dart';
import '../widgets/common.dart';
import 'dream_screens.dart';

class _Feature {
  final String label;
  final String emoji;
  final String route;
  const _Feature(this.label, this.emoji, this.route);
}

const _features = <_Feature>[
  _Feature('หมวดหมู่ฝัน', '📚', '/categories'),
  _Feature('เลขนำโชค', '🍀', '/lucky'),
  _Feature('ความหมายตัวเลข', '🔢', '/digits'),
  _Feature('เลขล็อกรายวัน', '🔒', '/locked'),
  _Feature('สูตรวันหวยออก', '📅', '/formula-draw'),
  _Feature('สูตรดาราศาสตร์', '🪐', '/formula-astro'),
  _Feature('เลขวิ่ง', '🏃', '/running'),
  _Feature('แก้ฝันร้าย', '🛡️', '/remedies'),
  _Feature('ขอโชค', '✨', '/luck'),
  _Feature('บทสวดขอฝัน', '🙏', '/prayers'),
  _Feature('เลขสัตว์', '🐘', '/animals'),
  _Feature('ดัชนีแปะกง', '🀄', '/paekong'),
  _Feature('ตำราฝันโบราณ', '📜', '/rules'),
];

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final repo = DreamRepository.instance;
    final today = DateUtils.dateOnly(DateTime.now());
    return Scaffold(
      body: SafeArea(
        child: ListView(padding: const EdgeInsets.all(AppSpacing.md), children: [
          const SizedBox(height: AppSpacing.sm),
          const Text('🌙 มหาทำนายฝัน',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: AppColors.gold)),
          const Text('ทำนายฝัน ตีเลขเด็ด ตามตำราโบราณ',
              textAlign: TextAlign.center, style: TextStyle(color: AppColors.textMuted)),
          const SizedBox(height: AppSpacing.lg),
          TextField(
            readOnly: true,
            onTap: () => Navigator.pushNamed(context, '/search'),
            decoration: const InputDecoration(hintText: 'เมื่อคืนฝันเห็นอะไร...', prefixIcon: Icon(Icons.search)),
          ),
          SectionTitle('เลขล็อกวันนี้ · ${thaiDate(today)}',
              trailing: TextButton(
                  onPressed: () => Navigator.pushNamed(context, '/locked'), child: const Text('ดูทั้งหมด'))),
          SizedBox(
            height: 64,
            child: AsyncView<LockedNumbers?>(
              load: () => repo.lockedNumbers(today),
              emptyMessage: 'วันนี้ยังไม่มีเลขล็อก',
              builder: (_, d) => Align(alignment: Alignment.centerLeft, child: NumberWrap(d!.twoDigits, large: true)),
            ),
          ),
          const SectionTitle('เมนูทั้งหมด'),
          GridView.count(
            crossAxisCount: 3,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            mainAxisSpacing: 10,
            crossAxisSpacing: 10,
            childAspectRatio: 0.95,
            children: [
              for (final f in _features)
                InfoCard(
                  onTap: () => Navigator.pushNamed(context, f.route),
                  child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                    Text(f.emoji, style: const TextStyle(fontSize: 30)),
                    const SizedBox(height: AppSpacing.xs),
                    Text(f.label, textAlign: TextAlign.center, style: const TextStyle(fontSize: 13)),
                  ]),
                ),
            ],
          ),
          const SectionTitle('ฝันยอดนิยม'),
          AsyncView<List<Dream>>(
            load: repo.popular,
            isEmpty: (d) => d.isEmpty,
            builder: (_, list) => Column(children: [
              for (final d in list)
                Padding(padding: const EdgeInsets.only(bottom: AppSpacing.sm), child: DreamTile(d)),
            ]),
          ),
        ]),
      ),
    );
  }
}
