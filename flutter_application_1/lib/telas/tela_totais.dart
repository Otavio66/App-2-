import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class TelaTotais extends StatelessWidget {
  const TelaTotais({super.key});

  @override
  Widget build(BuildContext context) {
    final CollectionReference riscosCollection =
        FirebaseFirestore.instance.collection('registro_riscos');

    return Scaffold(
      backgroundColor: Colors.grey[900],
      appBar: AppBar(
        backgroundColor: Colors.grey[900],
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
        automaticallyImplyLeading: false,
        title: const Text(
          'Totais',
          style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: riscosCollection.snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text(
                'Erro: ${snapshot.error}',
                style: const TextStyle(color: Colors.redAccent),
              ),
            );
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final docs = snapshot.data?.docs ?? [];

          if (docs.isEmpty) {
            return const Center(
              child: Text(
                'Nenhum risco encontrado',
                style: TextStyle(color: Colors.white70, fontSize: 16),
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: docs.length,
            itemBuilder: (context, index) {
              final doc = docs[index];
              final data = doc.data()! as Map<String, dynamic>;

              final nomeProblema = data['nomeProblema'] ?? 'Sem nome';
              final risco = data['risco'] ?? 0;
              final categoria = data['categoria'] ?? '';
              final descricao = data['descricao'] ?? '';
              final localizacao = data['localizacao'] ?? '';
              final status = data['status'] ?? '';
              final fotoUrl = data['fotoUrl'] ??
                  'https://images.unsplash.com/photo-1562072544-652caf91a269?auto=format&fit=crop&w=600&q=60';

              Color gravidadeColor;
              switch (status.toLowerCase()) {
                case 'ativo':
                  gravidadeColor = Colors.green[600]!;
                  break;
                case 'resolvido':
                  gravidadeColor = Colors.blueGrey[600]!;
                  break;
                default:
                  gravidadeColor = Colors.grey[600]!;
              }

              return Card(
                color: Colors.grey[850],
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                margin: const EdgeInsets.only(bottom: 20),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: Text(
                          nomeProblema.toString().toUpperCase(),
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Center(
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                          decoration: BoxDecoration(
                            color: gravidadeColor,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            'Gravidade $risco/5',
                            style: const TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.network(
                          fotoUrl,
                          height: 180,
                          width: double.infinity,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) => Container(
                            height: 180,
                            color: Colors.grey[700],
                            child: const Center(
                              child: Icon(Icons.image_not_supported,
                                  color: Colors.white54, size: 40),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'LOCALIZAÇÃO',
                        style: TextStyle(color: Colors.white70, fontWeight: FontWeight.bold),
                      ),
                      Text(localizacao, style: const TextStyle(color: Colors.white70)),
                      const SizedBox(height: 12),
                      const Text(
                        'CATEGORIA',
                        style: TextStyle(color: Colors.white70, fontWeight: FontWeight.bold),
                      ),
                      Text(categoria, style: const TextStyle(color: Colors.white70)),
                      const SizedBox(height: 12),
                      const Text(
                        'DESCRIÇÃO',
                        style: TextStyle(color: Colors.white70, fontWeight: FontWeight.bold),
                      ),
                      Text(descricao, style: const TextStyle(color: Colors.white70)),
                      const SizedBox(height: 12),
                      Center(
                        child: Text(
                          'STATUS: ${status.toString().toUpperCase()}',
                          style: const TextStyle(color: Colors.white70, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
