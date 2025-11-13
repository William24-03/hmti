import 'package:flutter/material.dart';
import '../models/post.dart';
import '../services/api_service.dart';
import 'create_edit_post_screen.dart';

class DetailScreen extends StatelessWidget {
  final Post post;

  const DetailScreen({super.key, required this.post});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Detail News'),
        actions: [
          IconButton(
            icon: Icon(Icons.delete),
            onPressed: () async {
              final confirmed = await showDialog<bool>(
                context: context,
                builder: (_) => AlertDialog(
                  title: Text('Hapus post?'),
                  content: Text('Yakin ingin menghapus post ini?'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context, false),
                      child: Text('Batal'),
                    ),
                    TextButton(
                      onPressed: () => Navigator.pop(context, true),
                      child: Text('Hapus'),
                    ),
                  ],
                ),
              );
              if (confirmed == true) {
                try {
                  await ApiService.deletePost(post.id);
                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(SnackBar(content: Text('Post dihapus')));
                  Navigator.pop(context, true); // kembali ke list
                } catch (e) {
                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(SnackBar(content: Text('Gagal hapus: $e')));
                }
              }
            },
          ),
          IconButton(
            icon: Icon(Icons.edit),
            onPressed: () async {
              // buka screen edit
              final res = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => CreateEditPostScreen(editPost: post),
                ),
              );
              if (res == true) {
                Navigator.pop(context, true); // refresh list di Home
              }
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              if (post.image != null && post.image!.isNotEmpty)
                Image.network(post.image!),
              SizedBox(height: 16),
              Text(
                post.title,
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Text(
                'By ${post.author} • ${post.createdAt ?? ''}',
                style: TextStyle(color: Colors.grey),
              ),
              SizedBox(height: 16),
              Text(post.content, style: TextStyle(fontSize: 16)),
            ],
          ),
        ),
      ),
    );
  }
}
