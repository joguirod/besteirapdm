import 'package:flutter/material.dart';
import 'package:flutter_application_1/view/contacts_list.dart';
import 'package:flutter_application_1/view/login.dart';
import 'package:flutter_application_1/view/register.dart';
import 'package:flutter_application_1/view/home.dart';
import 'package:flutter_application_1/controller/authController.dart';
import 'package:flutter_application_1/view/map_view.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  /// **Verifica se há um usuário logado e decide a tela inicial**
  Future<String> _initializeApp() async {
    await AuthController.printUsers(); // Apenas para depuração
    bool isLoggedIn = await AuthController.isLoggedIn();
    return isLoggedIn ? '/home' : '/login';
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Projeto Mapa',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: FutureBuilder<String>(
        future: _initializeApp(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()), // Tela de carregamento
            );
          }
          if (snapshot.hasError) {
            return Scaffold(
              body: Center(child: Text("Erro ao iniciar o aplicativo: ${snapshot.error}")),
            );
          }
          return snapshot.data == '/home' ? const HomeView() : const LoginView();
        },
      ),
      routes: {
        '/login': (context) => const LoginView(),
        '/register': (context) => const RegisterView(),
        '/home': (context) => const HomeView(),
        '/map': (context) => const MapView(),
        '/contact': (context) => const ContactsListView(),
      },
    );
  }
}
