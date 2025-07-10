import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'splash_screen.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(); // Inicializa Firebase

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: true, // habilida a tarja DEBUG no topo do APP
      title: 'Connect Feso',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: SplashScreen(), // Define a Splash Screen como a primeira tela
    );
  }
}

