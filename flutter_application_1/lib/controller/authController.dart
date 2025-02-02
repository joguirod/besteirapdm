import '../model/user.dart';

class AuthController {
  static final List<User> _users = [];

  static bool login(String email, String password) {
    return _users.any((user) => user.email == email && user.password == password);
  }

  static void register(String email, String password) {
    _users.add(User(email: email, password: password));
  }
}
