import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';

import '../../models/classes.dart';
import './register_controller.dart';

import '../../config/constant.dart';
import '../../component/customTextInput.dart';
import '../../component/customButton.dart';

class Register extends StatefulWidget {
  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  RegisterController controller = Get.find();
  bool _obscureText = true;
  IconData _iconVisible = Icons.visibility_off;
  Color _gradientTop = const Color(0xc2f66666);
  Color _gradientBottom = const Color(0xc2f1e4e4);
  Color _mainColor = red;
  Color _underlineColor = const Color(0xFFCCCCCC);
  String dropdownValue = "9th";
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
              : const SystemUiOverlayStyle(
                  statusBarIconBrightness: Brightness.light),
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
                                'SIGN UP',
                                style: TextStyle(
                                    color: _mainColor,
                                    fontSize: 18,
                                    fontWeight: FontWeight.w900),
                              ),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            TextField(
                              onChanged: (value) =>
                                  controller.firstName = value,
                              keyboardType: TextInputType.emailAddress,
                              decoration: InputDecoration(
                                  focusedBorder: UnderlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Colors.grey[600]!)),
                                  enabledBorder: UnderlineInputBorder(
                                    borderSide:
                                        BorderSide(color: _underlineColor),
                                  ),
                                  labelText: 'First Name',
                                  labelStyle:
                                      TextStyle(color: Colors.grey[700])),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            TextField(
                              onChanged: (value) => controller.lastName = value,
                              keyboardType: TextInputType.emailAddress,
                              decoration: InputDecoration(
                                  focusedBorder: UnderlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Colors.grey[600]!)),
                                  enabledBorder: UnderlineInputBorder(
                                    borderSide:
                                        BorderSide(color: _underlineColor),
                                  ),
                                  labelText: 'Last Name',
                                  labelStyle:
                                      TextStyle(color: Colors.grey[700])),
                            ),
                            const SizedBox(
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
                            const SizedBox(
                              height: 20,
                            ),
                            TextField(
                              onChanged: (value) =>
                                  controller.phoneNumber = value,
                              keyboardType: TextInputType.emailAddress,
                              decoration: InputDecoration(
                                  focusedBorder: UnderlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Colors.grey[600]!)),
                                  enabledBorder: UnderlineInputBorder(
                                    borderSide:
                                        BorderSide(color: _underlineColor),
                                  ),
                                  labelText: 'Phone Number',
                                  labelStyle:
                                      TextStyle(color: Colors.grey[700])),
                            ),
                            const SizedBox(
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
                            const SizedBox(
                              height: 20,
                            ),
                            TextField(
                              onChanged: (value) =>
                                  controller.passwordConfirm = value,
                              obscureText: _obscureText,
                              decoration: InputDecoration(
                                focusedBorder: UnderlineInputBorder(
                                    borderSide:
                                        BorderSide(color: Colors.grey[600]!)),
                                enabledBorder: UnderlineInputBorder(
                                  borderSide:
                                      BorderSide(color: _underlineColor),
                                ),
                                labelText: 'confirm password',
                                labelStyle: TextStyle(color: Colors.grey[700]),
                                suffixIcon: IconButton(
                                    icon: Icon(_iconVisible,
                                        color: Colors.grey[700], size: 20),
                                    onPressed: () {
                                      _toggleObscureText();
                                    }),
                              ),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            TextField(
                              onChanged: (value) =>
                                  controller.date_of_birth = value,
                              keyboardType: TextInputType.emailAddress,
                              decoration: InputDecoration(
                                  focusedBorder: UnderlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Colors.grey[600]!)),
                                  enabledBorder: UnderlineInputBorder(
                                    borderSide:
                                        BorderSide(color: _underlineColor),
                                  ),
                                  labelText: 'DOB',
                                  labelStyle:
                                      TextStyle(color: Colors.grey[700])),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text("Education level"),
                                Obx(() {
                                  if (controller.classes.isEmpty) {
                                    return CircularProgressIndicator();
                                  }
                                  return DropdownButton<Class>(
                                    value: controller.selectedClass,
                                    icon: const Icon(Icons.arrow_downward),
                                    elevation: 16,
                                    style: const TextStyle(color: Colors.black),
                                    underline: Container(
                                      height: 2,
                                      color: Colors.red,
                                    ),
                                    onChanged: (Class? newValue) {
                                      setState(() {
                                        controller.selectedClass = newValue!;
                                        controller.education_level =
                                            newValue.classId;
                                      });
                                    },
                                    items: controller.classes
                                        .map<DropdownMenuItem<Class>>(
                                            (Class value) {
                                      return DropdownMenuItem<Class>(
                                        value: value,
                                        child: Text(value.name),
                                      );
                                    }).toList(),
                                  );
                                }),
                              ],
                            ),
                            const SizedBox(
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
                                    onClickRegister();
                                  },
                                  child: const Padding(
                                    padding: EdgeInsets.symmetric(vertical: 5),
                                    child: Text(
                                      'submit',
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
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        const Text('Already have an account? '),
                        GestureDetector(
                          onTap: () {},
                          child: TextButton(
                              child: Text(
                                'Sign In',
                                style: TextStyle(
                                    color: _mainColor,
                                    fontWeight: FontWeight.w700),
                              ),
                              onPressed: () => Get.toNamed("Login")),
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
        ));
  }

  void onClickRegister() async {
    EasyLoading.showToast("Loading....",
        toastPosition: EasyLoadingToastPosition.bottom);
    var data = "register+" + controller.email;
    //print(data);
    await controller.registerOnClick();

    if (controller.registerStatus) {
      EasyLoading.showToast(controller.msg,
          dismissOnTap: true, toastPosition: EasyLoadingToastPosition.bottom);

      Get.toNamed("/OTP", arguments: data);
    } else {
      EasyLoading.showError(controller.msg + "\n" + controller.error,
          dismissOnTap: true);
    }
  }
}
