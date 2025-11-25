import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:game_vault/Controller/SteamApiController.dart';
import 'package:http/http.dart' as http;

class CIHome{
  var _user = SteamApiController.userData;
  var _jogadosRecentemente;
  late var _emAlta;
  late var _promocoes;


  get jogadosRecentemente {
    _jogadosRecentemente = SteamApiController.getRecenteJogados();
    return _jogadosRecentemente;
  }

  get emAlta{
    _emAlta = SteamApiController.getEmAlta();
    return _emAlta;
  }

  set user(value) {
    _user = value;
  }

  get user{
   _user = SteamApiController.userData;
   return _user;
  }


  get promocoes {
    _promocoes = SteamApiController.getPromocoes();
  return _promocoes;
}
}