import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:game_vault/Controller/ListaPromocao.dart';
import 'package:game_vault/Controller/SteamApiController.dart';
import 'package:game_vault/Tela/TelaPrincipal.dart';

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
      SteamApiController.getUserData().then((dados){
        SteamApiController.atualizarNomeUsuario(user.uid, dados['response']['players'][0]['personaname']);
        FirebaseFirestore.instance.collection("users").doc(user.uid).get().then((data){
          SteamApiController.userData = data.data();
          print("Usuário já logado: ${user.uid}");
          ListaPromocao.getWishlistPromotionsBrl();
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => TelaPrincipal()), // Vai para a Home
          );
        });
      });

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
      backgroundColor: Color(0xFF1A1920), // Cor de fundo do seu app
      body: Center(
        child: Container(
          decoration: BoxDecoration(
            image: DecorationImage(image: AssetImage('assets/images/imageLogin.png'))
          ),
        ),
      ),
    );
  }
}