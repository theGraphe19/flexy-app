import 'package:flutter/material.dart';

import '../models/chat_overview.dart';

/*
  <a target="_blank" href="https://icons8.com/icons/set/chat">Chat icon</a> icon by <a target="_blank" href="https://icons8.com">Icons8</a>
 */

class ChatItem extends StatefulWidget {
  ChatOverView chat;

  ChatItem(this.chat);

  @override
  _ChatItemState createState() => _ChatItemState();
}

class _ChatItemState extends State<ChatItem> {
  bool _show = false;

  int _countUnreadMessages() {
    var count = 0;
    for (var i = 0; i < widget.chat.chats.length; i++) {
      if (widget.chat.chats[i].status == 0) count++;
    }
    print(count);
    return count;
  }

  @override
  Widget build(BuildContext context) {
    _countUnreadMessages();
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
          widget.chat.name,
          style: TextStyle(color: Colors.black87),
        ),
        subtitle: Text((!_show)
            ? (widget.chat.chats[0].message.length > 30)
                ? '${widget.chat.chats[0].message.substring(0, 30)}...'
                : widget.chat.chats[0].message
            : widget.chat.chats[0].message),
        trailing: Container(
          height: 25.0,
          width: 25.0,
          padding: const EdgeInsets.all(4.0),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: (widget.chat.chats[0].status == 0)
                ? Colors.green
                : Colors.transparent,
          ),
          child: Center(
              child: Text(
            '${_countUnreadMessages()}',
            style: TextStyle(
              color: Colors.white,
              fontSize: 15.0,
            ),
          )),
        ),
      ),
    );
  }
}
