import 'package:app/models/topic_model.dart';
import 'package:app/pages/flashcardPage.dart';
import 'package:app/pages/folderPage.dart';
import 'package:app/pages/loginPage.dart';
import 'package:app/pages/onboardingPage1.dart';
import 'package:app/pages/profile/profilePage.dart';
import 'package:app/pages/quiz/quizPage.dart';
import 'package:app/pages/settingPage2.dart';
import 'package:app/pages/topicPage.dart';
import 'package:app/pages/topicPopularPage.dart';
import 'package:app/pages/vocabularyPage.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';

import 'package:app/widgets/custom_alert_dialog.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: false,
      ),
      home:  OnboardingPage1(), // chạy loginPage đầu tiên khi app khởi động
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _GoogleBottomBarState();
}

class _GoogleBottomBarState extends State<MyHomePage> {
  int _selectedIndex = 0;
  static List<Widget> _widgetOptions = <Widget>[
    FolderPage(),
    TopicPopularPage(),
    SettingsPage2()
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: SalomonBottomBar(
          currentIndex: _selectedIndex,
          selectedItemColor: const Color(0xff6200ee),
          unselectedItemColor: const Color(0xff757575),
          onTap: (index) {
            if (index < _widgetOptions.length) {
              setState(() {
                _selectedIndex = index;
              });
            } else {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return CustomAlertDialog(
                    title: 'Warning',
                    content: 'This page is not available yet.',
                    onOkPressed: () {
                    },
                  );
                },
              );
            }
          },
          items: _navBarItems),
    );
  }
}

final _navBarItems = [
  SalomonBottomBarItem(
    icon: Icon(Icons.folder),
    title: const Text("Folder"),
    selectedColor: Colors.purple,
  ),
  SalomonBottomBarItem(
    icon: const Icon(Icons.topic),
    title: const Text("Topic"),
    selectedColor: Colors.teal,
  ),
  SalomonBottomBarItem(
    icon: Icon(Icons.settings),
    title: const Text("Settings"),
    selectedColor: Colors.orange,
  ),
  SalomonBottomBarItem(
    icon: const Icon(Icons.person),
    title: const Text("Profile"),
    selectedColor: Colors.teal,
  ),
];
