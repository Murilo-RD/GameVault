import 'dart:convert';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:game_vault/Controller/ImageGamesController.dart';
import 'package:game_vault/Controller/SteamApiController.dart';
import 'package:game_vault/Tela/widgets/ListCard.dart';
import 'package:game_vault/Tela/widgets/PromocoesList.dart';
import 'package:game_vault/Tela/widgets/SteamGameCover.dart';
import 'package:google_fonts/google_fonts.dart';

import 'ControleIteracao/CIHome.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final CIHome _controladora = CIHome();

  @override
  Widget build(BuildContext context) {
    return Scaffold(backgroundColor: Color(0xFF1A1920), body: _body());
  }

  @override
  void initState() {
    super.initState();
  }

  Widget _body() {
    return Padding(
      padding: const EdgeInsets.only(top: 30),
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 20, bottom: 10,right: 20,left: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(right: 10),
                    // Espaço da borda direita
                    child: CircleAvatar(
                      radius: 23, // Tamanho da bolinha
                      // Opção A: Imagem da Internet
                      backgroundImage: NetworkImage(
                        _controladora.user['avatar'],
                      ),
                      // Opção B: Se for imagem local (assets), use:
                      // backgroundImage: AssetImage("assets/perfil.png"),
                    ),
                  ),
                  Flexible(
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      alignment: Alignment.bottomLeft,
                      child: Text(
                        "Olá, ${_controladora.user["steamName"]}!",
                        style: GoogleFonts.inter(
                          fontSize: 25,
                          fontWeight: FontWeight.w600,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                ],

              ),
            ),
            Padding(
              padding: EdgeInsets.only(right: 10,left: 10,bottom: 20),
              child: Container(
                decoration: BoxDecoration(
                  // Adiciona a linha na parte superior
                  border: Border(
                    top: BorderSide(
                      color: Colors.grey.shade800, // Cor da linha
                      width:
                      1.0, // Espessura da linha (1.0 ou 0.5 para bem fina)
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 20, bottom: 10),
              child: Text(
                "Continue Jogando",
                style: GoogleFonts.inter(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xffE0E0E0),
                ),
              ),
            ),
            SizedBox(
              height: 200,
              child: Listcard(
                count: (dado) {
                  return dado?['response']['total_count'];
                },
                dado: _controladora.jogadosRecentemente,
                getImage: ImageGAmesController.verticalImage((dado) {
                  return dado["response"]["games"];
                }, 'appid'),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 20, bottom: 10, top: 30),
              child: Text(
                "Mais Jogados Atualmente",
                style: GoogleFonts.inter(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xffE0E0E0),
                ),
              ),
            ),
            SizedBox(
              height: 200,
              child: Listcard(
                dado: _controladora.emAlta,
                count: (dado) {
                  return dado?['response']['ranks'].length;
                },
                getImage: ImageGAmesController.verticalImage((dado) {
                  return dado['response']['ranks'];
                }, 'appid'),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 20, top: 30,bottom: 10),
              child: Text(
                "Promoções em Destaque",
                style: GoogleFonts.inter(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xffE0E0E0),
                ),
              ),
            ),
            PromocoesList(dado: _controladora.promocoes),
            Padding(padding: EdgeInsets.only(bottom: 30))
          ],
        ),
      ),
    );
  }
}
