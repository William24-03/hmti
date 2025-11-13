import 'package:flutter/material.dart';
import '../services/api_service.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailC = TextEditingController();
  final _passC = TextEditingController();
  bool _loading = false;

  Future<void> _login() async {
    setState(() => _loading = true);
    try {
      final res =
          await ApiService.login(email: _emailC.text, password: _passC.text);
      // res contains data and maybe token (already saved in ApiService)
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Login sukses')));
      Navigator.pushReplacementNamed(context, '/home');
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Login gagal: $e')));
    } finally {
      setState(() => _loading = false);
    }
  }

  @override
  void dispose() {
    _emailC.dispose();
    _passC.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 80.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Hello,",
                style: TextStyle(fontSize: 48, fontWeight: FontWeight.bold)),
            const Text("Again!",
                style: TextStyle(
                    fontSize: 48,
                    color: Color(0xFF1877F2),
                    fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            Text("Welcome back, you’ve been missed!",
                style: TextStyle(fontSize: 16, color: Colors.grey[600])),
            const SizedBox(height: 40),
            TextField(
                controller: _emailC,
                decoration: const InputDecoration(
                    labelText: "Email", border: OutlineInputBorder())),
            const SizedBox(height: 20),
            TextField(
                controller: _passC,
                obscureText: true,
                decoration: const InputDecoration(
                    labelText: "Password", border: OutlineInputBorder())),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(children: [
                  Checkbox(value: true, onChanged: (_) {}),
                  const Text('Remember me')
                ]),
                GestureDetector(
                    onTap: () {},
                    child: const Text('Forgot the password?',
                        style: TextStyle(
                            color: Color(0xFF1877F2),
                            decoration: TextDecoration.underline))),
              ],
            ),
            const SizedBox(height: 40),
            Center(
              child: _loading
                  ? const CircularProgressIndicator()
                  : ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF1877F2),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 120, vertical: 14),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10))),
                      onPressed: _login,
                      child: const Text('Login',
                          style: TextStyle(fontSize: 18, color: Colors.white)),
                    ),
            ),
            const SizedBox(height: 20),
            Center(
              child:
                  Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                const Text("Don't have an account? "),
                GestureDetector(
                    onTap: () => Navigator.pushNamed(context, '/signup'),
                    child: const Text('Sign Up',
                        style: TextStyle(
                            color: Color(0xFF1877F2),
                            fontWeight: FontWeight.bold))),
              ]),
            ),
          ],
        ),
      ),
    );
  }
}
