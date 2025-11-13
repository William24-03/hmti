import 'package:flutter/material.dart';
import '../models/user.dart';
import '../services/api_service.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});
  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  User? _user;
  bool _loading = false;
  final _nameC = TextEditingController();
  final _usernameC = TextEditingController();
  final _emailC = TextEditingController();
  final _phoneC = TextEditingController();
  final _bioC = TextEditingController();
  final _websiteC = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    setState(() => _loading = true);
    try {
      final user = await ApiService.getProfile();
      _user = user;
      _nameC.text = user.name ?? '';
      _usernameC.text = user.username ?? '';
      _emailC.text = user.email ?? '';
      _phoneC.text = user.phone ?? '';
      _bioC.text = user.bio ?? '';
      _websiteC.text = user.website ?? '';
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Gagal ambil profile: $e')));
    } finally {
      setState(() => _loading = false);
    }
  }

  Future<void> _save() async {
    setState(() => _loading = true);
    try {
      final updated = User(
        id: _user?.id,
        name: _nameC.text,
        username: _usernameC.text,
        email: _emailC.text,
        phone: _phoneC.text,
        bio: _bioC.text,
        website: _websiteC.text,
      );
      final res = await ApiService.updateProfile(updated);
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Profile updated')));
      setState(() => _user = res);
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Gagal update: $e')));
    } finally {
      setState(() => _loading = false);
    }
  }

  @override
  void dispose() {
    _nameC.dispose();
    _usernameC.dispose();
    _emailC.dispose();
    _phoneC.dispose();
    _bioC.dispose();
    _websiteC.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_loading && _user == null) {
      return const Center(child: CircularProgressIndicator());
    }
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(children: [
        CircleAvatar(
            radius: 50,
            backgroundImage: const AssetImage('assets/images/profile.jpg')),
        const SizedBox(height: 12),
        TextField(
            controller: _usernameC,
            decoration: const InputDecoration(
                labelText: 'Username', border: OutlineInputBorder())),
        const SizedBox(height: 12),
        TextField(
            controller: _nameC,
            decoration: const InputDecoration(
                labelText: 'Full name', border: OutlineInputBorder())),
        const SizedBox(height: 12),
        TextField(
            controller: _emailC,
            decoration: const InputDecoration(
                labelText: 'Email', border: OutlineInputBorder())),
        const SizedBox(height: 12),
        TextField(
            controller: _phoneC,
            decoration: const InputDecoration(
                labelText: 'Phone', border: OutlineInputBorder())),
        const SizedBox(height: 12),
        TextField(
            controller: _websiteC,
            decoration: const InputDecoration(
                labelText: 'Website', border: OutlineInputBorder())),
        const SizedBox(height: 12),
        TextField(
            controller: _bioC,
            minLines: 3,
            maxLines: 5,
            decoration: const InputDecoration(
                labelText: 'Bio', border: OutlineInputBorder())),
        const SizedBox(height: 16),
        _loading
            ? const CircularProgressIndicator()
            : ElevatedButton(
                onPressed: _save, child: const Text('Save Changes')),
      ]),
    );
  }
}
