
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../Service/AuthEmail.dart';
import '../Home.dart';

class CICadastro {
  final _formKey = GlobalKey<FormState>();
  final _nomeController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _passwordVisible = false;

  final _authEmail = AuthEmail();
  late BuildContext _context;

  // Getter/Setter de contexto
  set context(BuildContext value) {
    _context = value;
  }

  // Dispose dos controladores
  void dispose() {
    _nomeController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
  }

  // Getters e Setters
  get formKey => _formKey;
  get nomeController => _nomeController;
  get emailController => _emailController;
  get passwordController => _passwordController;
  bool get passwordVisible => _passwordVisible;
  set passwordVisible(bool value) {
    _passwordVisible = value;
  }

  void _showMsg(String msg) {
    ScaffoldMessenger.of(_context).showSnackBar(
      SnackBar(content: Text(msg)),
    );
  }

  Future<void> signUp() async {
    try {
      final user = await _authEmail.cadastrarUsuario(
        nome: _nomeController.text,
        email: _emailController.text,
        senha: _passwordController.text,
      );
      print("User: $user");
      if (user != null) {
        await user.sendEmailVerification();
        _showMsg('Conta criada! Verifique seu e-mail para confirmar.');
        Navigator.pushReplacement(
          _context,
          MaterialPageRoute(builder: (context) => Home()),
        );
      } else {
        _showMsg('Erro ao criar conta. Tente novamente.');
      }
    } on FirebaseAuthException catch (e) {
      _showMsg(e.message ?? 'Erro desconhecido ao cadastrar');
    } catch (e) {
      _showMsg('Erro inesperado: $e');
    }
  }
}