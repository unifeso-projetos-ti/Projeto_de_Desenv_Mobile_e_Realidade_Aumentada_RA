import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:carousel_slider/carousel_slider.dart';
import '360_screen.dart';



class LocalizationScreen extends StatefulWidget {

  @override
  State<LocalizationScreen> createState() => _LocalizationScreen();
}

class _LocalizationScreen extends State<LocalizationScreen> {
  late GoogleMapController _mapController;

  final List<Map<String, dynamic>> locais = [
    {
      'campusId': '1',
      'titulo': 'Campus Antonio Paulo Capanema de Souza',
      'imagem': 'assets/foto_sede.jpg',
      'posicao': LatLng(-22.433915, -42.979152),
    },
    {
      'campusId': '2',
      'titulo': 'Campus Quinta do Paraíso',
      'imagem': 'assets/foto_fazenda.jpg',
      'posicao': LatLng(-22.393867, -42.959523),
    },
    {
      'campusId': '3',
      'titulo': 'Centro Cultural Feso Pro Arte',
      'imagem': 'assets/foto_proarte.jpg',
      'posicao': LatLng(-22.440599, -42.978091),
    },
  ];

  int _currentIndex = 0;
  Set<Marker> _markers = {};

  void _onMapCreated(GoogleMapController controller) {
    _mapController = controller;
    _atualizarMapa();
  }

  void _atualizarMapa() {
    final local = locais[_currentIndex];

    _mapController.animateCamera(
      CameraUpdate.newLatLng(local['posicao']),
    );

    setState(() {
      _markers = {
        Marker(
          markerId: MarkerId("local"),
          position: local['posicao'],
          infoWindow: InfoWindow(
            title: local['titulo'],
            snippet: "Clique para ver o tour 360º",
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => TourScreen(campusId: locais[_currentIndex]['campusId']),
                ),
              );
            },
          ),
        ),
      };
    });

    Future.delayed(Duration(milliseconds: 500), () {
      _mapController.showMarkerInfoWindow(MarkerId("local"));
    });
  }

  void _onCarouselChanged(int index, CarouselPageChangedReason reason) {
    setState(() {
      _currentIndex = index;
    });
    _atualizarMapa();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF5F5F5),
      appBar: AppBar(
        backgroundColor: Color(0xFF006B64),
        title: Image.asset(
          "assets/tour_360_branco_sem_fundo.png",
          height: 40,
        ),
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: Column(
        children: [
          // MAPA
          Container(
            height: MediaQuery.of(context).size.height * 0.56,
            child: GoogleMap(
              onMapCreated: _onMapCreated,
              initialCameraPosition: CameraPosition(
                target: locais[0]['posicao'],
                zoom: 17.5,
              ),
              markers: _markers,
            ),
          ),

          // CARROSSEL PRINCIPAL
          SizedBox(
            height: 220, // Ajuste esse valor para subir ou descer
            child: CarouselSlider.builder(
              itemCount: locais.length,
              itemBuilder: (context, index, realIdx) {
                final local = locais[index];
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      local['titulo'],
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    SizedBox(height: 10),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: Image.asset(
                        local['imagem'],
                        height: 150,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ],
                );
              },
              options: CarouselOptions(
                enlargeCenterPage: true,
                autoPlay: true,
                autoPlayInterval: Duration(seconds: 15),
                onPageChanged: _onCarouselChanged,
              ),
            ),
          )

        ],
      ),
    );
  }
}