import 'package:flutter/material.dart';
import '../models/book.dart';

class BookCard extends StatelessWidget {
  final Book book;
  final VoidCallback? onTap;
  const BookCard({super.key, required this.book, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(book.title,
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 6),
            Text('${book.author} • ${book.createdAt ?? ''}',
                style: const TextStyle(color: Colors.grey)),
            const SizedBox(height: 8),
            Text(book.description.length > 120
                ? '${book.description.substring(0, 120)}...'
                : book.description),
          ]),
        ),
      ),
    );
  }
}
