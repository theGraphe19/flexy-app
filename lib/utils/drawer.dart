import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart' as UrlLauncher;

import '../models/chat_overview.dart';
import '../models/chat.dart';
import '../screens/my_orders_screen.dart';
import '../screens/cart_screen.dart';
import '../screens/view_update_profile_screen.dart';
import '../screens/chat_screen.dart';
import '../screens/legal_details_screen.dart';
import '../models/user.dart';
import '../HTTP_handler.dart';
import '../screens/start_screen.dart';

/* 
<a target="_blank" href="https://icons8.com/icons/set/add-shopping-cart">Add Shopping Cart icon</a> icon by <a target="_blank" href="https://icons8.com">Icons8</a>
<a target="_blank" href="https://icons8.com/icons/set/gender-neutral-user">Customer icon</a> icon by <a target="_blank" href="https://icons8.com">Icons8</a>
<a target="_blank" href="https://icons8.com/icons/set/purchase-order">Purchase Order icon</a> icon by <a target="_blank" href="https://icons8.com">Icons8</a>
<a target="_blank" href="https://icons8.com/icons/set/exit">Exit icon</a> icon by <a target="_blank" href="https://icons8.com">Icons8</a>
<a target="_blank" href="https://icons8.com/icons/set/phone">Phone icon</a> icon by <a target="_blank" href="https://icons8.com">Icons8</a>
<a target="_blank" href="https://icons8.com/icons/set/connected-people">Connected People icon</a> icon by <a target="_blank" href="https://icons8.com">Icons8</a>
*/

class SideDrawer {
  User user;
  var scaffoldKey = GlobalKey<ScaffoldState>();
  HTTPHandler _handler = HTTPHandler();
  Map details;
  var hasUnread;

  SideDrawer(
    this.user,
    this.scaffoldKey,
    this.hasUnread,
  ) {
    print('from within the drawer => $hasUnread');
    _handler.getAdminContactDetails().then((value) {
      this.details = value;
    });
  }

  Widget drawer(BuildContext context) {
    return Drawer(
      child: Column(
        children: <Widget>[
          DrawerHeader(
            child: Container(
              height: double.infinity,
              width: double.infinity,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Container(
                    height: 70.0,
                    width: 70.0,
                    child: Image.asset(
                      'assets/images/user1.png',
                      fit: BoxFit.cover,
                    ),
                  ),
                  Container(
                    height: 50.0,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: <Widget>[
                        Text(
                          user.name,
                          style: TextStyle(
                            color: Colors.yellow[800],
                            fontWeight: FontWeight.bold,
                            fontSize: 20.0,
                          ),
                        ),
                        Text(
                          user.email,
                          textAlign: TextAlign.start,
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
          _drawerTile(
            'View/Update Profile',
            () {
              print('view or update profile');
              Navigator.pop(context);
              Navigator.of(context)
                  .pushNamed(ViewUpdateProfile.routeName, arguments: user);
            },
            'assets/images/user.png',
          ),
          Divider(),
          SizedBox(height: 5.0),
          ListTile(
            leading: Container(
              height: 60.0,
              width: 60.0,
              child: Image.asset(
                'assets/images/chatnot.png',
                fit: BoxFit.cover,
              ),
            ),
            title: Text('Messages'),
            onTap: () {
              print('chat');
              Navigator.pop(context);
              Navigator.of(context).pushNamed(
                ChatScreen.routeName,
                arguments: user.token,
              );
            },
            trailing: (this.hasUnread)
                ? Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: CircleAvatar(
                      backgroundColor: Theme.of(context).primaryColor,
                      radius: 5.0,
                    ),
                  )
                : SizedBox(),
          ),
          Divider(),
          SizedBox(height: 5.0),
          _drawerTile(
            'View Cart',
            () {
              print('view cart');
              Navigator.pop(context);
              Navigator.of(context).pushNamed(
                CartScreen.routeName,
                arguments: user,
              );
            },
            'assets/images/cart.png',
          ),
          Divider(),
          SizedBox(height: 5.0),
          _drawerTile(
            'View Orders',
            () {
              print('view orders');
              Navigator.pop(context);
              Navigator.of(context)
                  .pushNamed(MyOrdersScreen.routeName, arguments: user.token);
            },
            'assets/images/order.png',
          ),
          Divider(),
          SizedBox(height: 5.0),
          _drawerTile(
            'Legal Details',
            () {
              print('legal details');
              Navigator.pop(context);
              Navigator.of(context).pushNamed(LegalDetailsScreen.routeName);
            },
            'assets/images/legal.png',
          ),
          Divider(),
          SizedBox(height: 5.0),
          _drawerTile(
            'LogOut',
            () {
              print('Log out');
              _handler.logOut(user.token).then((loggedOut) async {
                if (loggedOut) {
                  SharedPreferences prefs =
                      await SharedPreferences.getInstance();
                  await prefs.remove('loggedIn');
                  await prefs.remove('loggedInUser');
                  await prefs.remove('token');
                  Navigator.of(context).popAndPushNamed(
                    StartScreen.routeName,
                  );
                } else
                  scaffoldKey.currentState.showSnackBar(SnackBar(
                    content: Text(
                      'LogOut failed',
                      style: TextStyle(color: Colors.white),
                    ),
                    backgroundColor: Color(0xff6c757d),
                    duration: Duration(seconds: 3),
                  ));
              }).catchError((e) {
                scaffoldKey.currentState.showSnackBar(SnackBar(
                  content: Text(
                    'Network error!',
                    style: TextStyle(color: Colors.white),
                  ),
                  backgroundColor: Color(0xff6c757d),
                  duration: Duration(seconds: 3),
                ));
              });
            },
            'assets/images/exit.png',
          ),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                Divider(),
                Container(
                  margin: const EdgeInsets.all(20.0),
                  padding: const EdgeInsets.only(bottom: 10.0),
                  alignment: Alignment.bottomCenter,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      GestureDetector(
                        onTap: () {
                          print('calling');
                          UrlLauncher.launch("tel:${details['phone']}");
                        },
                        child: Image.asset(
                          'assets/images/call.png',
                          height: 60.0,
                          width: 60.0,
                        ),
                      ),
                      GestureDetector(
                        onTap: () async {
                          var whatsappUrl =
                              "whatsapp://send?phone=+91${details['whatsapp']}";
                          await UrlLauncher.canLaunch(whatsappUrl)
                              ? UrlLauncher.launch(whatsappUrl)
                              : scaffoldKey.currentState.showSnackBar(SnackBar(
                                  content: Text(
                                    'WhatsApp not installed!',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                  backgroundColor: Color(0xff6c757d),
                                  duration: Duration(seconds: 2),
                                ));
                        },
                        child: Image.asset(
                          'assets/images/whatsapp.png',
                          height: 60.0,
                          width: 60.0,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _drawerTile(
    String text,
    Function f,
    String icon,
  ) =>
      ListTile(
        leading: Container(
          height: 60.0,
          width: 60.0,
          child: Image.asset(
            icon,
            fit: BoxFit.cover,
          ),
        ),
        title: Text(text),
        onTap: f,
      );
}
