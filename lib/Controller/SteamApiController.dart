import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:game_vault/Service/ApiService.dart';

class SteamApiController {
  static final _playerService =
  ApiService(baseUrl: 'https://api.steampowered.com/IPlayerService/');
  static final _userStats =
  ApiService(baseUrl: 'https://api.steampowered.com/ISteamUserStats/');
  static final _user =
  ApiService(baseUrl: 'https://api.steampowered.com/ISteamUser/');
  static final _listaDesejo =
  ApiService(baseUrl: 'https://api.steampowered.com/IWishlistService/');
  static final _steamGames = 'https://store.steampowered.com/';
  static late User _usuario;


  static get user => _user; // Getter dinâmico para a chave da API
  static String get _KEY {
    final key = dotenv.env['STEAM_API_KEY'];
    if (key == null || key.isEmpty) {
      throw Exception('STEAM_API_KEY não definida no .env');
    }
    return key;
  }

  static User get usuario => _usuario;

  static set usuario(User usuario) => _usuario = usuario;

  // --- Endpoints usando User.uid como SteamID ---

  static Future<Map<String, dynamic>> getUserData() async {
    final url =
        'GetPlayerSummaries/v0002/?key=$_KEY&steamids=${_usuario.uid}&format=json';
    return _user.get(url);
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
        'api/featuredcategories';
    Map<String,dynamic> data = await _playerService.get(url);
    return data['top_sellers']['items'];
  }

  static Future<Map<String, dynamic>> getPromocoes() async {
    final url =
        'api/featuredcategories';
    Map<String,dynamic> data = await _playerService.get(url);
    return data['specials']['items'];
  }
}
