import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart'; // Importa Firebase Auth
import 'tela_login.dart'; // Importa a tela de login para navegação

class TelaPerfil extends StatelessWidget {
  final String nomeUsuario;
  final String emailUsuario; // adiciona o parâmetro

  const TelaPerfil({
    super.key,
    required this.nomeUsuario,
    required this.emailUsuario, // recebe o email por parâmetro
  });

  @override
  Widget build(BuildContext context) {
    // Remova esta linha, pois vai usar o email passado:
    // final user = FirebaseAuth.instance.currentUser;
    // final email = user?.email ?? 'SEM EMAIL';

    return Scaffold(
      backgroundColor: Colors.grey[400],
      appBar: AppBar(
        backgroundColor: Colors.grey[400],
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black87),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          'Android Compact - 4',
          style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold),
        ),
      ),
      body: Center(
        child: Container(
          width: 300,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.grey[800],
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  color: Colors.grey[700],
                  borderRadius: BorderRadius.circular(30),
                ),
                child: const Icon(Icons.person, color: Colors.white, size: 80),
              ),
              const SizedBox(height: 12),
              Text(
                nomeUsuario.toUpperCase(),
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.5,
                ),
              ),
              const SizedBox(height: 20),

              _botaoInfo(
                texto: emailUsuario.toUpperCase(), // usa o email recebido aqui
                icone: Icons.edit,
                onPressed: () {
                  // ação editar email
                },
              ),

              const SizedBox(height: 12),

              _botaoInfo(
                texto: 'ALTERAR SENHA',
                icone: Icons.edit,
                onPressed: () {
                  // ação alterar senha
                },
              ),

              const SizedBox(height: 12),

              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.grey[700],
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 12,
                  ),
                  minimumSize: const Size(double.infinity, 40),
                ),
                onPressed: () async {
                  await FirebaseAuth.instance.signOut();
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (_) => const TelaLogin()),
                    (route) => false,
                  );
                },
                icon: const Icon(Icons.logout),
                label: const Text(
                  'SAIR',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _botaoInfo({
    required String texto,
    required IconData icone,
    required VoidCallback onPressed,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[700],
        borderRadius: BorderRadius.circular(25),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          Expanded(
            child: Text(texto, style: const TextStyle(color: Colors.white)),
          ),
          IconButton(
            icon: Icon(icone, color: Colors.white),
            onPressed: onPressed,
            splashRadius: 20,
          ),
        ],
      ),
    );
  }
}
