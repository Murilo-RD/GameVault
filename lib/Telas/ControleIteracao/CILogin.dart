

import 'package:flutter/cupertino.dart';

import '../../Service/AuthService.dart';

class CILogin{
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _passwordVisible = false;
  final auth = AuthService();

  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
  }


  set passwordVisible(bool value) {
    _passwordVisible = value;
  }

  get formKey => _formKey;

  get emailController => _emailController;

  get passwordController => _passwordController;

  bool get passwordVisible => _passwordVisible;

}