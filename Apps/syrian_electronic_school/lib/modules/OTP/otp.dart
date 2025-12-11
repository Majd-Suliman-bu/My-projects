import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

import '../../config/constant.dart';
import 'otp_controller.dart';

class OTP extends StatefulWidget {
  @override
  _OTPState createState() => _OTPState();
}

class _OTPState extends State<OTP> {
  //Color _color1 = Color(0xc2f66666);
  Color _color1 = red;
  Color _color2 = Color(0xFF515151);
  Color _color3 = Color(0xff777777);
  Color _color4 = Color(0xFFaaaaaa);
  bool _buttonDisabled = true;
  String _verificationCode = "" ;
  final String _data = Get.arguments;
  late String _type ;
  late String _email ;


  OtpController _controllers = Get.find();
  late List<FocusNode> _focusNodes;
  Timer? _timer;
  int _start = 300; // 5 minutes in seconds
  bool _resendEnabled = false;

  @override
  void initState() {
    List<String> parts = _data.split('+');
     _type = parts[0];
     _email = parts[1];
    super.initState();
    startTimer();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (Timer timer) {
      if (_start == 0) {
        setState(() {
          _resendEnabled = true;
          _timer?.cancel();
        });
      } else {
        setState(() {
          _start--;
        });
      }
    });
  }

  void resendOtp() {
    // Implement your logic to resend OTP here
    // For demonstration, we'll just reset the timer
    setState(() {
      _start = 300;
      _resendEnabled = false;
    });
    startTimer();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: ListView(
      padding: EdgeInsets.fromLTRB(30, 120, 30, 30),
      children: <Widget>[
        Center(child: Icon(Icons.phone_android, color: _color1, size: 50)),
        SizedBox(height: 20),
        Center(
            child: Text(
          'Enter the Verification Code',
          style: TextStyle(
              fontSize: 16, fontWeight: FontWeight.bold, color: _color2),
        )),
        SizedBox(
          height: 20,
        ),
        Container(
          width: MediaQuery.of(context).size.width / 1.5,
          child: Text(
            'The verification code has been sent via email to $_email',
            style: TextStyle(fontSize: 13, color: _color3),
            textAlign: TextAlign.center,
          ),
        ),
        SizedBox(
          height: 40,
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 50),
          child: PinCodeTextField(
            autoFocus: true,
            appContext: context,
            keyboardType: TextInputType.number,
            length: 4,
            showCursor: false,
            obscureText: false,
            animationType: AnimationType.fade,
            pinTheme: PinTheme(
                shape: PinCodeFieldShape.underline,
                fieldHeight: 50,
                fieldWidth: 40,
                inactiveColor: _color4,
                activeColor: _color1,
                selectedColor: _color1),
            animationDuration: Duration(milliseconds: 300),
            backgroundColor: Colors.transparent,
            onChanged: (value) {
              setState(() {
                if (value.length == 4) {
                  _buttonDisabled = false;
                } else {
                  _buttonDisabled = true;
                }
                _verificationCode = value ;
              });
            },
            beforeTextPaste: (text) {
              return false;
            },
          ),
        ),
        SizedBox(
          height: 40,
        ),
        Container(
          child: SizedBox(
              width: double.maxFinite,
              child: TextButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.resolveWith<Color>(
                      (Set<MaterialState> states) =>
                          _buttonDisabled ? Colors.grey[300]! : _color1,
                    ),
                    overlayColor: MaterialStateProperty.all(Colors.transparent),
                    shape: MaterialStateProperty.all(RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    )),
                  ),
                  onPressed: () {
                    if (!_buttonDisabled) {
                      print(_verificationCode);
                      //_controllers.otp = int.parse(_verificationCode);
                      onClickVerify();
                      FocusScope.of(context).unfocus();
                    }
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 5.0),
                    child: Text(
                      'Verify',
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: _buttonDisabled
                              ? Colors.grey[600]
                              : Colors.white),
                      textAlign: TextAlign.center,
                    ),
                  ))),
        ),
        SizedBox(
          height: 40,
        ),
        Center(
          child: Wrap(
            children: [
              Text(
                "Didn't receive the code? ",
                style: TextStyle(fontSize: 13, color: _color4),
              ),
              GestureDetector(
                onTap: () {},
                child: Text(
                  'Resend',
                  style: TextStyle(fontSize: 13, color: _color1),
                ),
              )
            ],
          ),
        ),
      ],
    ));
  }

  void onClickVerify() async {
    print("method");
    print(_type);
    if (_type == "register"){

        await _controllers.registerVerifyClick(
            _verificationCode
        );
        if (_controllers.checkStatus) {
          EasyLoading.showSuccess(
            _controllers.msg,
            dismissOnTap: true,
          );

          Get.offAllNamed("/Login");
        } else {
          EasyLoading.showError(
            _controllers.error,
            dismissOnTap: true,
          );
        }

    }
    else if (_type == "forgetPassword"){
      await _controllers.forgetPasswordVerifyClick(
          _verificationCode
      );
      if (_controllers.checkStatus) {
        EasyLoading.showSuccess(
          _controllers.msg,
          dismissOnTap: true,
        );

        var data= "$_email+$_verificationCode";
        print (data);
        Get.toNamed("/ResetPassword",arguments:data );
      } else {
        EasyLoading.showError(
          _controllers.error,
          dismissOnTap: true,
        );
      }
    }

  }
}
