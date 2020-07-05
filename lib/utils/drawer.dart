import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../screens/my_orders_screen.dart';
import '../screens/cart_screen.dart';
import '../screens/view_update_profile_screen.dart';
import '../models/user.dart';
import '../HTTP_handler.dart';
import '../screens/start_screen.dart';

class SideDrawer {
  User user;
  var scaffoldKey = GlobalKey<ScaffoldState>();

  SideDrawer(this.user, this.scaffoldKey);

  Widget drawer(BuildContext context) => Drawer(
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
                      height: 50.0,
                      width: 50.0,
                      child: Icon(Icons.person),
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
            _drawerTile('View/Update Profile', () {
              print('view or update profile');
              Navigator.pop(context);
              Navigator.of(context)
                  .pushNamed(ViewUpdateProfile.routeName, arguments: user);
            }),
            _drawerTile('View Cart', () {
              print('view cart');
              Navigator.pop(context);
              Navigator.of(context).pushNamed(CartScreen.routeName);
            }),
            _drawerTile('View Orders', () async {
              print('view orders');
              Navigator.pop(context);
              //  ADD ARGUMENTS AS EXPECTED IN ORDERS SCREEN
              Navigator.of(context)
                  .pushNamed(MyOrdersScreen.routeName, arguments: user.token);
            }),
            _drawerTile('LogOut', () {
              print('Log out');
              HTTPHandler().logOut(user.token).then((loggedOut) async {
                if (loggedOut) {
                  SharedPreferences prefs =
                      await SharedPreferences.getInstance();
                  await prefs.remove('loggedIn');
                  await prefs.remove('loggedInEmail');
                  await prefs.remove('token');
                  await prefs.remove('loggedInPassword');
                  Navigator.of(context).popAndPushNamed(
                    StartScreen.routeName,
                  );
                } else
                  scaffoldKey.currentState.showSnackBar(SnackBar(
                    content: Text('LogOut failed'),
                    backgroundColor: Colors.red,
                    duration: Duration(seconds: 3),
                  ));
              });
            }),
          ],
        ),
      );

  Widget _drawerTile(
    String text,
    Function f,
  ) =>
      ListTile(
        // leading: Container(
        //   height: 30.0,
        //   width: 30.0,
        //   child: SvgPicture.asset(
        //     imagePath,
        //     color: Colors.yellow[800],
        //     fit: BoxFit.cover,
        //   ),
        // ),
        title: Text(text),
        onTap: f,
      );
}
