// Imports necessários, incluindo os de plataforma do exemplo
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:webview_flutter/webview_flutter.dart';
// Import para recursos do Android (como debugging)
import 'package:webview_flutter_android/webview_flutter_android.dart';
// Import para recursos do iOS/macOS
import 'package:webview_flutter_wkwebview/webview_flutter_wkwebview.dart';

/// CLASSE DE SERVIÇO (Sem mudanças aqui)
/// Esta classe apenas abre a tela de login.
class AuthSteam {
  final String cloudFunctionUrl;

  AuthSteam({required this.cloudFunctionUrl});

  Future<User?> login(BuildContext context) async {
    try {
      final User? user = await Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) =>
              _SteamLoginWebView(cloudFunctionUrl: cloudFunctionUrl),
        ),
      );
      return user;
    } catch (e) {
      print("Erro no login Steam: $e");
      return null;
    }
  }
}

// ===================================================================
// A TELA DA WEBVIEW (Aqui está a mágica da refatoração)
// ===================================================================

class _SteamLoginWebView extends StatefulWidget {
  final String cloudFunctionUrl;
  _SteamLoginWebView({required this.cloudFunctionUrl});

  @override
  State<_SteamLoginWebView> createState() => _SteamLoginWebViewState();
}

class _SteamLoginWebViewState extends State<_SteamLoginWebView> {
  // 1. O controlador agora é 'late final'.
  // Ele será criado no initState e nunca mudará.
  late final WebViewController _controller;

  bool _loading = true; // Para mostrar o CircularProgressIndicator

  @override
  void initState() {
    super.initState();

    // 2. Construímos a URL de login aqui
    final steamLoginUrl = "https://steamcommunity.com/openid/login?"
        "openid.ns=http://specs.openid.net/auth/2.0&"
        "openid.mode=checkid_setup&"
        "openid.return_to=${Uri.encodeComponent(widget.cloudFunctionUrl)}&"
        "openid.realm=${Uri.encodeComponent(widget.cloudFunctionUrl)}&"
        "openid.identity=http://specs.openid.net/auth/2.0/identifier_select&"
        "openid.claimed_id=http://specs.openid.net/auth/2.0/identifier_select";

    // 3. Lógica de inicialização tirada do EXEMPLO OFICIAL
    // Isso configura o controlador ANTES da tela ser construída.
    late final PlatformWebViewControllerCreationParams params;
    if (WebViewPlatform.instance is WebKitWebViewPlatform) {
      params = WebKitWebViewControllerCreationParams(
        allowsInlineMediaPlayback: true,
        mediaTypesRequiringUserAction: const <PlaybackMediaTypes>{},
      );
    } else {
      params = const PlatformWebViewControllerCreationParams();
    }

    final WebViewController controller =
    WebViewController.fromPlatformCreationParams(params);

    // 4. Configuramos o controlador (o "novo" jeito)
    controller
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0x00000000)) // Fundo transparente
      ..setNavigationDelegate(
        NavigationDelegate(
          // Atualiza nosso estado de 'loading'
          onPageStarted: (_) => setState(() => _loading = true),
          onPageFinished: (_) => setState(() => _loading = false),
          onProgress: (int progress) {
            // Você pode usar isso para um indicador de progresso
          },

          // O MAIS IMPORTANTE: nossa lógica de callback
          onNavigationRequest: (NavigationRequest request) async { // Agora é async
            final uri = Uri.parse(request.url);

            // 1. Ouve pelo redirect de SUCESSO da Cloud Function
            if (uri.path.contains("steam_login_complete") &&
                uri.queryParameters['token'] != null) {

              final token = uri.queryParameters['token']!;

              try {
                // 2. Loga no Firebase
                final userCredential =
                await FirebaseAuth.instance.signInWithCustomToken(token);

                // 3. Sucesso! Fecha a WebView (com 'mounted' check)
                if (!mounted) return NavigationDecision.prevent;
                Navigator.of(context).pop(userCredential.user);

              } catch (e) {
                print("Erro ao logar no Firebase com Custom Token: $e");
                if (!mounted) return NavigationDecision.prevent;
                Navigator.of(context).pop(null); // Falha
              }
              // Impede que o WebView navegue para a URL '.../steam_login_complete'
              return NavigationDecision.prevent;
            }

            // Ouve por uma falha
            if (uri.path.contains("steam_login_failed")) {
              print("Login falhou (visto no WebView): ${uri.queryParameters['error']}");
              if (!mounted) return NavigationDecision.prevent;
              Navigator.of(context).pop(null); // Falha
              return NavigationDecision.prevent;
            }

            // Permite todas as outras navegações (ex: dentro da página do Steam)
            return NavigationDecision.navigate;
          },

          // Opcional: Tratar erros de carregamento
          onWebResourceError: (WebResourceError error) {
            print('''
Page resource error:
  code: ${error.errorCode}
  description: ${error.description}
  errorType: ${error.errorType}
            ''');
            setState(() => _loading = false);
          },
        ),
      )
    // 5. Carrega a URL inicial
      ..loadRequest(Uri.parse(steamLoginUrl));

    // Ativa o debugging no Android (muito útil!)
    if (controller.platform is AndroidWebViewController) {
      AndroidWebViewController.enableDebugging(true);
    }

    // 6. Finalmente, atribui o controlador configurado à variável de estado
    _controller = controller;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Login com Steam"),
        actions: [
          IconButton(
            icon: Icon(Icons.close),
            onPressed: () => Navigator.of(context).pop(null), // cancela login
          ),
        ],
      ),
      // 7. O 'body' agora usa o 'WebViewWidget' e passa o controlador
      body: Stack(
        children: [
          WebViewWidget(controller: _controller),

          // Indicador de loading
          if (_loading)
            const Center(
              child: CircularProgressIndicator(),
            ),
        ],
      ),
    );
  }
}