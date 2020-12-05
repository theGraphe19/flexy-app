import 'package:flutter/material.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_html/flutter_html.dart';

import '../utils/wishlist_bottom_sheet.dart';
import './products_screen.dart';
import '../models/user.dart';
import '../HTTP_handler.dart';
import '../utils/drawer.dart';
import '../widgets/loading_body.dart';
import '../models/category.dart';
import './search_screen.dart';
import '../models/chat.dart';

class CategoriesScreen extends StatefulWidget {
  static const routeName = '/categories-screen';

  @override
  _CategoriesScreenState createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen> {
  User _currentUser;
  bool categoryListHandler = false;
  List<Category> categoriesList;
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  HTTPHandler _handler = HTTPHandler();
  String mobileNo;
  bool _controller = false;
  Map adminDetails;
  SharedPreferences prefs;
  WishlistBottomSheet _wishlistBottomSheet;
  var hasUnread = false;

  void _showAbout(BuildContext context) {
    _scaffoldKey.currentState.showBottomSheet(
      (context) => Container(
        height: MediaQuery.of(context).size.height * 1 / 2 - 20.0,
        color: Colors.grey[300],
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                height: 3.0,
                width: MediaQuery.of(context).size.width,
                color: Colors.red,
              ),
              SizedBox(height: 20.0),
              Image.asset('assets/images/pending.png'),
              SizedBox(height: 15.0),
              Container(
                padding: const EdgeInsets.symmetric(
                  vertical: 10.0,
                  horizontal: 20.0,
                ),
                child: Text(
                  'Thank You for registering and providing us your details. Your account is under review and will be accepted for trade soon.\n\n Meanwhile You can get in touch with us through Call/Whatsapp us at:',
                  style: TextStyle(fontSize: 13.0),
                ),
              ),
              SizedBox(height: 15.0),
              Text(
                mobileNo,
                style: TextStyle(
                  color: Colors.red[600],
                  fontSize: 26.0,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 1.1,
                ),
              ),
              SizedBox(height: 15.0),
              Container(
                padding: const EdgeInsets.symmetric(
                  vertical: 10.0,
                  horizontal: 20.0,
                ),
                child: Text(
                  'Please relaunch to check if your account has been activated!',
                  style: TextStyle(fontSize: 13.0),
                ),
              ),
              SizedBox(height: 15.0),
              RaisedButton(
                color: Color(0xffbf1e2e),
                child: Text(
                  'RELAUNCH',
                  style: TextStyle(color: Colors.white),
                ),
                onPressed: () async {
                  prefs = await SharedPreferences.getInstance();
                  await prefs.remove('loggedIn');
                  await prefs.remove('token');
                  await prefs.remove('loginTime');
                  await prefs.remove('loggedInUser');
                  Phoenix.rebirth(context);
                },
              ),
              SizedBox(height: 35.0),
            ],
          ),
        ),
      ),
    );
  }

  Route _createRoute() {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) =>
          SearchScreen(_currentUser),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        var begin = Offset(0.0, 1.0);
        var end = Offset.zero;
        var curve = Curves.ease;

        var tween =
            Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

        return SlideTransition(
          position: animation.drive(tween),
          child: child,
        );
      },
    );
  }

  @override
  void initState() {
    final fbm = FirebaseMessaging();
    fbm.requestNotificationPermissions();
    fbm.configure(
      onMessage: (message) {
        print('onMessage => $message');
        return;
      },
      onLaunch: (message) {
        print('onLaunch => $message');
        return;
      },
      onResume: (message) {
        print('onResume => $message');
        return;
      },
    );
    super.initState();
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

      hasUnread = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    _currentUser = ModalRoute.of(context).settings.arguments as User;

    if (_currentUser.status != 1 && !_controller) {
      _controller = true;
      _handler.getAdminContactDetails().then((Map value) {
        adminDetails = value;
        mobileNo = value['phone'];
        setState(() {
          Future.delayed(Duration(seconds: 1), () => _showAbout(context));
        });
      });
    }

    if (_currentUser.status == 1) if (!categoryListHandler) {
      categoryListHandler = true;

      checkUnreadMsgs();

      _handler.getWishListItems(context, _currentUser.id.toString());

      _handler.getCategoriesList(_currentUser.token).then((cat) {
        categoriesList = cat;
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

    _wishlistBottomSheet = WishlistBottomSheet(
      context: context,
      scaffoldKey: _scaffoldKey,
      user: _currentUser,
    );

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
        title: Text((_currentUser.status == 1) ? 'Categories' : 'Flexy'),
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.search,
              color: Colors.white,
            ),
            onPressed: () {
              print('search');
              Navigator.of(context).push(_createRoute());
            },
          ),
          Padding(
            padding: const EdgeInsets.only(right: 5.0),
            child: IconButton(
              icon: Icon(
                Icons.favorite,
                color: Colors.white,
              ),
              onPressed: () {
                _wishlistBottomSheet.fireWishlist();
              },
            ),
          )
        ],
      ),
      drawer: SideDrawer(_currentUser, _scaffoldKey, hasUnread).drawer(context),
      body: Padding(
          padding: const EdgeInsets.all(10.0),
          child: (_currentUser.status == 1)
              ? (categoriesList == null)
                  ? LoadingBody()
                  : Container(
                      height: double.infinity,
                      child: ListView.builder(
                        itemCount: categoriesList.length,
                        itemBuilder: (BuildContext context, int index) {
                          return GestureDetector(
                            onTap: () {
                              Navigator.of(context).pushNamed(
                                ProductsScreen.routeName,
                                arguments: <String, dynamic>{
                                  'user': _currentUser,
                                  'category': categoriesList[index],
                                },
                              );
                            },
                            child: Container(
                              height: MediaQuery.of(context).size.height / 3,
                              width: double.infinity,
                              child: Column(
                                children: [
                                  Image.network(
                                    'https://developers.thegraphe.com/flexy/storage/app/categories/${categoriesList[index].image}',
                                    height:
                                        MediaQuery.of(context).size.height / 3 -
                                            5,
                                    fit: BoxFit.fitHeight,
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    )
              : Container(
                  color: Colors.white,
                  width: MediaQuery.of(context).size.width,
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(height: 20.0),
                        Image.asset(
                          'assets/icon/icon.png',
                          height: 180.0,
                          width: 180.0,
                        ),
                        SizedBox(height: 30.0),
                        Container(
                          margin: const EdgeInsets.only(bottom: 400.0),
                          padding: const EdgeInsets.symmetric(
                            vertical: 10.0,
                            horizontal: 20.0,
                          ),
                          child: Html(
                            data: (adminDetails == null)
                                ? ''
                                : adminDetails['about'],
                            // style: TextStyle(fontSize: 13.0),
                          ),
                        ),
                      ],
                    ),
                  ),
                )),
    );
  }
}
