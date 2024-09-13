import 'package:flutter/material.dart';

class TapAnimation extends StatefulWidget {
  const TapAnimation({
    super.key,
    required this.onTap,
    required this.child,
  });

  final VoidCallback onTap;
  final Widget child;

  @override
  State<TapAnimation> createState() => _TapAnimationState();
}

class _TapAnimationState extends State<TapAnimation>
    with SingleTickerProviderStateMixin {
  late final AnimationController _animationController = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 150),
  );

  late final Animation<double> _scaleAnimation = Tween(
    begin: 1.0,
    end: 0.94,
  ).animate(_animationController);

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _scaleAnimation,
      child: GestureDetector(
        onTap: () async {
          _animationController.forward();
          widget.onTap.call();
          await Future.delayed(
            const Duration(milliseconds: 150),
          );
          _animationController.reverse();
        },
        onTapCancel: () => _animationController.reverse(),
        onTapUp: (_) => _animationController.reverse(),
        onTapDown: (_) => _animationController.forward(),
        child: widget.child,
      ),
    );
  }
}
