import 'package:get/get.dart';

import '../modules/quiz/quiz_controller.dart';

class QuizBinding implements Bindings {
  @override
  void dependencies() {
    Get.put<QuizController>(QuizController());
  }
}
