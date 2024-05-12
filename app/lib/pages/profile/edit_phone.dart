import 'package:flutter/material.dart';
import 'package:string_validator/string_validator.dart';

class EditPhonePage extends StatefulWidget {
  const EditPhonePage({super.key});

  @override
  State<EditPhonePage> createState() => _EditPhonePageState();
}

class _EditPhonePageState extends State<EditPhonePage> {
  final _formKey = GlobalKey<FormState>();
  final phoneController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(children: [
            SizedBox(
              width: 330,
              child: const Text(
                "What's Your Phone Number?",
                style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: EdgeInsets.fromLTRB(0, 40, 16, 0),
                    child: SizedBox(
                      height: 100,
                      child: TextFormField(
                        keyboardType: TextInputType.phone,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Vui lòng nhập số điện thoại!';
                          } else if (!isNumeric(value)) {
                            return 'Chỉ nhập số';
                          }
                          return null;
                        },
                        decoration: InputDecoration(labelText: 'Số điện thoại'),
                        controller: phoneController,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
                padding: EdgeInsets.only(top: 10),
                child: Align(
                    alignment: Alignment.bottomCenter,
                    child: SizedBox(
                      width: 330,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: () {},
                        child: const Text(
                          'Cập nhật số điện thoại',
                          style: TextStyle(fontSize: 15),
                        ),
                      ),
                    )))
          ]),
        ),
      ),
    );
  }
}
