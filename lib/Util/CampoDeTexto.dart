import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CampoDeTexto extends StatelessWidget {
  final TextEditingController controller;
  final String labelText;
  final String hintText;
  final IconData prefixIcon;
  final String? Function(String?) validator;
  final bool obscureText;
  final Widget? suffixIcon;
  final TextInputType? keyboardType;

  const CampoDeTexto({
    Key? key,
    required this.controller,
    required this.labelText,
    required this.hintText,
    required this.prefixIcon,
    required this.validator,
    this.obscureText = false,
    this.suffixIcon,
    this.keyboardType,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Cores padrão
    final Color textColor = Color(0xFFE0E0E0);
    final Color fieldColor = Color(0xFF2A2A2A);
    final Color hintColor = Colors.grey[600]!;
    final Color focusBorderColor = Colors.white;

    // Estilo centralizado
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType,
      style: TextStyle(color: textColor),
      decoration: InputDecoration(
        filled: true,
        fillColor: fieldColor,
        labelText: labelText,
        labelStyle: TextStyle(color: textColor),
        hintText: hintText,
        hintStyle: TextStyle(color: hintColor),
        prefixIcon: Icon(prefixIcon, color: textColor),
        suffixIcon: suffixIcon,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
          borderSide: BorderSide.none, // Remove a borda padrão
        ),
        enabledBorder: OutlineInputBorder( // Borda quando não está focado
          borderRadius: BorderRadius.circular(12.0),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder( // Borda quando está focado
          borderRadius: BorderRadius.circular(12.0),
          borderSide: BorderSide(color: focusBorderColor),
        ),
      ),
      validator: validator,
    );
  }
}