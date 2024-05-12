import 'package:flutter/material.dart';

// models
import 'user_model.dart';
import 'package:app/models/topic_model.dart';

class Folder {
  String? id;
  final String name;
  User? creator;

  final List<Topic> topics;

  Folder({this.id, required this.name, this.creator, List<Topic>? topics})
      : topics = topics ?? [];

  factory Folder.fromJson(Map<String, dynamic> json) {
    print(json);
    return Folder(
      id: json['id'],
      name: json['name'],
      creator: json['creator'],
      topics: []
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'user': creator?.toJson(),
      // 'topics': topics.map((topic) => topic.toJson()).toList(),
    };
  }
}
