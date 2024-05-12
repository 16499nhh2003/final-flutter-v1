import 'package:app/controllers/question_controller.dart';
import 'package:app/pages/quiz/components/progress_bar.dart';
import 'package:app/pages/quiz/components/question_card.dart';
import 'package:app/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Body extends StatefulWidget {
  const Body({
    Key? key,
  }) : super(key: key);

  @override
  State<Body> createState() => _BodyState();
}

class _BodyState extends State<Body> {
  @override
  Widget build(BuildContext context) {
    int pageNumber = 1;
    QuestionController questionController = Get.put(QuestionController());

    void showConfirmationDialog() {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Nộp"),
            content: Text("Xác nhận nộp bài?"),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text("Cancel"),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);

                  // Show the "Quiz Submitted" dialog
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text("Ghi nhận điểm"),
                        content: Text(
                            "Số câu đúng. ${questionController.numOfCorrectAns}  / ${questionController.questionNumber} "),
                        actions: [
                          TextButton(
                            onPressed: () {
                              // navigate to page list topic
                              // Navigator.pop(context);
                            },
                            child: Text("Xác nhận"),
                          ),
                        ],
                      );
                    },
                  );
                },
                child: Text("Nộp bài"),
              ),
            ],
          );
        },
      );
    }

    return Stack(
      children: [
        SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: kDefaultPadding),
                child: ProgressBar(),
              ),
              ElevatedButton(
                onPressed: () {
                  if (questionController.questionNumber ==
                      questionController.questions.length) {
                    showConfirmationDialog();
                  } else {
                    questionController.nextQuestion();
                  }
                },
                child: Text('Tiếp'),
              ),
              SizedBox(height: kDefaultPadding),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: kDefaultPadding),
                child: Text(
                  "Câu hỏi ${questionController.questionNumber}/${questionController.questions.length}",
                ),
              ),
              Divider(thickness: 1.5),
              SizedBox(height: kDefaultPadding),
              Expanded(
                child: PageView.builder(
                  physics: NeverScrollableScrollPhysics(),
                  controller: questionController.pageController,
                  onPageChanged: (index) {
                    questionController.updateTheQnNum(index);
                    setState(() {
                      pageNumber = questionController.questionNumber;
                    });
                  },
                  itemCount: questionController.questions.length,
                  itemBuilder: (context, index) => QuestionCard(
                      question: questionController.questions[index]),
                ),
              ),
            ],
          ),
        )
      ],
    );
  }
}
