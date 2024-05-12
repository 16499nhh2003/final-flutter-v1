import 'dart:math';

import 'package:app/controllers/folder_controller.dart';
import 'package:app/controllers/topic_controller.dart';
import 'package:app/pages/quiz/quizPage.dart';
import 'package:app/pages/vocabularyPage.dart';
import 'package:flutter/material.dart';
import 'package:app/models/folder_model.dart'; // Import folder model
import 'package:app/models/topic_model.dart'; // Import topic model
import 'package:app/utils/topic_utils.dart'; // Import topic utils
import 'package:app/widgets/custom_app_bar.dart';
import 'package:get/get.dart';

class TopicListPage extends StatefulWidget {
  final Folder folder;

  const TopicListPage({required this.folder});

  @override
  State<TopicListPage> createState() => _TopicListPageState();
}

class _TopicListPageState extends State<TopicListPage> {
  List<Topic> topics = [];
  late TextEditingController _topicController;
  final _formKey = GlobalKey<FormState>();
  late FocusNode _focusNode;

  // controller
  final TopicController __topicController = Get.put(TopicController());
  final FolderController _folderController = Get.put(FolderController());
  Topic? topicSelected;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _topicController = TextEditingController();
    _focusNode = FocusNode();
    _focusNode.requestFocus();

    _fetchTopicsByFolder();
  }

  Future<void> _fetchTopicsByFolder() async {
    try {
      Folder folder = widget.folder;
      List<Topic> response = await __topicController.getTopicsByFolder(folder);
      setState(() {
        topics = response;
      });
    } catch (error) {
      // Handle error
      print("Error fetching topics: $error");
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _topicController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.folder.name),
        actions: [],
      ),
      body: Container(
        padding: const EdgeInsets.all(10),
        child: ListView.builder(
          itemBuilder: (context, index) {
            final random = Random();
            final percentage = random.nextInt(101);

            return Row(
              children: [
                // Sequential number
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
                      padding:
                          EdgeInsets.only(top: 10.0, right: 10, bottom: 10),
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
                                topics[index].title,
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
                          ), // Add spacing between topic content and circle
                          // Circle showing percentage
                          Column(
                            // mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Container(
                                width: 50,
                                height: 50,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.green, // Change color as needed
                                ),
                                child: Center(
                                  child: Text(
                                    '$percentage%', // Display percentage here
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                              IconButton(
                                icon: Icon(
                                  Icons.delete,
                                  color: Colors.red,
                                ),
                                onPressed: () {
                                  setState(() {
                                    topicSelected = topics[index];
                                    _handleRemoveTopic();
                                  });
                                },
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
          itemCount: topics.length,
        ),
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
                          //     title: _topicController.text,
                          //     // folder: Folder(
                          //     //     name: "Basic English",
                          //     //     iconData: Icons.school),
                          //   ));
                          //
                          //   // clear input
                          //   _topicController.clear();
                          //   _focusNode.requestFocus();
                          // });
                          //
                          // // Show snackbar alert them thanh cong
                          // ScaffoldMessenger.of(context).showSnackBar(
                          //   SnackBar(
                          //     content: Text('Đã thêm topic thành công'),
                          //   ),
                          // );
                        }
                      },
                      child: Text('Thêm'),
                    ),
                  ],
                );
              });
        },
      ),
    );
  }

  void _handleRemoveTopic() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Xác nhận xóa topic khỏi folder"),
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
                  await _folderController.deleteTopicFromFolder(
                      widget.folder.id!, topicSelected!.id!);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content:
                          Text("Topic ${topicSelected!.title} đã được xóa."),
                      duration:
                          Duration(seconds: 2), // Adjust duration as needed
                    ),
                  );
                  List<Topic> response = await __topicController.getTopicsByFolder(widget.folder);
                  setState(() {
                    topics = response;
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
}
