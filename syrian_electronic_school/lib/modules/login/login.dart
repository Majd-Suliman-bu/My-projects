import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:syrian_electronic_school/config/constant.dart';

import 'login_controller.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  LoginController controller = Get.find();
  bool _obscureText = true;
  IconData _iconVisible = Icons.visibility_off;

  Color _gradientTop = Color(0xc2f66666);
  Color _gradientBottom = Color(0xc2f1e4e4);
  Color _mainColor = red;
  Color _underlineColor = Color(0xFFCCCCCC);

  void _toggleObscureText() {
    setState(() {
      _obscureText = !_obscureText;
      if (_obscureText == true) {
        _iconVisible = Icons.visibility_off;
      } else {
        _iconVisible = Icons.visibility;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: AnnotatedRegion<SystemUiOverlayStyle>(
          value: Platform.isIOS
              ? SystemUiOverlayStyle.light
              : SystemUiOverlayStyle(statusBarIconBrightness: Brightness.light),
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
                        margin: EdgeInsets.fromLTRB(24, 0, 24, 20),
                        child: Column(
                          children: <Widget>[
                            SizedBox(
                              height: 40,
                            ),
                            Center(
                              child: Text(
                                'SIGN IN',
                                style: TextStyle(
                                    color: _mainColor,
                                    fontSize: 18,
                                    fontWeight: FontWeight.w900),
                              ),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            TextField(
                              onChanged: (value) => controller.email = value,
                              keyboardType: TextInputType.emailAddress,
                              decoration: InputDecoration(
                                  focusedBorder: UnderlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Colors.grey[600]!)),
                                  enabledBorder: UnderlineInputBorder(
                                    borderSide:
                                        BorderSide(color: _underlineColor),
                                  ),
                                  labelText: 'Email',
                                  labelStyle:
                                      TextStyle(color: Colors.grey[700])),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            TextField(
                              onChanged: (value) => controller.password = value,
                              obscureText: _obscureText,
                              decoration: InputDecoration(
                                focusedBorder: UnderlineInputBorder(
                                    borderSide:
                                        BorderSide(color: Colors.grey[600]!)),
                                enabledBorder: UnderlineInputBorder(
                                  borderSide:
                                      BorderSide(color: _underlineColor),
                                ),
                                labelText: 'Password',
                                labelStyle: TextStyle(color: Colors.grey[700]),
                                suffixIcon: IconButton(
                                    icon: Icon(_iconVisible,
                                        color: Colors.grey[700], size: 20),
                                    onPressed: () {
                                      _toggleObscureText();
                                    }),
                              ),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Align(
                              alignment: Alignment.centerRight,
                              child: GestureDetector(
                                onTap: () {
                                  onClickForgetPassword();
                                },
                                child: Text(
                                  'Forgot Password?',
                                  style: TextStyle(fontSize: 13),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 40,
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
                                    onClickLogin();
                                  },
                                  child: Padding(
                                    padding:
                                        const EdgeInsets.symmetric(vertical: 5),
                                    child: Text(
                                      'LOGIN',
                                      style: TextStyle(
                                          fontSize: 16, color: Colors.white),
                                      textAlign: TextAlign.center,
                                    ),
                                  )),
                            ),
                          ],
                        )),
                  ),
                  SizedBox(
                    height: 50,
                  ),
                  // create sign up link
                  Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text('New User? '),
                        GestureDetector(
                          onTap: () {
                            EasyLoading.showToast("Click signup",
                                toastPosition: EasyLoadingToastPosition.bottom);
                          },
                          child: TextButton(
                              child: Text(
                                'Sign Up',
                                style: TextStyle(
                                    color: _mainColor,
                                    fontWeight: FontWeight.w700),
                              ),
                              onPressed: () => Get.toNamed("Register")),
                        )
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                ],
              )
            ],
          ),
        ));
  }

  void onClickLogin() async {
    EasyLoading.showToast("Loading....",
        toastPosition: EasyLoadingToastPosition.bottom);

    await controller.LoginOnclick();
    if (controller.loginStatus) {
      EasyLoading.showToast(controller.error,
          dismissOnTap: true, toastPosition: EasyLoadingToastPosition.bottom);
      Get.offAllNamed("/Home");
    }
    EasyLoading.showToast(controller.error,
        dismissOnTap: true, toastPosition: EasyLoadingToastPosition.bottom);
  }

  void onClickForgetPassword() async {
    Get.toNamed("/ForgetPassword");
  }
}
