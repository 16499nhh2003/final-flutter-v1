import 'package:app/controllers/question_controller.dart';
import 'package:app/models/flashcard_model.dart';
import 'package:app/models/topic_model.dart';
import 'package:app/pages/quiz/components/body.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class QuizPage extends StatefulWidget {

  final  List<Flashcard>? danhsachcactuvung;
  const QuizPage({this.danhsachcactuvung});

  @override
  State<QuizPage> createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {
  @override
  Widget build(BuildContext context) {

    final QuestionController controller = Get.put(QuestionController());
    // controller.questions = widget.danhsachcactuvung!;

    String? displayLanguage = 'Anh-Việt';

    return Scaffold(
      appBar: AppBar(
        title: Text('Chức năng trắc nghiệm'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.settings),
            onPressed: () {
              showModalBottomSheet(
                  context: context,
                  builder: (BuildContext context) {
                    return Container(
                      padding: EdgeInsets.all(20.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'Thiết lập cài đặt cho người dùng',
                            style: TextStyle(
                              fontSize: 18.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 10.0),
                          Text('Câu hỏi và trả lời:'),
                          DropdownButton<String>(
                            value: displayLanguage,
                            onChanged: (newValue) {
                              displayLanguage = newValue;
                              if (displayLanguage == 'Anh-Việt') {
                                controller.updateQuestions(true, true);
                              } else {
                                controller.updateQuestions(false, false);
                              }
                            },
                            items: ["Anh-Việt", "Việt-Anh"]
                                .map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                          ),
                          SizedBox(height: 10.0),
                        ],
                      ),
                    );
                  });
            },
          ),
        ],
      ),
      body: Body(),
    );
  }
}
