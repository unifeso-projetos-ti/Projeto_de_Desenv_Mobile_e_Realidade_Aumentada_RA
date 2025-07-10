import 'package:flutter/material.dart';

import '../models/favorites_manager.dart';
import '../widgets/product_card.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Favoritos'),
      ),
      body: AnimatedBuilder(
        animation: favoritesManager,
        builder: (context, _) {
          final favorites = favoritesManager.favorites;
          if (favorites.isEmpty) {
            return const Center(
              child: Text('Nenhum produto favorito'),
            );
          }
          return GridView.builder(
            padding: const EdgeInsets.all(16),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: 0.89,
            ),
            itemCount: favorites.length,
            itemBuilder: (context, index) {
              final product = favorites[index];
              return ProductCard(product: product);
            },
          );
        },
      ),
    );
  }
}