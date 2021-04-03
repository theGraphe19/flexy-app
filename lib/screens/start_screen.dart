import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';

import '../HTTP_handler.dart';
import '../models/user.dart';
import './registration_form_page1.dart';
import './login_screen.dart';
import './categories_screen.dart';

class StartScreen extends StatefulWidget {
  static const routeName = '/start-screen';

  @override
  _StartScreenState createState() => _StartScreenState();
}

class _StartScreenState extends State<StartScreen> {
  var _scaffoldKey = GlobalKey<ScaffoldState>();
  bool _retreivingPrev = true;

  void _storeData(
    String token,
    bool loggedIn,
    User user,
  ) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('loggedIn');
    await prefs.remove('token');
    await prefs.remove('loginTime');
    await prefs.remove('loggedInUser');
    await prefs.setBool('loggedIn', loggedIn);
    await prefs.setString('loggedInUser', json.encode(user.data));
    await prefs.setString('token', token);
    await prefs.setInt('loginTime', DateTime.now().millisecondsSinceEpoch);
    print('data stored');
    print(prefs.getBool('loggedIn'));
    print(prefs.getString('token'));
  }

  void _retreiveData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool _stayLoggedIn = prefs.getBool('loggedIn') ?? false;
    print("StayLoggedIn: " + _stayLoggedIn.toString());

    if (_stayLoggedIn) {
      print('staying');
      final encodedUser = prefs.getString('loggedInUser');
      User user = User();
      user.mapToUser(json.decode(encodedUser));

      int timeStamp = prefs.getInt('loginTime');
      Duration timeDiff = DateTime.now()
          .difference(DateTime.fromMillisecondsSinceEpoch(timeStamp));
      if (timeDiff.inHours < 24) {
        await HTTPHandler()
            .verifyOTPLogin(prefs.getString('mobile'), prefs.getString('otp'))
            .then((User user) {
          _storeData(user.token, true, user);
          print(user.name);
          Navigator.of(context).pushNamedAndRemoveUntil(
            CategoriesScreen.routeName,
            (Route<dynamic> route) => false,
            arguments: user,
          );
        }).catchError((e) {
          _scaffoldKey.currentState.showSnackBar(SnackBar(
            content: Text(
              'Network error! Try again later.',
              style: TextStyle(color: Colors.white),
            ),
            backgroundColor: Color(0xff6c757d),
            duration: Duration(seconds: 5),
          ));
        });
      } else {
        _stayLoggedIn = false;
        Toast.show(
          'You have been automatically logged out!',
          context,
          duration: Toast.LENGTH_LONG,
          gravity: Toast.BOTTOM,
        );
        setState(() {});
      }
    }

    setState(() {
      _retreivingPrev = false;
    });
  }

  @override
  void initState() {
    super.initState();
    _retreiveData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.white,
      body: (_retreivingPrev)
          ? Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.black),
              ),
            )
          : Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Image.asset(
                    'assets/icon/icon.png',
                    width: MediaQuery.of(context).size.width * 0.5,
                    frameBuilder:
                        (context, child, frame, wasSynchronouslyLoaded) =>
                            Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: child,
                    ),
                  ),
                  SizedBox(height: 150.0),
                  GestureDetector(
                    onTap: () => Navigator.of(context)
                        .popAndPushNamed(RegistrationFormPag1.routeName),
                    child: Container(
                      width: MediaQuery.of(context).size.width * 0.65,
                      padding: const EdgeInsets.symmetric(
                        vertical: 13.0,
                        horizontal: 50.0,
                      ),
                      decoration: BoxDecoration(
                        color: Theme.of(context).primaryColor,
                        shape: BoxShape.rectangle,
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      child: Center(
                        child: Text(
                          'Register',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 22.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 20.0),
                  GestureDetector(
                    onTap: () =>
                        Navigator.of(context).pushNamed(LoginScreen.routeName),
                    child: Container(
                      width: MediaQuery.of(context).size.width * 0.65,
                      padding: const EdgeInsets.symmetric(
                        vertical: 13.0,
                        horizontal: 65.0,
                      ),
                      decoration: BoxDecoration(
                        color: Theme.of(context).primaryColor,
                        shape: BoxShape.rectangle,
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      child: Center(
                        child: Text(
                          'Login',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
