import 'package:flutter/material.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 80.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Hello,",
                style: TextStyle(
                  fontSize: 48,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Text(
                "Again!",
                style: TextStyle(
                  fontSize: 48,
                  color: Color(0xFF1877F2),
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                "Welcome back, you’ve been missed!",
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[600],
                ),
              ),
              const SizedBox(height: 40),
              TextField(
                decoration: InputDecoration(
                  labelText: "Username",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              TextField(
                obscureText: true,
                decoration: InputDecoration(
                  labelText: "Password",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Checkbox(
                        fillColor:
                            WidgetStateProperty.all(Color(0xFF1877F2)),
                        value: true,
                        onChanged: (value) {},
                      ),
                      const Text('Remember me'),
                    ],
                  ),
                  GestureDetector(
                    onTap: () {
                      // Aksi ketika klik "Forgot the password?"
                    },
                    child: const Text(
                      'Forgot the password?',
                      style: TextStyle(
                        color: Color(0xFF1877F2),
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 40),
              Center(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1877F2),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 140, vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onPressed: () {
                    Navigator.pushReplacementNamed(context, '/home');
                  },
                  child: const Text(
                    'Login',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.white, // Ubah warna teks menjadi putih
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Don't have an account? "),
                    GestureDetector(
                      onTap: () {
                        // Aksi ketika klik "Sign Up"
                      },
                      child: const Text(
                        'Sign Up',
                        style: TextStyle(
                          color: Color(0xFF1877F2),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
