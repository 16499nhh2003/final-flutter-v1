import 'package:app/auth/auth_service.dart';
import 'package:app/main.dart';
import 'package:app/pages/registerPage.dart';
import 'package:app/widgets/custom_app_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  var _isHidePassword = true;
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final _auth = AuthService();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: CustomAppBar(
          title: 'Đăng nhập',
        ),
        body: Container(
          padding: const EdgeInsets.all(10),
          child: Column(
            children: [
              Image.asset(
                "assets/icon.png",
                scale: 5,
              ),
              _createSizedBox,
              Text(
                "HI THERE!",
                style: TextStyle(
                  fontFamily: "Coopbl",
                  fontSize: 50,
                  color: Colors.blue,
                ),
              ),
              _createSizedBox,
              TextFormField(
                controller: emailController,
                decoration: InputDecoration(
                  labelText: 'Email',
                  hintText: 'Email',
                  prefixIcon: Icon(Icons.email),
                  border: OutlineInputBorder(),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.blue, width: 2.0),
                  ),
                ),
              ),
              _createSizedBox,
              TextFormField(
                controller: passwordController,
                obscureText: _isHidePassword, // biến mật khẩu thành dấu *
                decoration: InputDecoration(
                  labelText: 'Mật khẩu',
                  hintText: 'Mật khẩu',
                  prefixIcon: Icon(Icons.lock),
                  border: OutlineInputBorder(),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.blue,
                      width: 2.0,
                    ),
                  ),
                ),
              ),
              _createSizedBox,
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () =>
                        setState(() => _isHidePassword = !_isHidePassword),
                    child: Row(
                      children: [
                        Icon(_isHidePassword
                            ? Icons.visibility_off
                            : Icons.visibility),
                        Text("  Hiện mật khẩu"),
                      ],
                    ),
                  ),
                  Text(
                    "Quên mật khẩu",
                    style: TextStyle(
                      color: Colors.blue,
                    ),
                  )
                ],
              ),
              _createSizedBox,
              SizedBox(
                width: double.infinity,
                height: 40,
                child: ElevatedButton(
                  onPressed: _login,
                  child: Text("ĐĂNG NHẬP"),
                ),
              ),
              _createSizedBox,
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Chưa có tài khoản? "),
                  GestureDetector(
                    onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => RegisterPage())),
                    child: Text(
                      "Đăng ký",
                      style: TextStyle(
                        color: Colors.blue,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      theme: ThemeData(
        useMaterial3: false,
      ),
    );
  }

  void _login() async {
    String email = emailController.text.trim();
    String password = passwordController.text.trim();
    if (!_isValidEmail(email)) {
      _showInvalidEmailDialog();
    }
    User? user = await _auth.loginUserWithEmailAndPassword(email, password);
    if (user != null) {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => MyHomePage()));
    } else {
      _showErrorDialog();
    }
  }

  //Regex email
  bool _isValidEmail(String email) {
    // Sử dụng regex để kiểm tra định dạng email
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    return emailRegex.hasMatch(email);
  }

//show dialog nếu email không đunhs định dạng
  void _showInvalidEmailDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Email không hợp lệ"),
          content: Text("Vui lòng nhập một địa chỉ email hợp lệ."),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text("Đóng"),
            ),
          ],
        );
      },
    );
  }

//show dialog nếu tài khoản không tồn tại
  void _showErrorDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Xảy ra lỗi khi đăng nhập"),
          content: Text("Vui lòng kiểm tra lại tài khoản hoặc mật khẩu"),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text("Đóng"),
            ),
          ],
        );
      },
    );
  }

  Widget get _createSizedBox {
    return SizedBox(
      height: 10,
    );
  }
}
