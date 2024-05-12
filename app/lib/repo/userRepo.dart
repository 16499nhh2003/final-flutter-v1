import 'package:app/models/topic_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as authservice;
import 'package:get/get.dart';
import 'package:app/models/user_model.dart';

class UserRepository extends GetxController {
  static UserRepository get instance => Get.find();
  final _db = FirebaseFirestore.instance;
  final _auth = authservice.FirebaseAuth.instance;

  // [get] find user by id
  Future<User?> findUserById(String? id) async {
    try {
      DocumentSnapshot userSnapshot =
          await _db.collection("user").doc(id).get();
      if (userSnapshot.exists) {
        // User with the specified ID found
        Map<String, dynamic> data = userSnapshot.data() as Map<String, dynamic>;
        data["id"] = userSnapshot.id;
        return User.fromJson(data);
      } else {
        // User with the specified ID not found
        return null;
      }
    } catch (error) {
      throw Exception("Failed to find user by ID: $error");
    }
  }

  //  [get] danh sách các topics của người dùng đang theo học
  Future<List<Topic>> getMyTopics() async {
    try {
      authservice.User? userCurrent = _auth.currentUser;

      final QuerySnapshot topics =
          await _db.collection("user/${userCurrent!.uid}/topics").get();

      List<Topic> topics_ = [];
      for (var docSnapshot in topics.docs) {
        String docID = docSnapshot.id;
        Map<String, dynamic> dataJson =
            docSnapshot.data() as Map<String, dynamic>;

        final DocumentSnapshot docTopic =
            await _db.collection("topic").doc(docID).get();
        Map<String, dynamic> dataJson_ =
            docTopic.data() as Map<String, dynamic>;
        dataJson_["numberOfWord"] = dataJson["numberOfWord"];
        Topic topicInfo = Topic.fromJson(dataJson_);
        topics_.add(topicInfo);
      }
      return topics_;
    } catch (e) {
      throw Exception(e);
    }
  }
}
