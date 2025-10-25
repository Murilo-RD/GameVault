import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:game_vault/Telas/ControleIteracao/CILogin.dart';
import 'package:game_vault/Util/Botao.dart';
import '../firebase_options.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:game_vault/Util/CampoDeTexto.dart';

import 'Home.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(MaterialApp(
    theme: ThemeData.dark(),
    home: Login(),
  ));
}

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {

  CILogin _controle = CILogin();

  @override
  void dispose() {
    _controle.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Definindo as cores aqui para passá-las


    return Scaffold(
      backgroundColor: Color(0xFF1E1E1E),
      body: body(),
    );
  }

  body(){
    final Color textColor = Color(0xFFE0E0E0);
    final Color buttonBgColor = Color(0xFF2A2A2A);

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: Column(
          children: [
            Container(
              height: 350,
              decoration: BoxDecoration(
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
                        return 'Por favor, insira um email válido';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 16.0),
                  CampoDeTexto(
                    controller: _controle.passwordController,
                    labelText: 'Senha',
                    hintText: 'Sua senha',
                    prefixIcon: Icons.lock_outline,
                    obscureText: !_controle.passwordVisible,
                    // Passando o IconButton que muda o estado
                    suffixIcon: IconButton(
                      icon: Icon(
                        _controle.passwordVisible
                            ? Icons.visibility
                            : Icons.visibility_off,
                        color: textColor,
                      ),
                      onPressed: () {
                        setState(() {
                          _controle.passwordVisible = _controle.passwordVisible;
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
                  SizedBox(height: 24.0),
                  Botao(
                    onPressed: () {
                      if (_controle.formKey.currentState!.validate()) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              'Fazendo login com: ${_controle.emailController.text}',
                            ),
                          ),
                        );
                      }
                    },
                    child: Text(
                      'Entrar',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: textColor,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            Padding(
              padding: EdgeInsets.symmetric(horizontal: 25, vertical: 15),
              child: Text("ou", style: TextStyle(color: textColor,fontWeight: FontWeight.bold,fontSize: 20)),
            ),
            Botao(
              onPressed: () async {
                User? user = await _controle.auth.loginGoogle();
                if (user != null && context.mounted) {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => Home()),
                  );
                }
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(FontAwesomeIcons.google, size: 30, color: textColor),
                  SizedBox(width: 20),
                  Text(
                    "Login com Google",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: textColor,
                    ),
                  )
                ],
              ),
            ),
            SizedBox(height: 10),
            Botao(
              onPressed: () {},
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(FontAwesomeIcons.steam, size: 30, color: textColor),
                  SizedBox(width: 20),
                  Text(
                    "Login com Steam",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: textColor,
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}