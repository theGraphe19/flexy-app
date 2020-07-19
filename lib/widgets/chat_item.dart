import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:timeline_tile/timeline_tile.dart';

import '../models/chat_overview.dart';
import '../models/chat.dart';

/*
  <a target="_blank" href="https://icons8.com/icons/set/chat">Chat icon</a> icon by <a target="_blank" href="https://icons8.com">Icons8</a>
  <a target="_blank" href="https://icons8.com/icons/set/speech-bubble-with-dots">Chat Bubble icon</a> icon by <a target="_blank" href="https://icons8.com">Icons8</a>
 */

class ChatItem extends StatefulWidget {
  final ChatOverView chat;
  final GlobalKey<ScaffoldState> _scaffoldKey;

  ChatItem(
    this.chat,
    this._scaffoldKey,
  );

  @override
  _ChatItemState createState() => _ChatItemState();
}

class _ChatItemState extends State<ChatItem> {
  int _countUnreadMessages() {
    var count = 0;
    for (var i = 0; i < widget.chat.chats.length; i++) {
      if (widget.chat.chats[i].status == 0) count++;
    }
    print(count);
    return count;
  }

  void _showMessages() {
    widget._scaffoldKey.currentState.showBottomSheet((BuildContext context) {
      return Container(
        height: (widget.chat.chats.length * 150 > 400)
            ? 400
            : (widget.chat.chats.length * 150.0),
        padding: const EdgeInsets.all(10.0),
        width: double.infinity,
        color: Colors.grey[100],
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(widget.chat.chats[0].adminName),
                  GestureDetector(
                    onTap: () => Navigator.of(context).pop(),
                    child: Icon(
                      Icons.close,
                      color: Colors.black87,
                    ),
                  )
                ],
              ),
              Divider(),
              Column(
                children: widget.chat.chats.map((Chat c) {
                  return TimelineTile(
                    alignment: TimelineAlign.manual,
                    lineX: 0.1,
                    topLineStyle:
                        LineStyle(color: Colors.white.withOpacity(0.7)),
                    indicatorStyle: IndicatorStyle(
                      indicatorY: 0.2,
                      drawGap: true,
                      width: 30,
                      height: 30,
                      indicator: Stack(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.white.withOpacity(0.7),
                            ),
                          ),
                          Positioned.fill(
                            child: Align(
                              alignment: Alignment.center,
                              child: SizedBox(
                                height: 30,
                                width: 30,
                                child: Image.asset(
                                  'assets/images/chat-item.png',
                                  height: 30.0,
                                  width: 30.0,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    rightChild: Padding(
                      padding: const EdgeInsets.only(
                          left: 16, right: 10, top: 10, bottom: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            c.adminName,
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.black87,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            DateFormat('dd-MM-yyyy').format(c.timeStamp),
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.black87,
                              fontWeight: FontWeight.normal,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            c.message,
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.black54,
                              fontWeight: FontWeight.normal,
                            ),
                          )
                        ],
                      ),
                    ),
                  );
                }).toList(),
              )
            ],
          ),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    _countUnreadMessages();
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(10.0),
      child: ListTile(
        onTap: () {
          _showMessages();
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
        subtitle: Text((widget.chat.chats[0].message.length > 30)
            ? '${widget.chat.chats[0].message.substring(0, 30)}...'
            : widget.chat.chats[0].message),
        trailing: Container(
          height: 25.0,
          width: 25.0,
          padding: const EdgeInsets.all(4.0),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: (widget.chat.chats[0].status == 0)
                ? Colors.grey
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
