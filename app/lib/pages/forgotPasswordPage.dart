import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/services.dart';

class ForgotPassword extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Forgot Password'),
      ),
      body: SingleChildScrollView(
        reverse: true,
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            FutureBuilder<Uint8List>(
              future: _loadGif(), // Future để load ảnh GIF
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  if (snapshot.hasData && snapshot.data != null) {
                    return Image.memory(snapshot.data!); // Hiển thị ảnh GIF
                  } else {
                    return Text('Error loading GIF');
                  }
                } else {
                  return CircularProgressIndicator();
                }
              },
            ),
            Center(
              child: Text(
                'Forgot Password',
                style: TextStyle(fontSize: 32.0, color: Colors.blue),
              ),
            ),
            SizedBox(height: 20.0),
            TextField(
              decoration: InputDecoration(
                // labelText: 'Email',
                hintText: 'Enter your email',
                prefixIcon: Icon(Icons.email),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
              keyboardType: TextInputType.emailAddress,
            ),
            SizedBox(height: 20.0),
            SizedBox(
              width: double.infinity,
              height: 40,
              child: ElevatedButton(
                onPressed: () {},
                child: Text("Send OTP"),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<Uint8List> _loadGif() async {
    // Load ảnh GIF từ asset bằng rootBundle
    final ByteData data = await rootBundle.load('assets/forget-password.gif');
    return data.buffer.asUint8List();
  }
}
