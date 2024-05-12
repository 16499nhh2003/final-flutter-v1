import 'package:app/models/folder_model.dart';
import 'package:app/models/topic_model.dart';
import 'package:app/repo/authRepo.dart';
import 'package:app/repo/userRepo.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../models/user_model.dart';

class FolderRepository extends GetxController {
  static FolderRepository get instance => Get.find();

  final _db = FirebaseFirestore.instance;
  final _auth = auth.FirebaseAuth.instance;

  final _authRepository = Get.put(AuthenticateRepository());

  // final _userRepository = Get.put(UserRepository());

  // [post] thêm một topic vào folder
  addTopicToFolder(String docIdFolder, String docIdTopic) async {
    try {
      // print("$docIdFolder ,  $docIdTopic");
      DocumentSnapshot folderSnapshot =
          await _db.collection("folder").doc(docIdFolder).get();
      if (!folderSnapshot.exists) {
        throw Exception("Folder document not found with ID: $docIdFolder");
      }
      DocumentSnapshot topicSnapshot =
          await _db.collection("topic").doc(docIdTopic).get();
      if (!topicSnapshot.exists) {
        throw Exception("Topic document not found with ID: $docIdFolder");
      }

      //Update the folder document with the topic reference
      await _db.collection("folder").doc(docIdFolder).update({
        "topics":
            FieldValue.arrayUnion([_db.collection("topic").doc(docIdTopic)])
      });
    } catch (error) {
      throw Exception("Failed to add topic to folder: $error");
    }
  }

  // [Get] lấy danh sách các folder theo topic
  Stream<List<Folder>> getAllFolders() {
    try {
      String? userId = _authRepository.getCurrentUserId();
      if (userId == null) {
        throw Exception("không tìm thấy người dùng");
      }

      final DocumentReference userRef = _db.collection("user").doc(userId);

      Stream<List<Folder>> folders = _db
          .collection("folder")
          .where("user", isEqualTo: userRef)
          .snapshots()
          .map((querySnapshot) => querySnapshot.docs.map((doc) {
                Map<String, dynamic> data = doc.data();
                Folder folder = Folder.fromJson(data);
                folder.id = doc.id;

                DocumentReference creatorRef = data["user"];
                creatorRef.get().then((creatorSnapshot) {
                  if (creatorSnapshot.exists) {
                    Map<String, dynamic> creatorData =
                        creatorSnapshot.data()! as Map<String, dynamic>;
                    creatorData["id"] = creatorSnapshot.id;
                    User creator = User.fromJson(creatorData);
                    // print(creator.toJson());
                    folder.creator = creator;
                  } else {}
                });

                return folder;
              }).toList());

      return folders;
    } catch (error) {
      throw Exception("Failed to get folders stream: $error");
    }
  }

  // [post] tạo mới một folder
  Future<Folder?> postOneFolder(Folder folder) async {
    try {
      String? userId = _authRepository.getCurrentUserId();

      DocumentReference docRef = await _db.collection("folder").add({
        'name': folder.name,
        'user': userId != null ? _db.collection("user").doc(userId) : null,
        'topics': folder.topics
      });
      String id = docRef.id;

      DocumentSnapshot folderSnapshot =
          await _db.collection("folder").doc(id).get();

      if (folderSnapshot.exists) {
        Map<String, dynamic> data =
            folderSnapshot.data() as Map<String, dynamic>;
        return Folder.fromJson(data);
      }
    } catch (error) {
      throw Exception("Failed to post folder: $error");
    }
  }

  // [delete] xóa một topic ra khỏi folder
  Future<void> deleteTopicFromFolder(
      String docIdFolder, String docIdTopic) async {
    try {
      DocumentSnapshot folderSnapshot =
          await _db.collection("folder").doc(docIdFolder).get();
      if (!folderSnapshot.exists) {
        throw Exception("Folder document not found with ID: $docIdFolder");
      }
      DocumentSnapshot topicSnapshot =
          await _db.collection("topic").doc(docIdTopic).get();
      if (!topicSnapshot.exists) {
        throw Exception("Topic document not found with ID: $docIdFolder");
      }

      //Update the folder document with the topic reference
      await _db.collection("folder").doc(docIdFolder).update({
        "topics":
            FieldValue.arrayRemove([_db.collection("topic").doc(docIdTopic)])
      });
    } catch (error) {
      throw Exception("Failed to add topic to folder: $error");
    }
  }

  // [delete] xóa một folder
  Future<void> deleteFolder(Folder folder) async {
    try {
      String tacgiaID = folder.creator!.id!;
      User? user = await _authRepository.getCurrentUser();

      debugPrint("$tacgiaID -  ${user!.toJson()}");

      String userCurrent = user!.id!;
      if (tacgiaID != userCurrent) {
        throw Exception("Không có quyền xóa");
      }
      DocumentReference folderDocRef = _db.collection("folder").doc(folder.id);
      await folderDocRef.delete();
    } catch (e) {
      throw Exception("Có lỗi xảy ra : $e");
    }
  }
}
