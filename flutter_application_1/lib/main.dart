// main.dart
import 'package:flutter/material.dart';
import 'view/login.dart';
import 'view/register.dart';
import 'view/home.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Projeto Besteira',
      theme: ThemeData(primarySwatch: Colors.blue),
      initialRoute: '/login',
      routes: {
        '/login': (context) => LoginView(),
        '/register': (context) => RegisterView(),
        '/home': (context) => HomeView(),
      },
    );
  }
}
