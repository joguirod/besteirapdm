import 'package:flutter/material.dart';

class AuthNotifier with ChangeNotifier {
  bool _isLoggedIn = false;
  String _userName = 'Usuário';
  String _userImage = 'https://via.placeholder.com/150';

  bool get isLoggedIn => _isLoggedIn;
  String get userName => _userName;
  String get userImage => _userImage;

  void login(String email, String password) {
    _isLoggedIn = true;
    notifyListeners();
  }

  void register(String email, String password) {
    _isLoggedIn = true;
    notifyListeners();
  }

  void logout() {
    _isLoggedIn = false;
    notifyListeners();
  }

  void updateProfile(String name, String password, String imageUrl) {
    _userName = name;
    _userImage = imageUrl;
    notifyListeners();
  }
}