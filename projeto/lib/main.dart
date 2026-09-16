import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/produto_provider.dart';
import 'providers/usuario_provider.dart';
import 'pages/login_page.dart';

void main() {
  runApp(const MinhaAtividadeApp());
}

class MinhaAtividadeApp extends StatelessWidget {
  const MinhaAtividadeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => UsuarioProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => ProdutoProvider(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Controle de Estoque',
        theme: ThemeData(
          useMaterial3: true,
          colorSchemeSeed: Colors.blue,
        ),
        home: const LoginPage(),
      ),
    );
  }
}