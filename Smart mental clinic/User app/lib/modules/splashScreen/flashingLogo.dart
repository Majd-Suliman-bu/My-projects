import 'package:flutter/material.dart';

class FlashingLogo extends StatefulWidget {
  @override
  _FlashingLogoState createState() => _FlashingLogoState();
}

class _FlashingLogoState extends State<FlashingLogo>
    with SingleTickerProviderStateMixin {
  AnimationController? _animationController;
  Animation<double>? _animation;

  @override
  void initState() {
    super.initState();
    _animationController =
        AnimationController(vsync: this, duration: Duration(seconds: 2))
          ..repeat(reverse: true);
    _animation =
        Tween<double>(begin: 0.0, end: 1.0).animate(_animationController!);
  }

  @override
  void dispose() {
    _animationController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _animation!,
      child: Image.asset('assets/images/logo2.png'),
    );
  }
}
