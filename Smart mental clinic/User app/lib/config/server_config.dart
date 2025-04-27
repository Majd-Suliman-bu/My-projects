import 'package:smart_medical_clinic/modules/myTherapists/myTherapists.dart';

class ServerConfig {
  // static const domainNameServer = 'http://192.168.43.21:3000';
  static const domainNameServer = 'https://backend-cznw.onrender.com';
  static const chatbotServer = 'http://192.168.137.1:5005/';

  //Auth
  static const registerAPI = '/user/register';
  static const loginAPI = '/user/login';
  static const emailVerificationAPI = '/otp/verify';
  static const resendOtpAPI = '/otp/sendOTP';
  static const checkEmailAPI = '/user/checkEmail';
  static const forgetPasswordToken = '/otp/checkToken';
  static const forgetPasswordAPI = '/user/forgetPassword';

  //Reservations
  static const String sendToBackendForNotificationUrl = '/chat/message';

  static const appointmentHomeAPI = '/appointment/home';
  static const appointmentRemoveAPI = '/appointment/request/';
  static const appointmentCancelAPI = '/appointment/cancellation/';
  static const appointmentAccept1API = '/appointment/request/';
  static const appointmentAccept2API = '/patient/accept';
  static const showAppointmentAPI = '/appointment/';
  static const requestAppointmentAPI = '/appointment/request/clinic/';

  //Doctors
  static const doctorListAPI = '/clinic/doctors';
  static const doctorProfile1API = '/clinic/doctors/';
  static const doctorProfile2API = '/profile';
  static const imageurl = "$domainNameServer/Storage/";

  //User
  static const userProfileAPI = '/user/profile';
  static const redeemcode = '/user/redeemCode';

  //Therapists
  static const MyTherapists = "/chat";
  static const getChatInfoUri = "/chat/getChat/";
  static const deleteTherapist1 = "/assignment/spec/";
  static const deleteTherapist2 = "/user/";
  static const deleteTherapist3 = "/unassign";

  //ChatBot
  static const getChatBotQuestions = 'webhooks/rest/webhook';
  static const String reportVideoCallUri = '/reports/appointment';
  static const String checkIfSessionCompleteUri = '/appointment/check/';
  static const String videoCallCompleteUri = '/appointment/complete';
  static const String botscore = '/botScore';
}
