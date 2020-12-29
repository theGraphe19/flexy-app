import 'package:flutter/material.dart';
import 'package:toast/toast.dart';

import './categories_screen.dart';
import '../HTTP_handler.dart';
import '../models/user.dart';
import '../utils/drawer.dart';
import '../models/notification.dart' as notif;
import './cart_screen.dart';
import './chat_screen.dart';
import './legal_details_screen.dart';
import './my_orders_screen.dart';
import '../models/chat.dart';

class NotificationScreen extends StatefulWidget {
  static const routeName = '/notification-screen';

  @override
  _NotificationScreenState createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  User _currentUser;
  bool notificationListHandler = false;
  List<notif.Notification> _notificationList;
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  HTTPHandler _handler = HTTPHandler();
  var hasUnread = false;
  var text;

  getNotification() {
    notificationListHandler = true;
    _handler.getNotification(_currentUser.token).then((value) {
      setState(() {
        _notificationList = value;
      });
    }).catchError((e) {
      print(e);
      Toast.show(
        'Network Error',
        context,
        duration: Toast.LENGTH_SHORT,
        gravity: Toast.BOTTOM,
      );
    });
  }

  void checkUnreadMsgs() {
    _handler.getChats(_currentUser.token).then((value) {
      for (Chat c in value[0].chats) {
        if (c.status == 0) {
          setState(() {
            hasUnread = true;
          });
          break;
        }
      }

      _handler.getLevelName().then((value) {
        for (Map m in value) {
          if (m['level'] == _currentUser.category) {
            this.text = m['name'];
            print('level => $text');
            break;
          }
        }
      });

      hasUnread = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    _currentUser = ModalRoute.of(context).settings.arguments as User;
    if (!notificationListHandler) {
      getNotification();
      checkUnreadMsgs();
    }

    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.menu),
          onPressed: () {
            print('more pressed');
            _scaffoldKey.currentState.openDrawer();
          },
        ),
        title: Text((_currentUser.status == 1) ? 'Notification' : 'Flexy'),
      ),
      drawer: SideDrawer(
        _currentUser,
        _scaffoldKey,
        hasUnread,
        text,
      ).drawer(context),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 0.0),
          child: (_notificationList == null)
              ? Center(child: Text('No content available'))
              : Container(
                  padding: EdgeInsets.all(20.0),
                  child: ListView.builder(
                    itemCount: _notificationList.length,
                    shrinkWrap: true,
                    physics: ClampingScrollPhysics(),
                    itemBuilder: (context, index) {
                      if (_notificationList[index].title ==
                          'Products in Cart') {
                        return NotificationTile(
                          title: _notificationList[index].title,
                          message: _notificationList[index].message,
                          date: _notificationList[index].date,
                          onTap: () {
                            Navigator.of(context).pushNamed(
                              CartScreen.routeName,
                              arguments: _currentUser,
                            );
                          },
                        );
                      } else if (_notificationList[index].title ==
                          'Order Complete') {
                        return NotificationTile(
                          title: _notificationList[index].title,
                          message: _notificationList[index].message,
                          date: _notificationList[index].date,
                          onTap: () {
                            Navigator.of(context).pushNamed(
                              MyOrdersScreen.routeName,
                              arguments: _currentUser,
                            );
                          },
                        );
                      } else if (_notificationList[index].title ==
                          'New Message') {
                        return NotificationTile(
                          title: _notificationList[index].title,
                          message: _notificationList[index].message,
                          date: _notificationList[index].date,
                          onTap: () {
                            Navigator.of(context).pushNamed(
                              ChatScreen.routeName,
                              arguments: _currentUser.token,
                            );
                          },
                        );
                      } else if (_notificationList[index].title ==
                          'Legal Details') {
                        return NotificationTile(
                          title: _notificationList[index].title,
                          message: _notificationList[index].message,
                          date: _notificationList[index].date,
                          onTap: () {
                            Navigator.of(context).pushNamed(
                              LegalDetailsScreen.routeName,
                            );
                          },
                        );
                      } else if (_notificationList[index].title ==
                          'New Category') {
                        return NotificationTile(
                          title: _notificationList[index].title,
                          message: _notificationList[index].message,
                          date: _notificationList[index].date,
                          onTap: () {
                            Navigator.of(context).pushNamed(
                              CategoriesScreen.routeName,
                              arguments: _currentUser,
                            );
                          },
                        );
                      } else {
                        return NotificationTile(
                          title: _notificationList[index].title,
                          message: _notificationList[index].message,
                          date: _notificationList[index].date,
                          onTap: () {},
                        );
                      }
                    },
                  ),
                ),
        ),
      ),
    );
  }
}

class NotificationTile extends StatelessWidget {
  final String title, message, date;
  final Function onTap;

  NotificationTile({
    this.title,
    this.message,
    this.date,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        child: Column(
          children: <Widget>[
            SizedBox(
              height: 10.0,
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                title,
                style: TextStyle(
                  fontSize: 18.0,
                  color: Colors.black,
                ),
              ),
            ),
            SizedBox(
              height: 10.0,
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                message,
                style: TextStyle(
                  fontSize: 16.0,
                  color: Colors.black54,
                ),
              ),
            ),
            SizedBox(
              height: 10.0,
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                date,
                style: TextStyle(
                  fontSize: 13.0,
                  color: Colors.black45,
                ),
              ),
            ),
            SizedBox(
              height: 10.0,
            ),
            Divider(
              height: 5.0,
              color: Colors.black54,
            ),
          ],
        ),
      ),
    );
  }
}
