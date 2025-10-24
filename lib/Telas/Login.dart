import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:game_vault/Telas/ControleIteracao/CILogin.dart';
import 'package:game_vault/Util/Botao.dart';
import '../firebase_options.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:game_vault/Util/CampoDeTexto.dart';

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
    final Color textColor = Color(0xFFE0E0E0);
    final Color buttonBgColor = Color(0xFF2A2A2A);

    return Scaffold(
      backgroundColor: Color(0xFF1E1E1E),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
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

              // --- INÍCIO DO FORMULÁRIO REUTILIZÁVEL ---
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    // --- WIDGET REUTILIZÁVEL ---
                    CampoDeTexto(
                      controller: _emailController,
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
                      controller: _passwordController,
                      labelText: 'Senha',
                      hintText: 'Sua senha',
                      prefixIcon: Icons.lock_outline,
                      obscureText: !_passwordVisible,
                      // Passando o IconButton que muda o estado
                      suffixIcon: IconButton(
                        icon: Icon(
                          _passwordVisible
                              ? Icons.visibility
                              : Icons.visibility_off,
                          color: textColor,
                        ),
                        onPressed: () {
                          setState(() {
                            _passwordVisible = !_passwordVisible;
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
                    // --- WIDGET REUTILIZÁVEL ---
                    Botao(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                'Fazendo login com: ${_emailController.text}',
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
                child: Text("ou", style: TextStyle(color: textColor)),
              ),
              Botao(
                onPressed: () {},
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
              SizedBox(height: 10), // Espaçamento
              // --- WIDGET REUTILIZÁVEL ---
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
      ),
    );
  }
}