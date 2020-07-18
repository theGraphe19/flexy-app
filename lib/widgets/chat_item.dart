import 'package:flutter/material.dart';

import '../models/chat.dart';

/*
  <a target="_blank" href="https://icons8.com/icons/set/chat">Chat icon</a> icon by <a target="_blank" href="https://icons8.com">Icons8</a>
 */

class ChatItem extends StatefulWidget {
  Chat chat;

  ChatItem(this.chat);

  @override
  _ChatItemState createState() => _ChatItemState();
}

class _ChatItemState extends State<ChatItem> {
  bool _show = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(10.0),
      child: ListTile(
        onTap: () {
          _show = !_show;
          setState(() {});
        },
        leading: Image.asset(
          'assets/images/chat.png',
          height: 60.0,
          width: 60.0,
        ),
        title: Text(
          widget.chat.adminName,
          style: TextStyle(color: Colors.black87),
        ),
        subtitle: Text((!_show)
            ? (widget.chat.message.length > 40)
                ? '${widget.chat.message.substring(0, 40)}...'
                : widget.chat.message
            : widget.chat.message),
      ),
    );
  }
}
