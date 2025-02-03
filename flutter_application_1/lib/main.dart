import 'package:flutter/material.dart';
import 'view/login.dart';
import 'view/register.dart';
import 'view/home.dart';
import 'controller/authController.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await AuthController.printUsers(); // Teste para garantir que o banco ta carregado

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Projeto Mapa',
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
