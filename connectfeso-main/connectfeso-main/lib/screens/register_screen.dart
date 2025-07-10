import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'login_screen.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  Future<void> _register() async {
    try {
      UserCredential userCredential = await _auth
          .createUserWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      await userCredential.user?.updateDisplayName(_nameController.text.trim());

      _showAlertDialog('Cadastro realizado com sucesso!');

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LoginScreen()),
      );
    } catch (e) {
      _showAlertDialog('Erro ao cadastrar: $e');
    }
  }

  void _showAlertDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Alerta"),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text("Fechar"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Color(0xF5F5F5F5), // Quase branco
      body: SingleChildScrollView(    // Permite que o conteúdo seja rolado
        child: Column(
          children: [
            // Botão de voltar no topo
            SafeArea(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                child: Align(
                  alignment: Alignment.topLeft,
                  child: IconButton(
                    icon: Icon(Icons.arrow_back, color: Color(0xFF006B64), size: 35),
                    onPressed: () {
                      Navigator.pop(context); // Voltar para a tela anterior
                    },
                  ),
                ),
              ),
            ),

            // Formulário um pouco mais para cima
            Padding(
              padding: EdgeInsets.all(24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center, // Mantém o formulário no topo
                children: [                  // Ajuste para subir mais
                  Image.asset(
                    'assets/cadastro.png',
                    height: 100,
                  ),
                  SizedBox(height: 20),

                  _buildTextField("Nome", _nameController),
                  SizedBox(height: 10),

                  _buildTextField("E-mail", _emailController),
                  SizedBox(height: 10),

                  _buildTextField("Senha", _passwordController),
                  SizedBox(height: 20),

                  _buildLoginButton("Cadastrar", _register),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}



// caixa de texto
Widget _buildTextField(String hint, TextEditingController controller,) {
  return TextField(
    controller: controller,
    decoration: InputDecoration(
      hintText: hint,
      filled: true,
      fillColor: Colors.grey.shade100,
      contentPadding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),

      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.teal.shade700, width: 2), // Borda quando não está focado
        borderRadius: BorderRadius.circular(20), // Borda arredondada
      ),

      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.teal.shade700, width: 2), // Borda quando focado
        borderRadius: BorderRadius.circular(20),
      ),
    ),
    style: TextStyle(color: Colors.teal.shade900), // Cor do texto digitado
    cursorColor: Colors.teal.shade700, // Cor do cursor piscante
  );
}


// configurações do botão "Cadastrar"
Widget _buildLoginButton(String text, VoidCallback onPressed) {
  return ElevatedButton(
    onPressed: onPressed,
    style: ElevatedButton.styleFrom(
      backgroundColor: Color(0xFF006B64),
      minimumSize: Size(double.infinity, 50),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
    ),
    child: Text(
      text,
      style: TextStyle(fontSize: 16, color: Colors.white),
    ),
  );
}
