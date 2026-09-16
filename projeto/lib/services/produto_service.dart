import 'package:sqflite/sqflite.dart';
import '../models/produto.dart';
import 'database_service.dart';

class ProdutoService {
  Future<int> cadastrarProduto(Produto produto) async {
    final db = await DatabaseService.database;

    final id = await db.insert(
      'produtos',
      produto.toMap(),
    );

    print('INSERT → Produto cadastrado: ${produto.nome}');

    return id;
  }

  Future<List<Produto>> buscarProdutos() async {
    final db = await DatabaseService.database;

    final resultado = await db.query(
      'produtos',
      orderBy: 'id DESC',
    );

    print('SELECT → Produtos encontrados:');

    for (final produto in resultado) {
      print(produto);
    }

    return resultado.map((map) => Produto.fromMap(map)).toList();
  }

  Future<void> alterarQuantidade(int id, int novaQuantidade) async {
    final db = await DatabaseService.database;

    final resultado = await db.query(
      'produtos',
      where: 'id = ?',
      whereArgs: [id],
      limit: 1,
    );

    if (resultado.isEmpty) {
      return;
    }

    final produto = Produto.fromMap(resultado.first);
    final quantidadeAnterior = produto.quantidade;

    await db.update(
      'produtos',
      {'quantidade': novaQuantidade},
      where: 'id = ?',
      whereArgs: [id],
    );

    print('UPDATE → ${produto.nome}');
    print('Quantidade anterior: $quantidadeAnterior');
    print('Nova quantidade: $novaQuantidade');
  }

  Future<void> excluirProduto(int id) async {
    final db = await DatabaseService.database;

    final resultado = await db.query(
      'produtos',
      where: 'id = ?',
      whereArgs: [id],
      limit: 1,
    );

    if (resultado.isEmpty) {
      return;
    }

    final produto = Produto.fromMap(resultado.first);

    await db.delete(
      'produtos',
      where: 'id = ?',
      whereArgs: [id],
    );

    print('DELETE → Produto excluído: ${produto.nome}');
  }

  Future<void> mostrarProdutosNoTerminal() async {
    final db = await DatabaseService.database;

    final produtos = await db.query('produtos');

    print('===== PRODUTOS NO BANCO =====');

    for (final produto in produtos) {
      print(produto);
    }
  }
}