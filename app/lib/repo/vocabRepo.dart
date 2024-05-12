import 'package:app/models/folder_model.dart';
import 'package:app/models/question_model.dart';
import 'package:app/models/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:flutter/material.dart';
import 'package:get/get.dart';

// MODELs
import '../models/topic_model.dart';
import '../models/flashcard_model.dart';

import 'authRepo.dart';

class VocabRepository extends GetxController {
  static VocabRepository get instance => Get.find();

  final _db = FirebaseFirestore.instance;
  final _auth = auth.FirebaseAuth.instance;

  final String URL_COLLECTION_VOCAB = "vocab";

  // [get] lấy danh sách các vocal theo topic
  Future<List<Flashcard>> getAllVocabByTopic(Topic topic) async {
    try {
      List<Flashcard> response = [];
      final String topicID = topic.id!;
      print(topicID);

      QuerySnapshot snapshot = await _db
          .collection(URL_COLLECTION_VOCAB)
          .where("topicId", isEqualTo: topicID)
          .get();

      for (var docSnapshot in snapshot.docs) {
        Map<String, dynamic> dataJson =
            docSnapshot.data() as Map<String, dynamic>;
        // print(dataJson);
        response.add(Flashcard.fromJson(dataJson));
      }
      return response;
    } catch (e) {
      throw Exception("Có lỗi xảy ra trong khi fetch vocab  :$e");
    }
  }


  //[get] lấy danh sách các từ vựng của topic theo người dùng hiện tại

  Future<List<Flashcard>> getVocabsByTopic(Topic topic) async{
    try{
      auth.User? user =  _auth.currentUser;
      final QuerySnapshot  vocabs  =  await _db.collection("user/${user!.uid}/topics/${topic.id}/vocal").get();


      List<Flashcard> res = [];
      for (var snapshot in vocabs.docs){
        String docID = snapshot.id;
        String status = snapshot["status"];
        bool isMark = snapshot["isMarked"];
        
        // get vocab
        final DocumentSnapshot documentSnapshot = await _db.collection("vocab").doc(docID).get();
        Map<String , dynamic > dataJson = documentSnapshot.data() as Map<String , dynamic >;
        dataJson["status"] = status;
        dataJson["isMark"] = isMark;
        Flashcard vob = Flashcard.fromJson(dataJson);

        res.add(vob);
      }

      return res;
    }catch(err){
      throw Exception("Đã xảy ra lỗi ở vovacb  : $err");
    }

  }

}
