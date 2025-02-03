import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:io' show Platform; // Para verificar se é Android/iOS
import 'package:flutter/foundation.dart' show kIsWeb; // Para verificar se é Web
import '../model/user.dart';
import '../model/contact.dart';

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
  // Gerenciamento de Usuários
  // ==========================

  /// Insere um novo usuário no banco de dados
  Future<int?> insertUser(User user) async {
    final db = await database;
    if (db == null) {
      return null;
    }
    return await db.insert(
      'users',
      user.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  /// Busca um usuário pelo email
  Future<User?> getUser(String email) async {
    final db = await database;
    if (db == null) {
      return null;
    }

    final result = await db.query(
      'users',
      where: 'email = ?',
      whereArgs: [email],
    );

    if (result.isNotEmpty) {
      return User.fromMap(result.first);
    }
    return null;
  }

  /// Retorna todos os usuários cadastrados
  Future<List<User>> getAllUsers() async {
    final db = await database;
    if (db == null) {
      return [];
    }

    final result = await db.query('users');
    return result.map((map) => User.fromMap(map)).toList();
  }

  // ==========================
  //  Gerenciamento de Contatos
  // ==========================

  /// Insere um novo contato
  Future<int?> insertContact(Contact contact) async {
    final db = await database;
    if (db == null) {
      return null;
    }
    return await db.insert('contacts', contact.toMap());
  }

  /// Retorna todos os contatos
  Future<List<Contact>> getAllContacts() async {
    final db = await database;
    if (db == null) {
      return [];
    }
    final result = await db.query('contacts');
    return result.map((json) => Contact.fromMap(json)).toList();
  }

  /// Atualiza um contato existente
  Future<int?> updateContact(Contact contact) async {
    final db = await database;
    if (db == null) {
      return null;
    }
    return await db.update(
      'contacts',
      contact.toMap(),
      where: 'id = ?',
      whereArgs: [contact.id],
    );
  }

  /// Deleta um contato pelo ID
  Future<int?> deleteContact(int id) async {
    final db = await database;
    if (db == null) {
      return null;
    }
    return await db.delete(
      'contacts',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
