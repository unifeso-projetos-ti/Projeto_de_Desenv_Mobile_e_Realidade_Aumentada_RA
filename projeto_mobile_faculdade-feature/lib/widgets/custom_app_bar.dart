import 'package:flutter/material.dart';

import '../models/user_account_manager.dart';

class CustomAppBar extends StatelessWidget {
  const CustomAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: userAccountManager,
      builder: (context, _) {
        final hasAccount = userAccountManager.hasAccount;
        final name = userAccountManager.nome ?? 'Visitante';

        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Olá,',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.deepPurple,
                  ),
                ),
                Text(
                  hasAccount ? name : 'Visitante',
                  style: TextStyle(
                    fontSize: 24,
                    color: Colors.deepPurple[300],
                  ),
                ),
              ],
            ),
            IconButton(
              icon: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.deepPurple[100],
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.shopping_cart,
                  color: Colors.deepPurple,
                  size: 28,
                ),
              ),
              onPressed: () {},
            ),
          ],
        );
      },
    );
  }
}