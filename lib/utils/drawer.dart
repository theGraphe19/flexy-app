import 'package:flutter/material.dart';

import '../screens/orders_screen.dart';
import '../screens/cart_screen.dart';
import '../screens/view_update_profile_screen.dart';
import '../models/user.dart';

class SideDrawer {
  User user;
  SideDrawer(this.user);
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
                            'Name',
                            style: TextStyle(
                              color: Colors.yellow[800],
                              fontWeight: FontWeight.bold,
                              fontSize: 20.0,
                            ),
                          ),
                          Text(
                            'Email',
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
              Navigator.of(context).pushNamed(ViewUpdateProfile.routeName, arguments: user);
            }),
            _drawerTile('View Cart', () {
              print('view cart');
              Navigator.pop(context);
              Navigator.of(context).pushNamed(CartScreen.routeName);
            }),
            _drawerTile('View Orders', () {
              print('view orders');
              Navigator.pop(context);
              //  ADD ARGUMENTS AS EXPECTED IN ORDERS SCREEN
              Navigator.of(context).pushNamed(OrdersScreen.routeName);
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
