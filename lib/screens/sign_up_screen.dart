import 'package:flutter/material.dart';
import '../services/api_service.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});
  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _nameC = TextEditingController();
  final _userC = TextEditingController();
  final _emailC = TextEditingController();
  final _passC = TextEditingController();
  final _pass2C = TextEditingController();
  bool _loading = false;

  Future<void> _register() async {
    setState(() => _loading = true);
    try {
      final res = await ApiService.register(
        name: _nameC.text,
        username: _userC.text,
        email: _emailC.text,
        password: _passC.text,
        passwordConfirmation: _pass2C.text,
      );
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Register sukses')));
      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Register gagal: $e')));
    } finally {
      setState(() => _loading = false);
    }
  }

  @override
  void dispose() {
    _nameC.dispose();
    _userC.dispose();
    _emailC.dispose();
    _passC.dispose();
    _pass2C.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Sign Up')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(children: [
          TextField(
              controller: _nameC,
              decoration: const InputDecoration(
                  labelText: 'Full name', border: OutlineInputBorder())),
          const SizedBox(height: 12),
          TextField(
              controller: _userC,
              decoration: const InputDecoration(
                  labelText: 'Username', border: OutlineInputBorder())),
          const SizedBox(height: 12),
          TextField(
              controller: _emailC,
              decoration: const InputDecoration(
                  labelText: 'Email', border: OutlineInputBorder())),
          const SizedBox(height: 12),
          TextField(
              controller: _passC,
              obscureText: true,
              decoration: const InputDecoration(
                  labelText: 'Password', border: OutlineInputBorder())),
          const SizedBox(height: 12),
          TextField(
              controller: _pass2C,
              obscureText: true,
              decoration: const InputDecoration(
                  labelText: 'Confirm password', border: OutlineInputBorder())),
          const SizedBox(height: 16),
          _loading
              ? const CircularProgressIndicator()
              : ElevatedButton(
                  onPressed: _register, child: const Text('Register')),
        ]),
      ),
    );
  }
}
