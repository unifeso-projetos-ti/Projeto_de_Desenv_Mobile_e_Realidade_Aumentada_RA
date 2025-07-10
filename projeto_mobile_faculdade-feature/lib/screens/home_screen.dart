import 'package:flutter/material.dart';

import '../models/product.dart';
import '../widgets/custom_app_bar.dart';
import '../widgets/product_card.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});

  final List<Product> products = [
    Product(
      name: 'Cadeira',
      description: 'de Abeto',
      details:
          'Transforme sua casa com essa cadeira, perfeita para quem busca sofisticação e aconchego. Feita com material de alta qualidade, ela proporciona máximo conforto para seus momentos de descanso. Com design moderno e diversas opções de cores, combina perfeitamente com qualquer decoração.',
      price: 529.90,
      imageUrl: 'lib/assets/cadeira.jpeg',
      product3dname: 'old_chair',
    ),
    Product(
      name: 'Roda',
      description: 'de Carro',
      details: 'Escolha ideal para quem busca desempenho e praticidade.',
      price: 999.99,
      imageUrl: 'lib/assets/roda.jpg',
      product3dname: 'model',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const CustomAppBar(),
            const SizedBox(height: 16),
            Container(
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(12),
              ),
              child: const TextField(
                decoration: InputDecoration(
                  hintText: 'Pesquisar...',
                  border: InputBorder.none,
                  prefixIcon: Icon(Icons.search),
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            // Conteúdo da tela inicial
            Expanded(
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2, // Dois cards por linha
                  crossAxisSpacing: 16, // Espaçamento horizontal entre os cards
                  mainAxisSpacing: 16, // Espaçamento vertical entre os cards
                  childAspectRatio:
                      0.89, // Proporção de aspecto dos cards (largura/altura)
                ),
                itemCount: products.length,
                itemBuilder: (context, index) {
                  final product = products[index];
                  return ProductCard(product: product);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
