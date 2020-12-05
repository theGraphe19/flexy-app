import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:timeline_tile/timeline_tile.dart';
import 'package:flutter_html/flutter_html.dart';

import '../HTTP_handler.dart';
import '../widgets/loading_body.dart';
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
  bool isLoaded = false;
  var _handler = HTTPHandler();

  void _getChats() {
    _chatsHandler = true;
    _handler.getChats(token).then((value) {
      this._chats = value;
      setState(() {
        isLoaded = true;
      });
      if (value.length > 0)
        _handler.readChats(token, value[0].chats[0].adminId);
    }).catchError((e) {
      print(e);
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
        child: (_chats == null && !isLoaded)
            ? LoadingBody()
            : (_chats.length == 0 && isLoaded)
                ? Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Container(
                          height: 70.0,
                          width: 70.0,
                          decoration: BoxDecoration(shape: BoxShape.circle),
                          child: Image.asset('assets/images/wait.png'),
                        ),
                        Text(
                          'No chats yet!',
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 20.0,
                          ),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    itemCount: _chats[0].chats.length,
                    itemBuilder: (BuildContext context, int index) {
                      return TimelineTile(
                        alignment: TimelineAlign.manual,
                        lineX: 0.1,
                        topLineStyle: LineStyle(color: Colors.grey[300]),
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
                                'Admin',
                                style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.black87,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                DateFormat('dd-MM-yyyy')
                                    .format(_chats[0].chats[index].timeStamp),
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.black87,
                                  fontWeight: FontWeight.normal,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Html(data: _chats[0].chats[index].message)
                            ],
                          ),
                        ),
                      );
                    },
                  ),
      ),
    );
  }
}
