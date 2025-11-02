import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthEmail {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // 🔹 CADASTRO DE USUÁRIO
  Future<User?> cadastrarUsuario({
    required String nome,
    required String email,
    required String senha,
  }) async {
    try {
      // Cria usuário no Firebase Auth
      UserCredential cred = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: senha,
      );

      // Salva os dados no Firestore
      await _firestore.collection('usuarios').doc(cred.user!.uid).set({
        'uid': cred.user!.uid,
        'nome': nome,
        'email': email,
        'criadoEm': FieldValue.serverTimestamp(),
      });

      print('Usuário cadastrado com sucesso!');
      return cred.user;
    } catch (e) {
      print('Erro ao cadastrar: $e');
      return null;
    }
  }

  // 🔹 LOGIN DE USUÁRIO
  Future<User?> loginUsuario({
    required String email,
    required String senha,
  }) async {
    try {
      UserCredential cred = await _auth.signInWithEmailAndPassword(
        email: email,
        password: senha,
      );

      print('Login realizado com sucesso!');
      return cred.user;
    } catch (e) {
      print('Erro ao fazer login: $e');
      return null;
    }
  }

  // 🔹 LOGOUT
  Future<void> logout() async {
    try {
      await _auth.signOut();
      print('Usuário deslogado!');
    } catch (e) {
      print('Erro ao deslogar: $e');
    }
  }

  // 🔹 PEGAR USUÁRIO ATUAL
  User? usuarioAtual() {
    return _auth.currentUser;
  }

  // 🔹 VERIFICA SE TÁ LOGADO
  bool estaLogado() {
    return _auth.currentUser != null;
  }
}