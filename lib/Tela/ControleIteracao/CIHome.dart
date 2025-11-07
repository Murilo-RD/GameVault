import 'package:firebase_auth/firebase_auth.dart';
import 'package:game_vault/Controller/SteamApiController.dart';

class CIHome{
  User _user = SteamApiController.usuario;

  get jogadosRecentemente => SteamApiController.getRecenteJogados();
  get emAlta => SteamApiController.getEmAlta();
  get promocoes => SteamApiController.getPromocoes();

  User get user => _user;





}