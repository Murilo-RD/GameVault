import '../../Controller/SteamApiController.dart';

class CIBiblioteca {
  var _user = SteamApiController.userData;
  var _jogosBiblioteca;

  get jogosBiblioteca{
    _jogosBiblioteca = SteamApiController.getUserGames();
    return _jogosBiblioteca;
  }

  get user => _user;


}