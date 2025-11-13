import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
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
  final ImagePicker _picker = ImagePicker();
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

  Future<void> _pickImage() async {
    final XFile? picked = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 80,
    );
    if (picked != null) {
      setState(() {
        _imageFile = File(picked.path);
      });
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
        ).showSnackBar(SnackBar(content: Text('Post berhasil dibuat')));
      } else {
        await ApiService.updatePost(
          id: widget.editPost!.id,
          title: _titleC.text,
          content: _contentC.text,
          author: _authorC.text,
          imageFile: _imageFile,
        );
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Post berhasil diperbarui')));
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
              SizedBox(height: 12),
              TextFormField(
                controller: _titleC,
                decoration: InputDecoration(
                  labelText: 'Title',
                  border: OutlineInputBorder(),
                ),
                validator: (v) =>
                    v == null || v.isEmpty ? 'Title harus diisi' : null,
              ),
              SizedBox(height: 12),
              TextFormField(
                controller: _authorC,
                decoration: InputDecoration(
                  labelText: 'Author',
                  border: OutlineInputBorder(),
                ),
                validator: (v) =>
                    v == null || v.isEmpty ? 'Author harus diisi' : null,
              ),
              SizedBox(height: 12),
              TextFormField(
                controller: _contentC,
                minLines: 5,
                maxLines: 10,
                decoration: InputDecoration(
                  labelText: 'Content',
                  border: OutlineInputBorder(),
                ),
                validator: (v) =>
                    v == null || v.isEmpty ? 'Content harus diisi' : null,
              ),
              SizedBox(height: 16),
              _loading
                  ? CircularProgressIndicator()
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
