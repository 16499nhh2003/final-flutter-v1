import 'package:app/auth/auth_service.dart';
import 'package:app/pages/loginPage.dart';
import 'package:app/widgets/custom_app_bar.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  var _isHidePassword = true;
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();
  final _auth = AuthService();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: CustomAppBar(
          title: 'Đăng ký',
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
                "JOIN FOR FREE!",
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
              TextFormField(
                controller: confirmPasswordController,
                obscureText: _isHidePassword, // biến mật khẩu thành dấu *
                decoration: InputDecoration(
                  labelText: 'Xác nhận mật khẩu',
                  hintText: 'Xác nhận mật khẩu',
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
              GestureDetector(
                onTap: () => setState(() => _isHidePassword = !_isHidePassword),
                child: Row(
                  children: [
                    Icon(_isHidePassword
                        ? Icons.visibility_off
                        : Icons.visibility),
                    Text("  Hiện mật khẩu"),
                  ],
                ),
              ),
              _createSizedBox,
              SizedBox(
                width: double.infinity,
                height: 40,
                child: ElevatedButton(
                  onPressed: () {
                    _registerWithEmailAndPassword();
                  },
                  child: Text("ĐĂNG KÝ"),
                ),
              ),
              _createSizedBox,
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Đã có tài khoản? "),
                  GestureDetector(
                    onTap: () => Navigator.push(context,
                        MaterialPageRoute(builder: (context) => LoginPage())),
                    child: Text(
                      "Đăng nhập",
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

  //Regex email
  bool _isValidEmail(String email) {
    // Sử dụng regex để kiểm tra định dạng email
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    return emailRegex.hasMatch(email);
  }

  //show dialog khi mật khẩu không khớp
  void _showPasswordMismatchDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Mật khẩu không khớp"),
          content:
              Text("Vui lòng nhập lại mật khẩu và xác nhận mật khẩu đúng."),
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

  //show dialog khi email đã tồn tại
  void _showEmailExistsDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Email đã tồn tại"),
          content: Text(
              "Email này đã được đăng ký. Vui lòng sử dụng một email khác."),
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

  //show dialog khi mật khẩu ít hơn 6 kí tự
  void _showPasswordLengthDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Mật khẩu quá ngắn"),
          content: Text("Mật khẩu phải có ít nhất 5 kí tự"),
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

  //show dialog nếu email đã tồn tại
  void _showExistsEmailDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Email đã tồn tại"),
          content: Text("Email cung cấp đã tồn tại trong hệ thống"),
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

  //show dialog thông báo đăng kí thành công
  Future<void> _showSuccessDialog() async {
    showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        Future.delayed(Duration(seconds: 3), () {
          Navigator.of(context).pop(); // Close the dialog after 3 seconds
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => LoginPage()),
          );
        });

        return AlertDialog(
          title: Text("Đăng ký thành công"),
          content: Text("Tài khoản của bạn đã được tạo thành công."),
        );
      },
    );
  }

  Widget get _createSizedBox {
    return SizedBox(
      height: 10,
    );
  }

  void _registerWithEmailAndPassword() async {
    try {
      final email = emailController.text;
      final password = passwordController.text;
      final confirmPassword = confirmPasswordController.text;
      if (!_isValidEmail(email)) {
        _showInvalidEmailDialog();
        return;
      }
      if (password != confirmPassword) {
        _showPasswordMismatchDialog();
        return;
      } else if (password.length <= 5) {
        _showPasswordLengthDialog();
        return;
      } else {
        final user = await _auth.createUserWithEmailAndPassword(
            email, password, context);
        if (user != null) {
          _showSuccessDialog();
        } else {
          _showExistsEmailDialog();
        }
      }
    } catch (e) {
      print('Đăng ký thất bại: $e');
    }
  }
}
