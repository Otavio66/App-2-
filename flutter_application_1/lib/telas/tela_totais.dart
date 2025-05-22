import 'package:flutter/material.dart';

class TelaTotais extends StatelessWidget {
  const TelaTotais({super.key});

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
          'Totais',
          style: TextStyle(color: Colors.grey, fontSize: 14),
        ),
      ),
      body: const Center(
        child: Text(
          'Tela Totais vazia',
          style: TextStyle(color: Colors.white70, fontSize: 16),
        ),
      ),
    );
  }
}
