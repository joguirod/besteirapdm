import '../database/database_helper.dart';
import '../model/user.dart';

class AuthController {
  static final DatabaseHelper _dbHelper = DatabaseHelper();

  static Future<bool> login(String email, String password) async {
    User? user = await _dbHelper.getUser(email);
    if (user != null && user.password == password) {
      print("Usuário autenticado: ${user.email}");
      return true;
    }
    print("Falha no login: Usuário não encontrado ou senha incorreta.");
    return false;
  }

  static Future<void> register(String email, String password) async {
    User? existingUser = await _dbHelper.getUser(email);
    if (existingUser == null) {
      await _dbHelper.insertUser(User(email: email, password: password));
      print("Usuário registrado: $email");
    } else {
      print("Erro: Usuário já existe.");
    }
  }

  static Future<void> printUsers() async {
    List<User> users = await _dbHelper.getAllUsers();
    print("Usuários cadastrados no Banco de Dados:");
    for (var user in users) {
      print("Email: ${user.email}, Senha: ${user.password}");
    }
  }
}
