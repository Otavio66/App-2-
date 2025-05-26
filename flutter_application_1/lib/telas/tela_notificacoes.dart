import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

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
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('riscos')
            .orderBy('data', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Erro ao carregar riscos'));
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final riscos = snapshot.data!.docs;

          if (riscos.isEmpty) {
            return const Center(
              child: Text(
                'Nenhum risco encontrado',
                style: TextStyle(color: Colors.white70),
              ),
            );
          }

          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: riscos.length,
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final risco = riscos[index];
              final nomeProblema = risco['nomeProblema'] ?? 'Sem título';
              final categoria = risco['categoria'] ?? 'Sem categoria';
              final status = risco['status'] ?? 'Desconhecido';

              final timestamp = risco['data'] as Timestamp?;
              final dataFormatada = timestamp != null
                  ? DateTime.fromMillisecondsSinceEpoch(
                      timestamp.millisecondsSinceEpoch)
                  : DateTime.now();

              IconData icone = Icons.warning_amber_rounded;
              Color corFundo = Colors.black87;
              if (status.toString().toLowerCase() == 'resolvido') {
                icone = Icons.check_circle_outline;
                corFundo = Colors.green[800]!;
              } else if (status.toString().toLowerCase() == 'ativo') {
                icone = Icons.warning_amber_rounded;
                corFundo = Colors.red[800]!;
              }

              return Container(
                padding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
                decoration: BoxDecoration(
                  color: corFundo,
                  borderRadius: BorderRadius.circular(25),
                ),
                child: Row(
                  children: [
                    Icon(icone, color: Colors.white),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            nomeProblema,
                            style: const TextStyle(
                                color: Colors.white, fontWeight: FontWeight.bold),
                          ),
                          Text(
                            categoria,
                            style: const TextStyle(
                              color: Colors.white70,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Text(
                      '${dataFormatada.day}/${dataFormatada.month} ${dataFormatada.hour}:${dataFormatada.minute.toString().padLeft(2, '0')}',
                      style: const TextStyle(color: Colors.white70),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
