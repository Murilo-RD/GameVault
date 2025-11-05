import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

class ApiService {
  final String _baseUrl;
  final http.Client _client;

  // Headers padrão (ex: autenticação, se necessário)
  final Map<String, String> _defaultHeaders = {
    'Content-Type': 'application/json; charset=UTF-8',
    'Accept': 'application/json',
    // Ex: 'Authorization': 'Bearer SEU_TOKEN_AQUI'
  };

  /// Construtor: Requer uma [baseUrl] para a API.
  /// Opcionalmente, pode receber um [httpClient] para testes.
  ApiService({required String baseUrl, http.Client? httpClient})
      : _baseUrl = baseUrl,
        _client = httpClient ?? http.Client();

  /// Método genérico para processar e tratar a resposta HTTP.
  dynamic _handleResponse(http.Response response) {
    // Decodifica o corpo da resposta se não estiver vazio.
    final dynamic body = response.body.isNotEmpty ? jsonDecode(response.body) : null;

    if (response.statusCode >= 200 && response.statusCode < 300) {
      // Sucesso
      return body;
    } else {
      // Erro
      final String errorMessage = (body != null && body['message'] != null)
          ? body['message']
          : 'Erro desconhecido';

      throw ApiException(
        statusCode: response.statusCode,
        message: 'Falha na requisição: $errorMessage (Status: ${response.statusCode})',
      );
    }
  }

  /// Constrói a URL completa e os headers para a requisição.
  Uri _buildUri(String endpoint) {
    return Uri.parse('$_baseUrl$endpoint');
  }

  Map<String, String> _getHeaders({Map<String, String>? extraHeaders}) {
    final headers = {..._defaultHeaders};
    if (extraHeaders != null) {
      headers.addAll(extraHeaders);
    }
    return headers;
  }

  // --- Método GET ---

  /// Realiza uma requisição GET.
  /// Retorna o corpo da resposta decodificado (geralmente Map ou List).
  Future<dynamic> get(String endpoint, {Map<String, String>? headers}) async {
    try {
      final response = await _client.get(
        _buildUri(endpoint),
        headers: _getHeaders(extraHeaders: headers),
      );
      return _handleResponse(response);
    } on SocketException {
      throw ApiException(message: 'Sem conexão com a internet.');
    } on http.ClientException catch (e) {
      throw ApiException(message: 'Erro de conexão: ${e.message}');
    } catch (e) {
      // Re-lança a exceção se já for uma ApiException
      if (e is ApiException) rethrow;
      throw ApiException(message: 'Erro inesperado: $e');
    }
  }
}

/// Exceção personalizada para erros da API.
class ApiException implements Exception {
  final String message;
  final int? statusCode;

  ApiException({required this.message, this.statusCode});

  @override
  String toString() {
    return 'ApiException: $message${statusCode != null ? ' (Status: $statusCode)' : ''}';
  }
}