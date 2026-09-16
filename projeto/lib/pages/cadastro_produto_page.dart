import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/produto.dart';
import '../providers/produto_provider.dart';

class CadastroProdutoPage extends StatefulWidget {
  const CadastroProdutoPage({super.key});

  @override
  State<CadastroProdutoPage> createState() => _CadastroProdutoPageState();
}

class _CadastroProdutoPageState extends State<CadastroProdutoPage> {
  final nomeController = TextEditingController();
  final categoriaController = TextEditingController();
  final quantidadeController = TextEditingController();
  final precoController = TextEditingController();

  @override
  void dispose() {
    nomeController.dispose();
    categoriaController.dispose();
    quantidadeController.dispose();
    precoController.dispose();
    super.dispose();
  }

  Future<void> cadastrarProduto() async {
    final nome = nomeController.text.trim();
    final categoria = categoriaController.text.trim();
    final quantidade = int.tryParse(
      quantidadeController.text.trim(),
    );
    final preco = double.tryParse(
      precoController.text.trim().replaceAll(',', '.'),
    );

    if (nome.isEmpty ||
        categoria.isEmpty ||
        quantidade == null ||
        preco == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Preencha os campos corretamente.'),
        ),
      );
      return;
    }

    if (quantidade < 0 || preco < 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Quantidade e preço não podem ser negativos.'),
        ),
      );
      return;
    }

    final produto = Produto(
      nome: nome,
      categoria: categoria,
      quantidade: quantidade,
      preco: preco,
    );

    await context.read<ProdutoProvider>().cadastrarProduto(produto);

    if (!mounted) {
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Produto cadastrado com sucesso.'),
      ),
    );

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cadastrar Produto'),
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: ConstrainedBox(
            constraints: const BoxConstraints(
              maxWidth: 500,
            ),
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  children: [
                    const Text(
                      'CADASTRO DE PRODUTO',
                      style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 30),
                    TextField(
                      controller: nomeController,
                      decoration: const InputDecoration(
                        labelText: 'Nome',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: categoriaController,
                      decoration: const InputDecoration(
                        labelText: 'Categoria',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: quantidadeController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: 'Quantidade',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: precoController,
                      keyboardType: const TextInputType.numberWithOptions(
                        decimal: true,
                      ),
                      decoration: const InputDecoration(
                        labelText: 'Preço',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 24),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: cadastrarProduto,
                        child: const Padding(
                          padding: EdgeInsets.all(14),
                          child: Text('CADASTRAR PRODUTO'),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}