import 'package:app/models/folder_model.dart';
import 'package:app/models/topic_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

// repo
import 'package:app/repo/folderRepo.dart';
import 'package:app/repo/topicRepo.dart';
import 'package:app/repo/userRepo.dart';

class TopicController extends GetxController {
  static TopicController get instance => Get.find();

  // repo
  final _topicRepository = Get.put(TopicRepository());

  Stream<List<Topic>> getAllTopicsPublic() {
    try {
      return _topicRepository.getTopicPublic();
    } catch (error) {
      print("Error at  topic controller :$error");
      return Stream<List<Topic>>.empty();
    }
  }

  Future<List<Topic>> getTopicsByFolder(Folder folder) {
    try {
      return _topicRepository.getTopicsByFolder(folder);
    } catch (e) {
      rethrow;
    }
  }

  // [Get] lấy danh sách các topics của chính người dùng đó
  Future<List<Topic>> getMyTopics() {
    try {
      return _topicRepository.getMyTopics();
    } catch (e) {
      rethrow;
    }
  }


  // [delete] xóa một topic
  Future<void> deleteTopic(Topic topic) async{
    try{
      return await _topicRepository.deleteTopic(topic);
    }catch(e){
      rethrow;
    }
  }

  // [post] di chuyển một topic vào danh sách các topic đang học
  Future<void> addIntoMyTopics(Topic topic) async{
    try{
      await _topicRepository.joinTopic(topic);
    }catch(e){
      rethrow;
    }
  }
}
