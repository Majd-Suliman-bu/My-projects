class ServerConfig {
  //static const domainNameServer = 'http://10.0.2.2:3000';
// static const domainNameServer = 'http://192.168.1.111:3000';
//  static const domainNameServer = 'http://192.168.1.103:3000';
  // static const domainNameServer = 'http://172.22.176.1:3000';
  static const domainNameServer =
      'https://learning-platform-back-end.onrender.com';

  //Auth
  static const registerAPI = '/users/signup';
  static const loginAPI = '/users/login';
  static const emailVerificationAPI = '/users/email-verification/';
  static const resendOtpAPI = '/users/send-email-activtion-code/';

  static const forgetPasswordOtpAPI = '/users/send-forgot-password-code';
  static const forgetPasswordCheckOtpAPI = '/users/check-code-for-password';
  static const forgetPasswordAPI = '/users/forgot-password';

  static const resetPasswordAPI = '/users/reset-password';
  static const generateAccessTokenAPI = '/users/generate-ra-tokens';

  //subjects
  static const getAllSubjectsForLevel = "/users/courses/level/";
  static const getMySubscriptions = "/users/subscriptions";

  //classes
  static const getAllClasses = "/class";

  //course content
  static const showCourse = "/users/courses/";

  //
  static const sendCourseCode = "/users/enrollment/";
}
