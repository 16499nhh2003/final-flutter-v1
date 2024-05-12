import 'package:app/utils/user_data.dart';
import 'package:flutter/material.dart';
import 'package:string_validator/string_validator.dart';

class EditNameFormPage extends StatefulWidget {
  const EditNameFormPage({super.key});

  @override
  State<EditNameFormPage> createState() => _EditNameFormPageState();
}

class _EditNameFormPageState extends State<EditNameFormPage> {
  final _formKey = GlobalKey<FormState>();
  final firstNameController = TextEditingController();
  final secondNameController = TextEditingController();
  var user = UserData.myUser;
  @override
  void dispose() {
    // TODO: implement dispose
    firstNameController.dispose();
    secondNameController.dispose();
    super.dispose();
  }

  void updateUserValue(String name) {
    user.name = name;
  }

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
                "What's Your Name?",
                style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                    padding: EdgeInsets.fromLTRB(0, 40, 16, 0),
                    child: SizedBox(
                        height: 100,
                        width: 150,
                        child: TextFormField(
                          // Handles Form Validation for First Name
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your first name';
                            } else if (!isAlpha(value)) {
                              return 'Only Letters Please';
                            }
                            return null;
                          },
                          decoration: InputDecoration(labelText: 'First Name'),
                          controller: firstNameController,
                        ))),
                Padding(
                    padding: EdgeInsets.fromLTRB(0, 40, 16, 0),
                    child: SizedBox(
                        height: 100,
                        width: 150,
                        child: TextFormField(
                          // Handles Form Validation for Last Name
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your last name';
                            } else if (!isAlpha(value)) {
                              return 'Only Letters Please';
                            }
                            return null;
                          },
                          decoration:
                              const InputDecoration(labelText: 'Last Name'),
                          controller: secondNameController,
                        )))
              ],
            ),
            Padding(
                padding: EdgeInsets.only(top: 150),
                child: Align(
                    alignment: Alignment.bottomCenter,
                    child: SizedBox(
                      width: 330,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: () {
                          // Validate returns true if the form is valid, or false otherwise.
                          if (_formKey.currentState!.validate() &&
                              isAlpha(firstNameController.text +
                                  secondNameController.text)) {
                            updateUserValue(firstNameController.text +
                                " " +
                                secondNameController.text);
                            Navigator.pop(context);
                          }
                        },
                        child: const Text(
                          'Update',
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
