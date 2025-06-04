import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class TelaOcorrenciaScreen extends StatelessWidget {
  final String docId;
  const TelaOcorrenciaScreen({super.key, required this.docId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[900],
      appBar: AppBar(
        backgroundColor: Colors.grey[900],
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          'Detalhe da ocorrência',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: FutureBuilder<DocumentSnapshot>(
        future:
            FirebaseFirestore.instance
                .collection('registro_riscos')
                .doc(docId)
                .get(),
        builder: (context, snap) {
          if (snap.hasError) {
            return const Center(
              child: Text(
                'Erro ao carregar dados',
                style: TextStyle(color: Colors.redAccent),
              ),
            );
          }
          if (!snap.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final data = snap.data!.data()! as Map<String, dynamic>;

          final nome = data['nomeProblema'] ?? 'Sem título';
          final risco = data['risco'] ?? 0;
          final categoria = data['categoria'] ?? '—';
          final descricao = data['descricao'] ?? '—';
          final localizacao = data['localizacao'] ?? '—';
          final status = (data['status'] ?? '—').toString();
          final fotoUrl =
              data['fotoUrl'] ??
              'https://images.unsplash.com/photo-1562072544-652caf91a269?auto=format&fit=crop&w=600&q=60';

          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Card(
                color: Colors.grey[850],
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: Text(
                          nome.toUpperCase(),
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Center(
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.grey[800],
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            'Gravidade $risco/5',
                            style: const TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.network(
                          fotoUrl,
                          height: 200,
                          width: double.infinity,
                          fit: BoxFit.cover,
                          errorBuilder:
                              (_, __, ___) => Container(
                                height: 200,
                                color: Colors.grey[700],
                                child: const Center(
                                  child: Icon(
                                    Icons.image_not_supported,
                                    color: Colors.white54,
                                    size: 40,
                                  ),
                                ),
                              ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      _campo('LOCALIZAÇÃO', localizacao),
                      _campo('CATEGORIA', categoria),
                      _campo('DESCRIÇÃO', descricao),
                      const SizedBox(height: 12),
                      Center(
                        child: Text(
                          'STATUS: ${status.toUpperCase()}',
                          style: const TextStyle(
                            color: Colors.white70,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _campo(String rotulo, String valor) => Padding(
    padding: const EdgeInsets.only(bottom: 12),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          rotulo,
          style: const TextStyle(
            color: Colors.white70,
            fontWeight: FontWeight.bold,
            fontSize: 13,
          ),
        ),
        const SizedBox(height: 4),
        Text(valor, style: const TextStyle(color: Colors.white70)),
      ],
    ),
  );
}
