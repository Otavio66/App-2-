import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import '../utils/riscos_lidos.dart';

final _local = FlutterLocalNotificationsPlugin();

class TelaNotificacoes extends StatefulWidget {
  const TelaNotificacoes({super.key});
  @override
  State<TelaNotificacoes> createState() => _TelaNotificacoesState();
}

class _TelaNotificacoesState extends State<TelaNotificacoes> {
  Set<String> _jaLidos = {};

  @override
  void initState() {
    super.initState();
    // carrega IDs lidos salvos no aparelho
    RiscosLidos.carregar().then((set) => setState(() => _jaLidos = set));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[900],
      appBar: AppBar(
        backgroundColor: Colors.grey[900],
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Novas ocorrências',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream:
            FirebaseFirestore.instance
                .collection('registro_riscos')
                .where('status', isEqualTo: 'Ativo')
                .orderBy('createdAt', descending: true)
                .snapshots(),
        builder: (context, snap) {
          if (snap.hasError) {
            return const Center(child: Text('Erro ao carregar dados'));
          }
          if (snap.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          // descarta IDs já lidos
          final docs =
              (snap.data?.docs ?? [])
                  .where((d) => !_jaLidos.contains(d.id))
                  .toList();

          if (docs.isEmpty) {
            return const Center(child: Text('Nenhuma ocorrência nova'));
          }

          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: docs.length,
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (context, i) {
              final doc = docs[i];
              final data = doc.data()! as Map<String, dynamic>;

              final nome = data['nomeProblema'] ?? 'Sem título';
              final cat = data['categoria'] ?? 'Sem categoria';

              return InkWell(
                borderRadius: BorderRadius.circular(25),
                onTap: () async {
                  // abre detalhes
                  Navigator.pushNamed(
                    context,
                    '/detalheOcorrencia',
                    arguments: {'docId': doc.id},
                  );

                  // marca como lido apenas no aparelho
                  await RiscosLidos.adicionar(doc.id);
                  setState(() => _jaLidos.add(doc.id));

                  // cancela a notificação na bandeja (se existir)
                  await _local.cancel(doc.id.hashCode);
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    vertical: 10,
                    horizontal: 16,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.red[800],
                    borderRadius: BorderRadius.circular(25),
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.warning_amber_rounded,
                        color: Colors.white,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              nome,
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              cat,
                              style: const TextStyle(
                                color: Colors.white70,
                                fontSize: 12,
                              ),
                            ),
                          ],
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
