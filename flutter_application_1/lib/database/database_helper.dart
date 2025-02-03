import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:io' show Platform; // Para verificar se é Android/iOS
import 'package:flutter/foundation.dart' show kIsWeb; // Para verificar se é Web
import '../model/user.dart';
import '../model/contact.dart'; // Importamos a classe Contact

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._internal();
  static Database? _database;

  factory DatabaseHelper() => instance;

  DatabaseHelper._internal();

  /// Obtém o banco de dados SQLite (Mobile) ou SharedPreferences (Web)
  Future<Database?> get database async {
    if (!kIsWeb && (Platform.isAndroid || Platform.isIOS)) {
      _database ??= await _initDatabase();
      return _database;
    }
    return null; // No Web, usaremos SharedPreferences
  }

  /// Inicializa o banco de dados SQLite (apenas no Mobile)
  Future<Database> _initDatabase() async {
    final path = join(await getDatabasesPath(), 'app_database.db');

    return await openDatabase(
      path,
      version: 2, // Atualizamos a versão para 2 para incluir contatos
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE users (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            email TEXT UNIQUE NOT NULL,
            password TEXT NOT NULL
          )
        ''');

        await db.execute('''
          CREATE TABLE contacts (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            name TEXT NOT NULL,
            latitude REAL NOT NULL,
            longitude REAL NOT NULL
          )
        ''');
      },
    );
  }

  // ==========================
  // 📌 Gerenciamento de Usuários
  // ==========================

  Future<void> insertUser(User user) async {
    if (!kIsWeb && (Platform.isAndroid || Platform.isIOS)) {
      final db = await database;
      await db?.insert('users', user.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
    } else {
      final prefs = await SharedPreferences.getInstance();
      List<String> users = prefs.getStringList('users') ?? [];

      if (!users.contains(user.email)) {
        users.add(user.email);
        await prefs.setStringList('users', users);
        await prefs.setString('password_${user.email}', user.password);
      }
    }
  }

  Future<User?> getUser(String email) async {
    if (!kIsWeb && (Platform.isAndroid || Platform.isIOS)) {
      final db = await database;
      if (db == null) return null;

      final result = await db.query('users', where: 'email = ?', whereArgs: [email]);
      if (result.isNotEmpty) {
        return User.fromMap(result.first);
      }
    } else {
      final prefs = await SharedPreferences.getInstance();
      String? password = prefs.getString('password_$email');
      if (password != null) {
        return User(email: email, password: password);
      }
    }
    return null;
  }

  Future<List<User>> getAllUsers() async {
    if (!kIsWeb && (Platform.isAndroid || Platform.isIOS)) {
      final db = await database;
      if (db == null) return [];

      final result = await db.query('users');
      if (result.isNotEmpty) {
        return result.map((map) => User.fromMap(map)).toList();
      }
    } else {
      final prefs = await SharedPreferences.getInstance();
      List<String> users = prefs.getStringList('users') ?? [];

      return users.map((email) {
        String? password = prefs.getString('password_$email');
        if (password != null) {
          return User(email: email, password: password);
        }
        return null;
      }).whereType<User>().toList();
    }
    return [];
  }

  // ==========================
  // 📌 Gerenciamento de Contatos
  // ==========================

  /// Insere um novo contato no banco
  Future<void> insertContact(Contact contact) async {
    if (!kIsWeb && (Platform.isAndroid || Platform.isIOS)) {
      final db = await database;
      await db?.insert('contacts', contact.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
    } else {
      final prefs = await SharedPreferences.getInstance();
      List<String> contacts = prefs.getStringList('contacts') ?? [];

      String contactData = "${contact.name},${contact.latitude},${contact.longitude}";
      contacts.add(contactData);
      await prefs.setStringList('contacts', contacts);
    }
  }

  /// Obtém todos os contatos cadastrados
  Future<List<Contact>> getAllContacts() async {
    if (!kIsWeb && (Platform.isAndroid || Platform.isIOS)) {
      final db = await database;
      if (db == null) return [];

      final result = await db.query('contacts');
      return result.map((map) => Contact.fromMap(map)).toList();
    } else {
      final prefs = await SharedPreferences.getInstance();
      List<String> contacts = prefs.getStringList('contacts') ?? [];

      return contacts.map((contactData) {
        List<String> data = contactData.split(',');
        if (data.length == 3) {
          return Contact(
            name: data[0],
            latitude: double.parse(data[1]),
            longitude: double.parse(data[2]),
          );
        }
        return null;
      }).whereType<Contact>().toList();
    }
  }
}
