import 'package:flutter/material.dart';

class Flashcard {
  final String? id;
  final String englishWord;
  final String wordType;
  final String phonetic;
  final String imageUrl;
  final String vietnameseWord;
  final String? meaning;
  bool isStarred;
  String? status;

  Flashcard({
    this.id,
    required this.englishWord,
    required this.wordType,
    required this.phonetic,
    this.imageUrl = "https://th.bing.com/th/id/OIP.vfcvQrpunU1akdpD-BuCpgHaHa?w=179&h=180&c=7&r=0&o=5&dpr=1.3&pid=1.7",
    required this.vietnameseWord,
    this.meaning,
    this.isStarred = false,
    this.status,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'englishWord': englishWord,
      'wordType': wordType,
      'phonetic': phonetic,
      'imageUrl': imageUrl,
      'vietnameseWord': vietnameseWord,
      // 'meaning': meaning,
      'isStarred': isStarred,
      'status': status ?? 'Not Learning'
    };
  }

  factory Flashcard.fromJson(Map<String, dynamic> json) {
    print(json);
    return Flashcard(
      id: json['id'],
      englishWord: json['engMeaning'],
      wordType: json['type'],
      phonetic: json['phonetic'],
      imageUrl: json['imageUrl'] ?? "https://th.bing.com/th/id/OIP.vfcvQrpunU1akdpD-BuCpgHaHa?w=179&h=180&c=7&r=0&o=5&dpr=1.3&pid=1.7",
      vietnameseWord: json['vnMeaning'],
      // meaning: json['meaning'],
      isStarred: json['isMark'],
      status: json["status"],
    );
  }
}
