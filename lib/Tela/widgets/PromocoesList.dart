import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:game_vault/Controller/ListaPromocao.dart';
import 'package:game_vault/Controller/SteamApiController.dart';
import 'package:google_fonts/google_fonts.dart';

import 'ListCard.dart';

class PromocoesList extends StatefulWidget {
  PromocoesList({super.key, required this.dado});

  final dynamic dado; // Melhor tipagem

  @override
  State<PromocoesList> createState() => _PromocoesListState();
}

class _PromocoesListState extends State<PromocoesList> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 250,
      child: Listcard(
        largura: 300,
        altura: 241,
        dado: widget.dado,
        count: (dado) {
          return dado?['data']?.length ?? 0;
        },
        // Renderização da Imagem
        getImage: (dado, index) {
          return Image.network(
            'https://steamcdn-a.akamaihd.net/steam/apps/${dado == null ? '' : dado['data'][index]['steamAppID']}/header.jpg',
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) =>
                Container(color: Colors.grey), // Tratamento se imagem falhar
          );
        },
        // Renderização do Conteúdo (Preço e Título)
        filho: (dado, index) {
          if (dado != null) {
            // 1. Pega o ID dinâmico do jogo atual na lista
            String appid = dado['data'][index]['steamAppID'];

            // 2. Chama a API usando esse ID específico
            // Nota: O ideal seria o Controller ter um cache para não chamar a API toda vez que faz scroll
            var future = SteamApiController.getGamePrice(appid);

            return FutureBuilder<Map<String, dynamic>>(
              future: future,
              builder: (BuildContext context, snapshot) {
                // Caso de Erro ou Sem Dados
                if (snapshot.hasError || !snapshot.hasData) {
                  return Container(
                    height: 100,
                    width: 300,
                    color: const Color(0xff28292E),
                    child: const Center(
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                  );
                }

                // 3. Parse dos Dados da Steam
                var respostaSteam = snapshot.data;
                // Verifica se o jogo existe na resposta e se tem dados
                var dadosJogo = respostaSteam?[appid]?['data'];
                var priceOverview = dadosJogo?['price_overview'];

                // Define valores padrão caso não tenha preço (ex: Free to Play)
                String precoFinal =
                    priceOverview?['final_formatted'] ?? "Grátis/N/A";
                String precoOriginal =
                    priceOverview?['initial_formatted'] ?? "";
                int desconto = priceOverview?['discount_percent'] ?? 0;

                return Container(
                  height: 100,
                  decoration: const BoxDecoration(color: Color(0xff28292E)),
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Título
                        Text(
                          "${dado['data'][index]['title']}",
                          style: GoogleFonts.inter(
                            color: Colors.grey.shade400,
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),

                        const SizedBox(height: 8),

                        // Linha de Preços e Desconto
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            // Preço Atual
                            Text(
                              precoFinal,
                              // Removemos o "R$" manual pois a API já traz formatado
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                // Ajustei levemente para caber melhor
                                fontWeight: FontWeight.bold,
                              ),
                            ),

                            const SizedBox(width: 8),

                            // Preço Antigo (Só mostra se tiver desconto)
                            const Spacer(),

                            // Badge de Desconto (Só mostra se tiver desconto)
                            if (desconto > 0)
                              Column(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                      vertical: 4,
                                    ),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFF4CAF50),
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: Text(
                                      "-$desconto%",
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 5),
                                  if (desconto > 0)
                                    Text(
                                      precoOriginal,
                                      style: const TextStyle(
                                        color: Colors.grey,
                                        fontSize: 12,
                                        decoration: TextDecoration.lineThrough,
                                        decorationColor: Colors.grey,
                                      ),
                                    ),
                                ],
                              ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          }
          // Loading inicial enquanto 'dado' principal é null
          return Container(
            height: 100,
            width: 300,
            child: const Center(child: CircularProgressIndicator()),
          );
        },
      ),
    );
  }
}

class PromocoesDesejo extends StatefulWidget {
  const PromocoesDesejo({super.key});

  @override
  State<PromocoesDesejo> createState() => _PromocoesDesejoState();
}

class _PromocoesDesejoState extends State<PromocoesDesejo> {
  late Future<Map<String, dynamic>> _futurePromocoes;

  @override
  void initState() {
    super.initState();
    // Usa a função do controller que criamos (CheapShark + Steam IDs)
    _futurePromocoes = ListaPromocao.getWishlistPromotionsBrl();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Text(
            'Desejos em Oferta',
            style: GoogleFonts.inter(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
        ),

        FutureBuilder<Map<String, dynamic>>(
          future: _futurePromocoes,
          builder: (context, snapshot) {
            // Estado: Carregando
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const SizedBox(
                height: 260,
                child: Center(
                  child: CircularProgressIndicator(color: Color(0xff28292E)),
                ),
              );
            }

            // Estado: Sem dados ou Erro
            final dados = snapshot.data;
            final lista = dados?['data'] as List?;

            if (lista == null || lista.isEmpty) {
              return Container(
                height: 100,
                margin: const EdgeInsets.symmetric(horizontal: 20),
                decoration: BoxDecoration(
                  color: const Color(0xff28292E),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Center(
                  child: Text(
                    "Nenhuma oferta encontrada.",
                    style: TextStyle(color: Colors.grey),
                  ),
                ),
              );
            }

            // Estado: Sucesso -> Chama o NOVO Widget
            return PromocoesHorizontal(dados: dados!);
          },
        ),
      ],
    );
  }
}

class PromocoesHorizontal extends StatelessWidget {
  final Map<String, dynamic> dados;

  const PromocoesHorizontal({super.key, required this.dados});

  @override
  Widget build(BuildContext context) {
    // Extrai a lista segura do JSON
    final List<dynamic> listaJogos = dados['data'] ?? [];

    // Se a lista estiver vazia, não desenha nada
    if (listaJogos.isEmpty) {
      return const SizedBox.shrink();
    }

    return SizedBox(
      height: 240, // Altura total do carrossel
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        scrollDirection: Axis.horizontal,
        itemCount: listaJogos.length,
        separatorBuilder: (context, index) => const SizedBox(width: 15),
        itemBuilder: (context, index) {
          final jogo = listaJogos[index];
          return _buildCard(jogo);
        },
      ),
    );
  }

  Widget _buildCard(Map<String, dynamic> jogo) {
    // Extração segura dos dados
    final String appid = jogo['steamAppID']?.toString() ?? '';
    final String titulo = jogo['title'] ?? 'Desconhecido';
    final String precoFinal = jogo['final_price']?.toString() ?? '';
    final String precoOriginal = jogo['original_price']?.toString() ?? '';
    final int desconto = int.tryParse(jogo['discount_percent'].toString()) ?? 0;

    return Container(
      width: 280, // Largura de cada cartão
      decoration: BoxDecoration(
        color: const Color(0xff28292E), // Cor de fundo do cartão
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // --- 1. Imagem do Jogo ---
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
            child: Image.network(
              'https://steamcdn-a.akamaihd.net/steam/apps/$appid/header.jpg',
              height: 140,
              width: double.infinity,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  height: 140,
                  color: Colors.grey.shade800,
                  child: const Center(
                    child: Icon(Icons.broken_image, color: Colors.white54),
                  ),
                );
              },
            ),
          ),

          // --- 2. Detalhes do Jogo ---
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Título
                  Text(
                    titulo,
                    style: GoogleFonts.inter(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                      fontSize: 15,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),

                  // Linha de Preço
                  Row(
                    children: [
                      // Badge de Desconto
                      if (desconto > 0)
                        Container(
                          margin: const EdgeInsets.only(right: 8),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFF4CAF50),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            "-$desconto%",
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          ),
                        ),

                      // Preço Original (riscado)
                      if (desconto > 0)
                        Text(
                          precoOriginal,
                          style: TextStyle(
                            color: Colors.grey.shade500,
                            fontSize: 12,
                            decoration: TextDecoration.lineThrough,
                          ),
                        ),

                      const Spacer(),

                      // Preço Final (Grande)
                      Text(
                        precoFinal,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
