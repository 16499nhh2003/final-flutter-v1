import 'package:app/models/flashcard_model.dart';
import 'package:app/widgets/custom_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flip_card/flip_card.dart';

import 'dart:async';

class FlashCardPage extends StatefulWidget {
  final List<Flashcard> vocabs;

  const FlashCardPage({Key? key, required this.vocabs}) : super(key: key);

  @override
  State<FlashCardPage> createState() => _FlashCardPageState();
}

class _FlashCardPageState extends State<FlashCardPage> {
  List<Flashcard> _flashcards = [];


  int _currentIndex = 0;
  Timer? _autoModeTimer;

  bool trangthai = true; //  0 : Anh-Viet  , 1: Viet-Anh
  bool chedodanhdasao = false; //  false : tat  , 1 : bat
  List<Flashcard> originalFlashcards = []; // lưu giá trị gốc

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    setState(() {
      _flashcards = widget.vocabs;
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose

    _autoModeTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // for (Flashcard f in  widget.vocabs){
    //   print(f.toJson());
    // }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        bottom: PreferredSize(
          preferredSize:
              Size.fromHeight(2), // Chiều cao mong muốn của thanh tiến trình
          child: LinearProgressIndicator(
            value: (_currentIndex + 1) / _flashcards.length,
            // Giá trị của tiến trình (từ 0 đến 1)
            backgroundColor: Colors.grey[300],
            // Màu nền của thanh tiến trình
            valueColor: AlwaysStoppedAnimation<Color>(
                Colors.red), // Màu của thanh tiến trình
          ),
        ),
        actions: [
          Align(
            alignment: Alignment.center,
            child: Text("${_currentIndex + 1}/${_flashcards.length}"),
          ),
          PopupMenuButton<String>(
            itemBuilder: (context) => [
              PopupMenuItem(
                  child: ListTile(
                    leading: Icon(Icons.auto_awesome),
                    title: Text("Chế độ tự động"),
                  ),
                  value: "Chế độ tự động",
                  onTap: () {
                    // TODO: Xử lý khi người dùng chọn chế độ tự động
                    if (_autoModeTimer != null && _autoModeTimer!.isActive) {
                      _autoModeTimer!.cancel();
                      // Show SnackBar to inform the user about disabling auto mode
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Chế độ tự động đã được tắt'),
                        ),
                      );
                    } else {
                      _autoModeTimer?.cancel();
                      _autoModeTimer =
                          Timer.periodic(Duration(seconds: 2), (timer) {
                        setState(() {
                          _currentIndex =
                              (_currentIndex + 1) % _flashcards.length;
                        });
                      });

                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Chế độ tự động đã được kích hoạt'),
                        ),
                      );
                    }
                    ;
                  }),
              PopupMenuItem(
                child: ListTile(
                  leading: Icon(Icons.shuffle),
                  title: Text("Trộn thứ tự từ"),
                ),
                value: "Trộn thứ tự từ",
                onTap: () {
                  // TODO: Xử lý khi người dùng chọn trộn thứ tự từ
                  setState(() {
                    _currentIndex = 0;
                    _flashcards.shuffle();
                  });
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Trộn từ thành công'),
                    ),
                  );
                },
              ),
              PopupMenuItem(
                child: ListTile(
                  leading: Icon(Icons.volume_up_rounded),
                  title: Text("Tự động phát âm thanh"),
                ),
                value: "Tự động phát âm thanh",
                onTap: () {
                  // TODO: Xử lý khi người dùng chọn tự động phát âm thanh
                },
              ),
              PopupMenuItem(
                child: ListTile(
                  leading: Icon(Icons.swap_calls),
                  title: Text("Đổi vị trí của 2 ngôn ngữ"),
                ),
                value: "Đổi vị trí của 2 ngôn ngữ",
                onTap: () {
                  // TODO: Xử lý khi người dùng chọn Đổi vị trí của 2 ngôn ngữ
                  setState(() {
                    trangthai = !trangthai;
                  });

                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Đổi vị trí của 2 ngôn ngữ thành công'),
                    ),
                  );
                },
              ),
              PopupMenuItem(
                child: ListTile(
                  leading: Icon(Icons.select_all),
                  title: Text("Học tất cả các từ trong chủ đề"),
                ),
                value: "Học tất cả các từ trong chủ đề",
                onTap: () {
                  // TODO: Xử lý khi người dùng chọn học hết
                  setState(() {
                    _flashcards = _flashcards;
                  });

                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Chọn học hết thành công'),
                    ),
                  );
                },
              ),
              PopupMenuItem(
                child: ListTile(
                  leading: Icon(Icons.star),
                  title: Text("Học các từ đánh dấu sao"),
                ),
                value: "Học các từ đánh dấu sao",
                onTap: () {
                  // TODO: Xử lý khi người dùng chọn học Học các từ đánh dấu sao
                  if (!chedodanhdasao) {
                    // Switch to learning only starred words mode
                    List<Flashcard> starredFlashcards =
                        _flashcards.where((vocab) => vocab.isStarred).toList();
                    setState(() {
                      originalFlashcards =  _flashcards;
                      _flashcards = starredFlashcards;
                      chedodanhdasao = true; // Set the mode flag to true
                    });

                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content:
                            Text('Chế độ học các từ đánh dấu sao thành công'),
                      ),
                    );
                  } else {
                    // Switch back to learning all words mode
                    setState(() {
                      _flashcards = originalFlashcards;
                      chedodanhdasao = false; // Set the mode flag to false
                    });

                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content:
                            Text('Chế độ học các từ đánh dấu sao đã được tắt'),
                      ),
                    );
                  }
                },
              ),
            ],
            // Khi người dùng select 1 option bất kỳ trên PopupMenu
            onSelected: (option) {
              print('Người dùng đã chọn: $option');
            },
            icon: Icon(Icons.settings_outlined), // Icon đại diện cho PopupMenu
          )
        ],
      ),
      body: Center(
        child: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/transient.jpg"),
              fit: BoxFit.cover,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: 350,
                height: 350,
                child: FlipCard(
                  direction: FlipDirection.HORIZONTAL,
                  front: trangthai == true
                      ? english(_flashcards[_currentIndex])
                      : vietnam(_flashcards[_currentIndex]),
                  back: trangthai != true
                      ? english(_flashcards[_currentIndex])
                      : vietnam(_flashcards[_currentIndex]),
                ),
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  ElevatedButton.icon(
                    onPressed: showPreviousCard,
                    icon: Icon(Icons.chevron_left),
                    label: Text('Prev'),
                  ),
                  ElevatedButton.icon(
                    onPressed: showNextCard,
                    icon: Icon(Icons.chevron_right),
                    label: Text('Next'),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  // widget viet
  Widget vietnam(Flashcard flashcard) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.blueGrey,
        borderRadius: BorderRadius.circular(8),
      ),
      padding: EdgeInsets.all(16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Nghĩa tiếng anh: ${flashcard.englishWord}',
            style: TextStyle(
              fontSize: 24,
              color: Colors.white,
            ),
          ),
          SizedBox(height: 10),
          Text(
            'Phiên âm: ${flashcard.phonetic}',
            style: TextStyle(
              fontSize: 18,
              color: Colors.white,
            ),
          ),
          SizedBox(height: 10),
          Text(
            'Loại từ: ${flashcard.wordType}',
            style: TextStyle(
              fontSize: 18,
              color: Colors.white,
            ),
          ),
          SizedBox(height: 10),
          Text(
            'Nghĩa tiếng việt: ${flashcard.vietnameseWord}',
            style: TextStyle(
              fontSize: 18,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  // widget english
  Widget english(Flashcard flashcard) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.blueGrey,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "${_flashcards[_currentIndex].englishWord}"
            "(${_flashcards[_currentIndex].wordType == "Động từ" ? "Verb" : _flashcards[_currentIndex].wordType == "Danh từ" ? "Noun" : _flashcards[_currentIndex].wordType == "Tính từ" ? "Noun" : "Not Known"})",
            style: TextStyle(
              fontSize: 24,
              color: Colors.black,
            ),
          ),
          SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                _flashcards[_currentIndex].phonetic,
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.black,
                ),
              ),
              IconButton(
                icon: Icon(Icons.volume_up),
                onPressed: () {
                  // Xử lý sự kiện khi người dùng nhấn vào biểu tượng loa
                },
              ),
            ],
          ),
          SizedBox(height: 10),
          Image.network(
            _flashcards[_currentIndex].imageUrl,
            width: 200,
            height: 200,
            fit: BoxFit.cover,
          ),
        ],
      ),
    );
  }

  void showNextCard() {
    setState(() {
      _currentIndex = (_currentIndex + 1) % _flashcards.length;
    });
  }

  void showPreviousCard() {
    setState(() {
      _currentIndex = (_currentIndex - 1) % _flashcards.length;
    });
  }
}
