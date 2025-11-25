import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:game_vault/Controller/ImageGamesController.dart';
import 'package:game_vault/Controller/SteamApiController.dart';
import 'package:google_fonts/google_fonts.dart';

class ListGameprice extends StatefulWidget {
  ListGameprice({
    super.key,
    required this.dado,
    required this.count,
    required this.appid,
  });

  Function(Map<String, dynamic>? dado) count;
  var dado;
  String Function(Map<String, dynamic>? dado, int index) appid;

  @override
  State<ListGameprice> createState() => _ListGamepriceState();
}

class _ListGamepriceState extends State<ListGameprice> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, dynamic>>(
      future: widget.dado,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(
            child: Text(
              'Erro ao acessar dados!!',
              style: GoogleFonts.inter(
                color: Colors.red,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          );
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator(color: Color(0xff28292E),));
        }
        var dado = snapshot.data;

        return ListView.builder(
          padding: EdgeInsets.only(top: 10),
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemCount: widget.count(dado),
          itemBuilder: (contex, index) {
            return FutureBuilder(
              future: getGame(dado, index),
              builder: (contex, snapshot) {
                if (snapshot.hasError) {
                  return Center(
                    child: Text(
                      'Erro ao acessar dados!!',
                      style: GoogleFonts.inter(
                        color: Colors.red,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  );
                }

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: Container(
                      height: 100,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Color(0xff28292E),
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                  );
                }
                var data = snapshot.data;

                if(data?['success'] == false){
                  return SizedBox(height: 0,);
                }

                var valor;
                var desc;
                var prcAnt;

                if (data?['data']['is_free'] == true || data?['data']['price_overview'] == null ) {
                  valor = 'Grátis';
                } else{
                  valor = data?['data']['price_overview']['final_formatted'];
                  if (data?['data']['price_overview']['discount_percent'] !=
                      0) {
                    desc = data?['data']['price_overview']['discount_percent'];
                    prcAnt = data?['data']['price_overview']['initial_formatted'];
                  }
                }

                Widget preco = Padding(
                  padding: const EdgeInsets.only(right: 20,top: 8,bottom: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        valor,
                        style: GoogleFonts.inter(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      desc == null? SizedBox(height: 2,): Column(children: [
                        Container(
                          decoration: BoxDecoration(color: CupertinoColors.activeGreen,borderRadius: BorderRadius.circular(5)),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 1,horizontal: 10),
                            child: Text(
                              desc ==null? '':'$desc%',
                              style: GoogleFonts.inter(
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: 5,),
                        Text(
                          prcAnt ==null? '':'$prcAnt',
                          style: GoogleFonts.inter(
                              fontSize: 8,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey,
                              decoration: TextDecoration.lineThrough
                          ),
                        ),

                      ],),
                    ],
                  ),
                );

                return Padding(
                  padding: const EdgeInsets.only(bottom: 10,right: 8,left: 8),
                  child: Container(
                    clipBehavior: Clip.antiAlias,
                    height: 100,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Color(0xff28292E),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Container(
                          clipBehavior: Clip.antiAlias,
                          height: 100,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: ImageGAmesController.Imagem(data!['data']['steam_appid']),
                        ),
                        SizedBox(width: 20,),
                        Flexible(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                              child: Padding(
                                padding: const EdgeInsets.only(top:10),
                                child: AutoSizeText(
                                  data?['data']['name'],
                                  minFontSize: 15,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: GoogleFonts.inter(
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          Padding(
                            padding: const EdgeInsets.only(right: 20),
                            child: Container(
                              height: 2,
                              width: double.infinity,
                              color: Colors.grey,
                            ),
                          ),
                          preco]
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          },
        );
      },
    );
  }

  Future<Map<String, dynamic>> getGame(var dado, int index) async {
    var data = await SteamApiController.getGamePrice(widget.appid(dado, index));
    return data[widget.appid(dado, index)];
  }
}
