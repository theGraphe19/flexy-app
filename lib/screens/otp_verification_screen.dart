import 'package:flutter/material.dart';
import 'package:progress_dialog/progress_dialog.dart';

import '../models/user.dart';
import './registration_form_page1.dart';
import './products_screen.dart';
import '../HTTP_handler.dart';

enum VerificationStatus {
  notVerified,
  waiting,
  verified,
}

class OTPVerificationScreen extends StatefulWidget {
  static const routeName = '/otp-verification-screen';

  @override
  _OTPVerificationScreenState createState() => _OTPVerificationScreenState();
}

class _OTPVerificationScreenState extends State<OTPVerificationScreen> {
  User currentUser;

  HTTPHandler _handler = HTTPHandler();
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  var _otpController = TextEditingController();
  var _passwordController = TextEditingController();
  var _confirmPasswordController = TextEditingController();

  VerificationStatus status = VerificationStatus.notVerified;

  ProgressDialog progressDialog;

  void _confirmUser() async {
    if (_passwordController.text.isEmpty ||
        _confirmPasswordController.text.isEmpty) {
      _scaffoldKey.currentState.showSnackBar(SnackBar(
        content: Text('Please enter value in both text fields.', style: TextStyle(color: Colors.white),),
        backgroundColor: Color(0xff6c757d),
      ));
    } else {
      if (_passwordController.text.contains(_confirmPasswordController.text) &&
          _confirmPasswordController.text.contains(_passwordController.text)) {
        currentUser.password = _confirmPasswordController.text;
        print(currentUser.password);
        await progressDialog.show();
        _handler.registerUser(currentUser).then((value) async {
          if (value != null) {
            await progressDialog.hide();
            Navigator.of(context).popAndPushNamed(
              ProductsScreen.routeName,
              arguments: value,
            );
          } else
            await progressDialog.hide();
          _scaffoldKey.currentState.showSnackBar(SnackBar(
            content: Text('User registration failed, try again later.', style: TextStyle(color: Colors.white),),
            backgroundColor: Color(0xff6c757d),
          ));
        });

        //Navigator.of(context).popAndPushNamed(ProductsScreen.routeName);
      } else {
        _scaffoldKey.currentState.showSnackBar(SnackBar(
          content: Text('Please enter same value in both text fields.', style: TextStyle(color: Colors.white),),
          backgroundColor: Color(0xff6c757d),
        ));
      }
    }
  }

  @override
  void dispose() {
    _otpController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    currentUser = ModalRoute.of(context).settings.arguments as User;
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
        title: Text('Verify your Number'),
      ),
      body: (status == VerificationStatus.notVerified)
          ? sendOTP()
          : (status == VerificationStatus.waiting)
              ? verifyOTP()
              : setPassword(),
    );
  }

  Widget sendOTP() => Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            RichText(
              text: TextSpan(
                children: <TextSpan>[
                  TextSpan(
                    text: 'Send OTP to ',
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 20.0,
                    ),
                  ),
                  TextSpan(
                    text: currentUser.mobileNo,
                    style: TextStyle(
                      color: Colors.blueGrey,
                      fontSize: 25.0,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 10.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                FlatButton(
                  child: Text(
                    'Change',
                    style: TextStyle(
                      color: Theme.of(context).accentColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  onPressed: () => Navigator.of(context).popAndPushNamed(
                    RegistrationFormPag1.routeName,
                    arguments: currentUser,
                  ),
                ),
                FlatButton(
                  child: Text(
                    'OK',
                    style: TextStyle(
                      color: Theme.of(context).primaryColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  onPressed: () async {
                    await progressDialog.show();
                    _handler
                        .sendOTP('91${currentUser.mobileNo}')
                        .then((bool otpSent) async {
                      await progressDialog.hide();
                      if (otpSent) {
                        status = VerificationStatus.waiting;
                        setState(() {});
                      } else {
                        _scaffoldKey.currentState.showSnackBar(SnackBar(
                          content: Text('Unable to send OTP!', style: TextStyle(color: Colors.white),),
                          backgroundColor: Color(0xff6c757d),
                          duration: Duration(seconds: 5),
                        ));
                      }
                    });
                  },
                ),
              ],
            )
          ],
        ),
      );

  Widget verifyOTP() => Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            SizedBox(height: 20.0),
            RichText(
              text: TextSpan(
                children: <TextSpan>[
                  TextSpan(
                    text: 'OTP sent to ',
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 20.0,
                    ),
                  ),
                  TextSpan(
                    text: currentUser.mobileNo,
                    style: TextStyle(
                      color: Colors.blueGrey,
                      fontSize: 25.0,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20.0),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15.0),
              child: TextField(
                controller: _otpController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  hintText: 'Enter 6-digit OTP',
                ),
              ),
            ),
            SizedBox(height: 10.0),
            Align(
              alignment: Alignment.bottomRight,
              child: Container(
                margin: const EdgeInsets.only(right: 15.0),
                child: RaisedButton(
                  onPressed: () async {
                    if (_otpController.text.length != 6) {
                      _scaffoldKey.currentState.showSnackBar(SnackBar(
                        content: Text('Enter 6-digit OTP', style: TextStyle(color: Colors.white),),
                        backgroundColor: Color(0xff6c757d),
                        duration: Duration(seconds: 5),
                      ));
                      return;
                    }
                    await progressDialog.show();
                    _handler
                        .verifyOTP(
                            '91${currentUser.mobileNo}', _otpController.text)
                        .then((bool otpVerified) async {
                      await progressDialog.hide();
                      if (otpVerified) {
                        status = VerificationStatus.verified;
                        setState(() {});
                      } else {
                        _scaffoldKey.currentState.showSnackBar(SnackBar(
                          content: Text('OPT verification failed', style: TextStyle(color: Colors.white),),
                          backgroundColor: Color(0xff6c757d),
                          duration: Duration(seconds: 5),
                        ));
                      }
                    });
                  },
                  child: Text(
                    'VERIFY',
                    style: TextStyle(color: Colors.white),
                  ),
                  color: Theme.of(context).primaryColor,
                ),
              ),
            ),
          ],
        ),
      );

  Widget setPassword() => Column(
        children: <Widget>[
          SizedBox(height: 20.0),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0),
            child: TextField(
              controller: _passwordController,
              obscureText: true,
              keyboardType: TextInputType.visiblePassword,
              decoration: InputDecoration(
                hintText: 'Enter Password',
              ),
            ),
          ),
          SizedBox(height: 20.0),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0),
            child: TextField(
              controller: _confirmPasswordController,
              obscureText: true,
              keyboardType: TextInputType.visiblePassword,
              decoration: InputDecoration(
                hintText: 'Confirm Password',
              ),
            ),
          ),
          SizedBox(height: 10.0),
          Align(
            alignment: Alignment.bottomRight,
            child: Container(
              margin: const EdgeInsets.only(right: 15.0),
              child: RaisedButton(
                onPressed: _confirmUser,
                child: Text(
                  'Proceed',
                  style: TextStyle(color: Colors.white),
                ),
                color: Theme.of(context).primaryColor,
              ),
            ),
          ),
        ],
      );
}
