import 'package:flutter/material.dart';

import '../app_shell.dart';
import '../data/design_data.dart';
import '../data/dream_images_k.dart';
import '../state/load_request.dart';
import '../theme.dart';
import '../widgets/ui.dart';

class ResultScreen extends StatefulWidget {
  final String dreamId;
  const ResultScreen({super.key, required this.dreamId});

  @override
  State<ResultScreen> createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen> {
  // One request per screen: AppShell gives every dream page its own key, so
  // a different dream id always gets a fresh State (no stale detail).
  final _request = LoadRequest<Dream?>();
  bool _started = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_started) return;
    _started = true;
    final repo = AppScope.of(context).repository;
    _request.run(() => repo.byId(widget.dreamId));
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
    final app = AppScope.of(context);
    switch (_request.status) {
      case LoadStatus.idle || LoadStatus.loading:
        return _Placeholder(onBack: () => app.goSearch(), child: const GoldLoading(height: 200));
      case LoadStatus.failure:
        return _Placeholder(
          onBack: () => app.goSearch(),
          child: LoadErrorView(message: loadErrorMessage(_request.error), onRetry: _request.retry),
        );
      case LoadStatus.success:
    }
    final d = _request.value;
    // Unknown id: never fall back to another dream; show a not-found state.
    if (d == null) {
      return _Placeholder(
        onBack: () => app.goSearch(),
        child: Text('ไม่พบความฝันนี้', textAlign: TextAlign.center, style: sans(14, color: C.caption)),
      );
    }
    final saved = app.saved.contains(d.id);

    return ListView(padding: EdgeInsets.zero, children: [
      RedHeader(
        padding: const EdgeInsets.fromLTRB(16, 10, 16, 20),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(children: [
            BackLink(label: 'กลับ', onTap: () => app.goSearch()),
            const Spacer(),
            Semantics(
              button: true,
              child: GestureDetector(
                onTap: () => app.toggleSave(d.id),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: C.gold),
                  ),
                  child: Row(mainAxisSize: MainAxisSize.min, children: [
                    Icon(saved ? Icons.star : Icons.star_border, size: 16, color: C.goldLight),
                    const SizedBox(width: 4),
                    Text(saved ? 'บันทึกแล้ว' : 'บันทึก', style: sans(14, color: C.goldLight)),
                  ]),
                ),
              ),
            ),
          ]),
          const SizedBox(height: 6),
          DreamImageView(
            image: dreamImageFor(d.id, d.image),
            placeholderLabel: 'ภาพประกอบ: ${d.name}',
            height: 170,
            width: double.infinity,
            radius: 16,
            fontSize: 12,
            band: 8,
            border: Border.all(color: C.gold, width: 2),
          ),
          if (d.image?.attribution case final credit?) ...[
            const SizedBox(height: 4),
            Text(credit, style: sans(11, color: C.onRedMuted)),
          ],
          const SizedBox(height: 14),
          // The name as written in the source (no added "ฝันเห็น": many names are actions, e.g. กินข้าว).
          Text(d.name, style: serif(26, weight: FontWeight.w800, color: C.goldLight)),
          // Sourced content names its source; the bundled SAMPLE data keeps the original design text.
          // Only a cited source is named; no source → no claim about where the text comes from.
          Text(
            [d.cat.startsWith('หมวด') ? d.cat : 'หมวด${d.cat}', ?d.source?.title].join(' · '),
            style: sans(14, color: C.onRedMuted),
          ),
        ]),
      ),
      Padding(
        padding: const EdgeInsets.all(16),
        child: CreamCard(
          borderWidth: 1.5,
          child: Column(children: [
            Text('เลขนำโชคจากความฝัน', style: serif(15, color: C.red)),
            const SizedBox(height: 10),
            if (d.digits.isNotEmpty) ...[
              Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                for (final n in d.digits)
                  Padding(padding: const EdgeInsets.symmetric(horizontal: 4), child: DigitBox(n)),
              ]),
              const SizedBox(height: 14),
            ],
            // "ไม่ควรเสี่ยง" is shown as the source says it, never as numbers.
            if (d.numbers.isNone)
              const SizedBox(
                width: double.infinity,
                child: _NumTile(label: 'เลขเสี่ยงโชค', value: LuckyNumbers.noLuckyNumbersText),
              )
            else
              Row(children: [
                Expanded(child: _NumTile(label: 'สองตัว', value: d.two)),
                const SizedBox(width: 8),
                Expanded(child: _NumTile(label: 'สามตัว', value: d.three)),
              ]),
          ]),
        ),
      ),
      Padding(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
        child: Column(children: [
          CreamCard(
            child: SizedBox(
              width: double.infinity,
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text('คำทำนาย', style: serif(16)),
                const SizedBox(height: 6),
                Text(d.meaning, style: sans(15, color: C.inkBody, height: 1.7)),
                if (d.source != null) ...[
                  const SizedBox(height: 10),
                  Text('ที่มา: ${d.source!.citation}', style: sans(12, color: C.caption)),
                ],
              ]),
            ),
          ),
          // Forecast scores and advice are optional: sourced content shows only what its source gives.
          if (d.luckForecast case final f?) ...[
            const SizedBox(height: 12),
            CreamCard(
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text('พยากรณ์โชคชะตา', style: serif(16)),
                const SizedBox(height: 10),
                _LuckBar(label: 'การเงิน', value: f.money),
                _LuckBar(label: 'ความรัก', value: f.love),
                _LuckBar(label: 'สุขภาพ', value: f.health),
              ]),
            ),
          ],
          if (d.advice case final advice?) ...[
          const SizedBox(height: 12),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(color: C.red, borderRadius: BorderRadius.circular(16)),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(
                switch (d.good) {
                  true => 'เคล็ดลับขอโชค',
                  false => 'เคล็ดลับแก้ฝันร้าย',
                  null => 'คำแนะนำ',
                },
                style: serif(16, color: C.goldLight),
              ),
              const SizedBox(height: 6),
              Text(advice, style: sans(14, color: C.onRed, height: 1.7)),
              const SizedBox(height: 12),
              Semantics(
                button: true,
                child: GestureDetector(
                  onTap: () => app.goTab('ritual'),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(color: C.gold, borderRadius: BorderRadius.circular(20)),
                    child: Text('อ่านบทสวด ›', style: sans(14, weight: FontWeight.w600, color: C.redDeep)),
                  ),
                ),
              ),
            ]),
          ),
          ],
        ]),
      ),
    ]);
  }
}

class _NumTile extends StatelessWidget {
  final String label, value;
  const _NumTile({required this.label, required this.value});

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(color: C.tileLight, borderRadius: BorderRadius.circular(10)),
        child: Column(children: [
          Text(label, style: sans(12, color: C.imgText)),
          Text(value, style: serif(18, color: C.red)),
        ]),
      );
}

class _LuckBar extends StatelessWidget {
  final String label;
  final int value;
  const _LuckBar({required this.label, required this.value});

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.only(bottom: 8),
        child: Row(children: [
          SizedBox(width: 56, child: Text(label, style: sans(14, color: C.inkSoft))),
          const SizedBox(width: 10),
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: Container(
                height: 8,
                color: C.divider,
                alignment: Alignment.centerLeft,
                child: FractionallySizedBox(
                  widthFactor: value / 100,
                  child: Container(
                    decoration: const BoxDecoration(gradient: LinearGradient(colors: [C.goldDeep, C.redBright])),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: 10),
          SizedBox(width: 30, child: Text('$value', textAlign: TextAlign.right, style: sans(13, color: C.red))),
        ]),
      );
}

/// Red header with a back link above a not-found, loading or error body.
class _Placeholder extends StatelessWidget {
  final VoidCallback onBack;
  final Widget child;
  const _Placeholder({required this.onBack, required this.child});

  @override
  Widget build(BuildContext context) => ListView(padding: EdgeInsets.zero, children: [
        RedHeader(
          padding: const EdgeInsets.fromLTRB(16, 10, 16, 20),
          child: Align(alignment: Alignment.centerLeft, child: BackLink(label: 'กลับ', onTap: onBack)),
        ),
        Padding(padding: const EdgeInsets.symmetric(vertical: 40), child: child),
      ]);
}
