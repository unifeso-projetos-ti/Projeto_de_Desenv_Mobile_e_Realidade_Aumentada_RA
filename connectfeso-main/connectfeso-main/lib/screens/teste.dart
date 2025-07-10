import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';

class MenuTeste extends StatelessWidget {

  final List<Map<String, String>> imagens = [
    {
      'titulo': 'Campus Antonio Paulo Capanema de Souza',
      'path': 'assets/foto_sede.jpg'
    },
    {
      'titulo': 'Campus Quinta do Paraíso',
      'path': 'assets/foto_fazenda.jpg'
    },
    {
      'titulo': 'Centro Cultural Feso Pro Arte',
      'path': 'assets/foto_proarte.jpg'
    },
  ];

  @override
  Widget build(BuildContext context) {
    final reversedImagens = List.from(imagens.reversed);
    final alturaDisponivel = MediaQuery.of(context).size.height -
        kToolbarHeight - MediaQuery.of(context).padding.top;

    return Scaffold(
      backgroundColor: Color(0xFFF5F5F5),
      appBar: AppBar(
        backgroundColor: Color(0xFF006B64),
        title: Image.asset(
          "assets/connect_feso_branco.png",
          height: 40,
        ),
        iconTheme: IconThemeData(color: Colors.white),
      ),

      body: Stack(
        children: [
          // Carrossel de fundo com transparência
          Opacity(
            opacity: 0.2,
            child: CarouselSlider(
              items: reversedImagens.map((img) {
                return Image.asset(
                  img['path']!,
                  fit: BoxFit.cover,
                  width: double.infinity,
                );
              }).toList(),
              options: CarouselOptions(
                autoPlay: true,
                viewportFraction: 1.0,
                height: alturaDisponivel,
                reverse: true,
                autoPlayInterval: Duration(seconds: 6),
              ),
            ),
          ),

          // Conteúdo principal
          Center(
            child: Align(
              alignment: Alignment(0, 0.8),
              child: CarouselSlider(
                items: imagens.map((img) {
                  return
                    SizedBox(
                      height: 280, // altura fixa para o item do carrossel
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16.0),
                            child: Text(
                              img['titulo']!,
                              textAlign: TextAlign.center,
                              softWrap: true,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                shadows: [Shadow(color: Colors.black, blurRadius: 10)],
                              ),
                            ),
                          ),

                          SizedBox(height: 10),
                          Expanded(
                            child: GestureDetector(
                              onTap: () {
                                print("Clicou em ${img['titulo']}");
                              },
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(16),
                                child: Image.asset(
                                  img['path']!,
                                  fit: BoxFit.cover,
                                  width: double.infinity,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    );

                }).toList(),
                options: CarouselOptions(
                  autoPlay: true,
                  enlargeCenterPage: true,
                  height: 200,
                  autoPlayInterval: Duration(seconds: 6),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
