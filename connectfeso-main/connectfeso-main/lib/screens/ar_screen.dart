import 'package:flutter/material.dart';

class ARScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF5F5F5),
      appBar: AppBar(
        backgroundColor: Color(0xFF006B64),
        title: Text('Realidade Aumentada'),
        // title: Image.asset(
        //   "assets/tour_360_branco_sem_fundo.png",
        //   height: 40,
        // ),
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: Center(
        child:
        Image.asset(
          "assets/construcao.png",
          height: 500,
          width: 500,
          fit: BoxFit.contain, // ou BoxFit.cover, BoxFit.fill, etc.
        ),
      ),
    );
  }
}
