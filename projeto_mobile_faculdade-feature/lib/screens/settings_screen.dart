import 'package:flutter/material.dart';

import '../models/user_account_manager.dart';
import 'minha_conta_page.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Configurações'),
      ),
      body: ListView(
        children: [
          ListTile(
            leading: const Icon(Icons.person),
            title: const Text('Minha Conta'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => MinhaContaPage(
                    showFormInitially: !userAccountManager.hasAccount,
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}