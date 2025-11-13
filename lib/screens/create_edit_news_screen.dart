import 'dart:io';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import '../models/news.dart';
import '../services/api_service.dart';

class CreateEditNewsScreen extends StatefulWidget {
  final News? editNews;
  const CreateEditNewsScreen({super.key, this.editNews});

  @override
  State<CreateEditNewsScreen> createState() => _CreateEditNewsScreenState();
}

class _CreateEditNewsScreenState extends State<CreateEditNewsScreen> {
  final _titleC = TextEditingController();
  final _authorC = TextEditingController();
  final _descC = TextEditingController();
  File? _image;
  bool _loading = false;

  @override
  void initState() {
    super.initState();
    if (widget.editNews != null) {
      _titleC.text = widget.editNews!.title;
      _authorC.text = widget.editNews!.author;
      _descC.text = widget.editNews!.description;
    }
  }

  Future<void> _pickImage() async {
    final r = await FilePicker.platform.pickFiles(type: FileType.image);
    if (r != null && r.files.single.path != null) {
      setState(() => _image = File(r.files.single.path!));
    }
  }

  Future<void> _submit() async {
    setState(() => _loading = true);
    try {
      if (widget.editNews == null) {
        await ApiService.createNews(
            title: _titleC.text,
            description: _descC.text,
            author: _authorC.text,
            imageFile: _image);
      } else {
        await ApiService.updateNews(
            id: widget.editNews!.id,
            title: _titleC.text,
            description: _descC.text,
            author: _authorC.text,
            imageFile: _image);
      }
      Navigator.pop(context, true);
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
    final isEdit = widget.editNews != null;
    return Scaffold(
      appBar: AppBar(title: Text(isEdit ? 'Edit News' : 'Create News')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(children: [
          GestureDetector(
              onTap: _pickImage,
              child: _image != null
                  ? Image.file(_image!,
                      height: 180, width: double.infinity, fit: BoxFit.cover)
                  : (widget.editNews?.image != null
                      ? Image.network(widget.editNews!.image!,
                          height: 180,
                          width: double.infinity,
                          fit: BoxFit.cover)
                      : Container(
                          height: 180,
                          color: Colors.grey[200],
                          child: const Icon(Icons.image, size: 60)))),
          const SizedBox(height: 12),
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
