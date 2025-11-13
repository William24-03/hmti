import 'dart:io';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import '../models/post.dart';
import '../services/api_service.dart';

class CreateEditPostScreen extends StatefulWidget {
  final Post? editPost;
  const CreateEditPostScreen({super.key, this.editPost});

  @override
  _CreateEditPostScreenState createState() => _CreateEditPostScreenState();
}

class _CreateEditPostScreenState extends State<CreateEditPostScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleC = TextEditingController();
  final _contentC = TextEditingController();
  final _authorC = TextEditingController();
  File? _imageFile;
  bool _loading = false;

  @override
  void initState() {
    super.initState();
    if (widget.editPost != null) {
      _titleC.text = widget.editPost!.title;
      _contentC.text = widget.editPost!.content;
      _authorC.text = widget.editPost!.author;
    }
  }

  //  Ganti fungsi ambil gambar agar buka file explorer laptop (bukan galeri emulator)
  Future<void> _pickImage() async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.image,
        allowMultiple: false,
      );

      if (result != null && result.files.single.path != null) {
        setState(() {
          _imageFile = File(result.files.single.path!);
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Tidak ada file yang dipilih')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Gagal memilih file: $e')));
    }
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _loading = true);
    try {
      if (widget.editPost == null) {
        await ApiService.createPost(
          title: _titleC.text,
          content: _contentC.text,
          author: _authorC.text,
          imageFile: _imageFile,
        );
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Post berhasil dibuat')));
      } else {
        await ApiService.updatePost(
          id: widget.editPost!.id,
          title: _titleC.text,
          content: _contentC.text,
          author: _authorC.text,
          imageFile: _imageFile,
        );
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Post berhasil diperbarui')),
        );
      }
      Navigator.pop(context, true);
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Gagal: $e')));
    } finally {
      setState(() => _loading = false);
    }
  }

  @override
  void dispose() {
    _titleC.dispose();
    _contentC.dispose();
    _authorC.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.editPost != null;
    return Scaffold(
      appBar: AppBar(title: Text(isEdit ? 'Edit Post' : 'Buat Post')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              GestureDetector(
                onTap: _pickImage,
                child: _imageFile != null
                    ? Image.file(
                        _imageFile!,
                        height: 180,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      )
                    : (widget.editPost?.image != null
                          ? Image.network(
                              widget.editPost!.image!,
                              height: 180,
                              width: double.infinity,
                              fit: BoxFit.cover,
                            )
                          : Container(
                              height: 180,
                              width: double.infinity,
                              color: Colors.grey[200],
                              child: Icon(
                                Icons.image,
                                size: 60,
                                color: Colors.grey[600],
                              ),
                            )),
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _titleC,
                decoration: const InputDecoration(
                  labelText: 'Title',
                  border: OutlineInputBorder(),
                ),
                validator: (v) =>
                    v == null || v.isEmpty ? 'Title harus diisi' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _authorC,
                decoration: const InputDecoration(
                  labelText: 'Author',
                  border: OutlineInputBorder(),
                ),
                validator: (v) =>
                    v == null || v.isEmpty ? 'Author harus diisi' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _contentC,
                minLines: 5,
                maxLines: 10,
                decoration: const InputDecoration(
                  labelText: 'Content',
                  border: OutlineInputBorder(),
                ),
                validator: (v) =>
                    v == null || v.isEmpty ? 'Content harus diisi' : null,
              ),
              const SizedBox(height: 16),
              _loading
                  ? const CircularProgressIndicator()
                  : ElevatedButton(
                      onPressed: _submit,
                      child: Text(isEdit ? 'Update' : 'Create'),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
