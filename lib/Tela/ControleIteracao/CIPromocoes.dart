import 'package:game_vault/Controller/ListaPromocao.dart';

import '../../Controller/SteamApiController.dart';

class CIPromocoes{

  var _user = SteamApiController.userData;
  get user => _user;
  var _promo;

  get promo {
    _promo = SteamApiController.getPromocoes();
    return _promo;
  }
}