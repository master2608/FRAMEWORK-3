import 'package:flutter/material.dart';
import '../models/usuario.dart';
import '../services/usuario_service.dart';

class UsuarioProvider extends ChangeNotifier {
  final UsuarioService _service = UsuarioService();

  Usuario? usuarioAtual;
  bool carregando = false;

  Future<bool> cadastrar(
    String nome,
    String email,
    String senha,
  ) async {
    carregando = true;
    notifyListeners();

    final usuario = Usuario(
      nome: nome,
      email: email,
      senha: senha,
    );

    final resultado = await _service.cadastrarUsuario(usuario);

    carregando = false;
    notifyListeners();

    return resultado;
  }

  Future<bool> login(String email, String senha) async {
    carregando = true;
    notifyListeners();

    final usuario = await _service.realizarLogin(email, senha);

    usuarioAtual = usuario;

    carregando = false;
    notifyListeners();

    return usuario != null;
  }

  void logout() {
    usuarioAtual = null;
    notifyListeners();
  }
}