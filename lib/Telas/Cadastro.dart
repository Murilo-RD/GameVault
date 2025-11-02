import 'package:flutter/material.dart';
import 'package:game_vault/Util/Botao.dart';
import 'package:game_vault/Util/CampoDeTexto.dart';
import 'package:game_vault/Telas/ControleIteracao/CICadastro.dart';

class Cadastro extends StatefulWidget {
  const Cadastro({super.key});

  @override
  State<Cadastro> createState() => _CadastroState();
}

class _CadastroState extends State<Cadastro> {
  final CICadastro _controle = CICadastro();

  @override
  void dispose() {
    _controle.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _controle.context = context;
    final Color textColor = const Color(0xFFE0E0E0);
    final Color buttonBgColor = const Color(0xFF2A2A2A);

    return Scaffold(
      backgroundColor: const Color(0xFF1E1E1E),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: Column(
          children: [
            // Imagem de topo
            Container(
              height: 300,
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/images/imageLogin.png'),
                ),
              ),
            ),

            Form(
              key: _controle.formKey,
              child: Column(
                children: [
                  CampoDeTexto(
                    controller: _controle.nomeController,
                    labelText: 'Nome completo',
                    hintText: 'Digite seu nome',
                    prefixIcon: Icons.person_outline,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor, insira seu nome';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),

                  CampoDeTexto(
                    controller: _controle.emailController,
                    labelText: 'Email',
                    hintText: 'seuemail@exemplo.com',
                    prefixIcon: Icons.email_outlined,
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor, insira seu email';
                      }
                      if (!value.contains('@') || !value.contains('.')) {
                        return 'Email inválido';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),

                  CampoDeTexto(
                    controller: _controle.passwordController,
                    labelText: 'Senha',
                    hintText: 'Crie uma senha segura',
                    prefixIcon: Icons.lock_outline,
                    obscureText: !_controle.passwordVisible,
                    suffixIcon: IconButton(
                      icon: Icon(
                        _controle.passwordVisible
                            ? Icons.visibility
                            : Icons.visibility_off,
                        color: textColor,
                      ),
                      onPressed: () {
                        setState(() {
                          _controle.passwordVisible = !_controle.passwordVisible;
                        });
                      },
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor, insira sua senha';
                      }
                      if (value.length < 6) {
                        return 'A senha deve ter pelo menos 6 caracteres';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 24),

                  Botao(
                    onPressed: () {
                      if (_controle.formKey.currentState!.validate()) {
                        _controle.signUp();
                      }
                    },
                    child: Text(
                      'Cadastrar',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: textColor,
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text(
                      'Já tem uma conta? Entrar',
                      style: TextStyle(
                        color: textColor.withOpacity(0.8),
                        fontSize: 16,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
