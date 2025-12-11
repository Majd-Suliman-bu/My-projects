import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'quiz_controller.dart';
import '../../models/Course.dart'; // Ensure this points to your Course model

class QuizPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final QuizController controller = Get.put(QuizController());

    return Scaffold(
      appBar: AppBar(
        title: Text('Quiz'),
        actions: [
          Obx(() => controller.quizStarted.isTrue
              ? Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Center(
                    child: Text(
                      'Question ${controller.currentQuestionIndex.value + 1}/${controller.questions.length}',
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                )
              : SizedBox
                  .shrink()), // Hide question count if quiz hasn't started
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10.0),
          child: Obx(() {
            if (!controller.quizStarted.value) {
              // Display "Start Quiz" button if the quiz hasn't started
              return Center(
                child: ElevatedButton(
                  onPressed: () => controller.startQuiz(),
                  child: Text(
                    'Start Quiz',
                    style: TextStyle(color: Colors.white),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    padding: EdgeInsets.symmetric(horizontal: 50, vertical: 20),
                    textStyle: TextStyle(fontSize: 18),
                  ),
                ),
              );
            } else if (controller.currentQuestionIndex.value <
                controller.questions.length) {
              // Quiz content
              final question =
                  controller.questions[controller.currentQuestionIndex.value];
              return Column(
                children: [
                  LinearProgressIndicator(
                    value: (controller.currentQuestionIndex.value + 1) /
                        controller.questions.length,
                    backgroundColor: Colors.grey[300],
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Text(
                      'Time left: ${controller.remainingTime.value} seconds',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: controller.remainingTime.value <= 5
                            ? Colors.red
                            : Colors.black,
                      ),
                    ),
                  ),
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: Text(
                              question.question,
                              style: TextStyle(
                                  fontSize: 24, fontWeight: FontWeight.bold),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          ...List.generate(
                            question.choices.length,
                            (index) => Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 10.0, horizontal: 20.0),
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  foregroundColor: Colors.black,
                                  backgroundColor: Colors.white, // Text color
                                  padding: EdgeInsets.symmetric(vertical: 15.0),
                                  textStyle: TextStyle(fontSize: 18),
                                  minimumSize: Size.fromHeight(50),
                                ),
                                onPressed: () =>
                                    controller.answerQuestion(index),
                                child: Text(question.choices[index].choice),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(bottom: 50),
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width * 0.2,
                                  height:
                                      MediaQuery.of(context).size.height * 0.1,
                                  child: CircularProgressIndicator(
                                    value: controller.remainingTime.value / 5,
                                    strokeWidth: 6,
                                    backgroundColor: Colors.grey[200],
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                        Colors.blue),
                                  ),
                                ),
                                Text(
                                  '${controller.remainingTime.value}',
                                  style: TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              );
            } else {
              // Display score when quiz is finished
              return Center(
                child: Text(
                  'Score: ${controller.score.value}/${controller.questions.length}',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
              );
            }
          }),
        ),
      ),
    );
  }
}
