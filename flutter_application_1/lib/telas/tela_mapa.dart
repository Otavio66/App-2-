import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geocoding/geocoding.dart';

class TelaMapa extends StatefulWidget {
  const TelaMapa({super.key});

  @override
  State<TelaMapa> createState() => _TelaMapaState();
}

class _TelaMapaState extends State<TelaMapa> {
  final Set<Marker> _marcadores = {};
  late GoogleMapController _mapaController;
  Map<String, dynamic>? riscoSelecionado;

  @override
  void initState() {
    super.initState();
    _carregarMarcadoresDosRiscos();
  }

  Future<void> _carregarMarcadoresDosRiscos() async {
    final snapshot = await FirebaseFirestore.instance.collection('registro_riscos').get();

    List<LatLng> coordenadas = [];
    Set<Marker> novosMarcadores = {};

    double? minLat, maxLat, minLng, maxLng;

    for (var doc in snapshot.docs) {
      final data = doc.data();
      final nome = data['nomeProblema'] ?? 'Risco';
      final risco = (data['risco'] is int)
          ? data['risco']
          : int.tryParse(data['risco']?.toString() ?? '0') ?? 0;
      final fotoUrl = data['fotoUrl'] ?? '';
      final localizacaoTexto = data['localizacao'] ?? '';

      try {
        final partes = localizacaoTexto.split(',');
        final lat = double.parse(partes[0].split(':')[1].trim());
        final lng = double.parse(partes[1].split(':')[1].trim());

        final latLng = LatLng(lat, lng);
        coordenadas.add(latLng);

        minLat = (minLat == null) ? lat : (lat < minLat ? lat : minLat);
        maxLat = (maxLat == null) ? lat : (lat > maxLat ? lat : maxLat);
        minLng = (minLng == null) ? lng : (lng < minLng ? lng : minLng);
        maxLng = (maxLng == null) ? lng : (lng > maxLng ? lng : maxLng);

        double hue;
        switch (risco) {
          case 0:
          case 1:
            hue = BitmapDescriptor.hueGreen;
            break;
          case 2:
            hue = BitmapDescriptor.hueYellow;
            break;
          case 3:
            hue = BitmapDescriptor.hueOrange;
            break;
          case 4:
            hue = BitmapDescriptor.hueRose;
            break;
          case 5:
            hue = BitmapDescriptor.hueRed;
            break;
          default:
            hue = BitmapDescriptor.hueAzure;
        }

        novosMarcadores.add(
          Marker(
            markerId: MarkerId(doc.id),
            position: latLng,
            icon: BitmapDescriptor.defaultMarkerWithHue(hue),
            zIndex: risco.toDouble(),
            onTap: () async {
              final placemarks = await placemarkFromCoordinates(lat, lng);
              final lugar = placemarks.isNotEmpty ? placemarks.first : null;

              final endereco = lugar != null
                  ? [
                      if (lugar.street != null) lugar.street,
                      if (lugar.subThoroughfare != null) lugar.subThoroughfare,
                      if (lugar.subLocality != null) lugar.subLocality,
                      if (lugar.locality != null) lugar.locality,
                      if (lugar.administrativeArea != null) lugar.administrativeArea,
                      if (lugar.postalCode != null) 'CEP: ${lugar.postalCode}',
                    ].join(', ')
                  : 'Endereço desconhecido';

              setState(() {
                riscoSelecionado = {
                  'nome': nome,
                  'risco': risco,
                  'endereco': endereco,
                  'fotoUrl': fotoUrl,
                };
              });
            },
          ),
        );
      } catch (e) {
        print('Erro ao processar risco ${doc.id}: $e');
      }
    }

    setState(() {
      _marcadores.clear();
      _marcadores.addAll(novosMarcadores);
    });

    // Ajuste do zoom para enquadrar os riscos
    if (coordenadas.length == 1) {
      _mapaController.animateCamera(CameraUpdate.newLatLngZoom(coordenadas.first, 15));
    } else if (minLat != null && maxLat != null && minLng != null && maxLng != null) {
      final bounds = LatLngBounds(
        southwest: LatLng(minLat, minLng),
        northeast: LatLng(maxLat, maxLng),
      );

      await Future.delayed(const Duration(milliseconds: 500));
      _mapaController.animateCamera(CameraUpdate.newLatLngBounds(bounds, 60));
    }
  }

  Widget _bolinhaGravidade(int risco) {
    Color cor;
    switch (risco) {
      case 0:
      case 1:
        cor = Colors.green;
        break;
      case 2:
        cor = Colors.amber;
        break;
      case 3:
        cor = Colors.orange;
        break;
      case 4:
        cor = Colors.pinkAccent;
        break;
      case 5:
        cor = Colors.red;
        break;
      default:
        cor = Colors.blue;
    }

    return Container(
      width: 14,
      height: 14,
      margin: const EdgeInsets.only(right: 8),
      decoration: BoxDecoration(
        color: cor,
        shape: BoxShape.circle,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey[900],
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          'Mapa de Riscos',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
      ),
      body: Stack(
        children: [
          GoogleMap(
            initialCameraPosition: const CameraPosition(
              target: LatLng(-14.2350, -51.9253),
              zoom: 4,
            ),
            markers: _marcadores,
            onMapCreated: (controller) {
              _mapaController = controller;
            },
          ),
          if (riscoSelecionado != null)
            Positioned(
              left: 16,
              right: 16,
              bottom: 20,
              child: Material(
                elevation: 10,
                borderRadius: BorderRadius.circular(15),
                color: Colors.grey[900],
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Align(
                        alignment: Alignment.topRight,
                        child: GestureDetector(
                          onTap: () {
                            setState(() => riscoSelecionado = null);
                          },
                          child: const Icon(Icons.close, color: Colors.red),
                        ),
                      ),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.network(
                          riscoSelecionado!['fotoUrl'],
                          height: 140,
                          width: double.infinity,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) => Container(
                            height: 140,
                            color: Colors.grey[700],
                            child: const Center(
                              child: Icon(Icons.image_not_supported, size: 40, color: Colors.white),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        riscoSelecionado!['nome'],
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          _bolinhaGravidade(riscoSelecionado!['risco']),
                          Text(
                            'Gravidade: ${riscoSelecionado!['risco']}/5',
                            style: const TextStyle(color: Colors.white70),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        riscoSelecionado!['endereco'] ?? 'Endereço desconhecido',
                        style: const TextStyle(color: Colors.white70),
                      ),
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
