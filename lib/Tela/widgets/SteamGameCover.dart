import 'package:flutter/material.dart';
// 1. Ele importa o "Cérebro"
import '../../Controller/SteamApiController.dart';

class SteamGameCover extends StatefulWidget {
  final String appId;
  final double width;
  final double height;
  final BoxFit fit;

  const SteamGameCover({
    Key? key,
    required this.appId,
    this.width = 150.0,
    this.height = 225.0,
    this.fit = BoxFit.fill,
  }) : super(key: key);

  @override
  _SteamGameCoverState createState() => _SteamGameCoverState();
}

class _SteamGameCoverState extends State<SteamGameCover> {
  late Future<String> _coverUrlFuture;

  @override
  void initState() {
    super.initState();
    // 2. Ele pede a URL (o link) para o Controller
    _coverUrlFuture = SteamApiController.getGameCover(widget.appId);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String>(
      // 3. Ele espera pelo link
      future: _coverUrlFuture,
      builder: (context, snapshot) {

        // 4. Se o link chegou (sucesso)...
        if (snapshot.hasData) {
          print(snapshot.data);
          // 5. Ele cria o Image.network com o link recebido
          return Image.network(
            snapshot.data!, // <-- A URL que o Controller enviou!
            fit: widget.fit,
            loadingBuilder: (context, child, loadingProgress) {
              if (loadingProgress == null) return child;
              return _buildPlaceholder();
            },
            errorBuilder: (context, error, stackTrace) {
              return _buildErrorWidget();
            },
          );
        }

        // 6. Se a API deu erro...
        if (snapshot.hasError) {
          return _buildErrorWidget();
        }

        // 7. Enquanto espera...
        return _buildPlaceholder();
      },
    );
  }

  // Métodos de ajuda (placeholder e erro)
  Widget _buildPlaceholder() {
    return Container(

      color: Colors.grey[850],
      child: Center(
        child: CircularProgressIndicator(
          strokeWidth: 2.0,
          color: Colors.white54,
        ),
      ),
    );
  }

  Widget _buildErrorWidget() {
    return Container(
      color: Colors.grey[850],
      child: Center(
        child: Icon(
          Icons.broken_image_outlined,
          color: Colors.grey[600],
          size: 40,
        ),
      ),
    );
  }
}