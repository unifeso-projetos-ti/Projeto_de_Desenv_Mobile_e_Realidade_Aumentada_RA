import 'package:flutter/material.dart';
import '../models/user_account_manager.dart';
import '../models/favorites_manager.dart';

class MinhaContaPage extends StatefulWidget {
  final bool showFormInitially;
  const MinhaContaPage({super.key, this.showFormInitially = false});

  @override
  State<MinhaContaPage> createState() => _MinhaContaPageState();
}

class _MinhaContaPageState extends State<MinhaContaPage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _passwordController;
  bool _editing = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: userAccountManager.nome);
    _emailController = TextEditingController(text: userAccountManager.email);
    _passwordController = TextEditingController(text: userAccountManager.senha);
    _editing = widget.showFormInitially || !userAccountManager.hasAccount;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _save() {
    if (_formKey.currentState!.validate()) {
      userAccountManager.saveAccount(
        nome: _nameController.text,
        email: _emailController.text,
        senha: _passwordController.text,
      );
      setState(() {
        _editing = false;
      });
    }
  }

  void _confirmClearFavorites() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Limpar Favoritos'),
        content: const Text('Tem certeza que deseja limpar os favoritos?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () {
              favoritesManager.clearFavorites();
              Navigator.pop(context);
            },
            child: const Text('Confirmar'),
          ),
        ],
      ),
    );
  }

  Widget _buildForm() {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          TextFormField(
            controller: _nameController,
            decoration: const InputDecoration(labelText: 'Nome'),
            validator: (value) =>
                value == null || value.isEmpty ? 'Informe o nome' : null,
          ),
          TextFormField(
            controller: _emailController,
            decoration: const InputDecoration(labelText: 'Email'),
            validator: (value) {
              if (value == null || value.isEmpty) return 'Informe o email';
              if (!value.contains('@')) return 'Email inválido';
              return null;
            },
          ),
          TextFormField(
            controller: _passwordController,
            decoration: const InputDecoration(labelText: 'Senha'),
            obscureText: true,
            validator: (value) =>
                value == null || value.length < 4 ? 'Senha muito curta' : null,
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: _save,
            child: const Text('Salvar'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Minha Conta')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            if (_editing)
              _buildForm()
            else if (userAccountManager.hasAccount) ...[
              Text('Nome: ${userAccountManager.nome}'),
              Text('Email: ${userAccountManager.email}'),
              const SizedBox(height: 8),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    _editing = true;
                  });
                },
                child: const Text('Editar Dados'),
              ),
            ] else
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    _editing = true;
                  });
                },
                child: const Text('Criar Conta'),
              ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _confirmClearFavorites,
              child: const Text('Limpar Favoritos'),
            ),
          ],
        ),
      ),
    );
  }
}
