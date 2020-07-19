import 'package:flutter/material.dart';

import '../HTTP_handler.dart';
import '../widgets/loading_body.dart';
import '../widgets/chat_item.dart';
import '../models/chat_overview.dart';

class ChatScreen extends StatefulWidget {
  static const routeName = '/chat-screen';

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  String token;
  bool _chatsHandler = false;
  List<ChatOverView> _chats;
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  void _getChats() {
    _chatsHandler = true;
    HTTPHandler().getChats(token).then((value) {
      this._chats = value;
      setState(() {});
    }).catchError((e) {
      _scaffoldKey.currentState.showSnackBar(SnackBar(
        content: Text(
          'Network error!',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Color(0xff6c757d),
        duration: Duration(seconds: 3),
      ));
    });
  }

  @override
  Widget build(BuildContext context) {
    token = ModalRoute.of(context).settings.arguments;

    if (!_chatsHandler) _getChats();

    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(title: Text('Chats')),
      body: Container(
        height: double.infinity,
        width: double.infinity,
        alignment: Alignment.topCenter,
        child: (_chats == null)
            ? LoadingBody()
            : ListView.builder(
                itemCount: _chats.length,
                itemBuilder: (BuildContext context, int index) =>
                    ChatItem(_chats[index]),
              ),
      ),
    );
  }
}
