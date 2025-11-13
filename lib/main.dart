import 'package:flutter/material.dart';
import 'screens/splash_screen.dart';
import 'screens/login_screen.dart';
import 'screens/sign_up_screen.dart';
import 'screens/home_screen.dart';

void main() {
  runApp(const HMTINewsApp());
}

class HMTINewsApp extends StatelessWidget {
  const HMTINewsApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'HMTI News',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.blue),
      initialRoute: '/',
      routes: {
        '/': (context) => const SplashScreen(),
        '/login': (context) => const LoginScreen(),
        '/signup': (context) => const SignUpScreen(),
        '/home': (context) => const HomeScreen(),
      },
    );
  }
}
