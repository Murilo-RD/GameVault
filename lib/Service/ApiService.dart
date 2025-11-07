import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

class ApiService {
  final String _baseUrl;
  final http.Client _client;

  /// Construtor: base URL obrigatória, client opcional
  ApiService({required String baseUrl, http.Client? httpClient})
      : _baseUrl = baseUrl,
        _client = httpClient ?? http.Client();

  /// Constrói a URL completa
  Uri _buildUri(String endpoint) {
    return Uri.parse('$_baseUrl$endpoint');
  }

  /// Método genérico para processar a resposta HTTP
  Map<String, dynamic> _handleResponse(http.Response response) {
    if (response.body.isEmpty) {
      throw ApiException(message: 'Resposta vazia da API');
    }

    final body = jsonDecode(response.body);

    if (response.statusCode >= 200 && response.statusCode < 300) {
      if (body is Map<String, dynamic>) {
        return body;
      } else {
        // Força que sempre seja um Map
        return {'data': body};
      }
    } else {
      final errorMessage = (body is Map && body['message'] != null)
          ? body['message']
          : 'Erro desconhecido';
      throw ApiException(
        statusCode: response.statusCode,
        message: 'Falha na requisição: $errorMessage (Status: ${response.statusCode})',
      );
    }
  }

  /// Requisição GET sem headers retornando Map<String, dynamic>
  Future<Map<String, dynamic>> get(String endpoint) async {
    try {
      final response = await _client.get(_buildUri(endpoint));
      return _handleResponse(response);
    } on SocketException {
      throw ApiException(message: 'Sem conexão com a internet.');
    } on http.ClientException catch (e) {
      throw ApiException(message: 'Erro de conexão: ${e.message}');
    } catch (e) {
      if (e is ApiException) rethrow;
      throw ApiException(message: 'Erro inesperado: $e');
    }
  }
}

/// Exceção personalizada da API
class ApiException implements Exception {
  final String message;
  final int? statusCode;

  ApiException({required this.message, this.statusCode});

  @override
  String toString() =>
      'ApiException: $message${statusCode != null ? ' (Status: $statusCode)' : ''}';
}
