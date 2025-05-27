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
            .collection('registro_riscos')
            .orderBy('data', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Center(
              child: Text(
                'Erro ao carregar riscos',
                style: TextStyle(color: Colors.white70),
              ),
            );
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final riscos = snapshot.data?.docs ?? [];

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
              final data = risco.data()! as Map<String, dynamic>;

              final nomeProblema = data['nomeProblema'] ?? 'Sem título';
              final categoria = data['categoria'] ?? 'Sem categoria';
              final status = data['status'] ?? 'Desconhecido';

              final timestamp = data['data'] as Timestamp?;
              final dataFormatada = timestamp != null
                  ? timestamp.toDate()
                  : DateTime.now();

              IconData icone = Icons.warning_amber_rounded;
              Color corFundo = Colors.black87;

              final statusLower = status.toString().toLowerCase();
              if (statusLower == 'resolvido') {
                icone = Icons.check_circle_outline;
                corFundo = Colors.green[800]!;
              } else if (statusLower == 'ativo') {
                icone = Icons.warning_amber_rounded;
                corFundo = Colors.red[800]!;
              } else {
                // status desconhecido ou outro
                icone = Icons.info_outline;
                corFundo = Colors.grey[700]!;
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
                      '${dataFormatada.day.toString().padLeft(2, '0')}/${dataFormatada.month.toString().padLeft(2, '0')} '
                      '${dataFormatada.hour.toString().padLeft(2, '0')}:${dataFormatada.minute.toString().padLeft(2, '0')}',
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
