import 'package:flutter/material.dart';
import '../models/book.dart';
import '../services/api_service.dart';
import 'create_edit_book_screen.dart';

class DetailBookScreen extends StatelessWidget {
  final Book book;
  const DetailBookScreen({super.key, required this.book});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail Book'),
        actions: [
          IconButton(
              icon: const Icon(Icons.edit),
              onPressed: () async {
                final r = await Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => CreateEditBookScreen(editBook: book)));
                if (r == true) Navigator.pop(context, true);
              }),
          IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () async {
                final confirm = await showDialog<bool>(
                    context: context,
                    builder: (_) =>
                        AlertDialog(title: const Text('Hapus?'), actions: [
                          TextButton(
                              onPressed: () => Navigator.pop(context, false),
                              child: const Text('Batal')),
                          TextButton(
                              onPressed: () => Navigator.pop(context, true),
                              child: const Text('Hapus'))
                        ]));
                if (confirm == true) {
                  try {
                    await ApiService.deleteBook(book.id);
                    ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Book dihapus')));
                    Navigator.pop(context, true);
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Gagal hapus: $e')));
                  }
                }
              })
        ],
      ),
      body: Padding(
          padding: const EdgeInsets.all(16),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(book.title,
                style:
                    const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text('By ${book.author} • ${book.createdAt ?? ''}',
                style: const TextStyle(color: Colors.grey)),
            const SizedBox(height: 16),
            Text(book.description),
          ])),
    );
  }
}
