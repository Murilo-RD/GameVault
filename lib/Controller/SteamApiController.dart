import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:game_vault/Service/ApiService.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';

import '../Tela/widgets/SteamGameCover.dart';

class SteamApiController {
  static final _playerService =
  ApiService(baseUrl: 'https://api.steampowered.com/IPlayerService/');
  static final _userStats =
  ApiService(baseUrl: 'https://api.steampowered.com/ISteamUserStats/');
  static final _user =
  ApiService(baseUrl: 'https://api.steampowered.com/ISteamUser/');
  static final _listaDesejo =
  ApiService(baseUrl: 'https://api.steampowered.com/IWishlistService/');
  static final _steamGames = ApiService(baseUrl:'https://www.cheapshark.com/api/1.0/');
  static final _gameData = ApiService(baseUrl:'https://store.steampowered.com/api/');
  static var _userData;
  static late User _usuario;


  static set userData(value) {
    _userData = value;
  }

  static get user => _user;

  static get userData => _userData; // Getter dinâmico para a chave da API

  static String get _KEY {
    final key = dotenv.env['STEAM_API_KEY'];
    if (key == null || key.isEmpty) {
      throw Exception('STEAM_API_KEY não definida no .env');
    }
    return key;
  }

  static String get _STEAMGRIDDB_KEY {
    final key = dotenv.env['STEAMGRIDDB_API_KEY'];
    if (key == null || key.isEmpty) {
      throw Exception('STEAMGRIDDB_API_KEY não definida no .env');
    }
    return key;
  }

  static User get usuario => _usuario;

  static set usuario(User usuario) => _usuario = usuario;

  // --- Endpoints usando User.uid como SteamID ---

  static Future<Map<String, dynamic>> getUserData() async {
    final url =
        'GetPlayerSummaries/v0002/?key=$_KEY&steamids=${_usuario.uid}&format=json';
    return await _user.get(url);
  }

  static Future<Map<String, dynamic>> getRecenteJogados() async {
    final url =
        'GetRecentlyPlayedGames/v0001/?key=$_KEY&steamid=${_usuario.uid}&format=json';
    return await _playerService.get(url);
  }

  static Future<Map<String, dynamic>> getUserGames() async {
    final url =
        'GetOwnedGames/v0001/?key=$_KEY&steamid=${_usuario.uid}&include_appinfo=1&include_played_free_games=1&format=json';
    return _playerService.get(url);
  }

  static Future<Map<String, dynamic>> getGameAchievements(String appId) async {
    final url =
        'GetPlayerAchievements/v0001/?appid=$appId&key=$_KEY&steamid=${_usuario.uid}&format=json';
    return _playerService.get(url);
  }

  static Future<Map<String, dynamic>> getGameStats(String appId) async {
    final url =
        'GetUserStatsForGame/v0002/?appid=$appId&key=$_KEY&steamid=${_usuario.uid}&format=json';
    return _playerService.get(url);
  }

  static Future<Map<String, dynamic>> getEmAlta() async {
    final url =
        'https://api.steampowered.com/ISteamChartsService/GetMostPlayedGames/v1/?count=10';
    Map<String,dynamic> data = await ApiService(baseUrl: '').get(url);
    return data;
  }


  static Future<Map<String, dynamic>> getPromocoes() async {
    final url =
        'deals?storeID=1&onSale=1&sortBy=Metacritic&pageSize=15';
    Map<String,dynamic> data = await _steamGames.get(url);
    return data;
  }


  static Future<void> atualizarNomeUsuario(String userId, String novoNome) async {
    // Referência para a coleção 'users' e o documento do usuário específico
    await FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .update({
      'steamName': novoNome, // A chave é o nome do campo no banco
    })
        .then((value) => print("Nome atualizado com sucesso!"))
        .catchError((error) => print("Falha ao atualizar: $error"));
  }
  static Future<Map<String, dynamic>> getGamePrice(String id) async {
    final url =
        'appdetails?appids=$id&cc=br&filters=price_overview,basic';
    Map<String,dynamic> data = await _gameData.get(url);
    return data;
  }



  static Future<Map<String, dynamic>> getTopSteamGames(int topN) async {
    final url = Uri.parse(
        'https://us-central1-gamevault-steamapimanager.cloudfunctions.net/getTopSteamGames?topN=$topN');

    print("🟦 [1] URL: $url");

    try {
      final response = await http.get(url);
      print("🟦 [2] Status da resposta: ${response.statusCode}");
      print("🟦 [3] Corpo bruto da resposta: ${response.body}");

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonData = json.decode(response.body);
        return jsonData;
      } else {
        print("🔴 [ERRO] Status não OK");
        return {
          "success": false,
          "error": "Status ${response.statusCode}",
        };
      }
    } catch (e) {
      print("🔴 [ERRO] Exceção ao chamar API: $e");
      return {
        "success": false,
        "error": e.toString(),
      };
    }
  }

  static Future<String> getGameCover(String steamAppId) async {

    // 1. Define o link da API
    final url = Uri.parse('https://www.steamgriddb.com/api/v2/grids/steam/$steamAppId');

    try {
      // 2. Faz a chamada GET com a sua chave do SteamGridDB
      final resposta = await http.get(url, headers: {
        'Authorization': 'Bearer $_STEAMGRIDDB_KEY',
      });

      if (resposta.statusCode == 200) {
        // 3. Decodifica o JSON
        final json = jsonDecode(resposta.body);

        // 4. Pega a lista de imagens (chamada 'data')
        final listaDeImagens = json['data'] as List;

        if (listaDeImagens.isNotEmpty) {
          print("$listaDeImagens");
          // 5. Retorna a URL da primeira imagem da lista
          return listaDeImagens[0]['url'];
        } else {
          // Lança um erro se a lista de imagens estiver vazia
          throw Exception('Nenhuma imagem encontrada para este App ID ($steamAppId)');
        }
      } else {
        // Se a API der erro (Chave errada, ID não encontrado, etc.)
        throw Exception('Erro da API SteamGridDB: ${resposta.statusCode}');
      }
    } catch (e) {
      // Se der erro de rede ou ao decodificar o JSON
      throw Exception('Falha na requisição (getGameCover): $e');
    }
  }



}
