import 'package:app/models/folder_model.dart';
import 'package:app/repo/folderRepo.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class FolderController extends GetxController {
  static FolderController get instance => Get.find();

  final name = TextEditingController();

  final _folderRepository = Get.put(FolderRepository());

  //[post] tạo mới một folder
  Future<void> addTopicToFolder(String folderId, String topicId) async {
    try {
      await _folderRepository.addTopicToFolder(folderId, topicId);
    } catch (error) {
      print(error.toString());
      rethrow;
    }
  }

  // [Get] lấy danh sách các folder theo topic
  Stream<List<Folder>> getAllFoldersStream() {
    try {
      return _folderRepository.getAllFolders();
    } catch (error) {
      print(error.toString());
      return Stream<List<Folder>>.empty();
    }
  }

  // [post] thêm một topic vào folder
  Future<Folder?> postOneFolder(Folder folderModel) async {
    try {
      Folder? newFolder = await _folderRepository.postOneFolder(folderModel);
      return newFolder;
    } catch (error) {
      print("error at folder controller : $error");
      return null;
    }
  }

  //[delete] xóa một topic ra khỏi folder
  Future<void> deleteTopicFromFolder(String folderId, String topicId) async {
    try {
      await _folderRepository.deleteTopicFromFolder(folderId, topicId);
    } catch (error) {
      print(error.toString());
      rethrow;
    }
  }

  //[delete] xóa một folder
  Future<void> deleteFolder(Folder folder) async {
    try {
      await _folderRepository.deleteFolder(folder);
    } catch (error) {
      print(error.toString());
      rethrow;
    }
  }

}
