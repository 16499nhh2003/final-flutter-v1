import 'package:flutter/material.dart';

class ViewProfilePage extends StatefulWidget {
  ViewProfilePage();

  @override
  _ViewProfileState createState() => _ViewProfileState();
}

class _ViewProfileState extends State<ViewProfilePage> {
  String _username = 'John Doe';
  String _bio = 'This is a sample bio.';
  String _profileImageUrl = 'https://example.com/profile_image.jpg';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Center(
              child: CircleAvatar(
                radius: 80,
                backgroundImage: NetworkImage(_profileImageUrl),
              ),
            ),
            SizedBox(height: 20),
            Text(
              _username,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10),
            Text(
              _bio,
              style: TextStyle(
                fontSize: 18,
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {},
              child: Text('Edit Profile'),
            ),
          ],
        ),
      ),
    );
  }
}
