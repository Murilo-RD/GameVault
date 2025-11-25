import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:game_vault/Tela/ControleIteracao/CIBiblioteca.dart';
import 'package:game_vault/Tela/widgets/GridCard.dart';
import '../Controller/ImageGamesController.dart';

class Biblioteca extends StatefulWidget {
  const Biblioteca({super.key});

  @override
  State<Biblioteca> createState() => _BibliotecaState();
}

class _BibliotecaState extends State<Biblioteca> {
  final CIBiblioteca _controladora = CIBiblioteca();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A1920),
      body: SafeArea(child: _body()),
    );
  }

  Widget _body() {
    // O SingleChildScrollView envolve TUDO
    return SingleChildScrollView(
      child: Column(
        // MainAxisSize.min ajuda a Column a não tentar ser infinita
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 16,right: 16,left: 16,bottom: 5),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 23,
                  backgroundImage: NetworkImage(_controladora.user['avatar'] ?? ''),
                  backgroundColor: Colors.grey,
                ),
                const SizedBox(width: 15),
                Flexible(
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    alignment: Alignment.bottomLeft,
                    child: Text(
                      "Jogos de ${_controladora.user["steamName"]}",
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
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            child: Container(
              height: 1,
              color: Colors.grey.shade800,
            ),
          ),

          // NÃO use Expanded aqui dentro do SingleChildScrollView
          GridCard(
            // 1. shrinkWrap: true faz o Grid ocupar só o espaço necessário (não infinito)
            shrinkWrap: true,

            // 2. NeverScrollable desativa a rolagem interna do Grid
            // para que quem role seja o SingleChildScrollView lá em cima
            physics: const NeverScrollableScrollPhysics(),

            count: (dado) {
              return dado?['response']?['games']?.length ?? 0;
            },
            dado: _controladora.jogosBiblioteca,
            getImage: ImageGAmesController.verticalImage((dado) {
              return dado["response"]["games"];
            }, 'appid'),
          ),
        ],
      ),
    );
  }
}