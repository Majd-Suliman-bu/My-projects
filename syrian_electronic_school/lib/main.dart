import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

import 'getx_bindings/downloads_binding.dart';
import 'getx_bindings/splash_binding.dart';
import 'getx_bindings/landing_binding.dart';
import 'getx_bindings/register_binding.dart';
import 'getx_bindings/otp_binding.dart';
import 'getx_bindings/login_binding.dart';
import 'getx_bindings/home_binding.dart';
import 'getx_bindings/quiz_binding.dart';
import 'getx_bindings/courseVideo_binding.dart';
import 'getx_bindings/setting_binding.dart';
import 'getx_bindings/courses_binding.dart';
import 'getx_bindings/aboutus_binding.dart';
import 'getx_bindings/localFiles_binding.dart';
import 'getx_bindings/courseContent_binding.dart';
import 'getx_bindings/forgetPassword_binding.dart';
import 'getx_bindings/resetpssword_binding.dart';
import 'getx_bindings/mySubscriptions_binding.dart';

import 'modules/downloads.dart/downloads.dart';
import 'modules/login/login.dart';
import 'modules/splash/splash.dart';
import 'modules/landing/landing.dart';
import 'modules/register/register.dart';
import 'modules/OTP/otp.dart';

import 'modules/home/home.dart';
import 'modules/courseVideo/courseVideo.dart';
import 'modules/quiz/quiz.dart';
import 'modules/setting/setting.dart';
import 'modules/courses/courses.dart';
import 'modules/aboutUs/aboutUs.dart';
import 'modules/localFiles/localFiles.dart';
import 'modules/courseContent/courseContent.dart';
import 'modules/forgetPassword/forgetPassword.dart';
import 'modules/resetPassword/resetPassword.dart';
import 'modules/mySubscriptions/mySubscriptions.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      initialRoute: '/Login',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        focusColor: Colors.red,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
        //useMaterial3: true,
      ),
      getPages: [
        GetPage(
          name: "/Splash",
          page: () => Splash(),
          binding: SplashBinding(),
        ),
        GetPage(
          name: "/Landing",
          page: () => Landing(),
          binding: LandingBinding(),
        ),
        GetPage(
          name: "/Register",
          page: () => Register(),
          binding: RegisterBinding(),
          transition: Transition.rightToLeft,
        ),
        GetPage(
          name: "/ForgetPassword",
          page: () => ForgetPassword(),
          binding: ForgetPasswordBinding(),
        ),
        GetPage(
          name: "/OTP",
          page: () => OTP(),
          binding: OtpBinding(),
        ),
        GetPage(
          name: "/ResetPassword",
          page: () => ResetPassword(),
          binding: ResetPasswordBinding(),
        ),
        GetPage(
          name: "/Login",
          page: () => Login(),
          binding: LoginBinding(),
          transition: Transition.leftToRight,
        ),
        GetPage(
          name: "/Home",
          page: () => Home(),
          binding: HomeBinding(),
          transition: Transition.rightToLeftWithFade,
        ),
        GetPage(
          name: "/CourseVideo",
          page: () => CourseVideo(),
          binding: CourseVideoBinding(),
        ),
        GetPage(
          name: "/QuizPage",
          page: () => QuizPage(),
          binding: QuizBinding(),
        ),
        GetPage(
          name: "/Setting",
          page: () => Setting(),
          binding: SettingBinding(),
        ),
        GetPage(
          name: "/Courses",
          page: () => Courses(),
          binding: CoursesBinding(),
        ),
        GetPage(
          name: "/AboutUs",
          page: () => AboutUs(),
          binding: AboutUsBinding(),
        ),
        GetPage(
          name: "/LocalFiles",
          page: () => LocalFiles(),
          binding: LocalFilesBinding(),
        ),
        GetPage(
            name: "/CourseContent",
            page: () => CourseContent(),
            binding: CourseContentBinding(),
            transition: Transition.rightToLeftWithFade),
        GetPage(
          name: "/Downloads",
          page: () => Downloads(),
          binding: DownloadsBinding(),
        ),
        GetPage(
          name: "/MySubscriptions",
          page: () => MySubscriptions(),
          binding: MySubscriptionsBinding(),
        )
      ],
      builder: EasyLoading.init(),
    );
  }
}
