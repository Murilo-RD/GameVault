import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:game_vault/Controller/SteamApiController.dart';

import 'Home.dart';
import 'Login.dart';


class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  @override
  void initState() {
    super.initState();
    _verificarSessao();
  }

  Future<void> _verificarSessao() async {
    // Aguarda um momento (para mostrar um logo, se quiser)
    await Future.delayed(Duration(seconds: 2));

    // O Firebase Auth nos diz se há um usuário logado
    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      SteamApiController.usuario = user;
      // Usuário JÁ ESTÁ LOGADO
      print("Usuário já logado: ${user.uid}");
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => Home()), // Vai para a Home
      );
    } else {
      // Ninguém logado
      print("Nenhum usuário logado.");
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => Login()), // Vai para o Login
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // Uma tela de carregamento simples
    return Scaffold(
      backgroundColor: Color(0xFF1E1E1E), // Cor de fundo do seu app
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(color: Colors.white),
            SizedBox(height: 20),
            Text(
              'Carregando...',
              style: TextStyle(color: Colors.white, fontSize: 18),
            )
          ],
        ),
      ),
    );
  }
}