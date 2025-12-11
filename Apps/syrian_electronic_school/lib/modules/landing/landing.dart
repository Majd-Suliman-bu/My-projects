import 'package:flutter/material.dart';
import 'package:get/get.dart';

import './landing_controller.dart';

import '../../config/constant.dart';
import '../../component/customButton.dart';

class Landing extends StatelessWidget {
  LandingController controller = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
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
                const Text(
                  'Welcome',
                  style: TextStyle(
                    color: black,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(
                  height: 300,
                ),
                Button(
                  width: MediaQuery.of(context).size.width * .9,
                  hight: 60,
                  buttonColor: red,
                  buttonName: "Signup",
                  fontsize: 30,
                  nameColor: white,
                  ontap: () => Get.toNamed("/Register"),
                ),
                const SizedBox(
                  height: 20,
                ),
                Button(
                  hight: 60,
                  fontsize: 30,
                  width: MediaQuery.of(context).size.width * .9,
                  buttonColor: red,
                  buttonName: "Login",
                  nameColor: white,
                  ontap: () => Get.toNamed("/Login"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
