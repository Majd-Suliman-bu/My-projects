import 'package:flutter/material.dart';

import '../../constant/sizes.dart';
import '../../constant/text_style.dart';

// ignore: must_be_immutable
class AnimationAppBarTitle extends StatelessWidget {
  late AnimationController aController;
  late Animation<double> animationForA;
  String title;
  AnimationAppBarTitle({
    Key? key,
    required this.title,
  }) : super(key: key);
  double theNumber = 1;
  @override
  Widget build(BuildContext context) {
    Sizes size = Sizes(context);
    return TweenAnimationBuilder(
      builder: (BuildContext context, double theValForTheTween, child) {
        return Opacity(
          opacity: theValForTheTween,
          child: Padding(
            padding: EdgeInsets.only(top: theValForTheTween * 20, bottom: 20),
            child: child,
          ),
        );
      },
      tween: Tween<double>(begin: 0, end: theNumber),
      duration: const Duration(seconds: 1),
      child: Text(
        title,
        style: generalTextStyle(size.appBarTextSize / 2),
      ),
      onEnd: () {
        theNumber == 1 ? 0 : 1;
      },
    );
  }
}
