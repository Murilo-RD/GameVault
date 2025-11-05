import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:game_vault/Service/ApiService.dart';

class SteamApiController {
   final _playerService = ApiService(baseUrl: 'https://api.steampowered.com/IPlayerService/');
   final _userStats = ApiService(baseUrl: 'https://api.steampowered.com/ISteamUserStats/');
   final _user = ApiService(baseUrl: 'https://api.steampowered.com/ISteamUser/');
   final _listaDesejo = ApiService(baseUrl: 'https://api.steampowered.com/IWishlistService/');
   late final _usuario;
   late final _KEY = dotenv.env['STEAM_API_KEY'];


   set usuario(User usuario) {
     _usuario = usuario;
   }

   Future<dynamic> getUserData() async {
     return _user.get('GetPlayerSummaries/v0002/?key=$_KEY&steamids=${_usuario.uid}');
   }

   Future<dynamic> getRecenteJogados() async {
     return _playerService.get('GetRecentlyPlayedGames/v0001/?key=$_KEY&steamids=${_usuario.uid}&format=json');
   }

   Future<dynamic> getUserGames() async {
     return _playerService.get('GetOwnedGames/v0001/?$_KEY&steamids=${_usuario.uid}&include_appinfo=1&include_played_free_games=1&format=json');
   }

   Future<dynamic> getGameAchievements(String appId) async {
     return _playerService.get('GetPlayerAchievements/v0001/?appid=$appId&$_KEY&steamids=${_usuario.uid}');
   }

   Future<dynamic> getGameStats(String appId) async {
     return _playerService.get('GetUserStatsForGame/v0002/?appid=$appId&$_KEY&steamids=${_usuario.uid}');
   }




}