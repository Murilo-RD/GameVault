import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:game_vault/Controller/SteamApiController.dart';
import 'package:http/http.dart' as http;

class ListaPromocao {
  static final String? apiKey = dotenv.env['STEAM_API_KEY'];
  // Certifique-se que usuario.uid não é nulo
  static final String steamId = SteamApiController.usuario.uid;
  static Map<String,dynamic> _lista = {};
  static Future<Map<String, dynamic>> getWishlistPromotionsBrl() async {
    if(_lista.isEmpty){
      try {
        final wishlistUrl = Uri.parse(
            'https://api.steampowered.com/IWishlistService/GetWishlist/v1/?key=$apiKey&steamid=$steamId&format=json');

        final resWishlist = await http.get(wishlistUrl);
        if (resWishlist.statusCode != 200) return {"data": []};

        // CORREÇÃO 1: Verifica se o decode retornou um Map ou List
        final dynamic decodedResponse = jsonDecode(resWishlist.body);

        // Se a API retornou uma lista (ex: []), não é o formato que esperamos
        if (decodedResponse is List) {
          return {"data": []};
        }

        final Map<String, dynamic> wishlistMap = decodedResponse;

        // Verifica se 'response' e 'items' existem antes de acessar
        if (!wishlistMap.containsKey('response') ||
            wishlistMap['response'] == null ||
            !wishlistMap['response'].containsKey('items')) {
          return {"data": []};
        }

        List items = wishlistMap['response']['items'];
        if (items.isEmpty) return {"data": []};

        List<Map<String, dynamic>> gamesOnSale = [];

        // Limita a 30 para evitar bloqueio da Steam e lentidão
        int limit = items.length > 30 ? 30 : items.length;

        for (int i = 0; i < limit; i++) {
          String appid = items[i]['appid'].toString();

          // Busca dados do jogo
          // CORREÇÃO 2: Tipagem segura do retorno do getGamePrice
          var rawGameData = await SteamApiController.getGamePrice(appid);

          // Se o retorno não for um Map (ex: retornou [] por erro), pula esse jogo


          Map<String, dynamic> gameData = rawGameData;

          // Agora é seguro usar containsKey
          if (gameData.containsKey(appid) &&
              gameData[appid]['success'] == true) {
            var data = gameData[appid]['data'];

            if (data != null && data is Map &&
                data.containsKey('price_overview')) {
              var price = data['price_overview'];
              int discount = price['discount_percent'] ?? 0;

              if (discount > 0) {
                gamesOnSale.add({
                  "steamAppID": appid,
                  "title": data['name'],
                  "final_price": price['final_formatted'],
                  "original_price": price['initial_formatted'],
                  "discount_percent": discount,
                });
              }
            }
          }
        }
        _lista = {"data": gamesOnSale};

      } catch (e) {
        print("Erro tratado ao buscar promoções BR: $e");
        return {"data": []};
      }
      }
      return _lista;

  }
}