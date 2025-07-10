import 'package:flutter/foundation.dart';

class UserAccountManager extends ChangeNotifier {
  String? _nome;
  String? _email;
  String? _senha;

  String? get nome => _nome;
  String? get email => _email;
  String? get senha => _senha;

  bool get hasAccount => _nome != null && _email != null;

  void saveAccount({required String nome, required String email, required String senha}) {
    _nome = nome;
    _email = email;
    _senha = senha;
    notifyListeners();
  }
}

final UserAccountManager userAccountManager = UserAccountManager();
