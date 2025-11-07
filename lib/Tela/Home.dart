import 'package:flutter/material.dart';
import 'package:game_vault/Controller/SteamApiController.dart';

class Home extends StatefulWidget {
  const Home({super.key});
  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  var _dadosDaApi;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _body(),
    );
  }

  @override
  void initState() {
    _dadosDaApi = SteamApiController.getRecenteJogados();
    super.initState();
  }


  Widget _body() {
    return FutureBuilder<dynamic>(
      future: _dadosDaApi,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        }
        else if (snapshot.hasError) {
          // Mostra a mensagem de erro da nossa ApiException
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'Erro ao carregar dados: ${snapshot.error.toString()}',
              style: TextStyle(color: Colors.red, fontSize: 16),
              textAlign: TextAlign.center,
            ),
          );
        }
        else if (snapshot.hasData) {
          final Map<String, dynamic> dados = snapshot.data;

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Título: ${dados['title']}',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 10),
                Text(
                  'Corpo: ${dados['body']}',
                  style: TextStyle(fontSize: 16),
                ),
                SizedBox(height: 10),
                Text(
                  'ID do Usuário: ${dados['userId']}',
                  style: TextStyle(fontSize: 14, color: Colors.grey[700]),
                ),
              ],
            ),
          );
        }

        // --- ESTADO 4: Nenhum dado (caso inicial) ---
        else {
          return Text('Nenhum dado para exibir.');
        }
      },
    );
  }
}
