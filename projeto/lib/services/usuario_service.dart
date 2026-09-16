import 'package:sqflite/sqflite.dart';
import '../models/usuario.dart';
import 'database_service.dart';

class UsuarioService {
  Future<bool> emailExiste(String email) async {
    final db = await DatabaseService.database;

    final resultado = await db.query(
      'usuarios',
      where: 'email = ?',
      whereArgs: [email],
      limit: 1,
    );

    return resultado.isNotEmpty;
  }

  Future<bool> cadastrarUsuario(Usuario usuario) async {
    final db = await DatabaseService.database;

    final existe = await emailExiste(usuario.email);

    if (existe) {
      print('E-mail já cadastrado.');
      return false;
    }

    await db.insert(
      'usuarios',
      usuario.toMap(),
      conflictAlgorithm: ConflictAlgorithm.abort,
    );

    print('Usuário cadastrado: ${usuario.nome}');

    return true;
  }

  Future<Usuario?> realizarLogin(String email, String senha) async {
    final db = await DatabaseService.database;

    print('SELECT → Procurando usuário: $email');

    final resultado = await db.query(
      'usuarios',
      where: 'email = ? AND senha = ?',
      whereArgs: [email, senha],
      limit: 1,
    );

    if (resultado.isNotEmpty) {
      final usuario = Usuario.fromMap(resultado.first);

      print('SELECT → Usuário encontrado: ${usuario.nome}');

      return usuario;
    }

    print('SELECT → Usuário não encontrado');

    return null;
  }
}