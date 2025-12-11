import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import '../../modules/forgetPassword/forgetPassword_controller.dart';

import '../../component/customButton.dart';
import '../../component/customTextInput.dart';
import '../../config/constant.dart';

class ForgetPassword extends StatelessWidget {
  ForgetPasswordController controller = Get.find();
  Color _gradientTop = Color(0xc2f66666);
  Color _gradientBottom = Color(0xc2f1e4e4);
  Color _mainColor = red;
  Color _underlineColor = Color(0xFFCCCCCC);

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
                                'Forget Password',
                                style: TextStyle(
                                    color: _mainColor,
                                    fontSize: 18,
                                    fontWeight: FontWeight.w900),
                              ),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Center(
                              child: Text(
                                'Enter your email and we will send an OTP code ',
                                style: TextStyle(
                                  color: Colors.grey[600],
                                  fontSize: 14,
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 10,
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
                                    onClickReset();
                                  },
                                  child: Padding(
                                    padding:
                                        const EdgeInsets.symmetric(vertical: 5),
                                    child: Text(
                                      'Rest Password',
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
                  SizedBox(
                    height: 20,
                  ),
                ],
              )
            ],
          ),
        ));
  }

  void onClickReset() async {
    await controller.resetClick(controller.email);
    if (controller.requestStatus) {
      EasyLoading.showSuccess(
        controller.msg,
        dismissOnTap: true,
      );
      var data = "forgetPassword+" + controller.email;
      Get.toNamed("/OTP", arguments: data);
    } else {
      EasyLoading.showError(
        controller.error,
        dismissOnTap: true,
      );
    }
  }
}
