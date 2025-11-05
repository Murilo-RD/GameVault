import 'package:game_vault/Service/ApiService.dart';

class SteamApiController {
   final _playerService = ApiService(baseUrl: 'https://api.steampowered.com/IPlayerService/');
   final _userStats = ApiService(baseUrl: 'https://api.steampowered.com/ISteamUserStats/');
   final _user = ApiService(baseUrl: 'https://api.steampowered.com/ISteamUser/');
   final _listaDesejo = ApiService(baseUrl: 'https://api.steampowered.com/IWishlistService/');


   Future<dynamic> getUserData() async {
     return _user.get('GetPlayerSummaries/v0002/?key=<YOUR_KEY>&steamids=<STEAMID>');
   }

}