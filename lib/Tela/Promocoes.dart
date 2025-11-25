import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:game_vault/Tela/ControleIteracao/CIPromocoes.dart';
import 'package:game_vault/Tela/widgets/ListGamePrice.dart';
import 'package:game_vault/Tela/widgets/PromocoesList.dart';
import 'package:google_fonts/google_fonts.dart';

class Promocoes extends StatefulWidget {
  const Promocoes({super.key});

  @override
  State<Promocoes> createState() => _PromocoesState();
}

class _PromocoesState extends State<Promocoes> {
  CIPromocoes _controladora = CIPromocoes();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.only(
                top: 40,
                right: 16,
                left: 16,
                bottom: 5,
              ),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 23,
                    backgroundImage: NetworkImage(
                      _controladora.user['avatar'] ?? '',
                    ),
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
            PromocoesDesejo(),
            Padding(
              padding: const EdgeInsets.only(top: 20,left: 20,bottom: 10),
              child: Text(
                'Promoções em Destaque',
                style: GoogleFonts.inter(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
            ),
            ListGameprice(
              dado: _controladora.promo,
              count: (dado) => dado?['data'].length,
              appid: (dado, index) =>
                  '${dado?['data'][index]['steamAppID']}',
            ),
          ],
        ),
      ),
    );
  }
}
