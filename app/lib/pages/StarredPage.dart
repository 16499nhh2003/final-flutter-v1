import 'package:flutter/material.dart';
import 'package:app/models/flashcard_model.dart';

class StarredPage extends StatelessWidget {
  final List<Flashcard> flashcards;
  final List<bool> starredStates;

  const StarredPage({
    required this.flashcards,
    required this.starredStates,
  });

  @override
  Widget build(BuildContext context) {
    // Retrieve starred flashcards
    List<Flashcard> starredFlashcards = [];
    for (int i = 0; i < flashcards.length; i++) {
      if (starredStates[i]) {
        starredFlashcards.add(flashcards[i]);
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Starred Flashcards'),
      ),
      body: ListView.builder(
        itemCount: starredFlashcards.length,
        itemBuilder: (BuildContext context, int index) {
          final flashcard = starredFlashcards[index];
          return ListTile(
            title: Text(flashcard.englishWord),
            subtitle: Text(flashcard.vietnameseWord),
            leading: Icon(Icons.star, color: Colors.yellow),
            onTap: () {
              // Navigate to flashcard details page or do something else
            },
          );
        },
      ),
    );
  }
}
