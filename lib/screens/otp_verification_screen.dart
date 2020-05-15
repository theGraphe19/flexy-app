import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:progress_dialog/progress_dialog.dart';

import '../models/user.dart';
import './registration_form_page1.dart';
import '../credentials.dart';
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

  String baseUrl = 'https://api.msg91.com/api/v5/otp';

  VerificationStatus status = VerificationStatus.notVerified;

  ProgressDialog progressDialog;

  // Future<void> _verifyOTP() async {
  //   if (_otpController.text.isNotEmpty &&
  //       (_otpController.text.length == 6 || _otpController.text.length == 4)) {
  //     await progressDialog.show();
  //     http.Response response = await http.post(
  //         '$baseUrl/verify?authkey=$MSG91_API_KEY&mobile=91${currentUser.mobileNo}&otp=${_otpController.text}');

  //     Map<String, dynamic> result = json.decode(response.body);
  //     print(result.toString());
  //     if (result['type'].contains('success')) {
  //       print('OTP verified');
  //       status = VerificationStatus.verified;
  //       await progressDialog.hide();
  //       setState(() {});
  //     } else {
  //       await progressDialog.hide();
  //       print('error');
  //     }
  //   } else {
  //     print('Enter a valid OTP');
  //   }
  // }

  void _confirmUser() {
    if (_passwordController.text.isEmpty ||
        _confirmPasswordController.text.isEmpty) {
      print('Please fill all the fields.');
    } else {
      if (_passwordController.text.contains(_confirmPasswordController.text) &&
          _confirmPasswordController.text.contains(_passwordController.text)) {
        currentUser.password = _confirmPasswordController.text;

        Navigator.of(context).popAndPushNamed(ProductsScreen.routeName);
      } else {
        print('Please enter same password in both the fields.');
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
                      color: Colors.blue,
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
                      color: Colors.blue,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  onPressed: () {
                    _handler.sendOTP(currentUser.mobileNo).then((bool otpSent) {
                      if (otpSent) {
                        status = VerificationStatus.waiting;
                        setState(() {});
                      } else {
                        _scaffoldKey.currentState.showSnackBar(SnackBar(
                          content: Text('Unable to send OTP!'),
                          backgroundColor: Colors.red,
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
                  onPressed: () {
                    if (_otpController.text.length != 6) {
                      _scaffoldKey.currentState.showSnackBar(SnackBar(
                        content: Text('Enter 6-digit OTP'),
                        backgroundColor: Colors.red,
                        duration: Duration(seconds: 5),
                      ));
                      return;
                    }
                    _handler
                        .verifyOTP(currentUser.mobileNo, _otpController.text)
                        .then((bool otpVerified) {
                      if (otpVerified) {
                        status = VerificationStatus.verified;
                        setState(() {});
                      } else {
                        _scaffoldKey.currentState.showSnackBar(SnackBar(
                          content: Text('OPT verification failed'),
                          backgroundColor: Colors.red,
                          duration: Duration(seconds: 5),
                        ));
                      }
                    });
                  },
                  child: Text(
                    'VERIFY',
                    style: TextStyle(color: Colors.white),
                  ),
                  color: Colors.blue,
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
              keyboardType: TextInputType.number,
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
              keyboardType: TextInputType.number,
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
                color: Colors.blue,
              ),
            ),
          ),
        ],
      );
}
