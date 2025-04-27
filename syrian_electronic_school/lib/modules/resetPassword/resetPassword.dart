import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import '../../modules/resetPassword/resetPassword_controller.dart';

import '../../component/customButton.dart';
import '../../component/customTextInput.dart';
import '../../config/constant.dart';

class ResetPassword extends StatefulWidget {
  @override
  State<ResetPassword> createState() => _ResetPasswordState();
}

class _ResetPasswordState extends State<ResetPassword> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  ResetPasswordController controller = Get.find();

  final String data = Get.arguments;

  Color _gradientTop = const Color(0xc2f66666);

  Color _gradientBottom = const Color(0xc2f1e4e4);

  Color _mainColor = red;

  Color _underlineColor = const Color(0xFFCCCCCC);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: AnnotatedRegion<SystemUiOverlayStyle>(
          value: Platform.isIOS
              ? SystemUiOverlayStyle.light
              : const SystemUiOverlayStyle(statusBarIconBrightness: Brightness.light),
          child: Form(
            key: _formKey,
            child: Stack(
              children: <Widget>[
                // top blue background gradient
                Container(
                  height: MediaQuery.of(context).size.height / 3.5,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      gradient: LinearGradient(
                          colors: [_gradientTop, _gradientBottom],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter)),
                ),
                // set your logo here
                Container(
                    margin: EdgeInsets.fromLTRB(
                        0, MediaQuery.of(context).size.height / 20, 0, 0),
                    alignment: Alignment.topCenter,
                    child: Image.asset('assets/logos/logo.png', height: 120)),
                ListView(
                  children: <Widget>[
                    // create form login
                    Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      elevation: 5,
                      margin: EdgeInsets.fromLTRB(32,
                          MediaQuery.of(context).size.height / 3.5 - 72, 32, 0),
                      color: Colors.white,
                      child: Container(
                          margin: const EdgeInsets.fromLTRB(24, 0, 24, 20),
                          child: Column(
                            children: <Widget>[
                              const SizedBox(
                                height: 40,
                              ),
                              Center(
                                child: Text(
                                  'Reset password',
                                  style: TextStyle(
                                      color: _mainColor,
                                      fontSize: 18,
                                      fontWeight: FontWeight.w900),
                                ),
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              Center(
                                child: Text(
                                  'Enter your New Password ',
                                  style: TextStyle(
                                    color: Colors.grey[600],
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              TextFormField(
                                onChanged: (value) => controller.password = value,
                                keyboardType: TextInputType.emailAddress,
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return 'Password is required';
                                  }
                                  if (value.length < 8) {
                                    return 'Password must be at least 8 characters long';
                                  }
                                  return null;
                                },
                                decoration: InputDecoration(
                                    focusedBorder: UnderlineInputBorder(
                                        borderSide:
                                        BorderSide(color: Colors.grey[600]!)),
                                    enabledBorder: UnderlineInputBorder(
                                      borderSide:
                                      BorderSide(color: _underlineColor),
                                    ),
                                    labelText: 'Password',
                                    labelStyle:
                                    TextStyle(color: Colors.grey[700])),
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              TextFormField(obscureText: true,obscuringCharacter: "*",
                                onChanged: (value) => controller.c_password = value,
                                keyboardType: TextInputType.emailAddress,
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return 'Confirm password is required';
                                  }
                                  if (value != controller.password) {
                                    return 'Passwords do not match';
                                  }
                                  return null;
                                },
                                decoration: InputDecoration(
                                    focusedBorder: UnderlineInputBorder(
                                        borderSide:
                                        BorderSide(color: Colors.grey[600]!)),
                                    enabledBorder: UnderlineInputBorder(
                                      borderSide:
                                      BorderSide(color: _underlineColor),
                                    ),
                                    labelText: 'Confirm password',
                                    labelStyle:
                                    TextStyle(color: Colors.grey[700])),
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              SizedBox(
                                width: double.maxFinite,
                                height: MediaQuery.of(context).size.height * .08,
                                child: ElevatedButton(
                                    style: ButtonStyle(
                                      backgroundColor: MaterialStateProperty
                                          .resolveWith<Color>(
                                            (Set<MaterialState> states) => _mainColor,
                                      ),
                                      overlayColor: MaterialStateProperty.all(
                                          Colors.transparent),
                                      shape: MaterialStateProperty.all(
                                          RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(10),
                                          )),
                                    ),
                                    onPressed: () {

                                      if (_formKey.currentState!.validate()) {


                                      }
                                      onClickReset();
                                    },
                                    child: const Padding(
                                      padding:
                                      EdgeInsets.symmetric(vertical: 5),
                                      child: Text(
                                        'Reset Password',
                                        style: TextStyle(
                                            fontSize: 16, color: Colors.white),
                                        textAlign: TextAlign.center,
                                      ),
                                    )),
                              ),
                            ],
                          )),
                    ),
                    const SizedBox(
                      height: 50,
                    ),
                    // create sign up link
                    Center(
                      child: Wrap(
                        children: <Widget>[
                          Icon(Icons.arrow_back, size: 16, color: _mainColor),

                          GestureDetector(
                            onTap: () {
                              Navigator.pop(context);

                            },
                            child: Text(
                              'back to log in',
                              style: TextStyle(
                                  color: _mainColor, fontWeight: FontWeight.w700),
                            ),
                          )
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                  ],
                )
              ],
            ),
          ),
        ));
  }
  void onClickReset() async {
    List<String> parts = data.split('+');

    String email = parts[0];
    String otp = parts[1];

    await controller.resetClick(email,otp,controller.password);
    if (controller.resetStatus) {
      EasyLoading.showSuccess(controller.msg,
        dismissOnTap: true, );
      Get.offAllNamed("/Login",);
    }
    else {EasyLoading.showError(controller.error,
      dismissOnTap: true, );}

  }
}
