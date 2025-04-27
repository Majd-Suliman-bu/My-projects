import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gradient_borders/gradient_borders.dart';

import '../theme/themeController.dart';

class Landing extends StatelessWidget {
  final ThemeController themeController = Get.find();

  //color: Color.fromARGB(255, 21, 56, 85)

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 89, 155, 222),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: MediaQuery.of(context).size.height * 0.03),
              Container(
                height: MediaQuery.of(context).size.height *
                    0.27, // Adjust the size as needed
                width: MediaQuery.of(context).size.width,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(
                      20.0), // Adjust the radius as needed
                  child: Image.asset(
                    "assets/images/logo22.png",
                  ),
                ),
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.03),
              Text('Welcome',
                  style: GoogleFonts.merriweather(
                      textStyle: TextStyle(
                    fontSize: MediaQuery.of(context).size.height * 0.065,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ))),
              SizedBox(height: 5),
              Text('Login to your account',
                  style: GoogleFonts.merriweather(
                      textStyle: TextStyle(
                    fontSize: MediaQuery.of(context).size.height * 0.02,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ))),
              SizedBox(height: MediaQuery.of(context).size.height * 0.1),
              ElevatedButton(
                onPressed: () {
                  Get.toNamed("/Login");
                },
                child: Text(
                  'Login',
                  style: TextStyle(color: Colors.white),
                ),
                style: ElevatedButton.styleFrom(
                  // Button color changed to blue
                  backgroundColor: Color.fromARGB(255, 21, 56, 85),
                  minimumSize: Size(
                      MediaQuery.of(context).size.width * 0.7,
                      MediaQuery.of(context).size.height *
                          0.08), // Set the minimum size of the button (width, height)
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(
                        30), // Rounded borders with a radius of 30
                  ),
                ),
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.015),
              ElevatedButton(
                onPressed: () {
                  Get.toNamed("/Register");
                },
                child: Text(
                  'Register',
                  style: TextStyle(color: Colors.white),
                ),
                style: ElevatedButton.styleFrom(
                  // Button color changed to blue
                  backgroundColor: Color.fromARGB(255, 21, 56, 85),
                  minimumSize: Size(
                      MediaQuery.of(context).size.width * 0.7,
                      MediaQuery.of(context).size.height *
                          0.08), // Set the minimum size of the button (width, height)
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(
                        30), // Rounded borders with a radius of 30
                  ),
                ),
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.015),
              ElevatedButton(
                onPressed: () {
                  Get.toNamed("/ForgotPassword");
                },
                child: Text(
                  'Forgot Password / Verify email',
                  style: TextStyle(color: Colors.white),
                ),
                style: ElevatedButton.styleFrom(
                  // Button color changed to blue
                  backgroundColor: Color.fromARGB(255, 21, 56, 85),
                  minimumSize: Size(
                      MediaQuery.of(context).size.width * 0.7,
                      MediaQuery.of(context).size.height *
                          0.08), // Set the minimum size of the button (width, height)
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(
                        30), // Rounded borders with a radius of 30
                  ),
                ),
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.015),
            ],
          ),
        ),
      ),
    );
  }
}
