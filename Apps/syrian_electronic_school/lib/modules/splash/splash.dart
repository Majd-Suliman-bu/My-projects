import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../config/constant.dart';

import './splash_controller.dart';

class Splash extends StatelessWidget {
  SplashController controller = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          decoration: const BoxDecoration(color: white),
          child: Column(
            children: [
              const SizedBox(
                height: 10,
              ),
              Container(
                height: 200,
                width: 200,
                child: Image.asset(
                    'assets/logos/logo.png'), ////////////////////////////////////////////////
              ),
              const SizedBox(
                height: 10,
              ),
              const SizedBox(
                height: 200,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
