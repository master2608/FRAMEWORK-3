import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/produto.dart';
import '../providers/produto_provider.dart';

class EstoquePage extends StatefulWidget {
  const EstoquePage({super.key});

  @override
  State<EstoquePage> createState() => _EstoquePageState();
}

class _EstoquePageState extends State<EstoquePage> {
  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      context.read<ProdutoProvider>().carregarProdutos();
    });
  }

  String formatarPreco(double preco) {
    return 'R\$ ${preco.toStringAsFixed(2).replaceAll('.', ',')}';
  }

  Future<void> excluirProduto(Produto produto) async {
    final confirmar = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Excluir produto'),
          content: Text(
            'Deseja excluir o produto "${produto.nome}"?',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context, false);
              },
              child: const Text('CANCELAR'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context, true);
              },
              child: const Text('EXCLUIR'),
            ),
          ],
        );
      },
    );

    if (confirmar == true) {
      await context.read<ProdutoProvider>().excluirProduto(produto);
    }
  }

  Widget construirProduto(Produto produto) {
    final estoqueBaixo = produto.quantidade <= 3;

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              produto.nome,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              produto.categoria,
              style: const TextStyle(
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Preço: ${formatarPreco(produto.preco)}',
              style: const TextStyle(
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                IconButton(
                  onPressed: produto.quantidade > 0
                      ? () {
                          context
                              .read<ProdutoProvider>()
                              .diminuirQuantidade(produto);
                        }
                      : null,
                  icon: const Icon(Icons.remove),
                ),
                Text(
                  'Quantidade: ${produto.quantidade}',
                  style: const TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                IconButton(
                  onPressed: () {
                    context
                        .read<ProdutoProvider>()
                        .aumentarQuantidade(produto);
                  },
                  icon: const Icon(Icons.add),
                ),
              ],
            ),
            if (estoqueBaixo)
              Container(
                margin: const EdgeInsets.only(top: 8),
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                child: const Text(
                  'ESTOQUE BAIXO',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            const SizedBox(height: 10),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: () {
                  excluirProduto(produto);
                },
                icon: const Icon(Icons.delete),
                label: const Text('EXCLUIR'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ProdutoProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('ESTOQUE'),
        actions: [
          IconButton(
            onPressed: () {
              provider.carregarProdutos();
              provider.mostrarProdutosNoTerminal();
            },
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      body: provider.carregando
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : provider.produtos.isEmpty
              ? const Center(
                  child: Text(
                    'Nenhum produto cadastrado.',
                    style: TextStyle(
                      fontSize: 18,
                    ),
                  ),
                )
              : RefreshIndicator(
                  onRefresh: provider.carregarProdutos,
                  child: ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: provider.produtos.length,
                    itemBuilder: (context, index) {
                      return construirProduto(
                        provider.produtos[index],
                      );
                    },
                  ),
                ),
    );
  }
}