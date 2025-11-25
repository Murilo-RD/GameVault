import 'package:flutter/cupertino.dart';

import '../Tela/widgets/SteamGameCover.dart';

class  ImageGAmesController{
  static verticalImage(Function(Map<String,dynamic> dado) appid,String chaveId){
    return (dados, index){ return Image.network(
      'https://steamcdn-a.akamaihd.net/steam/apps/${appid(dados)[index][chaveId]}/library_600x900_2x.jpg',
      fit: BoxFit.fill,
      errorBuilder:
          (BuildContext context, Object error, StackTrace? stackTrace) {
        return SteamGameCover(appId: '${appid(dados)[index][chaveId]}');
      },
    );};
  }

  static Imagem( appid){
    return Image.network(
      'https://steamcdn-a.akamaihd.net/steam/apps/${appid}/library_600x900_2x.jpg',
      fit: BoxFit.fill,
      errorBuilder:
          (BuildContext context, Object error, StackTrace? stackTrace) {
        return SteamGameCover(appId: '$appid');
      },
    );
  }
}