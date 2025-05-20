import 'package:flutter/material.dart';
import 'telas/tela_login.dart';
import 'telas/tela_inicial.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/login',
      onGenerateRoute: (settings) {
        if (settings.name == '/login') {
          return MaterialPageRoute(builder: (_) => const TelaLogin());
        } else if (settings.name == '/inicial') {
          final args = settings.arguments as Map<String, dynamic>?;
          final nomeUsuario = args?['nomeUsuario'] ?? 'Usuário';
          return MaterialPageRoute(
            builder: (_) => TelaInicial(nomeUsuario: nomeUsuario),
          );
        }
        return null;
      },
    );
  }
}
