import 'package:flutter/material.dart';

import '../controller/authcontroller.dart';

class LoginView extends StatefulWidget {
  @override
  _LoginViewState createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  String _errorMessage = '';

  void _login() {
    if (AuthController.login(_emailController.text, _passwordController.text)) {
      Navigator.pushNamed(context, '/home');
    } else {
      setState(() {
        _errorMessage = 'Email ou senha inválidos';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Login")),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            Image.asset('./assets/logo.png', height: 100),
            SizedBox(height: 20),
            TextField(controller: _emailController, decoration: InputDecoration(labelText: "Email")),
            TextField(controller: _passwordController, decoration: InputDecoration(labelText: "Senha"), obscureText: true),
            SizedBox(height: 10),
            Text(_errorMessage, style: TextStyle(color: Colors.red)),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _login,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.yellow,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.zero,
                ),
                padding: EdgeInsets.symmetric(vertical: 16, horizontal: 32),
              ),
              child: Text("Entrar"),
            ),
            TextButton(
              onPressed: () {
                Navigator.pushNamed(context, '/register');
              },
              child: Text("Criar conta"),
            )
          ],
        ),
      ),
    );
  }
}
