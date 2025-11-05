const functions = require("firebase-functions");
const admin = require("firebase-admin");
const axios = require("axios");
const { URLSearchParams } = require("url");

admin.initializeApp();

// SUA CHAVE DE API DA STEAM (Opcional, mas recomendado)
// Obtenha em: https://steamcommunity.com/dev/apikey
const STEAM_API_KEY = "76E8C550A51CDAFDE49A65F70E45CE5D";

/**
 * Endpoint HTTP para o callback do OpenID do Steam.
 * Steam redireciona para cá. Nós verificamos a autenticidade
 * e criamos um Token Customizado do Firebase.
 */
exports.steamLoginCallback = functions.https.onRequest(async (req, res) => {
  // 1. O Steam redirecionou o usuário de volta para nós.
  //    Precisamos verificar se o pedido é legítimo.

  // Recria a URL de verificação, trocando 'checkid_setup' por 'check_authentication'
  const params = new URLSearchParams(req.query);
  params.set("openid.mode", "check_authentication");

  let steamCheckUrl = "https://steamcommunity.com/openid/login";

  try {
    // 2. Fazemos uma requisição POST de volta ao Steam para verificar os dados
    const steamResponse = await axios.post(
      steamCheckUrl,
      params.toString(),
      { headers: { "Content-Type": "application/x-www-form-urlencoded" } }
    );

    // 3. O Steam responde se é válido ou não
    if (!steamResponse.data.includes("is_valid:true")) {
      throw new Error("Falha na validação do Steam.");
    }

    // 4. Se for válido, extraímos o SteamID
    const steamId = req.query["openid.claimed_id"].split("/").pop();
    if (!steamId) {
      throw new Error("Não foi possível extrair o SteamID.");
    }

    // 5. (Opcional) Salvar dados do usuário (nome, avatar) no Firestore
    //    Isso cria um perfil de usuário mais rico.
    try {
      if (STEAM_API_KEY) { // Só executa se a chave foi fornecida
        const summaryUrl = `http://api.steampowered.com/ISteamUser/GetPlayerSummaries/v0002/?key=${STEAM_API_KEY}&steamids=${steamId}`;
        const summaryRes = await axios.get(summaryUrl);
        const player = summaryRes.data.response.players[0];

        if (player) {
          const userData = {
            steamName: player.personaname,
            avatar: player.avatarfull,
            profileUrl: player.profileurl,
            lastUpdate: admin.firestore.FieldValue.serverTimestamp(),
          };
          // Salva/Atualiza dados no Firestore
          await admin.firestore().collection("users").doc(steamId).set(userData, { merge: true });
        }
      }
    } catch (dbError) {
      console.warn("Falha ao salvar dados do usuário no Firestore:", dbError.message);
      // Não bloqueia o login, apenas loga o aviso.
    }

    // 6. Criar um Token Customizado do Firebase usando o SteamID como UID
    const firebaseToken = await admin.auth().createCustomToken(steamId);

    // 7. Redirecionar o WebView para uma URL que o app possa interceptar,
    //    passando o token como parâmetro.
    //    O Flutter (WebView) estará ouvindo por "steam_login_complete".
    res.redirect(`https://placeholder.com/steam_login_complete?token=${firebaseToken}`);

  } catch (error) {
    console.error("Erro no steamLoginCallback:", error.message, error.stack);
    // Redireciona para uma página de falha
    res.redirect(`https://placeholder.com/steam_login_failed?error=${error.message}`);
  }
});