import 'package:flutter/material.dart';
import '../services/gemini_service.dart';
import '../widgets/chat_message.dart';

class ChatScreen extends StatefulWidget {
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _controller = TextEditingController();
  final List<Map<String, String>> _messages = [];
  final GeminiService _geminiService = GeminiService();

  bool _isLoading = false;

  void _addBotMessage(String text) {
    setState(() {
      _messages.add({"sender": "bot", "text": text});
    });
  }

  @override
  void initState() {
    super.initState();
    _addBotMessage("Olá! Sou o seu assistente virtual da UNIFESO, em que posso te ajudar?");
  }

  void _enviarMensagem() async {
    String pergunta = _controller.text.trim();
    if (pergunta.isEmpty) return;


    setState(() {
      _messages.add({"role": "user", "text": pergunta});
      _isLoading = true;
    });

    _controller.clear();
    String resposta = await _geminiService.obterResposta(pergunta);

    setState(() {
      _messages.add({"role": "bot", "text": resposta});
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xF5F5F5F5),
      appBar: AppBar(
        backgroundColor: Color(0xFF006B64),
        title: Image.asset(
          "assets/connect_chat_branco.png",
          height: 40, // Ajuste o tamanho conforme necessário
        ),
        iconTheme: IconThemeData(color: Colors.white),
      ),

      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                return ChatMessage(
                  text: _messages[index]["text"]!,
                  isUser: _messages[index]["role"] == "user",
                );
              },
            ),
          ),
          if (_isLoading) CircularProgressIndicator(),
          Padding(
            padding: EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child:
                  TextField(
                    controller: _controller,
                    decoration: InputDecoration(
                      labelText: "Pergunte algo...",
                      labelStyle: TextStyle(color: Colors.teal.shade900), // Cor do rótulo
                      filled: false, // Preenche o fundo do campo
                      fillColor: Colors.teal.shade50, // Cor de fundo
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.teal.shade700, width: 2), // Borda quando não está focado
                        borderRadius: BorderRadius.circular(20), // Borda arredondada
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.teal.shade700, width: 2), // Borda quando focado
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),

                    style: TextStyle(color: Colors.teal.shade900), // Cor do texto digitado
                    cursorColor: Colors.teal.shade700, // Cor do cursor piscante
                  )
                ),

                IconButton(
                  icon: Icon(Icons.send, color: Color(0xFF006B64), size: 35),
                  onPressed: _enviarMensagem,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
