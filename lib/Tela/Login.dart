import 'package:flutter/material.dart';
import 'package:game_vault/Util/Botao.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'ControleIteracao/CILogin.dart';



class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {

  CILogin _controle = CILogin();

  @override
  Widget build(BuildContext context) {
    _controle.context = context;
    return Scaffold(
      backgroundColor: Color(0xFF1A1920),
      body: body(),
    );
  }

  body(){
    final Color textColor = Color(0xFFE0E0E0);
    final Color buttonBgColor = Color(0xFF28292E);

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
            SizedBox(height: 10),
            Botao(
              onPressed: () {
                _controle.loginSteam(context);
              }
              ,
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
            )
          ],
        ),
      ),
    );
  }
}