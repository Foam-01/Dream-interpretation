import 'package:flutter/material.dart';

import '../data/repository.dart';
import '../models.dart';
import '../theme.dart';
import '../widgets/common.dart';

final _repo = DreamRepository.instance;

class LuckyNumbersScreen extends StatelessWidget {
  const LuckyNumbersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('เลขนำโชค')),
      body: AsyncView<List<Dream>>(
        load: _repo.popular,
        isEmpty: (d) => d.isEmpty,
        builder: (context, dreams) {
          final all = dreams.expand((d) => d.numbers).where((n) => n.length == 2).toSet().toList();
          return ListView(padding: const EdgeInsets.all(AppSpacing.md), children: [
            const SampleDataBanner(),
            const SectionTitle('เลขยอดนิยมจากความฝัน'),
            NumberWrap(all, large: true),
            const SectionTitle('ที่มาของเลข'),
            for (final d in dreams)
              Padding(
                padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                child: InfoCard(
                  onTap: () => Navigator.pushNamed(context, '/dream', arguments: d),
                  child: Row(children: [
                    Expanded(child: Text('ฝันเห็น${d.keyword}', style: const TextStyle(fontSize: 16))),
                    Text(d.numbers.join(' '), style: const TextStyle(color: AppColors.gold)),
                  ]),
                ),
              ),
          ]);
        },
      ),
    );
  }
}

class DigitMeaningsScreen extends StatelessWidget {
  const DigitMeaningsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('ความหมายของตัวเลข')),
      body: AsyncView<List<DigitMeaning>>(
        load: _repo.digitMeanings,
        isEmpty: (d) => d.isEmpty,
        builder: (_, list) => ListView.separated(
          padding: const EdgeInsets.all(AppSpacing.md),
          itemCount: list.length,
          separatorBuilder: (_, _) => const SizedBox(height: AppSpacing.sm),
          itemBuilder: (_, i) => InfoCard(
            child: Row(children: [
              NumberChip(list[i].digit, large: true),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(list[i].meaning, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                  const SizedBox(height: AppSpacing.xs),
                  Text('สัญลักษณ์: ${list[i].symbols.join(', ')}',
                      style: const TextStyle(color: AppColors.textMuted)),
                ]),
              ),
            ]),
          ),
        ),
      ),
    );
  }
}

/// Shared date selector header used by date-based number screens.
class _DateHeader extends StatelessWidget {
  final DateTime date;
  final String label;
  final VoidCallback onPrev;
  final VoidCallback onNext;
  final VoidCallback onPick;
  const _DateHeader({required this.date, required this.label, required this.onPrev, required this.onNext, required this.onPick});

  @override
  Widget build(BuildContext context) => InfoCard(
        child: Row(children: [
          IconButton(tooltip: 'ก่อนหน้า', onPressed: onPrev, icon: const Icon(Icons.chevron_left)),
          Expanded(
            child: InkWell(
              onTap: onPick,
              child: Column(children: [
                Text(label, style: const TextStyle(color: AppColors.textMuted)),
                Text(thaiDate(date), style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.goldSoft)),
              ]),
            ),
          ),
          IconButton(tooltip: 'ถัดไป', onPressed: onNext, icon: const Icon(Icons.chevron_right)),
        ]),
      );
}

Future<DateTime?> _pickDate(BuildContext context, DateTime initial) => showDatePicker(
      context: context,
      initialDate: initial,
      firstDate: DateTime(2020),
      lastDate: DateTime(2035),
      locale: const Locale('th'),
    );

class DailyLockedNumbersScreen extends StatefulWidget {
  const DailyLockedNumbersScreen({super.key});
  @override
  State<DailyLockedNumbersScreen> createState() => _DailyLockedNumbersScreenState();
}

class _DailyLockedNumbersScreenState extends State<DailyLockedNumbersScreen> {
  DateTime _date = DateUtils.dateOnly(DateTime.now());

  void _set(DateTime d) => setState(() => _date = d);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('เลขล็อกประจำวัน')),
      body: Column(children: [
        Padding(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: _DateHeader(
            date: _date,
            label: 'ประจำวันที่',
            onPrev: () => _set(_date.subtract(const Duration(days: 1))),
            onNext: () => _set(_date.add(const Duration(days: 1))),
            onPick: () async {
              final d = await _pickDate(context, _date);
              if (d != null) _set(d);
            },
          ),
        ),
        Expanded(
          child: AsyncView<LockedNumbers?>(
            key: ValueKey(_date),
            load: () => _repo.lockedNumbers(_date),
            emptyMessage: 'ยังไม่มีเลขล็อกสำหรับวันนี้',
            builder: (_, data) => ListView(padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md), children: [
              const SampleDataBanner(),
              const SectionTitle('เลขล็อก 2 ตัว'),
              NumberWrap(data!.twoDigits, large: true),
              const SectionTitle('เลขล็อก 3 ตัว'),
              NumberWrap(data.threeDigits, large: true),
            ]),
          ),
        ),
      ]),
    );
  }
}

class FormulaScreen extends StatefulWidget {
  final String title;
  final FormulaResult Function(DateTime) compute;
  const FormulaScreen({super.key, required this.title, required this.compute});

  @override
  State<FormulaScreen> createState() => _FormulaScreenState();
}

class _FormulaScreenState extends State<FormulaScreen> {
  DateTime _draw = nextDrawDate(DateTime.now());

  DateTime _next(DateTime d) => nextDrawDate(d.add(const Duration(days: 1)));

  @override
  Widget build(BuildContext context) {
    final r = widget.compute(_draw);
    return Scaffold(
      appBar: AppBar(title: Text(widget.title)),
      body: ListView(padding: const EdgeInsets.all(AppSpacing.md), children: [
        const SampleDataBanner(),
        _DateHeader(
          date: _draw,
          label: 'งวดวันที่',
          onPrev: () => setState(() => _draw = previousDrawDate(_draw)),
          onNext: () => setState(() => _draw = _next(_draw)),
          onPick: () async {
            final d = await _pickDate(context, _draw);
            if (d != null) setState(() => _draw = nextDrawDate(d));
          },
        ),
        const SectionTitle('เลขจากสูตร'),
        NumberWrap(r.numbers, large: true),
        const SectionTitle('วิธีคำนวณ'),
        InfoCard(child: Text(r.explanation, style: const TextStyle(height: 1.7))),
      ]),
    );
  }
}

class RunningNumbersScreen extends StatefulWidget {
  const RunningNumbersScreen({super.key});
  @override
  State<RunningNumbersScreen> createState() => _RunningNumbersScreenState();
}

class _RunningNumbersScreenState extends State<RunningNumbersScreen> {
  DateTime _draw = previousDrawDate(nextDrawDate(DateTime.now()));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('เลขวิ่ง')),
      body: Column(children: [
        Padding(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: _DateHeader(
            date: _draw,
            label: 'งวดวันที่',
            onPrev: () => setState(() => _draw = previousDrawDate(_draw)),
            onNext: () => setState(() => _draw = nextDrawDate(_draw.add(const Duration(days: 1)))),
            onPick: () async {
              final d = await _pickDate(context, _draw);
              if (d != null) setState(() => _draw = nextDrawDate(d));
            },
          ),
        ),
        Expanded(
          child: AsyncView<List<String>?>(
            key: ValueKey(_draw),
            load: () => _repo.runningNumbers(_draw),
            emptyMessage: 'ยังไม่มีข้อมูลเลขวิ่งของงวดนี้',
            builder: (_, nums) => ListView(padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md), children: [
              const SampleDataBanner(),
              const SectionTitle('เลขวิ่ง (ตัวเดียว)'),
              NumberWrap(nums!, large: true),
              const SectionTitle('จับคู่ 2 ตัว'),
              NumberWrap([
                for (final a in nums)
                  for (final b in nums)
                    if (a != b) '$a$b',
              ]),
            ]),
          ),
        ),
      ]),
    );
  }
}
