import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_medical_clinic/modules/chat-mayar/bloc/chat_bloc.dart';
import 'package:smart_medical_clinic/modules/videoCall/bloc/video_call_bloc.dart';
import 'package:smart_medical_clinic/shared_widget/app_injection.dart' as di;

import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:pushy_flutter/pushy_flutter.dart';
import 'package:smart_medical_clinic/lang/LocalStrings.dart';
import 'package:smart_medical_clinic/modules/chat-mayar/helper-stuff/responsive_util.dart';
import 'package:smart_medical_clinic/modules/chat-mayar/view/screens/chat_page.dart';
import 'package:smart_medical_clinic/modules/theme/themeController.dart';
import 'package:smart_medical_clinic/modules/videoCall/video_call_init_page.dart';

import 'getx_bindings/chatBot_binding.dart';
import 'getx_bindings/doctorProfile_binding.dart';
import 'getx_bindings/doctors_binding.dart';
import 'getx_bindings/forgotPassward_binding.dart';
import 'getx_bindings/landing_binding.dart';
import 'getx_bindings/login_binding.dart';
import 'getx_bindings/myTherapists_binding.dart';

import 'getx_bindings/newPassword_binding.dart';
import 'getx_bindings/otp_binding.dart';
import 'getx_bindings/profile_binding.dart';
import 'getx_bindings/register_binding.dart';
import 'getx_bindings/reservations_binding.dart';
import 'getx_bindings/splash_binding.dart';
import 'getx_bindings/tabView_binding.dart';

import 'modules/Navigator/Navigator.dart';
import 'modules/OTP/otp.dart';
import 'modules/chatBot/chatBot.dart';
import 'modules/doctorProfile/doctorProfile.dart';
import 'modules/doctors/doctors.dart';
import 'modules/forgotPassword/forgotPassword.dart';
import 'modules/landing/landing.dart';
import 'modules/login/login.dart';
import 'modules/myTherapists/myTherapists.dart';
import 'modules/newPassword/newPassword.dart';

import 'modules/profile/profile.dart';
import 'modules/pushy/pushy.dart';
import 'modules/register/register.dart';
import 'modules/reservations/reservations.dart';
import 'modules/reservations/videocallPlaceholder.dart';
import 'modules/splashScreen/splash.dart';
import 'modules/tabView/tabView.dart';
import 'modules/videoCall/call.dart';

late ResponsiveUtil responsiveUtil;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await di.init();

  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    // Start the Pushy service
    Pushy.listen();
    // Enable in-app notification banners (iOS 10+)
    Pushy.toggleInAppBanner(true);
    print("maaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaain 4");
    // Set custom notification icon (Android)
    Pushy.setNotificationIcon('@mipmap/launcher_icon');
    print("maaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaain 5");
// Listen for push notifications received
    Pushy.setNotificationListener(backgroundNotificationListener);
    print("maaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaain 6");
    Pushy.setNotificationClickListener((data) {});
    print("maaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaain 7");
  }

  final ThemeController themeController = Get.put(ThemeController());

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    responsiveUtil = ResponsiveUtil(context);

    return Obx(() => MultiBlocProvider(
          providers: [
            BlocProvider<VideoCallBloc>(create: (_) => di.sl<VideoCallBloc>()),
            BlocProvider<ChatBloc>(create: (_) => di.sl<ChatBloc>()),
          ],
          child: GetMaterialApp(
            initialRoute: '/Splash',
            debugShowCheckedModeBanner: false,
            theme: themeController.themeData.value,
            translations: LocalStrings(),
            locale: Locale('en,US'),
            getPages: [
              GetPage(
                name: "/Login",
                page: () => Login(),
                binding: LoginBinding(),
              ),
              GetPage(
                name: "/Register",
                page: () => Register(),
                binding: RegisterBinding(),
              ),
              GetPage(
                name: "/Splash",
                page: () => Splash(),
                binding: SplashBinding(),
              ),
              GetPage(
                name: "/ForgotPassword",
                page: () => ForgotPassword(),
                binding: ForgotPasswordBinding(),
              ),
              GetPage(
                name: "/OTP",
                page: () => OTP(),
                binding: OTPBinding(),
              ),
              GetPage(
                name: "/NewPassword",
                page: () => NewPassword(),
                binding: NewPasswordBinding(),
              ),
              GetPage(
                name: "/TabView",
                page: () => TabView(),
                binding: TabViewBinding(),
              ),
              GetPage(
                name: "/ChatBot",
                page: () => ChatBot(),
                binding: ChatBotBinding(),
              ),
              GetPage(
                name: "/Profile",
                page: () => Profile(),
                binding: ProfileBinding(),
              ),
              GetPage(
                name: "/Doctors",
                page: () => Doctors(),
                binding: DoctorsBinding(),
              ),
              GetPage(
                name: "/DoctorProfile",
                page: () => DoctorProfile(),
                binding: DoctorProfileBinding(),
              ),
              GetPage(
                name: "/Navigator",
                page: () => NavigatorPage(), // This will be your new page class
              ),
              GetPage(
                  name: "/Reservations",
                  page: () => Reservations(),
                  binding:
                      ReservationsBinding() // This will be your new page class
                  ),
              GetPage(
                  name: "/MyTherapists",
                  page: () => MyTherapists(),
                  binding:
                      MyTherapistsBinding() // This will be your new page class
                  ),
              GetPage(
                  name: "/Landing",
                  page: () => Landing(),
                  binding: LandingBinding() // This will be your new page class
                  ),
              GetPage(
                name: "/VideoCallPage",
                page: () => VideoCallPage(),
              ),
              // GetPage(
              //   name: "/ChatPagem",
              //   page: () => const ChatPagem(),
              // ),
              GetPage(
                name: "/VideocallPlaceholder",
                page: () => VideocallPlaceholder(),
              ),
              GetPage(
                name: "/VideoCallInitPage",
                page: () => const VideoCallInitPage(),
              ),
            ],
            builder: EasyLoading.init(),
          ),
        ));
  }
}
