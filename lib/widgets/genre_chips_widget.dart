import 'package:flutter/material.dart';
import '../models/book.dart';

class GenreChipsWidget extends StatelessWidget {
  final BookGenre? selectedGenre;
  final ValueChanged<BookGenre?> onGenreSelected;

  const GenreChipsWidget({
    super.key,
    required this.selectedGenre,
    required this.onGenreSelected,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: ChoiceChip(
              label: const Text('Բոլորը'),
              selected: selectedGenre == null,
              onSelected: (_) => onGenreSelected(null),
            ),
          ),
          ...BookGenre.values.map((genre) {
            return Padding(
              padding: const EdgeInsets.only(right: 8),
              child: ChoiceChip(
                label: Text(genre.label),
                selected: selectedGenre == genre,
                onSelected: (selected) {
                  onGenreSelected(selected ? genre : null);
                },
              ),
            );
          }),
        ],
      ),
    );
  }
}