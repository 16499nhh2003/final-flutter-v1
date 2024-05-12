import 'package:app/models/folder_model.dart';
import 'package:app/models/question_model.dart';
import 'package:app/models/user_model.dart';
import 'package:app/repo/vocabRepo.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:flutter/material.dart';
import 'package:get/get.dart';

// models
import '../models/topic_model.dart';
import '../models/flashcard_model.dart';
import 'authRepo.dart';

class TopicRepository extends GetxController {
  static TopicRepository get instance => Get.find();

  final _db = FirebaseFirestore.instance;
  final _auth = auth.FirebaseAuth.instance;

  // repo
  final _vocabRepo = Get.put(VocabRepository());

  // [Get] lấy danh sách các topic public
  Stream<List<Topic>> getTopicPublic() {
    try {
      return _db
          .collection("topic")
          .where("isPrivate", isEqualTo: false)
          .snapshots()
          .map(
        (QuerySnapshot querySnapshot) {
          List<Topic> topics = querySnapshot.docs.map((doc) {
            Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
            data["id"] = doc.id;
            return Topic.fromJson(data);
          }).toList();
          // print(topics.length);
          return topics;
        },
      );
    } catch (error) {
      throw Exception("Failed to get topics: $error");
    }
  }

  // [get] lấy danh sách các topics theo folder
  Future<List<Topic>> getTopicsByFolder(Folder folder) async {
    try {
      final folderId = folder.id;
      final querySnapshot = await _db.collection("folder").doc(folderId).get();
      final dataFolder = querySnapshot.data();
      List<Topic> topics = [];

      if (dataFolder != null) {
        final List<dynamic> topicRefs = dataFolder["topics"] ?? [];
        final List<Future<DocumentSnapshot>> topicFutures = topicRefs
            .map((docRef) => docRef.get() as Future<DocumentSnapshot>)
            .toList();

        final List<DocumentSnapshot> topicSnapshots =
            await Future.wait(topicFutures);

        topics = topicSnapshots
            .map((snapshot) =>
                Topic.fromJson(snapshot.data()! as Map<String, dynamic>))
            .toList();
      }
      return topics;
    } catch (e) {
      throw Exception("Error  $e}");
    }
  }

  // [delete] xóa một topic và  xóa các topics tồn tại trong folder
  // khi xóa một topics thì topic tồn tại trong các folder đều được xóa
  Future<void> deleteTopic(Topic topic) async {
    try {
      // email của tác giả
      String emailTacgia = topic.email!;

      // [Note] nhớ cập nhật người dùng hiện tại
      // ở đây default  email  demo@gmail.com
      // lấy email của người dùng hiện tại

      auth.User? user = _auth.currentUser;
      String uid = user!.uid;
      final DocumentSnapshot userDoc =
          await _db.collection("user").doc(uid).get();
      final Map<String, dynamic> dataUser =
          userDoc.data() as Map<String, dynamic>;
      User userInfo = User.fromJson(dataUser);
      // userInfo.email = "demo@gmail.com";

      debugPrint("$emailTacgia -  ${userInfo!.toJson()}");

      if (emailTacgia != userInfo.email) {
        throw Exception("Không có quyền xóa");
      }

      // if(emailTacgia != "demo@gmail.com"){
      //   throw Exception("Không có quyền xóa");
      // }

      final DocumentReference topicRef = _db.collection("topic").doc(topic.id);
      // cập nhật lại các folder đang chứa topicref
      _db
          .collection("folder")
          .where("topics", arrayContains: topicRef)
          .get()
          .then((foldersSnapshot) {
        foldersSnapshot.docs.forEach((folderDoc) async {
          //lấy ra danh sách topics của folder đó
          List<DocumentReference> topics =
              List.from(folderDoc.data()["topics"]);
          topics.remove(topicRef);

          // đợi cập nhật collection folder
          await _db
              .collection("folder")
              .doc(folderDoc.id)
              .update({"topics": topics});
        });
        // xóa topics đó
        topicRef.delete();
      }).catchError((error) {
        throw Exception("Error occurred while fetching folders: $error");
      });
    } catch (e) {
      throw Exception("Có lỗi xảy ra : $e");
    }
  }

  // [Get] lấy danh sách các topics của chính người dùng đó
  Future<List<Topic>> getMyTopics() async {
    try {
      auth.User? user = _auth.currentUser;
      String uid = user!.uid;

      DocumentSnapshot userDoc = await _db.collection("user").doc(uid).get();
      if (userDoc.exists) {
        User userInfo = User.fromJson(userDoc.data() as Map<String, dynamic>);
        QuerySnapshot topicSnapshot = await _db
            .collection("topic")
            .where("email", isEqualTo: userInfo.email)
            .get();

        List<Topic> topics = topicSnapshot.docs.map((doc) {
          Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
          data["id"] = doc.id;
          return Topic.fromJson(data);
        }).toList();

        return topics;
      } else {
        return [];
      }
    } catch (error) {
      // If an error occurs, throw an exception
      throw Exception("Failed to get topics: $error");
    }
  }

  // [post] khi một người dùng tham gia học một topic
  // TODO : lấy danh sách tất cả từ vựng của topic . Mặc định là (NotLearning) chưa học

  Future<void> joinTopic(Topic topic) async {
    try {
      String topicID = topic.id!;
      auth.User usercurrent = _auth.currentUser!;

      List<Flashcard> vocabs = await _vocabRepo.getAllVocabByTopic(topic);

      final topicRef =
          _db.collection("user/${usercurrent.uid}/topics").doc(topicID);
      final topicDoc = await topicRef.get();

      if (!topicDoc.exists) {
        await topicRef.set({'numberOfWord': vocabs.length});
      }

      for(Flashcard vocab in vocabs){
        String vocalID = vocab.id!;
        Map<String, dynamic> vocalData = {
          'vocab': _db.collection("vocab").doc(vocalID),
          'isMarked': false,
          'status': 'Not Learning'
        };
        final vocalRef = _db.collection("user/${usercurrent.uid}/topics/$topicID/vocal").doc(vocalID);
        await vocalRef.set(vocalData);
      }

      print('Vocabs added to topic successfully');
    } catch (e) {
      throw Exception("Có lỗi xảy ra ở repo topci : $e");
    }
  }
}
