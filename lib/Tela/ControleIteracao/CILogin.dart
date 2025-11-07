

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:game_vault/Controller/SteamApiController.dart';
import 'package:game_vault/Service/AuthSteam.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../Home.dart';

class CILogin{
  final String _URL = "https://us-central1-gamevault-steamapimanager.cloudfunctions.net/steamLoginCallback";
  late final _authSteam;
  late BuildContext _context;


  CILogin(){
    _authSteam = AuthSteam(cloudFunctionUrl: _URL);
  }

  set context(BuildContext value) {
    _context = value;
  }

  void _showMsg(BuildContext context, String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg),
        backgroundColor: Colors.redAccent, // Um toque de cor para erros
      ),
    );
  }


  Future<void> loginSteam(BuildContext context)async {
    final User? user = await _authSteam.login(context);

    if (user != null) {
      print("Login com Steam bem-sucedido!");
      print("ID do Usuário (SteamID): ${user.uid}");
      SteamApiController.usuario = user;

      // --- INÍCIO DA ADIÇÃO: SALVANDO NO SHARED PREFERENCES ---
      try {
        final prefs = await SharedPreferences.getInstance();

        // Salvamos dados públicos/não-sensíveis
        await prefs.setString('steam_display_name', user.displayName ?? 'Usuário');
        await prefs.setString('steam_avatar_url', user.photoURL ?? '');

        print("Dados do usuário salvos no SharedPreferences!");

      } catch (e) {
        print("Erro ao salvar no SharedPreferences: $e");
        // Não é um erro crítico, o login pode continuar
      }
      // --- FIM DA ADIÇÃO ---

      Navigator.pushReplacement(
        _context,
        MaterialPageRoute(builder: (_) => Home()),
      );
    } else {
      print("Login com Steam foi cancelado ou falhou.");
      _showMsg(_context, "Login cancelado ou falhou"); // Use o _showMsg corrigido da outra thread
    }
  }
}

