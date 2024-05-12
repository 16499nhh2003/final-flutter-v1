import 'package:app/models/flashcard_model.dart';
import 'package:app/models/topic_model.dart';
import 'package:app/repo/folderRepo.dart';
import 'package:app/repo/userRepo.dart';
import 'package:app/repo/vocabRepo.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class UserController extends GetxController {
  static UserController get instance => Get.find();

  final name = TextEditingController();

  final _userRepository = Get.put(UserRepository());
  final _vocabRepository = Get.put(VocabRepository());



  // [get] controller lấy danh sách các topics người dùng đang học
  Future<List<Topic>> getTopics() async {
    try{
      List<Topic> topics = await _userRepository.getMyTopics();
      return topics;
    }catch(e){
      rethrow;
    }
  }


  // [get] controller lấy danh sách các từ vựng (vocab)  của người dùng  theo topic
  Future<List<Flashcard>> getVocabsByTopic(Topic topic) async {
    try{
      List<Flashcard> tuvung = await _vocabRepository.getVocabsByTopic(topic);
      return tuvung;
    }
    catch(e){
      rethrow;
    }
  }

}
