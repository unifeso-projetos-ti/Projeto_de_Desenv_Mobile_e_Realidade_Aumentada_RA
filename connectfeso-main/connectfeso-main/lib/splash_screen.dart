// import 'package:flutter/material.dart';
// import 'package:flutter_spinkit/flutter_spinkit.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'screens/home_screen.dart'; // Tela principal
// import 'screens/login_screen.dart'; // Tela de login
//
// class SplashScreen extends StatefulWidget {
//   @override
//   _SplashScreenState createState() => _SplashScreenState();
// }
//
// class _SplashScreenState extends State<SplashScreen> {
//   @override
//   void initState() {
//     super.initState();
//     _checkLoginStatus();
//   }
//
//   Future<void> _checkLoginStatus() async {
//     await Future.delayed(Duration(seconds: 3)); // Simula um carregamento de 3s
//
//     // Verifica se o usuário está logado no Firebase
//     User? user = FirebaseAuth.instance.currentUser;
//
//     if (user != null) {
//       // Usuário autenticado → Vai para a tela principal
//       Navigator.pushReplacement(
//         context,
//         MaterialPageRoute(builder: (context) => HomeScreen()),
//       );
//     } else {
//       // Usuário não autenticado → Vai para a tela de login
//       Navigator.pushReplacement(
//         context,
//         MaterialPageRoute(builder: (context) => LoginScreen()),
//       );
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white, // Cor de fundo da Splash Screen
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Image.asset(
//               //'assets/logo_unifeso.png',
//               'assets/logo_animado.gif', // Substitua pelo seu logo// Substitua pelo seu logo
//               width: 150, // Ajuste o tamanho da logo
//             ),
//             SizedBox(height: 20),
//             SpinKitFadingCircle(
//               color: Colors.blue, // Cor do efeito de carregamento
//               size: 50.0,
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'screens/home_screen.dart'; // Tela principal
import 'screens/login_screen.dart'; // Tela de login

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
  }

  Future<void> _checkLoginStatus() async {
    await Future.delayed(Duration(seconds: 3)); // Simula carregamento
    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomeScreen()),
      );
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LoginScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Lottie.asset(
          'assets/feso_pulsando.json', // Caminho do JSON
          width: 300,
          height: 300,
          fit: BoxFit.contain,
        ),
      ),
    );
  }
}

