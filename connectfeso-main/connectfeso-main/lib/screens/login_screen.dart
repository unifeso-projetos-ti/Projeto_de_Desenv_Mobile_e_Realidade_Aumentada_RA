import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'register_screen.dart';
import 'home_screen.dart';
import 'resetpass_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _obscurePassword = true; // Para alternar a visibilidade da senha

  Future<void> _loginWithEmail() async {
    try {
      if (_emailController.text.trim().isEmpty ||
          _passwordController.text.trim().isEmpty) {
        _showAlertDialog('Por favor, preencha todos os campos.');
        return;
      }

      await _auth.signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      _showAlertDialog('Login bem-sucedido!');
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomeScreen()),
      );
    } catch (e) {
      // _showAlertDialog('Erro ao fazer login!');
      _showAlertDialog('Erro ao fazer login: $e'); //informa qual erro
    }
  }

  Future<void> _loginWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      final GoogleSignInAuthentication? googleAuth =
      await googleUser?.authentication;

      if (googleAuth == null) return;

      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      await _auth.signInWithCredential(credential);
      _showAlertDialog('Login com Google bem-sucedido!');

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomeScreen()),
      );
    } catch (e) {
      // _showAlertDialog('Erro ao fazer login com Google!');
      _showAlertDialog('Erro ao fazer login com Google: $e'); // informa qual erro
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
      backgroundColor: Color(0xF5F5F5F5),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Logo
              Image.asset(
                'assets/connectfeso.png',
                height: 50,
              ),
              SizedBox(height: 10),

              // Campo de e-mail
              _buildTextField("E-mail", _emailController),
              SizedBox(height: 10),

              // Campo de senha
              _buildTextField(
                "Senha",
                _passwordController,
                isPassword: true,
              ),
              SizedBox(height: 0),

              // Esqueceu a senha
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => ResetPassScreen()),
                    );
                  },
                  child: Text(
                    "Esqueceu a senha?",
                    style: TextStyle(color: Color(0xFF006B64)),
                  ),
                ),
              ),
              SizedBox(height: 0),

              // Botão de Login
              _buildLoginButton("Entrar", _loginWithEmail),
              SizedBox(height: 10),

              // Cadastro
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Não tem uma conta? "),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => RegisterScreen()),
                      );
                    },
                    child: Text(
                      "Cadastre-se",
                      style: TextStyle(
                          color: Color(0xFF006B64),
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10),

              // Login com Google
              _buildGoogleLoginButton(),
            ],
          ),
        ),
      ),
    );
  }


  // caixa de texto
  Widget _buildTextField(String hint, TextEditingController controller,
      {bool isPassword = false}) {
    return TextField(
      controller: controller,
      obscureText: isPassword ? _obscurePassword : false,
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

        suffixIcon: isPassword
            ? IconButton(
          icon: Icon(
            _obscurePassword ? Icons.visibility_off : Icons.visibility,
            color: Colors.grey,
          ),
          onPressed: () {
            setState(() {
              _obscurePassword = !_obscurePassword;
            });
          },
        )
            : null,
      ),
      style: TextStyle(color: Colors.teal.shade900), // Cor do texto digitado
      cursorColor: Colors.teal.shade700, // Cor do cursor piscante
    );
  }

  // botão verde
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


  // botão do google
  Widget _buildGoogleLoginButton() {
    return ElevatedButton(
      onPressed: _loginWithGoogle,
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.white,
        elevation: 2,
        minimumSize: Size(double.infinity, 50),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide(color: Colors.grey.shade400),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SvgPicture.asset(
            'assets/google.svg',
            height: 24,
            width: 24,
          ),
          SizedBox(width: 10),
          Text(
            'Entrar com Google',
            style: TextStyle(color: Colors.black),
          ),
        ],
      ),
    );
  }
}

