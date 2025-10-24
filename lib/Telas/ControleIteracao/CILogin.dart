

import 'package:flutter/cupertino.dart';

class CILogin{
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final bool _passwordVisible = false;

  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
  }


  get formKey => _formKey;

  get emailController => _emailController;

  get passwordController => _passwordController;

  bool get passwordVisible => _passwordVisible;
}