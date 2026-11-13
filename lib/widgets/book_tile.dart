import 'package:flutter/material.dart';
import '../models/book.dart';

class BookTile extends StatelessWidget {
  final Book book;
  final ValueChanged<bool?> onChanged;
  final VoidCallback onTap;

  const BookTile({
    super.key,
    required this.book,
    required this.onChanged,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      leading: Checkbox(
        value: book.isRead,
        onChanged: onChanged,
      ),
      title: Text(
        book.title,
        style: TextStyle(
          decoration: book.isRead ? TextDecoration.lineThrough : null,
          color: book.isRead ? Colors.grey : null,
          fontWeight: FontWeight.w600,
        ),
      ),
      subtitle: Text('${book.author} • ${book.genre.label}'),
      trailing: book.rating > 0
          ? Row(
              mainAxisSize: MainAxisSize.min,
              children: List.generate(
                book.rating,
                (_) => const Icon(Icons.star, color: Colors.amber, size: 18),
              ),
            )
          : const Icon(Icons.chevron_right),
    );
  }
}