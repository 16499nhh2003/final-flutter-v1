import 'package:app/models/folder_model.dart';

class Topic {
  final String? id;
  final String title;
  final Folder? folder;
  final bool isPrivate;
  final String? email;
  int? numberOfWord = 0;

  Topic(
      {this.id,
      required this.title,
      this.folder,
      required this.isPrivate,
      this.email,
      this.numberOfWord});

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'email': email,
      'isPrivate' :isPrivate ,
      'numberOfWord': numberOfWord
    };
  }

  factory Topic.fromJson(Map<String, dynamic> json) {
    // print("Model >>>>>> $json}");
    return Topic(
      id: json['id'],
      title: json['title'],
      isPrivate: json['isPrivate'],
      email: json['email'],
      numberOfWord: json['numberOfWord'],

    );
  }
}
