import 'dart:async';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});
  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  Future<void> checkLogin() async {
    final sp = await SharedPreferences.getInstance();
    final token = sp.getString('token');
    if (token != null && token.isNotEmpty) {
      Navigator.pushReplacementNamed(context, '/home');
    } else {
      Navigator.pushReplacementNamed(context, '/login');
    }
  }

  @override
  void initState() {
    super.initState();
    Timer(const Duration(milliseconds: 800), () {
      checkLogin();
    });
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: Text('HMTI News', style: TextStyle(fontSize: 24))),
    );
  }
}
