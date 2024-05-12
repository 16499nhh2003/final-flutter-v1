import 'package:app/controllers/folder_controller.dart';
import 'package:app/models/folder_model.dart';
import 'package:app/pages/topicPage.dart';
import 'package:app/widgets/custom_app_bar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'dart:math';

import 'package:get/get.dart';

// models
import '../models/user_model.dart';
import '../models/folder_model.dart';

class FolderPage extends StatefulWidget {
  const FolderPage({super.key});

  @override
  State<FolderPage> createState() => _FolderPageState();
}

class _FolderPageState extends State<FolderPage> {
  final _formKey = GlobalKey<FormState>();
  late FocusNode _focusNode;
  late TextEditingController _folderController;

  final FolderController __folderController = Get.put(FolderController());
  List<Folder> folders = [];
  Folder? selectedFolder;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _folderController = TextEditingController();
    _focusNode = FocusNode();
    _focusNode.requestFocus();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _folderController.dispose();
    super.dispose();
  }

  Widget _itemBuilder(context, index) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      color: Colors.lightBlueAccent,
      child: InkWell(
        onTap: () {
          Folder folderTarget = folders[index];
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => TopicListPage(folder: folderTarget),
            ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Column(
                  children: [
                    Icon(
                      Icons.folder,
                      size: 50,
                      color: Colors.blue,
                    ),
                    SizedBox(height: 10),
                    Text(
                      folders[index].name,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
              SizedBox(
                width: 50,
                // Điều chỉnh kích thước của SizedBox để đặt vị trí PopupMenuButton
                height: 50,
                child: PopupMenuButton(
                  itemBuilder: (BuildContext context) => <PopupMenuEntry>[
                    PopupMenuItem(
                      child: ListTile(
                        leading: Icon(Icons.edit),
                        title: Text('Chỉnh sửa'),
                        onTap: () {
                          // Hàm xử lý khi người dùng chọn "Edit"
                          // Thực hiện các thao tác chỉnh sửa folder ở đây
                        },
                      ),
                    ),
                    PopupMenuItem(
                      child: ListTile(
                        leading: Icon(Icons.delete),
                        title: Text('Xóa'),
                        onTap: () {
                          setState(() {
                            selectedFolder = folders[index];
                            _handleDeleteFolder();
                          });
                          // Hàm xử lý khi người dùng chọn "Delete"
                          // Thực hiện các thao tác xóa folder ở đây
                          // setState(() {
                          //   folders.removeAt(index);
                          // });
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Thư mục của bạn',
      ),
      body: Container(
          padding: const EdgeInsets.all(10),
          child: StreamBuilder<List<Folder>>(
            stream: __folderController.getAllFoldersStream(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return CircularProgressIndicator(); // Loading indicator while data is loading
              }
              if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              }
              if (snapshot.data != null) {
                folders = snapshot.data!;
                if (folders.isNotEmpty) {
                  return GridView.builder(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2),
                    itemBuilder: _itemBuilder,
                    itemCount: folders.length,
                  );
                }
              }
              return Text('No data available');
            },
          )),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text('Thêm folder'),
                content: Form(
                  key: _formKey,
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        Focus(
                          child: TextFormField(
                            focusNode: _focusNode,
                            controller: _folderController,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Vui lòng không được để trống';
                              }
                              return null;
                            },
                            onSaved: (value) {},
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text('Hủy bỏ'),
                  ),
                  TextButton(
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        Folder newFolder = Folder(
                          name: _folderController.text,
                        );

                        Folder? createFolder =
                            await __folderController.postOneFolder(newFolder);

                        if (createFolder != null) {
                          _folderController.clear();
                          _focusNode.requestFocus();
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Tạo thư mục mới thành công.'),
                            ),
                          );
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Có lỗi khi tạo thư mục.'),
                            ),
                          );
                        }
                      }
                    },
                    child: Text('Thêm'),
                  ),
                ],
              );
            },
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }

  void _handleDeleteFolder() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Xác nhận xóa thư mục"),
          content:
              Text("Bạn chắc chắn muốn xóa topic ${selectedFolder!.name}?"),
          actions: [
            ElevatedButton(
              child: Text("Hủy"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            ElevatedButton(
              child: Text("Xóa"),
              onPressed: () async {
                try {
                  print(selectedFolder!.toJson());
                  await __folderController.deleteFolder(selectedFolder!);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content:
                          Text("Thư mục ${selectedFolder!.name} đã được xóa."),
                      duration:
                          Duration(seconds: 2), // Adjust duration as needed
                    ),
                  );
                  Navigator.of(context).pop(); // Close the AlertDialog
                } catch (e) {
                  print(e);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                          "Thư mục ${selectedFolder!.name} xóa không thành công."),
                      duration:
                          Duration(seconds: 2), // Adjust duration as needed
                    ),
                  );
                }
              },
            ),
          ],
        );
      },
    );
  }
}
