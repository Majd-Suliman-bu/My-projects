import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../models/Course.dart'; // Ensure this points to your Course model
import 'quiz_controller.dart'; // Import your QuizController here

class ResultsPage extends StatelessWidget {
  final QuizController quizController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Quiz Results'),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 20.0),
                child: Text(
                  'Your Score: ${quizController.score.value}/${quizController.questions.length}',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
              ),
              Expanded(
                child: quizController.wrongAnswers.isEmpty
                    ? Center(
                        child: Text(
                          'No wrong answers!',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.green,
                          ),
                        ),
                      )
                    : ListView.builder(
                        itemCount: quizController.wrongAnswers.length,
                        itemBuilder: (context, index) {
                          int questionIndex =
                              quizController.wrongAnswers[index];
                          Question question =
                              quizController.questions[questionIndex];
                          int userAnswerIndex =
                              quizController.userAnswers[questionIndex];
                          String userAnswerText = userAnswerIndex != -1
                              ? question.choices[userAnswerIndex].choice
                              : "No Answer";
                          String correctAnswerText = question.choices
                              .firstWhere((choice) => choice.isCorrect)
                              .choice;
                          return Card(
                            margin: const EdgeInsets.symmetric(vertical: 8.0),
                            child: ListTile(
                              title: Text(
                                question.question,
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Your Answer: $userAnswerText',
                                      style: TextStyle(color: Colors.red)),
                                  Text('Correct Answer: $correctAnswerText',
                                      style: TextStyle(color: Colors.green)),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
              ),
              ElevatedButton(
                onPressed: () =>
                    Get.back(), // Adjust based on how you want to navigate
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                ),
                child: Text(
                  'Retake Quiz',
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
