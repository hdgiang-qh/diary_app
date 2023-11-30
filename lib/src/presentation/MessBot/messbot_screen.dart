import 'package:diary/src/core/apiPath.dart';
import 'package:diary/src/core/const.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class MessBotScreen extends StatefulWidget {
  const MessBotScreen({super.key});

  @override
  State createState() => MessBotScreenState();
}

class MessBotScreenState extends State<MessBotScreen> {
  final TextEditingController _textController = TextEditingController();
  final List<ChatMessage> _messages = [];
  late final List<String> list = [];

  Future<String> generateResponse(String inputText) async {
    final res = await http.get(
      Uri.parse("${Const.api_host}${ApiPath.chat}?prompt=$inputText"),
    );

    if (res.statusCode == 200) {
      String textData = res.body;
      list.add(textData);
      return textData;
    } else {
      throw Exception('Failed to generate response');
    }
  }

  void _handleSubmitted(String text) async {
    _textController.clear();
    ChatMessage message = ChatMessage(
      text: text,
      isUserMessage: true,
    );
    setState(() {
      _messages.insert(0, message);
    });

    try {
      String response = await generateResponse(text);
      ChatMessage botMessage = ChatMessage(
        text: response,
        isUserMessage: false,
      );
      setState(() {
        _messages.insert(0, botMessage);
      });
    } catch (e) {
      print('Error: $e');
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Chat AI App'),
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.refresh))
        ],
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            list.isEmpty
                ?  const Flexible(child: Center(child: Text("Can I Help You?")))
                : Flexible(
                    child: ListView.builder(
                      padding: const EdgeInsets.all(8.0),
                      reverse: true,
                      itemBuilder: (_, int index) => _messages[index],
                      itemCount: _messages.length,
                    ),
                  ),
            const Divider(height: 1.0),
            Container(
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
              ),
              child: _buildTextComposer(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextComposer() {
    return IconTheme(
      data: IconThemeData(color: Theme.of(context).primaryColor),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Row(
          children: <Widget>[
            Flexible(
              child: TextField(
                controller: _textController,
                onSubmitted: _handleSubmitted,
                decoration: const InputDecoration.collapsed(
                  hintText: 'Send a message',
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 4.0),
              child: IconButton(
                icon: const Icon(Icons.send),
                onPressed: () => _handleSubmitted(_textController.text),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ChatMessage extends StatefulWidget {
  const ChatMessage(
      {super.key, required this.text, required this.isUserMessage});

  final String text;
  final bool isUserMessage;

  @override
  State<ChatMessage> createState() => _ChatMessageState();
}

class _ChatMessageState extends State<ChatMessage> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(10.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          widget.isUserMessage
              ? const CircleAvatar(
                child: Icon(Icons.person),
              )
              : const CircleAvatar(
                child: Icon(Icons.chat_bubble),
              ),
          Flexible(
            child: Container(
              margin: const EdgeInsets.only(left: 8.0),
              padding: const EdgeInsets.all(10.0),
              decoration: BoxDecoration(
                color: widget.isUserMessage ? Colors.blue[100] : Colors.green[100],
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: Text(
                widget.text,
                style: const TextStyle(fontSize: 16.0),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
