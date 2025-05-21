import 'package:flutter/material.dart';

class TelaNotificacoes extends StatelessWidget {
  const TelaNotificacoes({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[500],
      appBar: AppBar(
        backgroundColor: Colors.grey[500],
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
        automaticallyImplyLeading: false,
        title: const Text(
          'Android Compact - 3',
          style: TextStyle(color: Colors.grey, fontSize: 14),
        ),
      ),
      body: Center(  // Centraliza todo o conteúdo
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _botaoRisco(
              icon: Icons.warning_amber_rounded,
              texto: 'NOVO RISCO',
              data: 'Hoje',
              corFundo: Colors.black87,
            ),
            const SizedBox(height: 8),
            _botaoRisco(
              icon: Icons.warning_amber_rounded,
              texto: 'NOVO RISCO',
              data: 'Hoje',
              corFundo: Colors.black87,
            ),
            const SizedBox(height: 8),
            _botaoRisco(
              icon: Icons.check_circle_outline,
              texto: 'RISCO RESOLVIDO',
              data: 'Hoje',
              corFundo: Colors.black87,
            ),
            const SizedBox(height: 8),
            _botaoRisco(
              icon: Icons.warning_amber_rounded,
              texto: 'NOVO RISCO',
              data: 'Ontem',
              corFundo: Colors.black87,
            ),
          ],
        ),
      ),
    );
  }

  Widget _botaoRisco({
    required IconData icon,
    required String texto,
    required String data,
    required Color corFundo,
  }) {
    return Container(
      width: 250, // largura fixa para alinhar e ficar centralizado
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
      decoration: BoxDecoration(
        color: corFundo,
        borderRadius: BorderRadius.circular(25),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: Colors.white),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              texto,
              style: const TextStyle(
                  color: Colors.white, fontWeight: FontWeight.bold),
            ),
          ),
          Text(
            data,
            style: const TextStyle(color: Colors.white70),
          ),
        ],
      ),
    );
  }
}
