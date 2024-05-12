import 'package:flutter/material.dart';

class FlashcardView extends StatelessWidget {
  final String text;

  FlashcardView({required this.text});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      child: Center(
        child: Text(
          text,
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
