import 'dart:io';

import 'package:app/models/flashcard_model.dart';
import 'package:app/pages/StarredPage.dart';
import 'package:app/pages/quiz/quizPage.dart';
import 'package:app/pages/typingPage.dart';
import 'package:app/widgets/custom_app_bar.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:app/pages/flashcardPage.dart';
import 'dart:convert';
import 'package:csv/csv.dart' as csv;
import 'package:flutter/services.dart' show rootBundle;
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';

// TODO: danh sách các vocab phải được truyền từ topic qua (file utils)
// TODO: appbar vocab là name của topic được chọn

class VocabularyPage extends StatefulWidget {
  List<Flashcard> vocabs;
  VocabularyPage({Key? key, required this.vocabs}) : super(key: key);

  @override
  State<VocabularyPage> createState() => _VocabularyPageState();
}

class _VocabularyPageState extends State<VocabularyPage> {
  List<bool> _starredStates = [];

  Future<List<Flashcard>> _loadFlashcardsFromCsv(String csvPath) async {
    // Read the CSV file from assets
    String csvString = await DefaultAssetBundle.of(context).loadString(csvPath);
    // Parse the CSV string
    List<List<dynamic>> csvData = csv.CsvToListConverter().convert(csvString);

    // Convert CSV data to Flashcard objects
    List<Flashcard> flashcards = [];
    for (var row in csvData) {
      if (row.length >= 6) {
        Flashcard flashcard = Flashcard(
          englishWord: row[0] as String,
          phonetic: row[1] as String,
          wordType: row[2] as String,
          imageUrl: row[3] as String,
          vietnameseWord: row[4] as String,
          meaning: row[5] as String,
        );
        flashcards.add(flashcard);
      } else {
        // Handle incomplete data in the CSV row
        print('Incomplete data in CSV row: $row');
      }
    }
    for (Flashcard c in flashcards) {
      print(c.vietnameseWord);
    }
    return flashcards;
  }

  @override
  void initState() {
    super.initState();

    _loadFlashcardsFromCsv('assets/flashcards.csv').then((flashcards) {
      setState(() {
        _flashcards = flashcards;
        _starredStates = List.filled(_flashcards.length, false);
      });
    });
  }

  List<Flashcard> _flashcards = [];

  // [post] nhập thông tin file csv
  Future<void> _importCsv() async {
    try {
      // Request permission to access external storage
      var status = await Permission.storage.request();
      if (status.isGranted) {
        // Open a file picker dialog to select CSV file
        FilePickerResult? result = await FilePicker.platform.pickFiles(
          type: FileType.custom,
          allowedExtensions: ['csv'],
        );

        // Check if a file was picked
        if (result == null || result.files.isEmpty) return;

        // Get the path of the picked file
        String csvPath = result.files.single.path!;

        // Read the CSV file with UTF-8 encoding
        String csvString = await File(csvPath).readAsString(encoding: utf8);

        // Parse the CSV string
        List<List<dynamic>> csvData =
            csv.CsvToListConverter().convert(csvString);

        // Convert CSV data to Flashcard objects
        List<Flashcard> newFlashcards = [];
        for (var row in csvData) {
          Flashcard flashcard = Flashcard(
            englishWord: row[0] as String,
            phonetic: row[1] as String,
            wordType: row[2] as String,
            imageUrl: row[3] as String,
            vietnameseWord: row[4] as String,
            meaning: row[5] as String,
          );
          newFlashcards.add(flashcard);
        }

        // Update state with new flashcards
        setState(() {
          _flashcards.addAll(newFlashcards);
          _starredStates.addAll(List.filled(newFlashcards.length, false));
        });

        // Show a success message
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('CSV file imported successfully!'),
          duration: Duration(seconds: 3),
        ));
      } else {
        // Permission denied
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Permission to accress stoage denied!'),
          duration: Duration(seconds: 3),
        ));
      }
    } catch (e) {
      // Show an error message if import fails
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Failed to import CSV file!'),
        duration: Duration(seconds: 3),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Từ vụng của bạn'),
        actions: [
          IconButton(
            icon: Icon(Icons.gamepad),
            onPressed: () {
              showModalBottomSheet(
                  context: context,
                  builder: (BuildContext context) {
                    return Container(
                      padding: EdgeInsets.all(20.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          ListTile(
                            title: Text('Học từ vựng bằng trắc nghiệm'),
                            onTap: () {
                              // Navigate to QuizPage for Option 1
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => QuizPage()),
                              );
                            },
                          ),
                          ListTile(
                            title: Text('Học từ vựng bằng gõ từ'),
                            onTap: () {
                              // Navigate to QuizPage for Option 2
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => Typing()),
                              );
                            },
                          ),
                          ListTile(
                            title: Text('Danh sách các từ đánh dấu sao'),
                            onTap: () {
                              // Navigate to StarredPage
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => StarredPage(
                                    flashcards: _flashcards,
                                    starredStates: _starredStates,
                                  ),
                                ),
                              );
                            },
                          ),
                          ListTile(
                            title: Text('Tạo mới từ vựng bằng file CSV'),
                            onTap: _importCsv,
                          ),
                        ],
                      ),
                    );
                  });
            },
          ),
        ],
      ),
      body: Container(
        padding: const EdgeInsets.all(10),
        child: ListView.builder(
          itemCount: widget.vocabs.length,
          itemBuilder: (BuildContext context, int index) {
            final Flashcard flashcard = widget.vocabs[index];
            print(flashcard.toJson());
            return ListTile(
              leading: IconButton(
                onPressed: () {},
                icon: Icon(
                  Icons.volume_up_sharp,
                  color: Colors.purple,
                  size: 30,
                ),
              ),
              title: Text(
                flashcard.englishWord,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              subtitle: Text(
                flashcard.phonetic,
                style: TextStyle(
                  color: Colors.green,
                ),
              ),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    onPressed: () {
                      setState(() {
                        // Toggle the starred state of the corresponding flashcard
                        // _starredStates[index] = !_starredStates[index];
                        //handle update here
                      });
                    },
                    icon: Icon(Icons.star, size: 30, color:
                      flashcard.isStarred == true ? Colors.yellow : Colors.grey,
                        ),
                  ),
                  IconButton(
                    onPressed: () {},
                    icon: Icon(
                      Icons.info,
                      color: Colors.orange,
                      size: 30,
                    ),
                  ),
                ],
              ),
              contentPadding: EdgeInsets.all(5),
              onTap: () {
                // chuyển sang trang flashcard của từ đó
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (ctx) => FlashCardPage(vocabs: widget.vocabs,)),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
