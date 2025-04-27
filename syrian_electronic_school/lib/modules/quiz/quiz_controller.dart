import 'dart:async';
import 'package:get/get.dart';
import '../../models/Course.dart'; // Ensure this points to your Course model
import 'resultPage.dart';

class QuizController extends GetxController {
  RxInt currentQuestionIndex = 0.obs;
  RxInt score = 0.obs;
  RxnInt selectedAnswerIndex = RxnInt(); // RxnInt allows for null values
  RxList<int> wrongAnswers = <int>[].obs;
  Timer? _timer;
  RxInt remainingTime = 5.obs;
  RxList<int> userAnswers = RxList<int>.filled(
      5, -1); // Assuming 5 questions, initialize with -1 indicating no answer
  RxBool quizStarted = false.obs;

  late List<Question> questions;

  @override
  void onInit() {
    super.onInit();
    questions = Get.arguments as List<Question>;
    startTimer();
  }

  void startQuiz() {
    quizStarted.value = true;
    currentQuestionIndex.value = 0; // Reset to the first question
    score.value = 0; // Reset score
    wrongAnswers.clear(); // Clear wrong answers
    userAnswers =
        RxList<int>.filled(questions.length, -1); // Reset user answers
    startTimer(); // Start or restart the timer
  }

  void startTimer() {
    remainingTime.value = 5; // Reset timer for each question
    _timer?.cancel(); // Cancel any existing timer
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (remainingTime.value > 0) {
        remainingTime.value--;
      } else {
        handleTimeout();
      }
    });
  }

  void handleTimeout() {
    if (selectedAnswerIndex.value == null) {
      wrongAnswers.add(currentQuestionIndex.value);
      // No need to add -1 for timeout, as it's already initialized with -1
    }
    goToNextQuestion();
  }

  void answerQuestion(int index) {
    final currentQuestion = questions[currentQuestionIndex.value];
    selectedAnswerIndex.value = index;
    userAnswers[currentQuestionIndex.value] = index; // Record the user's answer

    // Check if the selected answer is correct
    if (currentQuestion.choices[index].isCorrect) {
      score.value++;
    } else {
      wrongAnswers.add(currentQuestionIndex.value);
    }
    goToNextQuestion();
  }

  void goToNextQuestion() {
    _timer?.cancel();
    if (currentQuestionIndex.value < questions.length - 1) {
      currentQuestionIndex.value++;
      selectedAnswerIndex.value = null;
      startTimer(); // Restart the timer for the next question
    } else {
      quizStarted.value = false; // Reset the quiz start state
      Get.to(() => ResultsPage()); // Navigate to the results page
    }
  }

  @override
  void onClose() {
    _timer?.cancel();
    super.onClose();
  }
}
