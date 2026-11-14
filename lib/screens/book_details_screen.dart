import 'package:flutter/material.dart';
import '../models/book.dart';
import '../widgets/star_rating_widget.dart';

class BookDetailsScreen extends StatefulWidget {
  final Book book;

  const BookDetailsScreen({super.key, required this.book});

  @override
  State<BookDetailsScreen> createState() => _BookDetailsScreenState();
}

class _BookDetailsScreenState extends State<BookDetailsScreen> {
  late int _currentRating;

  @override
  void initState() {
    super.initState();
    _currentRating = widget.book.rating; 
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.book.title),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.book.title,
              style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              'Հեղինակ՝ ${widget.book.author}',
              style: const TextStyle(fontSize: 18, color: Colors.black87),
            ),
            const SizedBox(height: 4),
            Text(
              'Ժանր՝ ${widget.book.genre.label}',
              style: TextStyle(fontSize: 16, color: Colors.grey[700]), // Շտկված գույն
            ),
            const SizedBox(height: 32),
            const Text(
              'Գնահատեք գիրքը (1–5 աստղ)․',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 12),
            Center(
              child: StarRatingWidget(
                rating: _currentRating,
                size: 40,
                onRatingChanged: (newRating) {
                  setState(() {
                    _currentRating = newRating;
                  });
                },
              ),
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: FilledButton(
                onPressed: _currentRating == 0
                    ? null 
                    : () {
                        Navigator.pop(context, _currentRating);
                      },
                child: const Text(
                  'Պահպանել',
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}