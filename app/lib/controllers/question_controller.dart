import 'package:app/controllers/user_controller.dart';
import 'package:app/models/flashcard_model.dart';
import 'package:app/models/question_model.dart';
import 'package:app/models/topic_model.dart';
import 'package:app/repo/userRepo.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:get/state_manager.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../pages/quiz/score/score_screen.dart';

class QuestionController extends GetxController
    with GetSingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation _animation;

  Animation get animation => _animation;
  late PageController _pageController;

  PageController get pageController => _pageController;

  List<Question> _questions = generateQuestions(vocabularyList, true, true);

  set questions(List<Question> value) {
    _questions = value;
  }

  List<Question> get questions => _questions!;
  bool _isAnswered = false;

  bool get isAnswered => _isAnswered;

  int _correctAns = 0;

  int get correctAns => _correctAns;

  int? selectedAns;

  // int get selectedAns => this._selectedAns;

  int _questionNumber = 1;

  int get questionNumber => _questionNumber;
  int _numOfCorrectAns = 0;

  int get numOfCorrectAns => _numOfCorrectAns;

  final UserController _userController = Get.put(UserController());

  @override
  void onInit() {
    _pageController = PageController();

    _animationController =
        AnimationController(duration: Duration(seconds: 60), vsync: this);

    _animation = Tween<double>(begin: 0, end: 1).animate(_animationController)
      ..addListener(() {
        update();
      });

    _animationController.forward().whenComplete(nextQuestion);
    super.onInit();
  }

  @override
  void onClose() {
    super.onClose();
    _animationController.dispose();
    _pageController.dispose();
  }

  // logic kiểm tra đúng của câu hỏi
  void checkAns(Question question, int selectedIndex) {
    _isAnswered = true;
    _correctAns = question.answer_index;
    selectedAns = selectedIndex;

    if (_correctAns == selectedAns) _numOfCorrectAns++;

    _animationController.stop();
    update();
  }

  // chuyển tiếp câu tiếp theo
  void nextQuestion() {
    if (_questionNumber != _questions.length) {
      _isAnswered = false;
      _pageController.nextPage(
          duration: Duration(milliseconds: 250), curve: Curves.ease);
      _animationController.reset();
      _animationController.forward().whenComplete(nextQuestion);
    } else {
      // Get.to(ScoreScreen());
    }
  }

  // logic cập nhật số lượng câu hỏi
  void updateTheQnNum(int index) {
    _questionNumber = index + 1;
  }

  // cập nhật trạng thái anh- việt
  void updateQuestions(bool displayEnglish, bool answerVietnamese) {
    _questions =
        generateQuestions(vocabularyList, displayEnglish, answerVietnamese);
    _questionNumber = 1; // Reset question number when updating questions
    _numOfCorrectAns = 0; // Reset correct answers count
    _pageController.jumpToPage(0); // Jump to the first question page
    _animationController.reset(); // Reset animation
    _animationController
        .forward()
        .whenComplete(nextQuestion); // Start animation and load next question
  }
}
