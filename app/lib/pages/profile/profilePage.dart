import 'dart:async';

import 'package:app/pages/profile/edit_email.dart';
import 'package:app/pages/profile/edit_image.dart';
import 'package:app/pages/profile/edit_name.dart';
import 'package:app/pages/profile/edit_phone.dart';
import 'package:app/utils/user_data.dart';
import 'package:app/widgets/display_image_widget.dart';
import 'package:flutter/material.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final user = UserData.myUser;

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Column(
        children: [
          Center(
            child: Padding(
              padding: EdgeInsets.only(bottom: 20),
              child: Text(
                'Cập nhật thông tin',
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.w700,
                  color: Color.fromRGBO(64, 105, 225, 1),
                ),
              ),
            ),
          ),
          InkWell(
            onTap: () {
              navigateSecondPage(new EditImagePage());
            },
            child: DisplayImage(
              imagePath: user.image,
              onPressed: () {},
            ),
          ),
          buildUserInfoDisplay(user.name, 'Name', EditNameFormPage()),
          buildUserInfoDisplay(user.phone, 'Phone', EditPhonePage()),
          buildUserInfoDisplay(user.email, 'Email', EditEmailPage()),
        ],
      ),
    );
  }

  Widget buildUserInfoDisplay(String getValue, String title, Widget editPage) =>
      Padding(
          padding: EdgeInsets.only(bottom: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey,
                ),
              ),
              SizedBox(
                height: 1,
              ),
              Container(
                width: 350,
                height: 40,
                decoration: BoxDecoration(
                    border: Border(
                        bottom: BorderSide(
                  color: Colors.grey,
                  width: 1,
                ))),
                child: Row(
                  children: [
                    Expanded(
                      child: TextButton(
                        onPressed: () {
                          navigateSecondPage(editPage);
                        },
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            getValue,
                            style: TextStyle(fontSize: 16, height: 1.4),
                          ),
                        ),
                      ),
                    ),
                    Icon(
                      Icons.keyboard_arrow_right,
                      color: Colors.grey,
                      size: 40.0,
                    )
                  ],
                ),
              )
            ],
          ));

  FutureOr onGoBack(dynamic value) {
    setState(() {});
  }

  void navigateSecondPage(Widget editForm) {
    Route route = MaterialPageRoute(builder: (context) => editForm);
    Navigator.push(context, route).then(onGoBack);
  }
}
