import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
// import 'package:skeletonizer/skeletonizer.dart'; // Removido

class GridCard extends StatefulWidget {
  double altura;
  double largura;
  Widget Function(Map<String, dynamic>? dado, int index)? filho;
  Function(Map<String, dynamic>? dado) count;
  var dado;
  Function(Map<String, dynamic>? dado, int index) getImage;
  int colunas;

  // NOVOS PARÂMETROS
  bool shrinkWrap;
  ScrollPhysics? physics;

  GridCard({
    super.key,
    this.largura = 133,
    this.altura = 200,
    this.filho = null,
    this.colunas = 2,
    // Padrões para manter compatibilidade se não passar nada
    this.shrinkWrap = false,
    this.physics,
    required this.dado,
    required this.count,
    required this.getImage,
  }) {
    if (this.filho == null) {
      this.filho = (dado, index) {
        return Container();
      };
    }
  }

  @override
  State<GridCard> createState() => _GridCardState();
}

class _GridCardState extends State<GridCard> {
  // Não precisamos mais da variável _skeletonEnable

  @override
  Widget build(BuildContext context) {
    double razaoDeAspecto = widget.largura / widget.altura;

    return FutureBuilder<dynamic>(
      future: widget.dado,
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
        // 1. Estado de Carregamento (Loading)
        if (snapshot.connectionState == ConnectionState.waiting) {
          return SizedBox(
            height: widget.altura,
            width: widget.largura,// Mantém uma altura mínima ou use o espaço todo
            child: const Center(
              child: CircularProgressIndicator(),
            ),
          );
        }

        // 2. Estado de Erro
        if (snapshot.hasError) {
          return SizedBox(
            height: widget.altura,
            child: const Center(
              child: Text('Erro!', style: TextStyle(color: Colors.red)),
            ),
          );
        }

        // 3. Estado de Sucesso (Dados carregados)
        Map<String, dynamic>? dado = snapshot.data;

        return GridView.builder(
          shrinkWrap: widget.shrinkWrap,
          physics: widget.physics,
          itemCount: widget.count(dado),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: widget.colunas,
            childAspectRatio: razaoDeAspecto,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
          ),
          padding: const EdgeInsets.all(8.0),
          itemBuilder: (BuildContext context, int index) {
            // Removemos o Skeletonizer aqui e retornamos o Container direto
            return Container(
              clipBehavior: Clip.antiAlias,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                color: Color(0xff28292E),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(
                    child: dado == null
                        ? Container()
                        : widget.getImage(dado, index),
                  ),
                  widget.filho!(dado, index)
                ],
              ),
            );
          },
        );
      },
    );
  }
}