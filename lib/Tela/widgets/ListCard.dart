import 'dart:async';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:skeletonizer/skeletonizer.dart';

class Listcard extends StatefulWidget {
  double altura;
  double largura;
  Widget Function(Map<String, dynamic>? dado, int index) ?filho;
  Function(Map<String, dynamic>? dado) count;
  var dado;
  Function(Map<String, dynamic>? dado, int index) getImage;

  Listcard({
    super.key,
    this.largura = 133,
    this.altura = 200,
    this.filho = null,
    required this.dado,
    required this.count,
    required this.getImage,
  }){
    if(this.filho == null){
      this.filho = (dado,index){return Container();};
    }
  }

  @override
  State<Listcard> createState() => _ListcardState();
}

class _ListcardState extends State<Listcard> {
  bool _skeletonEnable = true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return FutureBuilder<dynamic>(
      future: widget.dado,
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot){
        Map<String,dynamic>? dado;
        if (snapshot.connectionState == ConnectionState.waiting) {
          _skeletonEnable = true;
        } else if (snapshot.hasError) {
          return Container(
            height: widget.altura,
            width: widget.largura,
            child: Text(
              'Erro ao Carregar os dados!!',
              style: TextStyle(color: Colors.red),
            ),
          );
        }else if(snapshot.hasData){
          dado = snapshot.data;
          sleep(Duration(microseconds: 500));
          _skeletonEnable = false;

        }
        return ListView.builder(
              itemCount: widget.count(dado),
              scrollDirection: Axis.horizontal,
              itemBuilder: (BuildContext context, int index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4.0,),
                  child: Skeletonizer(
                    enabled: _skeletonEnable,
                    enableSwitchAnimation: true,
                    child: Container(
                        clipBehavior: Clip.antiAlias,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        height: widget.altura,
                        width: widget.largura,
                        child: Column(
                          children: [
                            dado == null?Container():widget.getImage(dado,index),
                            widget.filho!(dado,index)
                          ],
                        )
                      ),
                    ),
                );
              },
            );
      },
    );
  }
}
