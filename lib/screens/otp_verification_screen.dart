import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:fluttertoast/fluttertoast.dart';

import '../models/user.dart';
import './registration_form_page1.dart';
import '../credentials.dart';

class OTPVerificationScreen extends StatefulWidget {
  static const routeName = '/otp-verification-screen';

  @override
  _OTPVerificationScreenState createState() => _OTPVerificationScreenState();
}

class _OTPVerificationScreenState extends State<OTPVerificationScreen> {
  User currentUser;

  Future<void> _sendOTP() async {
    String baseUrl = 'https://api.msg91.com/api/v5/otp';
    http.Response response = await http.get(
        '$baseUrl?authkey=${Credentials().MSG91_API_KEY}&mobile=91${currentUser.mobileNo}&otp_length=6');

    Map<String, dynamic> result = json.decode(response.body);
    print(result.toString());
    if (result['type'].contains('success')) {
      print('OTP received');
      Fluttertoast.showToast(
        msg: "OTP Sent",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.CENTER,
        backgroundColor: Colors.blue,
        textColor: Colors.white,
        fontSize: 16.0,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    currentUser = ModalRoute.of(context).settings.arguments as User;
    return Scaffold(
      appBar: AppBar(
        title: Text('Verify your Number'),
      ),
      body: Center(
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
                  onPressed: _sendOTP,
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
