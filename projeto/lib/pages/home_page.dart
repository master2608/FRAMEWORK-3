import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/usuario_provider.dart';
import 'cadastro_produto_page.dart';
import 'estoque_page.dart';
import 'login_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final usuario = context.watch<UsuarioProvider>().usuarioAtual;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Controle de Estoque'),
        centerTitle: true,
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: ConstrainedBox(
            constraints: const BoxConstraints(
              maxWidth: 500,
            ),
            child: Column(
              children: [
                Text(
                  'Olá, ${usuario?.nome ?? ''}!',
                  style: const TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  'CONTROLE DE ESTOQUE',
                  style: TextStyle(
                    fontSize: 20,
                  ),
                ),
                const SizedBox(height: 40),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const EstoquePage(),
                        ),
                      );
                    },
                    icon: const Icon(Icons.inventory),
                    label: const Padding(
                      padding: EdgeInsets.all(14),
                      child: Text('VER PRODUTOS'),
                    ),
                  ),
                ),
                const SizedBox(height: 15),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const CadastroProdutoPage(),
                        ),
                      );
                    },
                    icon: const Icon(Icons.add_box),
                    label: const Padding(
                      padding: EdgeInsets.all(14),
                      child: Text('CADASTRAR PRODUTO'),
                    ),
                  ),
                ),
                const SizedBox(height: 15),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    onPressed: () {
                      context.read<UsuarioProvider>().logout();

                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const LoginPage(),
                        ),
                        (route) => false,
                      );
                    },
                    icon: const Icon(Icons.logout),
                    label: const Padding(
                      padding: EdgeInsets.all(14),
                      child: Text('SAIR'),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}