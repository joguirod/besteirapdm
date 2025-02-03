import 'package:shared_preferences/shared_preferences.dart';
import '../database/database_helper.dart';
import '../model/user.dart';

class AuthController {
  static final DatabaseHelper _dbHelper = DatabaseHelper();

  /// Login do usuário
  static Future<bool> login(String email, String password) async {
    User? user = await _dbHelper.getUser(email);
    if (user != null && user.password == password) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('isLoggedIn', true);
      await prefs.setString('userEmail', email);
      print("Usuário autenticado: ${user.email}");
      return true;
    }
    print("Falha no login: Usuário não encontrado ou senha incorreta.");
    return false;
  }

  /// Registro de usuário
  static Future<bool> register(String email, String password) async {
    User? existingUser = await _dbHelper.getUser(email);
    if (existingUser == null) {
      await _dbHelper.insertUser(User(email: email, password: password));
      print("Usuário registrado: $email");
      return true;
    } else {
      print("Erro: Usuário já existe.");
      return false;
    }
  }

  /// Verifica se o usuário está logado
  static Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('isLoggedIn') ?? false;
  }

  /// Retorna o email do usuário logado
  static Future<String?> getLoggedInUser() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('userEmail');
  }

  /// Logout do usuário
  static Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    print("Usuário deslogado.");
  }

  /// Lista todos os usuários cadastrados (Debug)
  static Future<void> printUsers() async {
    List<User> users = await _dbHelper.getAllUsers();
    print("Usuários cadastrados no Banco de Dados:");
    for (var user in users) {
      print("Email: ${user.email}, Senha: ${user.password}");
    }
  }
}
