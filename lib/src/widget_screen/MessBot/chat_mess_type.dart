enum ChatMessType{user, bot}

class ChatMess{
  final String text;
  final ChatMess chatMess;
  ChatMess({required this.text, required this.chatMess});
}