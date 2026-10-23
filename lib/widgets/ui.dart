import 'dart:math' as math;

import 'package:flutter/material.dart';

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
                  style: TextStyle(fontFamily: 'monospace', fontSize: fontSize, color: C.imgText)),
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

/// Red gradient square holding a glyph (menu / quick links).
class GlyphTile extends StatelessWidget {
  final String glyph;
  final double size, radius, fontSize, borderWidth;
  const GlyphTile(this.glyph,
      {super.key, this.size = 58, this.radius = 16, this.fontSize = 20, this.borderWidth = 1.5});

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
        ),
        child: Text(glyph, style: serif(fontSize, color: C.goldLight)),
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
