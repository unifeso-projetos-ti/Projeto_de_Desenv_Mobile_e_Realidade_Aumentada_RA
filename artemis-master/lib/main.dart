import 'package:flutter/material.dart';
import 'package:flutter_app/screens/ar_screen.dart';
import 'screens/signup.dart';
import 'screens/register.dart';
import 'screens/login.dart';
import 'widgets/artemis_button.dart';

void main() {
  runApp(const ArtemisApp());
}

class ArtemisApp extends StatelessWidget {
  const ArtemisApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Artemis',
      home: ArtemisLandingPage(),
    );
  }
}

class ArtemisLandingPage extends StatelessWidget {
  const ArtemisLandingPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Artemis'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Welcome to Artemis!',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            const Text(
              'Your journey starts here.',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 20),
            ArtemisButton(
              backgroundColor: const Color(0xFFAB2628),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const RegisterPage()),
                );
              },
              text: 'Register',
            ),
            ArtemisButton(
              backgroundColor: const Color(0xFFAB2628),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ARScreen()),
                );
              },
              text: 'AR PAGE',
            ),
            // Navigate to LoginPage on button press
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const RegisterPage()),
                );
              },
              child: const Text('Register'),
            ),
            // Botão para navegação para a tela de registro
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SignUp()),
                );
              },
              child: const Text('login'),
            ),

            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Login()),
                );
              },
              child: const Text('login1'),
            ),
          ],
        ),
      ),
    );
  }
}
