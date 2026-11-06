// Opening animation shown once when the app starts: a night sky with twinkling stars, a gold crescent
// rising inside a turning ring, then the app name. About seven seconds (the owner's choice); a tap skips it. The app is built
// underneath from the first frame, so Home is ready the moment the sky fades away.
import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../theme.dart';

/// Shows [child] with the opening animation on top until it finishes or the person taps.
class OpeningGate extends StatefulWidget {
  const OpeningGate({super.key, required this.child});
  final Widget child;

  /// Full length of the opening, fade-out included.
  static const duration = Duration(milliseconds: 7000);

  @override
  State<OpeningGate> createState() => _OpeningGateState();
}

class _OpeningGateState extends State<OpeningGate> with SingleTickerProviderStateMixin {
  late final AnimationController _c = AnimationController(vsync: this, duration: OpeningGate.duration)
    ..addStatusListener((s) {
      if (s == AnimationStatus.completed) setState(() => _done = true);
    });
  bool _done = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Reduce-motion setting: skip straight to the app.
    if (MediaQuery.of(context).disableAnimations) {
      _done = true;
    } else if (!_started) {
      _started = true;
      // The first frames are busy (Android hands over from its launch screen, Home is built underneath):
      // start the clock only once they are drawn, so the whole animation is actually seen.
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        await WidgetsBinding.instance.endOfFrame;
        await Future<void>.delayed(const Duration(milliseconds: 300));
        if (mounted && !_done) _c.forward();
      });
    }
  }

  bool _started = false;

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  void _skip() {
    // Jump to the fade-out instead of cutting away.
    if (_c.value < 0.935) _c.forward(from: 0.935);
  }

  @override
  Widget build(BuildContext context) {
    if (_done) return widget.child;
    return Stack(
      fit: StackFit.expand,
      children: [
        widget.child,
        GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: _skip,
          child: AnimatedBuilder(
            animation: _c,
            builder: (context, _) => Opacity(
              opacity: 1 - _interval(_c.value, 0.935, 1.0, Curves.easeIn),
              child: _OpeningView(t: _c.value),
            ),
          ),
        ),
      ],
    );
  }
}

/// Progress of [t] inside [begin]–[end], eased, clamped to 0–1.
double _interval(double t, double begin, double end, [Curve curve = Curves.linear]) =>
    curve.transform(((t - begin) / (end - begin)).clamp(0.0, 1.0));

class _OpeningView extends StatelessWidget {
  const _OpeningView({required this.t});
  final double t;

  @override
  Widget build(BuildContext context) {
    final moon = _interval(t, 0.0, 0.13, Curves.easeOutBack);
    final title = _interval(t, 0.1, 0.19, Curves.easeOutCubic);
    final sub = _interval(t, 0.14, 0.23, Curves.easeOutCubic);
    return Material(
      color: C.bg,
      child: Stack(
        fit: StackFit.expand,
        children: [
          CustomPaint(painter: _SkyPainter(t)),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Spacer(flex: 5),
                SizedBox(
                  width: 260,
                  height: 260,
                  child: CustomPaint(
                    painter: _MoonPainter(appear: moon, t: t),
                  ),
                ),
                const SizedBox(height: 28),
                Opacity(
                  opacity: title,
                  child: Transform.translate(
                    offset: Offset(0, 24 * (1 - title)),
                    child: ShaderMask(
                      shaderCallback: (r) => goldGradient.createShader(r),
                      child: Text(
                        'ทำนายฝัน',
                        maxLines: 1,
                        softWrap: false,
                        overflow: TextOverflow.fade,
                        style: serif(44, weight: FontWeight.w800, color: Colors.white, letterSpacing: 2, height: 1.2),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Opacity(
                  opacity: sub,
                  child: Transform.translate(
                    offset: Offset(0, 16 * (1 - sub)),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(width: 28 * sub, height: 1, color: C.goldMuted),
                        const SizedBox(width: 10),
                        Flexible(
                          child: FittedBox(
                            fit: BoxFit.scaleDown,
                            child: Text('ค้นหาความหมายของฝัน พร้อมเลขนำโชค', style: sans(15, color: C.goldLight)),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Container(width: 28 * sub, height: 1, color: C.goldMuted),
                      ],
                    ),
                  ),
                ),
                const Spacer(flex: 6),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Deep blue sky: a glow behind the moon, a faint gold lattice and twinkling stars.
class _SkyPainter extends CustomPainter {
  _SkyPainter(this.t);
  final double t;

  static final _stars = () {
    final r = math.Random(9); // fixed seed: the same sky every time
    return [for (var i = 0; i < 70; i++) (r.nextDouble(), r.nextDouble(), 0.6 + r.nextDouble() * 1.8, r.nextDouble())];
  }();

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;
    canvas.drawRect(
      rect,
      Paint()
        ..shader = const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [C.brand, C.headerEnd, C.bg],
          stops: [0, 0.55, 1],
        ).createShader(rect),
    );
    final centre = Offset(size.width / 2, size.height * 0.4);
    final glow = _interval(t, 0.01, 0.13, Curves.easeOut);
    canvas.drawCircle(
      centre,
      size.width * 0.75,
      Paint()
        ..shader = RadialGradient(
          colors: [
            C.brandBright.withValues(alpha: 0.55 * glow),
            C.brandBright.withValues(alpha: 0),
          ],
        ).createShader(Rect.fromCircle(center: centre, radius: size.width * 0.75)),
    );

    // Gold diamond lattice, very faint, like the app's headers.
    final lattice = Paint()
      ..color = C.gold.withValues(alpha: 0.05 * _interval(t, 0, 0.08))
      ..strokeWidth = 1;
    const step = 46.0;
    for (var x = -size.height; x < size.width + size.height; x += step) {
      canvas.drawLine(Offset(x, 0), Offset(x + size.height, size.height), lattice);
      canvas.drawLine(Offset(x, size.height), Offset(x + size.height, 0), lattice);
    }

    // Shooting stars streak across the sky.
    for (final (start, y0) in const [(0.2, 0.12), (0.42, 0.22), (0.66, 0.08)]) {
      final k = _interval(t, start, start + 0.08, Curves.easeIn);
      if (k <= 0 || k >= 1) continue;
      final head = Offset(size.width * (1.1 - 1.3 * k), size.height * (y0 + 0.25 * k));
      final tail = head + Offset(size.width * 0.28, -size.height * 0.054);
      canvas.drawLine(
        head,
        tail,
        Paint()
          ..strokeWidth = 2
          ..strokeCap = StrokeCap.round
          ..shader = LinearGradient(
            colors: [
              C.goldLight.withValues(alpha: 0.9 * (1 - k)),
              C.goldLight.withValues(alpha: 0),
            ],
          ).createShader(Rect.fromPoints(head, tail)),
      );
      canvas.drawCircle(head, 2.5, Paint()..color = C.goldLight.withValues(alpha: 1 - k));
    }

    for (final (sx, sy, r, phase) in _stars) {
      final on = _interval(t, 0.02 + phase * 0.1, 0.07 + phase * 0.1);
      final twinkle = 0.55 + 0.45 * math.sin((t * 14 + phase) * math.pi * 2);
      final p = Offset(sx * size.width, sy * size.height);
      canvas.drawCircle(p, r, Paint()..color = C.goldLight.withValues(alpha: on * twinkle * 0.9));
      if (r > 2.0) {
        final glint = Paint()
          ..color = C.goldLight.withValues(alpha: on * twinkle * 0.5)
          ..strokeWidth = 1;
        canvas.drawLine(p - Offset(r * 3, 0), p + Offset(r * 3, 0), glint);
        canvas.drawLine(p - Offset(0, r * 3), p + Offset(0, r * 3), glint);
      }
    }
  }

  @override
  bool shouldRepaint(_SkyPainter old) => old.t != t;
}

/// The icon's crescent with its stars, inside a slowly turning dotted gold ring and a soft halo.
class _MoonPainter extends CustomPainter {
  _MoonPainter({required this.appear, required this.t});
  final double appear, t;

  @override
  void paint(Canvas canvas, Size size) {
    final c = size.center(Offset.zero);
    final r = size.width / 2;

    // Halo pulse.
    final halo = _interval(t, 0.03, 0.16) * (0.85 + 0.15 * math.sin(t * math.pi * 9));
    canvas.drawCircle(
      c,
      r * (0.9 + 0.15 * halo),
      Paint()
        ..color = C.gold.withValues(alpha: 0.18 * appear)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 30),
    );

    final ring = _interval(t, 0.04, 0.16, Curves.easeOut);
    final spin = t * math.pi * 3.1;

    // Slow sunburst of gold rays behind everything.
    canvas.save();
    canvas.translate(c.dx, c.dy);
    canvas.rotate(spin * 0.35);
    final ray = Paint()
      ..shader = RadialGradient(
        colors: [
          C.goldLight.withValues(alpha: 0.32 * ring),
          C.goldLight.withValues(alpha: 0),
        ],
      ).createShader(Rect.fromCircle(center: Offset.zero, radius: r * 1.25));
    for (var i = 0; i < 16; i++) {
      final a = i * math.pi * 2 / 16;
      final w = i.isEven ? 0.07 : 0.035;
      canvas.drawPath(
        Path()
          ..moveTo(0, 0)
          ..lineTo(math.cos(a - w) * r * 1.25, math.sin(a - w) * r * 1.25)
          ..lineTo(math.cos(a + w) * r * 1.25, math.sin(a + w) * r * 1.25)
          ..close(),
        ray,
      );
    }
    canvas.restore();

    // Outer ring of gold dots turning one way...
    canvas.save();
    canvas.translate(c.dx, c.dy);
    canvas.rotate(spin * 1.1);
    final dot = Paint()..color = C.gold.withValues(alpha: 0.85 * ring);
    for (var i = 0; i < 48; i++) {
      final a = i * math.pi * 2 / 48;
      canvas.drawCircle(Offset(math.cos(a), math.sin(a)) * (r * 0.98), i % 4 == 0 ? 2.8 : 1.3, dot);
    }
    canvas.restore();

    // ...a ring of small diamonds turning the other way...
    canvas.save();
    canvas.translate(c.dx, c.dy);
    canvas.rotate(-spin * 0.8);
    final diamond = Paint()..color = C.goldLight.withValues(alpha: 0.7 * ring);
    for (var i = 0; i < 12; i++) {
      final a = i * math.pi * 2 / 12;
      final p = Offset(math.cos(a), math.sin(a)) * (r * 0.8);
      canvas.save();
      canvas.translate(p.dx, p.dy);
      canvas.rotate(a);
      canvas.drawPath(
        Path()
          ..moveTo(0, -5)
          ..lineTo(3, 0)
          ..lineTo(0, 5)
          ..lineTo(-3, 0)
          ..close(),
        diamond,
      );
      canvas.restore();
    }
    canvas.restore();

    // ...and two thin circles between them.
    final line = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.2
      ..color = C.goldMuted.withValues(alpha: 0.6 * ring);
    canvas.drawCircle(c, r * 0.89, line);
    canvas.drawCircle(c, r * 0.72, line..color = C.goldMuted.withValues(alpha: 0.35 * ring));

    // Three sparkles orbiting the ring.
    final orbitPaint = Paint()..color = C.goldLight.withValues(alpha: ring);
    for (var k = 0; k < 3; k++) {
      final a = spin * 1.6 + k * math.pi * 2 / 3;
      _sparkle(canvas, c + Offset(math.cos(a), math.sin(a)) * (r * 0.89), 7 * ring, orbitPaint);
    }

    // Crescent rises into place.
    canvas.save();
    canvas.translate(c.dx, c.dy + 30 * (1 - appear));
    canvas.rotate(-math.pi * 1.5 * (1 - appear)); // spins in
    canvas.scale(0.6 + 0.4 * appear);
    final mr = r * 0.44;
    final moon = Path.combine(
      PathOperation.difference,
      Path()..addOval(Rect.fromCircle(center: Offset(-mr * 0.12, mr * 0.04), radius: mr)),
      Path()..addOval(Rect.fromCircle(center: Offset(mr * 0.36, -mr * 0.26), radius: mr * 0.9)),
    );
    final gold = Paint()
      ..shader = const LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [C.goldLight, C.goldDeep],
      ).createShader(Rect.fromCircle(center: Offset.zero, radius: mr));
    canvas.drawPath(
      moon,
      Paint()
        ..color = C.gold.withValues(alpha: 0.5 * appear)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 14),
    );
    canvas.drawPath(moon, gold..color = Colors.white.withValues(alpha: appear.clamp(0.0, 1.0)));

    // Star and two sparkles beside the crescent, popping in after it.
    final stars = _interval(t, 0.09, 0.17, Curves.easeOutBack);
    _star(canvas, Offset(mr * 0.62, -mr * 0.62), mr * 0.2 * stars, gold);
    _sparkle(canvas, Offset(mr * 0.98, mr * 0.05), mr * 0.12 * stars, gold);
    _sparkle(canvas, Offset(mr * 0.2, -mr * 1.02), mr * 0.09 * stars, gold);
    canvas.restore();
  }

  void _star(Canvas canvas, Offset c, double r, Paint p) {
    if (r <= 0) return;
    final path = Path();
    for (var i = 0; i < 10; i++) {
      final a = -math.pi / 2 + i * math.pi / 5;
      final rr = i.isEven ? r : r * 0.42;
      final pt = c + Offset(math.cos(a), math.sin(a)) * rr;
      i == 0 ? path.moveTo(pt.dx, pt.dy) : path.lineTo(pt.dx, pt.dy);
    }
    canvas.drawPath(path..close(), p);
  }

  void _sparkle(Canvas canvas, Offset c, double r, Paint p) {
    if (r <= 0) return;
    final k = r * 0.22;
    canvas.drawPath(
      Path()
        ..moveTo(c.dx, c.dy - r)
        ..lineTo(c.dx + k, c.dy - k)
        ..lineTo(c.dx + r, c.dy)
        ..lineTo(c.dx + k, c.dy + k)
        ..lineTo(c.dx, c.dy + r)
        ..lineTo(c.dx - k, c.dy + k)
        ..lineTo(c.dx - r, c.dy)
        ..lineTo(c.dx - k, c.dy - k)
        ..close(),
      p,
    );
  }

  @override
  bool shouldRepaint(_MoonPainter old) => old.t != t || old.appear != appear;
}
