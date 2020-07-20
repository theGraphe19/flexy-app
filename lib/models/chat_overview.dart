import './chat.dart';

class ChatOverView {
  String name;
  List<Chat> chats;

  ChatOverView({
    this.name,
    this.chats,
  });

  ChatOverView.fromMap(String name, List<dynamic> list) {
    this.name = name;
    chats = [];
    for (var i = 0; i < list.length; i++) {
      chats.add(Chat.fromMap(list[i]));
    }
  }
}
