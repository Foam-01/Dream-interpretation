import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../data/design_data.dart';
import '../theme.dart';

/// Gold diagonal lattice overlay used on red headers.
class _LatticePainter extends CustomPainter {
  final double opacity;
  const _LatticePainter(this.opacity);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = C.gold.withValues(alpha: opacity)
      ..strokeWidth = 1;
    const step = 14.0 * math.sqrt2;
    final extent = size.width + size.height;
    for (double x = -extent; x < extent; x += step) {
      canvas.drawLine(Offset(x, 0), Offset(x + size.height, size.height), paint);
      canvas.drawLine(Offset(x + size.height, 0), Offset(x, size.height), paint);
    }
  }

  @override
  bool shouldRepaint(_LatticePainter old) => old.opacity != opacity;
}

/// Red gradient header with gold lattice pattern.
class RedHeader extends StatelessWidget {
  final Widget child;
  final EdgeInsets padding;
  final bool pattern;
  final bool gradient;
  final double patternOpacity;
  const RedHeader({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.fromLTRB(16, 6, 16, 16),
    this.pattern = true,
    this.gradient = true,
    this.patternOpacity = .12,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: C.red,
        gradient: gradient
            ? const LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [C.red, C.redBright])
            : null,
      ),
      child: Stack(children: [
        if (pattern) Positioned.fill(child: CustomPaint(painter: _LatticePainter(patternOpacity))),
        Padding(padding: padding, child: child),
      ]),
    );
  }
}

/// Header used on feature/detail screens: back link, title, subtitle.
class FeatureHeader extends StatelessWidget {
  final String backLabel;
  final VoidCallback onBack;
  final String title;
  final String? sub;
  const FeatureHeader({super.key, required this.backLabel, required this.onBack, required this.title, this.sub});

  @override
  Widget build(BuildContext context) => RedHeader(
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          BackLink(label: backLabel, onTap: onBack),
          Text(title, style: serif(22, weight: FontWeight.w800, color: C.goldLight)),
          if (sub != null) Text(sub!, style: sans(13, color: C.onRedMuted)),
        ]),
      );
}

class BackLink extends StatelessWidget {
  final String label;
  final VoidCallback onTap;
  const BackLink({super.key, required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) => Semantics(
        button: true,
        label: 'กลับ',
        child: InkWell(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Text('‹ $label', style: sans(15, color: C.gold)),
          ),
        ),
      );
}

/// Cream card with gold border.
class CreamCard extends StatelessWidget {
  final Widget child;
  final EdgeInsets padding;
  final double radius;
  final double borderWidth;
  final VoidCallback? onTap;
  final List<BoxShadow>? shadow;
  const CreamCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(16),
    this.radius = 16,
    this.borderWidth = 1,
    this.onTap,
    this.shadow,
  });

  @override
  Widget build(BuildContext context) {
    final r = BorderRadius.circular(radius);
    return Container(
      decoration: BoxDecoration(
        color: C.card,
        borderRadius: r,
        border: Border.all(color: C.goldBorder, width: borderWidth),
        boxShadow: shadow,
      ),
      child: Material(
        type: MaterialType.transparency,
        child: InkWell(
          borderRadius: r,
          onTap: onTap,
          child: ClipRRect(borderRadius: r, child: Padding(padding: padding, child: child)),
        ),
      ),
    );
  }
}

class _StripePainter extends CustomPainter {
  final double band;
  const _StripePainter(this.band);

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawRect(Offset.zero & size, Paint()..color = C.stripeA);
    final p = Paint()
      ..color = C.stripeB
      ..strokeWidth = band;
    final step = band * 2 * math.sqrt2;
    final extent = size.width + size.height;
    for (double x = -extent; x < extent; x += step) {
      canvas.drawLine(Offset(x, 0), Offset(x + size.height, size.height), p);
    }
  }

  @override
  bool shouldRepaint(_StripePainter old) => old.band != band;
}

/// Striped image placeholder (design has no real artwork yet).
class ImagePlaceholder extends StatelessWidget {
  final String label;
  final double? height;
  final double? width;
  final double radius;
  final double fontSize;
  final double band;
  final BoxBorder? border;
  const ImagePlaceholder(this.label,
      {super.key, this.height, this.width, this.radius = 0, this.fontSize = 10, this.band = 6, this.border});

  @override
  Widget build(BuildContext context) => Container(
        height: height,
        width: width,
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(radius), border: border),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(radius),
          child: CustomPaint(
            painter: _StripePainter(band),
            child: Center(
              child: Text(label,
                  textAlign: TextAlign.center,
                  // Bundled Thai font (not the system 'monospace') so tests and devices match.
                  style: sans(fontSize, color: C.imgText)),
            ),
          ),
        ),
      );
}

/// Big red tile showing one digit.
class DigitBox extends StatelessWidget {
  final String digit;
  final double width, height, fontSize;
  const DigitBox(this.digit, {super.key, this.width = 60, this.height = 70, this.fontSize = 32});

  @override
  Widget build(BuildContext context) => Container(
        width: width,
        height: height,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: C.red,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: C.gold, width: 2),
        ),
        child: Text(digit, style: serif(fontSize, weight: FontWeight.w800, color: C.goldLight, height: 1.2)),
      );
}

/// Icon for a feature key ('dream' or a FeatDef key) on menu / quick-link tiles.
IconData featureIcon(String key) => switch (key) {
      'dream' => Icons.nightlight_round,
      '1' => Icons.auto_awesome_rounded,
      '2' => Icons.grid_view_rounded,
      '3' => Icons.shield_moon_rounded,
      '4' => Icons.volunteer_activism_rounded,
      '5' => Icons.pets_rounded,
      '6' => Icons.auto_stories_rounded,
      '7' => Icons.lock_rounded,
      '8' => Icons.event_available_rounded,
      '9' => Icons.stars_rounded,
      '10' => Icons.trending_up_rounded,
      '11' => Icons.self_improvement_rounded,
      '12' => Icons.pin_rounded,
      '13' || '14' || '15' || '16' || '17' || '18' || '19' || '20' || '21' || '22' => Icons.sort_by_alpha_rounded,
      _ => Icons.star_rounded,
    };

/// Red gradient square holding a gold icon (menu / quick links).
class GlyphTile extends StatelessWidget {
  final IconData icon;
  final double size, radius, borderWidth;
  const GlyphTile(this.icon, {super.key, this.size = 58, this.radius = 16, this.borderWidth = 1.5});

  @override
  Widget build(BuildContext context) => Container(
        width: size,
        height: size,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(radius),
          gradient: const LinearGradient(
              begin: Alignment(-0.35, -1), end: Alignment(0.35, 1), colors: [C.redTile, C.red]),
          border: Border.all(color: C.goldBorder, width: borderWidth),
          boxShadow: const [BoxShadow(color: Color(0x33781E0A), blurRadius: 8, offset: Offset(0, 3))],
        ),
        child: Icon(icon, size: size * .5, color: C.goldLight),
      );
}

/// Selectable pill/chip used for categories, weekdays, hundreds, digits.
class SelectPill extends StatelessWidget {
  final String text;
  final bool selected;
  final VoidCallback onTap;
  final Color selectedBg, selectedFg, bg, fg, border;
  final EdgeInsets padding;
  final double radius, fontSize;
  final FontWeight weight;
  const SelectPill({
    super.key,
    required this.text,
    required this.selected,
    required this.onTap,
    this.selectedBg = C.red,
    this.selectedFg = C.goldLight,
    this.bg = C.card,
    this.fg = C.red,
    this.border = C.goldBorder,
    this.padding = const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
    this.radius = 18,
    this.fontSize = 13,
    this.weight = FontWeight.w600,
  });

  @override
  Widget build(BuildContext context) => Semantics(
        selected: selected,
        button: true,
        child: GestureDetector(
          onTap: onTap,
          child: Container(
            padding: padding,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: selected ? selectedBg : bg,
              borderRadius: BorderRadius.circular(radius),
              border: Border.all(color: border),
            ),
            child: Text(text, style: sans(fontSize, weight: weight, color: selected ? selectedFg : fg)),
          ),
        ),
      );
}

class SectionLabel extends StatelessWidget {
  final String text;
  final EdgeInsets padding;
  final double size;
  const SectionLabel(this.text, {super.key, this.padding = const EdgeInsets.fromLTRB(16, 22, 16, 8), this.size = 17});

  @override
  Widget build(BuildContext context) => Padding(padding: padding, child: Text(text, style: serif(size)));
}

/// Fixed-column grid whose rows size to their content, so cells grow with the
/// user's text scale instead of overflowing a fixed `mainAxisExtent`.
/// [minRowHeight] keeps the original look at the default text scale.
class ContentGrid extends StatelessWidget {
  final int columns;
  final double spacing, runSpacing, minRowHeight;
  final List<Widget> children;
  const ContentGrid({
    super.key,
    required this.columns,
    required this.children,
    this.spacing = 0,
    this.runSpacing = 0,
    this.minRowHeight = 0,
  });

  @override
  Widget build(BuildContext context) {
    final rows = <Widget>[];
    for (var start = 0; start < children.length; start += columns) {
      if (rows.isNotEmpty) rows.add(SizedBox(height: runSpacing));
      rows.add(ConstrainedBox(
        constraints: BoxConstraints(minHeight: minRowHeight),
        child: IntrinsicHeight(
          child: Row(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
            for (var c = 0; c < columns; c++) ...[
              if (c > 0) SizedBox(width: spacing),
              Expanded(child: start + c < children.length ? children[start + c] : const SizedBox()),
            ],
          ]),
        ),
      ));
    }
    return Column(children: rows);
  }
}

/// Centered gold progress indicator for data that is still loading.
class GoldLoading extends StatelessWidget {
  final double height;
  const GoldLoading({super.key, this.height = 120});

  @override
  Widget build(BuildContext context) => SizedBox(
        height: height,
        child: const Center(
          child: SizedBox(
            width: 28,
            height: 28,
            child: CircularProgressIndicator(strokeWidth: 3, color: C.gold, semanticsLabel: 'กำลังโหลด'),
          ),
        ),
      );
}

/// Short Thai error message with a gold "ลองใหม่" (retry) pill.
class LoadErrorView extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;
  const LoadErrorView({super.key, required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          Text(message, textAlign: TextAlign.center, style: sans(14, color: C.caption)),
          const SizedBox(height: 12),
          Semantics(
            button: true,
            child: GestureDetector(
              onTap: onRetry,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                decoration: BoxDecoration(color: C.gold, borderRadius: BorderRadius.circular(20)),
                child: Text('ลองใหม่', style: sans(14, weight: FontWeight.w600, color: C.redDeep)),
              ),
            ),
          ),
        ]),
      );
}

/// A dream illustration from the API, or the striped placeholder when there is none.
/// The URL is not trusted to work: while loading it shows the placeholder with a small
/// gold indicator, and on any error (bad URL, 404, not an image) it falls back to the
/// placeholder, so a broken image never shows as a blank or error box.
class DreamImageView extends StatelessWidget {
  final DreamImage? image;
  final String placeholderLabel;
  final double? height;
  final double? width;
  final double radius;
  final double fontSize;
  final double band;
  final BoxBorder? border;
  final BoxFit fit;
  final Color? background;
  const DreamImageView({
    super.key,
    required this.image,
    required this.placeholderLabel,
    this.height,
    this.width,
    this.radius = 0,
    this.fontSize = 10,
    this.band = 6,
    this.border,
    this.fit = BoxFit.cover,
    this.background,
  });

  @override
  Widget build(BuildContext context) {
    final placeholder = ImagePlaceholder(placeholderLabel,
        height: height, width: width, radius: radius, fontSize: fontSize, band: band, border: border);
    final img = image;
    final uri = img == null ? null : Uri.tryParse(img.url);
    if (img == null) return placeholder;
    if (img.isAsset) {
      return Container(
        height: height,
        width: width,
        decoration: BoxDecoration(color: background, borderRadius: BorderRadius.circular(radius), border: border),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(radius),
          child: Image.asset(
            img.url,
            fit: fit,
            semanticLabel: img.alt,
            errorBuilder: (context, error, stack) =>
                ImagePlaceholder(placeholderLabel, radius: radius, fontSize: fontSize, band: band),
          ),
        ),
      );
    }
    if (uri == null || !uri.isScheme('https') || uri.host.isEmpty) return placeholder;
    return Container(
      height: height,
      width: width,
      decoration: BoxDecoration(color: background, borderRadius: BorderRadius.circular(radius), border: border),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(radius),
        child: Image.network(
          img.url,
          fit: fit,
          semanticLabel: img.alt,
          loadingBuilder: (context, child, progress) => progress == null
              ? child
              : Stack(fit: StackFit.expand, children: [
                  ImagePlaceholder(placeholderLabel, radius: radius, fontSize: fontSize, band: band),
                  const Center(
                    child: SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(strokeWidth: 2, color: C.gold),
                    ),
                  ),
                ]),
          errorBuilder: (context, error, stack) =>
              ImagePlaceholder(placeholderLabel, radius: radius, fontSize: fontSize, band: band),
        ),
      ),
    );
  }
}
