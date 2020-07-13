import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';

import './categories_screen.dart';
import '../HTTP_handler.dart';
import '../models/user.dart';
import '../widgets/loading_body.dart';

enum ForgotPassword {
  forgotAndNotVerified,
  waitingForOTP,
}

class LoginScreen extends StatefulWidget {
  static const routeName = '/login-screen';

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  HTTPHandler _handler = HTTPHandler();
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  var _mobileController = TextEditingController();
  var _otpController = TextEditingController();

  ProgressDialog progressDialog;
  SharedPreferences prefs;
  bool _checkedValue = false;
  bool _stayLoggedIn;
  var status = ForgotPassword.forgotAndNotVerified;

  void _storeData(
    String token,
    bool loggedIn,
    User user,
  ) async {
    prefs = await SharedPreferences.getInstance();
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
    prefs = await SharedPreferences.getInstance();
    _stayLoggedIn = prefs.getBool('loggedIn') ?? false;

    final encodedUser = prefs.getString('loggedInUser');
    User user = User();
    user.mapToUser(json.decode(encodedUser));

    if (_stayLoggedIn) {
      int timeStamp = prefs.getInt('loginTime');
      Duration timeDiff = DateTime.now()
          .difference(DateTime.fromMillisecondsSinceEpoch(timeStamp));
      if (timeDiff.inHours < 24) {
        print(user.name);
        _storeData(
          user.token,
          true,
          user,
        );
        Navigator.of(context).popAndPushNamed(
          CategoriesScreen.routeName,
          arguments: user,
        );
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
    } else {
      setState(() {});
    }
    print(_stayLoggedIn);
  }

  @override
  void initState() {
    super.initState();
    _retreiveData();
    SharedPreferences.getInstance().then((value) => prefs = value);
  }

  @override
  void dispose() {
    _mobileController.dispose();
    _otpController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    //_retreiveData();
    progressDialog = ProgressDialog(
      context,
      type: ProgressDialogType.Normal,
      isDismissible: false,
      showLogs: true,
    );
    progressDialog.style(
      message: 'Please wait!',
      borderRadius: 10.0,
      backgroundColor: Colors.white,
      progressWidget: CircularProgressIndicator(),
      elevation: 10.0,
      insetAnimCurve: Curves.easeInOut,
    );
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text('Login'),
      ),
      body: (_stayLoggedIn == null)
          ? LoadingBody()
          : (_stayLoggedIn)
              ? LoadingBody()
              : Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: (status == ForgotPassword.forgotAndNotVerified)
                      ? otpVerify()
                      : otpCheck(),
                ),
    );
  }

  Widget otpCheck() => Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          TextField(
            controller: _otpController,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(hintText: 'Enter OTP'),
          ),
          SizedBox(height: 20.0),
          Align(
            alignment: Alignment.bottomRight,
            child: Container(
              margin: const EdgeInsets.only(right: 10.0),
              decoration: BoxDecoration(
                shape: BoxShape.rectangle,
                color: Theme.of(context).primaryColorDark,
                borderRadius: BorderRadius.circular(30.0),
              ),
              child: FlatButton(
                child: Text(
                  'VERIFY OTP',
                  style: TextStyle(color: Colors.white),
                ),
                onPressed: () async {
                  print('verify otp');
                  if (_otpController.text == '') {
                    _scaffoldKey.currentState.showSnackBar(SnackBar(
                      content: Text(
                        'Enter OTP first',
                        style: TextStyle(color: Colors.white),
                      ),
                      backgroundColor: Color(0xff6c757d),
                      duration: Duration(seconds: 5),
                    ));
                  } else {
                    _handler
                        .verifyOTP(_mobileController.text, _otpController.text)
                        .then((bool verified) {
                      print(verified);
                      if (!verified) {   // TODO - Change to verified once we get transactionam OTP
                        _handler
                            .loginUser(_mobileController.text)
                            .then((User user) {
                          _storeData(user.token, _checkedValue, user);
                          Navigator.of(context).popAndPushNamed(
                            CategoriesScreen.routeName,
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
                          status = ForgotPassword.forgotAndNotVerified;
                          setState(() {});
                        });
                      } else {
                        _scaffoldKey.currentState.showSnackBar(SnackBar(
                          content: Text(
                            'Wrong OTP',
                            style: TextStyle(color: Colors.white),
                          ),
                          backgroundColor: Color(0xff6c757d),
                          duration: Duration(seconds: 5),
                        ));
                      }
                    }).catchError((e) {
                      _scaffoldKey.currentState.showSnackBar(SnackBar(
                        content: Text(
                          'Network error! Try again later.',
                          style: TextStyle(color: Colors.white),
                        ),
                        backgroundColor: Color(0xff6c757d),
                        duration: Duration(seconds: 5),
                      ));
                      status = ForgotPassword.forgotAndNotVerified;
                      setState(() {});
                    });
                  }
                },
              ),
            ),
          ),
        ],
      );

  Widget otpVerify() => Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          TextField(
            controller: _mobileController,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(hintText: 'Enter Mobile Number'),
          ),
          SizedBox(height: 20.0),
          CheckboxListTile(
            title: Text("Remember Me"),
            value: _checkedValue,
            onChanged: (newValue) {
              setState(() {
                _checkedValue = newValue;
              });
            },
            activeColor: Theme.of(context).primaryColor,
            controlAffinity: ListTileControlAffinity.leading,
          ),
          SizedBox(height: 10.0),
          Align(
            alignment: Alignment.bottomRight,
            child: Container(
              margin: const EdgeInsets.only(right: 10.0),
              decoration: BoxDecoration(
                shape: BoxShape.rectangle,
                color: Theme.of(context).primaryColorDark,
                borderRadius: BorderRadius.circular(30.0),
              ),
              child: FlatButton(
                child: Text(
                  'REQUEST OTP',
                  style: TextStyle(color: Colors.white),
                ),
                onPressed: () async {
                  print('req otp');
                  if (_mobileController.text == '') {
                    _scaffoldKey.currentState.showSnackBar(SnackBar(
                      content: Text(
                        'Enter a number',
                        style: TextStyle(color: Colors.white),
                      ),
                      backgroundColor: Color(0xff6c757d),
                      duration: Duration(seconds: 5),
                    ));
                  } else {
                    _handler.sendOTP(_mobileController.text).then((bool uid) {
                      if (!uid) {
                        _scaffoldKey.currentState.showSnackBar(SnackBar(
                          content: Text(
                            'Network error! Try again.',
                            style: TextStyle(color: Colors.white),
                          ),
                          backgroundColor: Color(0xff6c757d),
                          duration: Duration(seconds: 5),
                        ));
                      } else {
                        status = ForgotPassword.waitingForOTP;
                        setState(() {});
                      }
                    }).catchError((e) {
                      _scaffoldKey.currentState.showSnackBar(SnackBar(
                        content: Text(
                          'Network error!',
                          style: TextStyle(color: Colors.white),
                        ),
                        backgroundColor: Color(0xff6c757d),
                        duration: Duration(seconds: 3),
                      ));
                      status = ForgotPassword.forgotAndNotVerified;
                      setState(() {});
                    });
                  }
                },
              ),
            ),
          ),
        ],
      );
}
