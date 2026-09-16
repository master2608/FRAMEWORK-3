import 'package:flutter/material.dart';
import '../models/produto.dart';
import '../services/produto_service.dart';

class ProdutoProvider extends ChangeNotifier {
  final ProdutoService _service = ProdutoService();

  List<Produto> produtos = [];
  bool carregando = false;

  Future<void> carregarProdutos() async {
    carregando = true;
    notifyListeners();

    produtos = await _service.buscarProdutos();

    carregando = false;
    notifyListeners();
  }

  Future<void> cadastrarProduto(Produto produto) async {
    await _service.cadastrarProduto(produto);
    await carregarProdutos();
  }

  Future<void> alterarQuantidade(Produto produto, int novaQuantidade) async {
    if (novaQuantidade < 0) {
      return;
    }

    await _service.alterarQuantidade(
      produto.id!,
      novaQuantidade,
    );

    await carregarProdutos();
  }

  Future<void> aumentarQuantidade(Produto produto) async {
    await alterarQuantidade(
      produto,
      produto.quantidade + 1,
    );
  }

  Future<void> diminuirQuantidade(Produto produto) async {
    if (produto.quantidade <= 0) {
      return;
    }

    await alterarQuantidade(
      produto,
      produto.quantidade - 1,
    );
  }

  Future<void> excluirProduto(Produto produto) async {
    await _service.excluirProduto(produto.id!);
    await carregarProdutos();
  }

  Future<void> mostrarProdutosNoTerminal() async {
    await _service.mostrarProdutosNoTerminal();
  }
}