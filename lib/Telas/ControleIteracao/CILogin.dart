

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:game_vault/Service/AuthSteam.dart';
import '../Home.dart';

class CILogin{
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _passwordVisible = false;
  final String _URL = "https://us-central1-gamevault-steamapimanager.cloudfunctions.net/steamLoginCallback";
  late final _authSteam;
  late BuildContext _context;


  CILogin(){
    _authSteam = AuthSteam(cloudFunctionUrl: _URL);
  }

  set context(BuildContext value) {
    _context = value;
  }

  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
  }

  set passwordVisible(bool value) {
    _passwordVisible = value;
  }

  void _showMsg(String msg) => SnackBar(
      content: Text(
        msg));

  get formKey => _formKey;

  get emailController => _emailController;

  get passwordController => _passwordController;

  bool get passwordVisible => _passwordVisible;


  Future<void> loginSteam()async {

    // 3. Chame o método de login
    print("Iniciando login Steam...");
    final User? user = await _authSteam.login(_context);

    if (user != null) {
      print("Login com Steam bem-sucedido!");
      print("ID do Usuário (SteamID): ${user.uid}");
      Navigator.pushReplacement(
        _context,
        MaterialPageRoute(builder: (_) => Home()),
      );
    } else {
      print("Login com Steam foi cancelado ou falhou.");
    }
  }

}