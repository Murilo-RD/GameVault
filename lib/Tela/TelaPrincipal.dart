import 'package:flutter/material.dart';
import 'package:game_vault/Tela/Biblioteca.dart';
import 'package:game_vault/Tela/Promocoes.dart';
import 'Home.dart';

class TelaPrincipal extends StatefulWidget {
  @override
  _TelaPrincipalState createState() => _TelaPrincipalState();
}

class _TelaPrincipalState extends State<TelaPrincipal> {
  int _indiceAtual = 0;

  final List<Widget> _telas = [
    Home(),
    Biblioteca(),
    Promocoes(),
  ];

  void _aoClicar(int index) {
    setState(() {
      _indiceAtual = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // ---------------------------------------------------------
      // ALTERAÇÃO AQUI: Trocamos o acesso direto pelo IndexedStack
      // ---------------------------------------------------------
      body: IndexedStack(
        index: _indiceAtual, // Define qual tela está visível
        children: _telas,    // Mantém todas as telas carregadas
      ),
      // ---------------------------------------------------------

      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          border: Border(
            top: BorderSide(
              color: Colors.grey.shade800,
              width: 1.0,
            ),
          ),
        ),
        child: BottomNavigationBar(
          backgroundColor: Color(0xFF1A1920),
          selectedItemColor: Colors.white,
          unselectedItemColor: Colors.grey,
          currentIndex: _indiceAtual,
          onTap: _aoClicar,
          type: BottomNavigationBarType.fixed,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home_outlined),
              activeIcon: Icon(Icons.home),
              label: 'Início',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.menu_book_outlined),
              label: 'Biblioteca',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.local_offer_outlined),
              label: 'Promoções',
            ),
          ],
        ),
      ),
    );
  }
}