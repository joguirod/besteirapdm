import 'package:flutter/material.dart';

import '../controller/authcontroller.dart';
// views/register_view.dart
class RegisterView extends StatefulWidget {
  @override
  _RegisterViewState createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  void _register() {
    AuthController.register(_emailController.text, _passwordController.text);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Cadastro")),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            Image.asset('./assets/logo.png', height: 100),
            TextField(controller: _emailController, decoration: InputDecoration(labelText: "Email")),
            TextField(controller: _passwordController, decoration: InputDecoration(labelText: "Senha"), obscureText: true),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _register,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.yellow,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.zero,
                ),
                padding: EdgeInsets.symmetric(vertical: 16, horizontal: 32),
              ),
              child: Text("Cadastrar"),
            ),
          ],
        ),
      ),
    );
  }
}
