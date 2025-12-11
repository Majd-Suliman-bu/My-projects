import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:flutter/material.dart';
import 'flashingLogo.dart';
import 'navigator.dart';

class Splash extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AnimatedSplashScreen(
      splash: FlashingLogo(), // Use your custom flashing logo widget here
      splashIconSize: MediaQuery.of(context).size.height * 0.25,
      nextScreen: TemporaryNavigator(), // Use TemporaryNavigator here
      splashTransition: SplashTransition.slideTransition,
      backgroundColor: Color.fromARGB(255, 89, 155, 222),
    );
  }
}
