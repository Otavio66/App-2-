import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class TesteFirestore extends StatelessWidget {
  const TesteFirestore({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Teste Firestore')),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('registro_riscos').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Erro: ${snapshot.error}'));
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final docs = snapshot.data!.docs;

          if (docs.isEmpty) {
            return const Center(child: Text('Nenhum documento encontrado'));
          }

          return ListView(
            children: docs.map((doc) {
              final data = doc.data()! as Map<String, dynamic>;
              return ListTile(
                title: Text(data['nomeProblema'] ?? 'Sem nome'),
                subtitle: Text(data['status'] ?? 'Sem status'),
              );
            }).toList(),
          );
        },
      ),
    );
  }
}
