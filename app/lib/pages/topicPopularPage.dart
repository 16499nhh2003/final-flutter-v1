import 'dart:async';
import 'dart:math';
import 'package:app/controllers/user_controller.dart';
import 'package:app/models/flashcard_model.dart';
import 'package:flutter/material.dart';

// controllers
import 'package:app/controllers/folder_controller.dart';
import 'package:app/controllers/topic_controller.dart';

// screens
import 'package:app/pages/quiz/quizPage.dart';
import 'package:app/pages/vocabularyPage.dart';

// repo
import 'package:app/repo/folderRepo.dart';

// models
import 'package:app/models/folder_model.dart'; // Import folder model
import 'package:app/models/topic_model.dart'; // Import topic model
// firebase
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class TopicPopularPage extends StatefulWidget {
  final Folder? folder;

  const TopicPopularPage({this.folder});

  @override
  State<TopicPopularPage> createState() => _TopicListPageState();
}

class _TopicListPageState extends State<TopicPopularPage> {
  List<Topic> topics = [];

  late TextEditingController _topicController;
  late FocusNode _focusNode;
  final _formKey = GlobalKey<FormState>();

  final TopicController __topicController = Get.put(TopicController());
  final FolderController _folderController = Get.put(FolderController());
  final UserController _userController = Get.put(UserController());

  String? idtopicselected;
  Topic? topicSelected;
  String? status;


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _topicController = TextEditingController();
    _focusNode = FocusNode();
    _focusNode.requestFocus();
  }


  @override
  void dispose() {
    // TODO: implement dispose
    _topicController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.folder?.name ?? 'Chủ đề'),
          actions: [],
          bottom: TabBar(
            tabs: [
              Tab(text: 'Chủ đề của tôi'),
              Tab(text: 'Chủ đề phổ biến'),
              Tab(text  : 'Chủ để đang học')
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _handleMyTopic(),
            _handleTopicPopular(),
            _handleTopicLearning(),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add),
          onPressed: () {
            showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Text('Thêm topic'),
                    content: Form(
                      key: _formKey,
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            Focus(
                              child: TextFormField(
                                focusNode: _focusNode,
                                controller: _topicController,
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
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            // thêm một topic vào danh sách
                            // setState(() {
                            //   topics.add(Topic(
                            //     name: _topicController.text,
                            //     iconData: Icons.school,
                            //     folder: Folder(
                            //         name: "Basic English",
                            //         iconData: Icons.school ,
                            //       // creator:  dn
                            //       creator:
                            //     ),
                            //   ));
                            //
                            //   // clear input
                            //   _topicController.clear();
                            //   _focusNode.requestFocus();
                            // });

                            // Show snackbar alert them thanh cong
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Đã thêm topic thành công'),
                              ),
                            );
                          }
                        },
                        child: Text('Thêm'),
                      ),
                    ],
                  );
                });
          },
        ),
      ),
    );
  }

  // widget lấy các topic phổ biến
  Widget _handleTopicPopular() {
    return Container(
      padding: const EdgeInsets.all(10),
      child: StreamBuilder<List<Topic>>(
        stream: __topicController.getAllTopicsPublic(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator(); // Loading indicator while data is loading
          }
          if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          }
          if (snapshot.data != null) {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  child: Row(
                    children: [
                      Expanded(
                        child: InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => VocabularyPage(vocabs: [],)),
                            );
                          },
                          child: Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: Color.fromARGB(255, 230, 228, 228)),
                            padding: EdgeInsets.only(
                                top: 10.0, right: 10, bottom: 10),
                            margin: EdgeInsets.symmetric(vertical: 8),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  children: [
                                    SizedBox(height: 10),
                                    Container(
                                      decoration: BoxDecoration(
                                        color: Colors.red,
                                        // Background color for the rectangle
                                        borderRadius: BorderRadius.circular(
                                            5), // Border radius of the rectangle
                                      ),
                                      padding: EdgeInsets.symmetric(
                                          vertical: 3,
                                          horizontal:
                                              25), // Padding for the rectangle
                                      child: Text(
                                        '${index + 1}',
                                        style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white),
                                      ),
                                    ),
                                    SizedBox(
                                      width: 50,
                                    ),
                                  ],
                                ),
                                Column(
                                  children: [
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Text(
                                      snapshot.data![index].title,
                                      style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  width: 150,
                                ),
                                // Add spacing between topic content and circle
                                // Circle showing percentage
                                Column(
                                  children: [
                                    Container(
                                      width: 50,
                                      height: 50,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color:
                                        Colors.green, // Change color as needed
                                      ),
                                      child: Center(
                                        child: Text(
                                          '20 từ', // Display percentage here
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
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
                                              leading: Icon(Icons.add),
                                              title: Text('Thêm vào chủ đề đang học'),
                                              onTap: () {
                                                setState(() {
                                                  topicSelected =  snapshot.data![index];
                                                  _handleAddIntoTopicLearning();
                                                });
                                              },
                                            ),
                                          ),
                                          PopupMenuItem(
                                            child: ListTile(
                                              leading: Icon(Icons.move_to_inbox),
                                              title: Text('Di chuyển đến thư mục của bạn'),
                                              onTap: () {
                                                setState(() {
                                                  idtopicselected = snapshot.data![index].id;
                                                });
                                                showDialog(
                                                  context: context,
                                                  builder: (BuildContext context) {
                                                    return AlertDialog(
                                                      title: Text('Chọn thư mục'),
                                                      content: SingleChildScrollView(
                                                        child: StreamBuilder<List<Folder>>(
                                                          stream: _folderController.getAllFoldersStream(),
                                                          builder: (context, snapshot) {
                                                            if (snapshot.connectionState ==
                                                                ConnectionState.waiting) {
                                                              return CircularProgressIndicator(); // Loading indicator while data is loading
                                                            }
                                                            if (snapshot.hasError) {
                                                              return Text('Error: ${snapshot.error}');
                                                            }
                                                            if (snapshot.hasData && snapshot.data != null) {
                                                              List<Folder> folders = snapshot.data!;
                                                              print(folders.length);

                                                              return Column(
                                                                mainAxisSize: MainAxisSize.min,
                                                                children: folders.map((folder) {
                                                                  return ListTile(
                                                                    title: Text(folder.name),
                                                                    onTap: () async {
                                                                      try {
                                                                        String folderId = folder.id ?? "-1";
                                                                        String topicId =
                                                                            idtopicselected ?? "-1";
                                                                        // Handle folder selection
                                                                        await _folderController
                                                                            .addTopicToFolder(
                                                                            folderId, topicId);
                                                                        ScaffoldMessenger.of(context)
                                                                            .showSnackBar(
                                                                          SnackBar(
                                                                            content: Text(
                                                                                'Thêm chủ đề này vào thư mục thành công!'),
                                                                          ),
                                                                        );
                                                                      } catch (error) {
                                                                        // Handle error
                                                                        ScaffoldMessenger.of(context)
                                                                            .showSnackBar(
                                                                          SnackBar(
                                                                            content:
                                                                            Text('Có lỗi xảy ra'),
                                                                          ),
                                                                        );
                                                                      }
                                                                    },
                                                                  );
                                                                }).toList(),
                                                              );
                                                            }
                                                            return Text('No data available');
                                                          },
                                                        ),
                                                      ),
                                                    );
                                                  },
                                                );
                                              },
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            );
          } else {
            return Text('No data available');
          }
        },
      ),
    );
  }

  // widget danh sách các topic của chính bạn
  Widget _handleMyTopic() {
    return Container(
      padding: const EdgeInsets.all(10),
      child: FutureBuilder<List<Topic>>(
        future: __topicController.getMyTopics(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator(); // Loading indicator while data is loading
          }
          if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          }
          if (snapshot.data != null) {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  child: Row(
                    children: [
                      Expanded(
                        child: InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => VocabularyPage(vocabs: [],)),
                            );
                          },
                          child: Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: Color.fromARGB(255, 230, 228, 228)),
                            padding: EdgeInsets.only(
                                top: 10.0, right: 10, bottom: 10),
                            margin: EdgeInsets.symmetric(vertical: 8),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  children: [
                                    SizedBox(height: 10),
                                    Container(
                                      decoration: BoxDecoration(
                                        color: Colors.red,
                                        // Background color for the rectangle
                                        borderRadius: BorderRadius.circular(
                                            5), // Border radius of the rectangle
                                      ),
                                      padding: EdgeInsets.symmetric(
                                          vertical: 3,
                                          horizontal:
                                          25), // Padding for the rectangle
                                      child: Text(
                                        '${index + 1}',
                                        style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white),
                                      ),
                                    ),
                                    SizedBox(
                                      width: 50,
                                    ),
                                  ],
                                ),
                                Column(
                                  children: [
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Text(
                                      snapshot.data![index].title,
                                      style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  width: 150,
                                ),
                                // Add spacing between topic content and circle
                                // Circle showing percentage
                                Column(
                                  children: [Container(
                                    width: 50,
                                    height: 50,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color:
                                      Colors.green, // Change color as needed
                                    ),
                                    child: Center(
                                      child: Text(
                                        '20 từ', // Display percentage here
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
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
                                              },
                                            ),
                                          ),
                                          PopupMenuItem(
                                            child: ListTile(
                                              leading: Icon(Icons.delete),
                                              title: Text('Xóa'),
                                              onTap: () {
                                                setState(() {
                                                  topicSelected = snapshot.data![index];
                                                  _handleDeleteTopics();
                                                });
                                              },
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),],
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            );
          } else {
            return Text('No data available');
          }
        },
      ),
    );
  }
  void _handleDeleteTopics() {
    // print(topicSelected);
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Xác nhận xóa thư mục"),
          content:
          Text("Bạn chắc chắn muốn xóa topic ${topicSelected!.title}?"),
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
                  await __topicController.deleteTopic(topicSelected!);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content:
                      Text("Topic ${topicSelected!.title} đã được xóa."),
                      duration:
                      Duration(seconds: 2), // Adjust duration as needed
                    ),
                  );

                  setState(() {
                  });
                  Navigator.of(context).pop(); // Close the AlertDialog
                } catch (e) {
                  print(e);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                          "Topic ${topicSelected!.title} xóa không thành công."),
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


  // widget cho dnah sách các topic đang theo học của người dùng
  Widget _handleTopicLearning(){
    return Container(
      padding: const EdgeInsets.all(10),
      child: FutureBuilder<List<Topic>>(
        future: _userController.getTopics(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator(); // Loading indicator while data is loading
          }
          if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          }
          if (snapshot.data != null) {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  child: Row(
                    children: [
                      Expanded(
                        child: InkWell(
                          onTap: () {
                            setState(() {
                              topicSelected = snapshot.data![index];
                              _getAllVocabs();
                            });
                          },
                          child: Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: Color.fromARGB(255, 230, 228, 228)),
                            padding: EdgeInsets.only(
                                top: 10.0, right: 10, bottom: 10),
                            margin: EdgeInsets.symmetric(vertical: 8),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  children: [
                                    SizedBox(height: 10),
                                    Container(
                                      decoration: BoxDecoration(
                                        color: Colors.red,
                                        // Background color for the rectangle
                                        borderRadius: BorderRadius.circular(
                                            5), // Border radius of the rectangle
                                      ),
                                      padding: EdgeInsets.symmetric(
                                          vertical: 3,
                                          horizontal:
                                          25), // Padding for the rectangle
                                      child: Text(
                                        '${index + 1}',
                                        style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white),
                                      ),
                                    ),
                                    SizedBox(
                                      width: 50,
                                    ),
                                  ],
                                ),
                                Column(
                                  children: [
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Text(
                                      snapshot.data![index].title,
                                      style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  width: 150,
                                ),
                                // Add spacing between topic content and circle
                                // Circle showing percentage
                                Column(
                                  children: [Container(
                                    width: 50,
                                    height: 50,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color:
                                      Colors.green, // Change color as needed
                                    ),
                                    child: Center(
                                      child: Text(
                                        '${snapshot.data![index].numberOfWord} từ', // Display percentage here
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
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
                                              leading: Icon(Icons.add),
                                              title: Text('Chưa được học'),
                                              onTap: () {
                                                setState(() {
                                                  topicSelected = snapshot.data![index];
                                                  status = "Not Learning";
                                                  _handleShowVocabs();
                                                });
                                              },
                                            ),
                                          ),
                                          PopupMenuItem(
                                            child: ListTile(
                                              leading: Icon(Icons.delete),
                                              title: Text('Đang được học'),
                                              onTap: () {
                                                setState(() {
                                                  topicSelected = snapshot.data![index];
                                                  status = "Learning";
                                                  _handleShowVocabs();
                                                });
                                              },
                                            ),
                                          ),
                                          PopupMenuItem(
                                            child: ListTile(
                                              leading: Icon(Icons.percent_sharp),
                                              title: Text('Đã thành thạo'),
                                              onTap: () {
                                                setState(() {
                                                  topicSelected = snapshot.data![index];
                                                  status = "Master";
                                                  _handleShowVocabs();
                                                });
                                              },
                                            ),
                                          ),
                                          PopupMenuItem(
                                            child: ListTile(
                                              leading: Icon(Icons.fmd_good),
                                              title: Text('Được đánh đấu sao'),
                                              onTap: () {

                                              },
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),],
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            );
          } else {
            return Text('No data available');
          }
        },
      ),
    );
  }


  // logic handle thêm topic vào danh sách các topics của người dùng đang học
  void _handleAddIntoTopicLearning() async {
    try{
      Topic topic = topicSelected!;
      await __topicController.addIntoMyTopics(topic);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content:
          Text("Tham gia thành công"),
          duration:
          Duration(seconds: 2), // Adjust duration as needed
        ),
      );

      setState(() {
      });
      Navigator.of(context).pop(); // Close the AlertDialog

    }catch(e){
      print(e);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
              "Tham giá không thành công"),
          duration:
          Duration(seconds: 2), // Adjust duration as needed
        ),
      );
    }
  }


  // logic filter từ vựng theo trạng thái
  void _handleShowVocabs()async{
    print("$status - ${topicSelected.toString()}");
    List<Flashcard>  vocabs =  await _userController.getVocabsByTopic(topicSelected!);


    // filter status
    vocabs =  vocabs.where((vocab) => vocab.status ==  status).toList();
    // print(vocabs.length);
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => VocabularyPage(vocabs: vocabs,)),
    );
  }


  // logic DANH SÁCH CÁC TỪ VỰNG CỦA TOPIC
  void _getAllVocabs()async{
    // print("$status - ${topicSelected.toString()}");
    List<Flashcard>  vocabs =  await _userController.getVocabsByTopic(topicSelected!);
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => VocabularyPage(vocabs: vocabs,)),
    );
  }
}
