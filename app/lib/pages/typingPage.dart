import 'package:app/widgets/custom_app_bar.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(Typing());
}

class Typing extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Gõ Từ',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: GoTuScreen(),
    );
  }
}

class GoTuScreen extends StatefulWidget {
  @override
  _GoTuScreenState createState() => _GoTuScreenState();
}

class _GoTuScreenState extends State<GoTuScreen> {
  // Danh sách từ vựng
  final List<Map<String, String>> tuVung = [
    {'english': 'hello', 'vietnamese': 'xin chào'},
    {'english': 'apple', 'vietnamese': 'quả táo'},
    {'english': 'car', 'vietnamese': 'xe hơi'},
    // Thêm các từ vựng khác vào đây
  ];

  String currentWord = '';
  String currentTranslation = '';
  TextEditingController textEditingController = TextEditingController();
  bool showVietnamese = true; // Hiển thị Tiếng Việt hoặc Tiếng Anh

  @override
  void initState() {
    super.initState();
    _loadNextWord();
  }

  // Hàm này được gọi khi chuyển từ Tiếng Anh sang Tiếng Việt hoặc ngược lại
  void _loadNextWord() {
    final randomIndex = DateTime.now().microsecondsSinceEpoch % tuVung.length;
    final word = tuVung[randomIndex];
    setState(() {
      currentWord = showVietnamese ? word['vietnamese']! : word['english']!;
      currentTranslation =
          showVietnamese ? word['english']! : word['vietnamese']!;
    });
    textEditingController.clear();
  }

  // Hàm này kiểm tra xem câu trả lời có đúng không
  bool _checkAnswer(String answer) {
    return answer.trim().toLowerCase() == currentTranslation.toLowerCase();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Gõ từ',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 20.0,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.blue,
        elevation: 0,
        centerTitle: true,
        toolbarOpacity: 1.0, // Đặt độ trong suốt của app bar
        leading: IconButton(
          // Thêm leading widget cho app bar dựa trên vị trí
          icon: Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              showVietnamese ? 'Tiếng Việt' : 'Tiếng Anh',
              style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20.0),
            Text(
              currentWord,
              style: TextStyle(fontSize: 24.0),
            ),
            SizedBox(height: 20.0),
            TextField(
              controller: textEditingController,
              decoration: InputDecoration(
                hintText:
                    showVietnamese ? 'Nhập Tiếng Anh' : 'Enter Vietnamese',
                border: OutlineInputBorder(),
              ),
              textAlign: TextAlign.center,
              onSubmitted: (value) {
                if (_checkAnswer(value)) {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text('Chúc mừng!'),
                        content: Text('Đúng rồi!'),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                              _loadNextWord();
                            },
                            child: Text('Tiếp tục'),
                          ),
                        ],
                      );
                    },
                  );
                } else {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text('Sai rồi!'),
                        content: Text('Hãy thử lại.'),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.of(context).pop(),
                            child: Text('OK'),
                          ),
                        ],
                      );
                    },
                  );
                }
              },
            ),
            SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  showVietnamese = !showVietnamese;
                });
                _loadNextWord();
              },
              child: Text(showVietnamese
                  ? 'Chuyển sang Tiếng Anh'
                  : 'Switch to Vietnamese'),
            ),
          ],
        ),
      ),
    );
  }
}
