import 'package:flutter/material.dart';
import '../models/product.dart';
import '../models/favorites_manager.dart';
import '../models/user_account_manager.dart';
import '../screens/product_details_screen.dart';
import '../screens/minha_conta_page.dart';


class ProductCard extends StatelessWidget {
  final Product product;

  const ProductCard({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProductDetailsScreen(product: product),
          ),
        );
      }, 
    child: Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Imagem do produto com icone de favorito
          Stack(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                child: Image.asset(
                  product.imageUrl,
                  height: 120,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
              Positioned(
                top: 8,
                right: 8,
                child: AnimatedBuilder(
                  animation: favoritesManager,
                  builder: (context, _) {
                    final isFav = favoritesManager.isFavorite(product);
                    return GestureDetector(
                      onTap: () {
                        if (userAccountManager.hasAccount) {
                          favoritesManager.toggleFavorite(product);
                        } else {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const MinhaContaPage(
                                showFormInitially: true,
                              ),
                            ),
                          );
                        }
                      },
                      child: Icon(
                        isFav ? Icons.favorite : Icons.favorite_border,
                        color: Colors.deepPurple,
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
          // Detalhes do produto
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product.name,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  product.description,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'R\$${product.price.toStringAsFixed(2)}',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.deepPurple,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    )
    );
  }
}