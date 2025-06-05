import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'tela_notificacoes.dart';
import 'tela_totais.dart';
import 'tela_ativos.dart';
import 'tela_resolvidos.dart';
import 'tela_perfil.dart';
import 'tela_mapa.dart'; // <-- IMPORTAÇÃO DA NOVA TELA

class TelaInicial extends StatelessWidget {
  final String nomeUsuario;

  const TelaInicial({super.key, required this.nomeUsuario});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    final emailUsuario = user?.email ?? 'SEM EMAIL';

    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.grey[500],
      appBar: AppBar(
        backgroundColor: Colors.grey[500],
        elevation: 0,
        title: const Text(
          'Tela Inicial',
          style: TextStyle(color: Colors.grey, fontSize: 14),
        ),
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications, color: Colors.white),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const TelaNotificacoes()),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.menu, color: Colors.white),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => TelaPerfil(
                    nomeUsuario: nomeUsuario,
                    emailUsuario: emailUsuario,
                  ),
                ),
              );
            },
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 20),
            Text(
              'BEM VINDO, $nomeUsuario !',
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
            const SizedBox(height: 50),
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black87,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25),
                ),
                minimumSize: Size(screenWidth * 0.6, 50),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const TelaMapa()),
                );
              },
              icon: const Icon(Icons.location_on),
              label: const Text(
                'MAPA',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
            ),
            const SizedBox(height: 40),
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black87,
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(15),
                        topRight: Radius.circular(15),
                      ),
                    ),
                    minimumSize: Size(screenWidth * 0.6, 50),
                  ),
                  onPressed: () {},
                  icon: const Icon(Icons.warning_amber_rounded),
                  label: const Text(
                    'RISCOS',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                ),
                Container(
                  width: screenWidth * 0.6,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(15),
                      bottomRight: Radius.circular(15),
                    ),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  child: Column(
                    children: [
                      _itemLink(context, 'Totais', const TelaTotais()),
                      const SizedBox(height: 12),
                      _itemLink(context, 'Ativos', const TelaAtivos()),
                      const SizedBox(height: 12),
                      _itemLink(context, 'Resolvidos', const TelaResolvidos()),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _itemLink(BuildContext context, String label, Widget target) {
    return GestureDetector(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (_) => target));
      },
      child: Text(
        label,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 16,
          decoration: TextDecoration.underline,
          color: Colors.black,
        ),
      ),
    );
  }
}
