import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class TelaRelatorio extends StatefulWidget {
  const TelaRelatorio({super.key});

  @override
  State<TelaRelatorio> createState() => _TelaRelatorioState();
}

class _TelaRelatorioState extends State<TelaRelatorio> {
  String periodoSelecionado = 'Hoje';
  String tipoRiscoSelecionado = 'Todos';

  final List<String> periodos = ['Hoje', 'Essa Semana', 'Este Mês'];
  final List<String> tiposRisco = [
    'Todos',
    'Risco Elétrico',
    'Risco de Queda',
    'Risco Estrutural',
    'Outros',
  ];

  int totalOcorrencias = 0;
  double mediaRisco = 0;
  int resolvidos = 0;

  @override
  void initState() {
    super.initState();
    _carregarDados();
  }

  void _carregarDados() async {
    DateTime agora = DateTime.now();
    DateTime inicio;

    if (periodoSelecionado == 'Hoje') {
      inicio = DateTime(agora.year, agora.month, agora.day);
    } else if (periodoSelecionado == 'Essa Semana') {
      inicio = agora.subtract(const Duration(days: 7));
    } else {
      inicio = agora.subtract(const Duration(days: 30));
    }

    Query query = FirebaseFirestore.instance
        .collection('registro_riscos')
        .where('createdAt', isGreaterThanOrEqualTo: inicio);

    if (tipoRiscoSelecionado != 'Todos') {
      query = query.where('categoria', isEqualTo: tipoRiscoSelecionado);
    }

    final snapshot = await query.get();
    final docs = snapshot.docs;

    int total = docs.length;
    int resolvidosLocal = 0;
    double somaRisco = 0;

    for (var doc in docs) {
      final data = doc.data() as Map<String, dynamic>;
      final gravidade = (data['risco'] ?? 0).toInt();
      final status = data['status'] ?? '';

      if (status.toString().toLowerCase() == 'resolvido'.toLowerCase())
        resolvidosLocal++;

      somaRisco += gravidade;
    }

    setState(() {
      totalOcorrencias = total;
      resolvidos = resolvidosLocal;
      mediaRisco = total > 0 ? somaRisco / total : 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Relatório'),
        backgroundColor: Colors.grey[700],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children:
                  periodos.map((periodo) {
                    return ElevatedButton(
                      onPressed: () {
                        setState(() {
                          periodoSelecionado = periodo;
                          _carregarDados();
                        });
                      },
                      child: Text(periodo),
                    );
                  }).toList(),
            ),
            const SizedBox(height: 20),
            DropdownButton<String>(
              value: tipoRiscoSelecionado,
              items:
                  tiposRisco.map((tipo) {
                    return DropdownMenuItem(value: tipo, child: Text(tipo));
                  }).toList(),
              onChanged: (novoTipo) {
                setState(() {
                  tipoRiscoSelecionado = novoTipo!;
                  _carregarDados();
                });
              },
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildCard('Ocorrências', totalOcorrencias.toString()),
                _buildCard('Média de Risco', mediaRisco.toStringAsFixed(1)),
                _buildCard('Resolvidos', resolvidos.toString()),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCard(String titulo, String valor) {
    return Card(
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        child: Column(
          children: [
            Text(titulo, style: const TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 6),
            Text(valor, style: const TextStyle(fontSize: 18)),
          ],
        ),
      ),
    );
  }
}
