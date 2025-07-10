// import 'dart:convert';
// import 'package:http/http.dart' as http;
//
// class GeminiService {
//   final String apiKey = "AIzaSyBmh04A8O--izLU2glABjQSCBARkUnFnqQ";
//
//   Future<String> obterResposta(String pergunta) async {
//     final url = Uri.parse("https://generativelanguage.googleapis.com/v1beta/models/gemini-pro:generateText?key=$apiKey");
//
//     final response = await http.post(
//       url,
//       headers: {"Content-Type": "application/json"},
//       body: jsonEncode({
//         "prompt": {
//           "text": "Você é um guia turístico virtual do Centro Universitário Serra dos Órgãos (UNIFESO). Responda de forma amigável e "
//               "informativa sobre a instituição.\nUsuário: $pergunta\nGuia:"
//         }
//       }),
//     );
//
//     if (response.statusCode == 200) {
//       var data = jsonDecode(response.body);
//       return data["candidates"][0]["output"];
//     } else {
//       return "Desculpe, não consegui entender. Tente novamente.";
//     }
//   }
// }

import 'dart:convert';
import 'package:http/http.dart' as http;

class GeminiService {
  final String apiKey = "AIzaSyAaAY-GFQQhyPCAVq8fxaG7UTnfT_OlDfU"; // Substitua por sua chave real

  Future<String> obterResposta(String pergunta) async {
    // final url = Uri.parse("https://generativelanguage.googleapis.com/v1/models/gemini-pro:generateContent?key=$apiKey");
    final url = Uri.parse("https://generativelanguage.googleapis.com/v1beta/models/gemini-2.0-flash:generateContent?key=$apiKey");

    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "contents": [
          {
            "parts": [
              {"text": "Você é um guia turístico virtual do Centro Universitário Serra dos Órgãos (UNIFESO). "
                  "Responda de forma amigável e informativa sobre a instituição.\nUsuário: $pergunta\nGuia:"}
            ]
          }
        ]
      }),
    );


    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);

      // 🔹 Verifica se há uma resposta válida na estrutura correta
      if (data.containsKey("candidates") && data["candidates"].isNotEmpty) {
        return data["candidates"][0]["content"]["parts"][0]["text"];
      } else {
        return "Desculpe, não consegui entender. Tente novamente.";
      }
    } else {
      return "Erro na requisição: ${response.statusCode} - ${response.body}";
    }
  }
}
