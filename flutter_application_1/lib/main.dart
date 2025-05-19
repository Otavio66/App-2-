import 'package:flutter/material.dart';
import 'telas/tela_login.dart';
import 'telas/tela_inicial.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/login',
      routes: {
        '/login': (context) => const TelaLogin(),
        '/inicial': (context) => const TelaInicial(),
      },
    );
  }
}
