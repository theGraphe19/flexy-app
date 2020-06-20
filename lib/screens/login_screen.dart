import 'package:flutter/material.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';

import './products_screen.dart';
import '../HTTP_handler.dart';
import '../models/user.dart';
import '../widgets/loading_body.dart';

enum ForgotPassword {
  notForgot,
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

  var _emailController = TextEditingController();
  var _passwordController = TextEditingController();
  var _mobileController = TextEditingController();
  var _otpController = TextEditingController();

  ProgressDialog progressDialog;

  SharedPreferences prefs;

  bool _checkedValue = false;

  bool _stayLoggedIn;

  var status = ForgotPassword.notForgot;

  void _storeData(
    String token,
    bool loggedIn,
    String email,
    String password,
  ) async {
    prefs = await SharedPreferences.getInstance();
    await prefs.clear().then((isCleared) async {
      await prefs.setBool('loggedIn', loggedIn);
      await prefs.setString('loggedInEmail', email);
      await prefs.setString('loggedInPassword', password);
      await prefs.setString('token', token);
      print('data stored');
    });
    print(prefs.getBool('loggedIn'));
    print(prefs.getString('token'));
  }

  void _retreiveData() async {
    prefs = await SharedPreferences.getInstance();
    _stayLoggedIn = prefs.getBool('loggedIn') ?? false;

    final email = prefs.getString('loggedInEmail');
    final password = prefs.getString('loggedInPassword');

    if (_stayLoggedIn) {
      _handler
          .loginUser(
        email,
        password,
      )
          .then((User user) async {
        if (user != null) {
          print(user.name);
          _storeData(
            user.token,
            true,
            email,
            password,
          );
          Navigator.of(context).popAndPushNamed(
            ProductsScreen.routeName,
            arguments: user.token,
          );
        }
      }).catchError((onError) async {
        _stayLoggedIn = false;
        setState(() {});
        _scaffoldKey.currentState.showSnackBar(SnackBar(
          duration: Duration(seconds: 5),
          backgroundColor: Colors.red,
          content: Text("Error occured"),
        ));
      });
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
    _emailController.dispose();
    _passwordController.dispose();
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
                  child: (status == ForgotPassword.notForgot)
                      ? emailAndPassword()
                      : (status == ForgotPassword.forgotAndNotVerified)
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
                color: Colors.blue,
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
                      content: Text('Enter OTP first'),
                      backgroundColor: Colors.red,
                      duration: Duration(seconds: 5),
                    ));
                  } else {
                    _handler
                        .verifyOTP(_mobileController.text, _otpController.text)
                        .then((value) => print(value));
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
          Align(
            alignment: Alignment.bottomRight,
            child: Container(
              margin: const EdgeInsets.only(right: 10.0),
              decoration: BoxDecoration(
                shape: BoxShape.rectangle,
                color: Colors.blue,
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
                      content: Text('Enter a number'),
                      backgroundColor: Colors.red,
                      duration: Duration(seconds: 5),
                    ));
                  } else {
                    _handler
                        .requestPwdChangeOTP(_mobileController.text)
                        .then((int uid) {
                      if (uid == null) {
                        _scaffoldKey.currentState.showSnackBar(SnackBar(
                          content: Text('Network error! Try again.'),
                          backgroundColor: Colors.red,
                          duration: Duration(seconds: 5),
                        ));
                      } else {
                        status = ForgotPassword.waitingForOTP;
                        setState(() {});
                      }
                    });
                  }
                },
              ),
            ),
          ),
        ],
      );

  Widget emailAndPassword() => Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          TextField(
            controller: _emailController,
            keyboardType: TextInputType.emailAddress,
            decoration: InputDecoration(hintText: 'Email'),
          ),
          SizedBox(height: 20.0),
          TextField(
            obscureText: true,
            controller: _passwordController,
            keyboardType: TextInputType.visiblePassword,
            decoration: InputDecoration(hintText: 'Password'),
          ),
          SizedBox(height: 20.0),
          Container(
            padding: const EdgeInsets.only(right: 5.0),
            width: MediaQuery.of(context).size.width,
            child: GestureDetector(
              onTap: () {
                print('forgot password');
                status = ForgotPassword.forgotAndNotVerified;
                setState(() {});
              },
              child: Text(
                'Forgot Password?',
                textAlign: TextAlign.end,
                style: TextStyle(
                  color: Colors.blue[800],
                  decoration: TextDecoration.underline,
                ),
              ),
            ),
          ),
          CheckboxListTile(
            title: Text("Remember Me"),
            value: _checkedValue,
            onChanged: (newValue) {
              setState(() {
                _checkedValue = newValue;
              });
            },
            controlAffinity: ListTileControlAffinity.leading,
          ),
          SizedBox(height: 20.0),
          Align(
            alignment: Alignment.bottomRight,
            child: Container(
              margin: const EdgeInsets.only(right: 10.0),
              decoration: BoxDecoration(
                shape: BoxShape.rectangle,
                color: Colors.blue,
                borderRadius: BorderRadius.circular(30.0),
              ),
              child: FlatButton(
                child: Text(
                  'LOGIN',
                  style: TextStyle(color: Colors.white),
                ),
                onPressed: () async {
                  if (_emailController.text.isEmpty ||
                      _passwordController.text.isEmpty) {
                    _scaffoldKey.currentState.showSnackBar(SnackBar(
                      duration: Duration(seconds: 5),
                      backgroundColor: Colors.red,
                      content: Text("Empty Credentials"),
                    ));
                    return;
                  }
                  await progressDialog.show();
                  _handler
                      .loginUser(
                    _emailController.text,
                    _passwordController.text,
                  )
                      .then((User user) async {
                    if (user != null) {
                      print(user.name);
                      _storeData(
                        user.token,
                        _checkedValue,
                        _emailController.text,
                        _passwordController.text,
                      );
                      await progressDialog.hide();
                      Navigator.of(context).popAndPushNamed(
                        ProductsScreen.routeName,
                        arguments: user.token,
                      );
                    }
                  }).catchError((onError) async {
                    await progressDialog.hide();
                    _scaffoldKey.currentState.showSnackBar(SnackBar(
                      duration: Duration(seconds: 5),
                      backgroundColor: Colors.red,
                      content: Text("Wrong password or not registered"),
                    ));
                  });
                },
              ),
            ),
          ),
        ],
      );
}
