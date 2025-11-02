

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../Service/AuthEmail.dart';
import '../../Service/AuthService.dart';
import '../Home.dart';

class CILogin{
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _passwordVisible = false;
  final _auth = AuthService();
  final _authEmail = AuthEmail();
  late BuildContext _context;


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


  Future<void> signIn(BuildContext context) async {
    final email = emailController.text.trim();
    final senha = passwordController.text.trim();

    if (email.isEmpty || senha.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Preencha e-mail e senha')),
      );
      return;
    }

    try {
      final user = await _authEmail.loginUsuario(email: email, senha: senha);

      if (user == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Usuário não encontrado')),
        );
        return;
      }

      if (!user.emailVerified) {
        await user.sendEmailVerification();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Verifique seu e-mail (cheque a caixa de entrada)')),
        );
        return;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Login realizado com sucesso!')),
      );

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => Home()),
      );

    } on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.message ?? 'Erro ao logar')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Ocorreu um erro inesperado')),
      );
    }
  }
  authGoogle(BuildContext context) async {
      User? user = await _auth.loginGoogle();
      if (user != null && context.mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => Home()),
        );
      }

  }

}