import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../controllers/question_controller.dart';

class ScoreScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    final QuestionController qnController = Get.put(QuestionController());

    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Column(
            children: [
              Spacer(flex: 3),
              Text(
                "Điểm",
              ),
              Spacer(),
              Text(
                "${qnController.correctAns * 10}/${qnController.questions.length * 10}",
              ),
              Spacer(flex: 3),
            ],
          )
        ],
      ),
    );
  }
}
