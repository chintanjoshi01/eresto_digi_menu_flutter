import 'dart:math' as math;
import 'package:flutter/material.dart';

class BrandProgressIndicator extends StatefulWidget {
  final double size;
  final double? strokeWidth;
  final Color? color;

  const BrandProgressIndicator({
    super.key,
    this.size = 40.0,
    this.strokeWidth,
    this.color,
  });

  @override
  State<BrandProgressIndicator> createState() => _BrandProgressIndicatorState();
}

class _BrandProgressIndicatorState extends State<BrandProgressIndicator>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final themeColor = widget.color ?? const Color(0xFFAB2421);

    return SizedBox(
      width: widget.size,
      height: widget.size,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return CustomPaint(
            painter: _BrandPainter(
              animationValue: _controller.value,
              color: themeColor,
              strokeWidth: widget.strokeWidth,
            ),
          );
        },
      ),
    );
  }
}

class _BrandPainter extends CustomPainter {
  final double animationValue;
  final Color color;
  final double? strokeWidth;

  _BrandPainter({
    required this.animationValue,
    required this.color,
    this.strokeWidth,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = math.min(size.width, size.height) / 2;
    final effectiveStroke = strokeWidth ?? (radius * 0.15);

    // 1. Draw Pulsing Core (The Brand Heart)
    final pulseValue = (math.sin(animationValue * 2 * math.pi) + 1) / 2;
    final corePaint = Paint()
      ..color = color.withOpacity(0.2 + (0.3 * pulseValue))
      ..style = PaintingStyle.fill;
    
    canvas.drawCircle(center, radius * (0.4 + (0.1 * pulseValue)), corePaint);

    // 2. Draw Rotating Orbit (The Activity Ring)
    final orbitPaint = Paint()
      ..color = color
      ..strokeWidth = effectiveStroke
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    final startAngle = animationValue * 2 * math.pi;
    const maxSweepAngle = 3 * math.pi / 2; // 270 degrees

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius - (effectiveStroke / 2)),
      startAngle,
      maxSweepAngle * (0.2 + 0.8 * pulseValue), // Dynamic sweep
      false,
      orbitPaint,
    );

    // 3. Leading edge detail for premium feel
    final dotPaint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;
    
    final dotAngle = startAngle + (maxSweepAngle * (0.2 + 0.8 * pulseValue));
    final dotX = center.dx + (radius - (effectiveStroke / 2)) * math.cos(dotAngle);
    final dotY = center.dy + (radius - (effectiveStroke / 2)) * math.sin(dotAngle);
    
    canvas.drawCircle(Offset(dotX, dotY), effectiveStroke * 0.8, dotPaint);
  }

  @override
  bool shouldRepaint(covariant _BrandPainter oldDelegate) {
    return oldDelegate.animationValue != animationValue;
  }
}
