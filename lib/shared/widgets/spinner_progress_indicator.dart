import "dart:ui";

import "package:flutter/material.dart";

import "../../core/theme/glossip_colors.dart";

class GlossipSpinnerProgressIndicator extends StatefulWidget {
  const GlossipSpinnerProgressIndicator({
    super.key,
    this.radius = 46,
    this.progress,
  });

  final double radius;
  final double? progress;

  @override
  State<GlossipSpinnerProgressIndicator> createState() =>
      _GlossipSpinnerProgressIndicatorState();
}

class _GlossipSpinnerProgressIndicatorState
    extends State<GlossipSpinnerProgressIndicator>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  bool get _isIndeterminate => widget.progress == null;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );

    if (_isIndeterminate) {
      _controller.repeat();
    }
  }

  @override
  void didUpdateWidget(covariant GlossipSpinnerProgressIndicator oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (_isIndeterminate == (oldWidget.progress == null)) {
      return;
    }

    if (_isIndeterminate) {
      _controller.repeat();
      return;
    }

    _controller.stop();
    _controller.value = 0;
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = widget.radius * 2;
    final progress = widget.progress?.clamp(0.0, 1.0).toDouble();

    return SizedBox.square(
      dimension: size,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return Stack(
            alignment: Alignment.center,
            children: [
              CustomPaint(
                size: Size.square(size),
                painter: _GlossipSpinnerFramePainter(
                  progress: progress,
                  animationValue: _controller.value,
                ),
              ),
              _GlossipSpinnerCenter(
                size: size,
                progress: progress,
                animationValue: _controller.value,
              ),
            ],
          );
        },
      ),
    );
  }
}

class _GlossipSpinnerCenter extends StatelessWidget {
  const _GlossipSpinnerCenter({
    required this.size,
    required this.progress,
    required this.animationValue,
  });

  final double size;
  final double? progress;
  final double animationValue;

  @override
  Widget build(BuildContext context) {
    final innerSize = size * 0.67;
    final dotWidth = size * 0.065;
    final activeDotHeight = size * 0.18;
    final idleDotHeight = size * 0.09;
    final dotSpacing = size * 0.03;

    return Container(
      width: innerSize,
      height: innerSize,
      decoration: BoxDecoration(
        color: GlossipColors.primary,
        border: Border.all(color: Colors.black, width: 3),
        borderRadius: BorderRadius.circular(size * 0.22),
      ),
      child: Center(
        child: progress == null
            ? Row(
                mainAxisSize: MainAxisSize.min,
              children: List.generate(3, (index) {
                final phase = (animationValue + (index * 0.18)) % 1;
                final isActive = phase < 0.5;

                return AnimatedContainer(
                  duration: const Duration(milliseconds: 120),
                  margin: EdgeInsets.symmetric(horizontal: dotSpacing),
                  width: dotWidth,
                  height: isActive ? activeDotHeight : idleDotHeight,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(999),
                    ),
                  );
                }),
              )
            : Text(
                "${(progress! * 100).round()}%",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w900,
                  fontSize: size * 0.16,
                ),
              ),
      ),
    );
  }
}

class _GlossipSpinnerFramePainter extends CustomPainter {
  const _GlossipSpinnerFramePainter({
    required this.progress,
    required this.animationValue,
  });

  final double? progress;
  final double animationValue;

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;
    final path = Path()
      ..addRRect(
        RRect.fromRectAndRadius(rect.deflate(1.5), Radius.circular(size.width * 0.3)),
      );

    final trackPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3
      ..color = Colors.black.withValues(alpha: 0.22);

    final progressPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3
      ..strokeCap = StrokeCap.round
      ..color = Colors.black;

    canvas.drawPath(path, trackPaint);

    final metric = path.computeMetrics().single;
    final totalLength = metric.length;

    if (progress == null) {
      final start = totalLength * animationValue;
      final segmentLength = totalLength * 0.24;

      _drawSegment(canvas, metric, progressPaint, start, segmentLength);
      return;
    }

    final segmentLength = totalLength * progress!;
    if (segmentLength <= 0) {
      return;
    }

    _drawSegment(canvas, metric, progressPaint, 0, segmentLength);
  }

  void _drawSegment(
    Canvas canvas,
    PathMetric metric,
    Paint paint,
    double start,
    double length,
  ) {
    final totalLength = metric.length;
    final normalizedStart = start % totalLength;
    final end = normalizedStart + length;

    if (end <= totalLength) {
      canvas.drawPath(metric.extractPath(normalizedStart, end), paint);
      return;
    }

    canvas.drawPath(
      metric.extractPath(normalizedStart, totalLength),
      paint,
    );
    canvas.drawPath(metric.extractPath(0, end - totalLength), paint);
  }

  @override
  bool shouldRepaint(covariant _GlossipSpinnerFramePainter oldDelegate) {
    return oldDelegate.progress != progress ||
        oldDelegate.animationValue != animationValue;
  }
}
