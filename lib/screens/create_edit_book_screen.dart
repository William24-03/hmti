import 'package:flutter/material.dart';
import '../models/book.dart';
import '../services/api_service.dart';

class CreateEditBookScreen extends StatefulWidget {
  final Book? editBook;
  const CreateEditBookScreen({super.key, this.editBook});

  @override
  State<CreateEditBookScreen> createState() => _CreateEditBookScreenState();
}

class _CreateEditBookScreenState extends State<CreateEditBookScreen> {
  final _titleC = TextEditingController();
  final _authorC = TextEditingController();
  final _descC = TextEditingController();
  bool _loading = false;

  @override
  void initState() {
    super.initState();
    if (widget.editBook != null) {
      _titleC.text = widget.editBook!.title;
      _authorC.text = widget.editBook!.author;
      _descC.text = widget.editBook!.description;
    }
  }

  Future<void> _submit() async {
    setState(() => _loading = true);
    try {
      if (widget.editBook == null) {
        await ApiService.createBook(
            title: _titleC.text,
            author: _authorC.text,
            description: _descC.text);
        Navigator.pop(context, true);
      } else {
        await ApiService.updateBook(
            id: widget.editBook!.id,
            title: _titleC.text,
            author: _authorC.text,
            description: _descC.text);
        Navigator.pop(context, true);
      }
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Gagal: $e')));
    } finally {
      setState(() => _loading = false);
    }
  }

  @override
  void dispose() {
    _titleC.dispose();
    _authorC.dispose();
    _descC.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.editBook != null;
    return Scaffold(
      appBar: AppBar(title: Text(isEdit ? 'Edit Book' : 'Create Book')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(children: [
          TextField(
              controller: _titleC,
              decoration: const InputDecoration(
                  labelText: 'Title', border: OutlineInputBorder())),
          const SizedBox(height: 12),
          TextField(
              controller: _authorC,
              decoration: const InputDecoration(
                  labelText: 'Author', border: OutlineInputBorder())),
          const SizedBox(height: 12),
          TextField(
              controller: _descC,
              minLines: 4,
              maxLines: 8,
              decoration: const InputDecoration(
                  labelText: 'Description', border: OutlineInputBorder())),
          const SizedBox(height: 16),
          _loading
              ? const CircularProgressIndicator()
              : ElevatedButton(
                  onPressed: _submit,
                  child: Text(isEdit ? 'Update' : 'Create')),
        ]),
      ),
    );
  }
}
