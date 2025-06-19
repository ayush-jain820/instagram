import 'package:flutter/material.dart';

class Likeanimation extends StatefulWidget {
  final bool isAnimating;
  final Duration duration;
  final Widget child;
  final VoidCallback? onEnd;

  const Likeanimation({
    super.key,
    this.isAnimating = false,
    required this.duration,
    required this.child,
    this.onEnd,
  });

  @override
  State<Likeanimation> createState() => _LikeanimationState();
}

class _LikeanimationState extends State<Likeanimation> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late Animation<double> scale;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.duration,
    );
    scale = Tween(begin: 1.0, end: 1.5).animate(_controller);
  }

  @override
  void didUpdateWidget(covariant Likeanimation oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isAnimating && !oldWidget.isAnimating) {
      startAnimation();
    }
  }

  Future<void> startAnimation() async {
    await _controller.forward(from: 0.0);
    await _controller.reverse();
    if (widget.onEnd != null) {
      widget.onEnd!();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: scale,
      child: widget.child,
    );
  }
}