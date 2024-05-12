import 'dart:math';

import 'package:app/models/folder_model.dart';
import 'package:app/models/topic_model.dart';
import 'package:flutter/material.dart';

//  new instance
Folder folder = Folder(name: "Tiếng anh cơ bản");
Topic topic = Topic(title: "Trái cây", folder: folder , isPrivate: true);

// Vocabulary class
class Vocabulary {
  final int id;
  final Topic topic;
  final String englishWord;
  final String vietnameseWord;


  Vocabulary({
    required this.id,
    required this.englishWord,
    required this.vietnameseWord,
    required this.topic,
  });
}

// List of vocabulary words belonging to the same topic
List<Vocabulary> vocabularyList = [
  Vocabulary(
    id: 1,
    englishWord: "Apple",
    vietnameseWord: "Quả táo",
    topic: topic,
  ),
  Vocabulary(
    id: 2,
    englishWord: "Banana",
    vietnameseWord: "Quả chuối",
    topic: topic,
  ),
  Vocabulary(
    id: 3,
    englishWord: "Orange",
    vietnameseWord: "Quả cam",
    topic: topic,
  ),
  Vocabulary(
    id: 4,
    englishWord: "Mango",
    vietnameseWord: "Quả xoài",
    topic: topic,
  ),
  Vocabulary(
    id: 5,
    englishWord: "Melon",
    vietnameseWord: "Dưa hấu",
    topic: topic,
  ),
];

class Question {
  final String question;
  final int answer_index;
  final List<String> options;

  Question({
    required this.question,
    required this.answer_index,
    required this.options,
  });
}


List<Question> generateQuestions(List<Vocabulary> vocabularyList,
    bool displayEnglish, bool answerVietnamese) {

  // khởi tạo danh sách các câu hỏi
  List<Question> questions = [];

  for (Vocabulary vocabulary in vocabularyList) {
    // ramdom lấy những giá trị sai cùng topic

    // câu hỏi
    String questionWord =
        displayEnglish ? vocabulary.englishWord : vocabulary.vietnameseWord;

    // Đáp án đúng
    String correctAnswer =
        answerVietnamese ? vocabulary.vietnameseWord : vocabulary.englishWord;

    List<String> shuffledOptions = vocabularyList
        .where((v) => v != vocabulary)
        .map((v) => answerVietnamese ? v.vietnameseWord : v.englishWord)
        .toList()
      ..shuffle();

    // tạo một danh sách options ramdom mới
    shuffledOptions = shuffledOptions.sublist(0, 3)..add(correctAnswer);
    // lấy index của giá trị đúng
    int correctAnswerIndex = shuffledOptions.indexOf(correctAnswer);

    // tạo instancee
    Question question = Question(
      question: questionWord,
      options: shuffledOptions,
      answer_index: correctAnswerIndex,
    );

    questions.add(question);
  }

  return questions;
}
