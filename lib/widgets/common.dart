import 'package:flutter/material.dart';

import '../theme.dart';

/// Wraps a future with consistent loading / error / empty states.
class AsyncView<T> extends StatefulWidget {
  final Future<T> Function() load;
  final bool Function(T data)? isEmpty;
  final String emptyMessage;
  final Widget Function(BuildContext context, T data) builder;

  const AsyncView({
    super.key,
    required this.load,
    required this.builder,
    this.isEmpty,
    this.emptyMessage = 'ยังไม่มีข้อมูล',
  });

  @override
  State<AsyncView<T>> createState() => _AsyncViewState<T>();
}

class _AsyncViewState<T> extends State<AsyncView<T>> {
  late Future<T> _future = widget.load();

  void _retry() => setState(() => _future = widget.load());

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<T>(
      future: _future,
      builder: (context, snap) {
        if (snap.connectionState != ConnectionState.done) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snap.hasError) {
          return StateMessage(
            icon: Icons.cloud_off,
            title: 'โหลดข้อมูลไม่สำเร็จ',
            message: 'กรุณาตรวจสอบการเชื่อมต่อแล้วลองใหม่',
            action: FilledButton(onPressed: _retry, child: const Text('ลองใหม่')),
          );
        }
        final data = snap.data as T;
        if (data == null || (widget.isEmpty?.call(data) ?? false)) {
          return StateMessage(icon: Icons.inbox_outlined, title: widget.emptyMessage);
        }
        return widget.builder(context, data);
      },
    );
  }
}

class StateMessage extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? message;
  final Widget? action;
  const StateMessage({super.key, required this.icon, required this.title, this.message, this.action});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          Icon(icon, size: 56, color: AppColors.textMuted),
          const SizedBox(height: AppSpacing.md),
          Text(title, textAlign: TextAlign.center, style: Theme.of(context).textTheme.titleMedium),
          if (message != null) ...[
            const SizedBox(height: AppSpacing.sm),
            Text(message!, textAlign: TextAlign.center, style: const TextStyle(color: AppColors.textMuted)),
          ],
          if (action != null) ...[const SizedBox(height: AppSpacing.md), action!],
        ]),
      ),
    );
  }
}

class NumberChip extends StatelessWidget {
  final String number;
  final bool large;
  const NumberChip(this.number, {super.key, this.large = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: large ? 20 : 14, vertical: large ? 12 : 8),
      decoration: BoxDecoration(
        gradient: const LinearGradient(colors: [AppColors.gold, Color(0xFFC99A3B)]),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        number,
        style: TextStyle(
          color: AppColors.night,
          fontWeight: FontWeight.bold,
          fontSize: large ? 28 : 18,
          letterSpacing: 2,
        ),
      ),
    );
  }
}

class NumberWrap extends StatelessWidget {
  final List<String> numbers;
  final bool large;
  const NumberWrap(this.numbers, {super.key, this.large = false});

  @override
  Widget build(BuildContext context) => Wrap(
        spacing: AppSpacing.sm,
        runSpacing: AppSpacing.sm,
        children: [for (final n in numbers) NumberChip(n, large: large)],
      );
}

class SectionTitle extends StatelessWidget {
  final String text;
  final Widget? trailing;
  const SectionTitle(this.text, {super.key, this.trailing});

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.only(top: AppSpacing.lg, bottom: AppSpacing.sm),
        child: Row(children: [
          Expanded(
            child: Text(text,
                style: const TextStyle(color: AppColors.goldSoft, fontSize: 18, fontWeight: FontWeight.bold)),
          ),
          ?trailing,
        ]),
      );
}

class InfoCard extends StatelessWidget {
  final Widget child;
  final VoidCallback? onTap;
  const InfoCard({super.key, required this.child, this.onTap});

  @override
  Widget build(BuildContext context) => Card(
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          child: Padding(padding: const EdgeInsets.all(AppSpacing.md), child: child),
        ),
      );
}

/// Image with placeholder for missing / failed images.
class DreamImage extends StatelessWidget {
  final String? url;
  final String fallbackEmoji;
  final double height;
  const DreamImage({super.key, this.url, this.fallbackEmoji = '🌙', this.height = 180});

  @override
  Widget build(BuildContext context) {
    final placeholder = Container(
      height: height,
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppColors.nightSoft, AppColors.card],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(AppSpacing.radius),
      ),
      alignment: Alignment.center,
      child: Text(fallbackEmoji, style: TextStyle(fontSize: height / 3)),
    );
    if (url == null || url!.isEmpty) return placeholder;
    return ClipRRect(
      borderRadius: BorderRadius.circular(AppSpacing.radius),
      child: Image.network(url!, height: height, width: double.infinity, fit: BoxFit.cover,
          errorBuilder: (_, _, _) => placeholder),
    );
  }
}

class SampleDataBanner extends StatelessWidget {
  const SampleDataBanner({super.key});

  @override
  Widget build(BuildContext context) => Container(
        width: double.infinity,
        padding: const EdgeInsets.all(AppSpacing.sm),
        margin: const EdgeInsets.only(bottom: AppSpacing.md),
        decoration: BoxDecoration(
          color: AppColors.gold.withValues(alpha: 0.12),
          borderRadius: BorderRadius.circular(8),
        ),
        child: const Text(
          'ข้อมูลและสูตรในหน้านี้เป็นตัวอย่าง ใช้เพื่อความเชื่อและความบันเทิงเท่านั้น',
          style: TextStyle(color: AppColors.goldSoft, fontSize: 12),
          textAlign: TextAlign.center,
        ),
      );
}
