import 'package:flutter/material.dart';
import '../models/news.dart';
import '../services/api_service.dart';
import 'create_edit_news_screen.dart';

class DetailNewsScreen extends StatelessWidget {
  final News news;
  const DetailNewsScreen({super.key, required this.news});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail News'),
        actions: [
          IconButton(
              icon: const Icon(Icons.edit),
              onPressed: () async {
                final r = await Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => CreateEditNewsScreen(editNews: news)));
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
                    await ApiService.deleteNews(news.id);
                    ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('News dihapus')));
                    Navigator.pop(context, true);
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Gagal hapus: $e')));
                  }
                }
              })
        ],
      ),
      body: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            if (news.image != null)
              Image.network(news.image!,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => const SizedBox.shrink()),
            const SizedBox(height: 8),
            Text(news.title,
                style:
                    const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text('By ${news.author} • ${news.createdAt ?? ''}',
                style: const TextStyle(color: Colors.grey)),
            const SizedBox(height: 16),
            Text(news.description),
          ])),
    );
  }
}
