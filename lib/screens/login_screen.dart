import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sms_autofill/sms_autofill.dart';
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

class _LoginScreenState extends State<LoginScreen> with CodeAutoFill {
  HTTPHandler _handler = HTTPHandler();
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  var _mobileController = TextEditingController();
  var _otpController = TextEditingController();

  ProgressDialog progressDialog;
  SharedPreferences prefs;
  bool _checkedValue = false;
  bool _stayLoggedIn;
  List<String> mobiles;
  var status = ForgotPassword.forgotAndNotVerified;
  String _code = "";

  bool _chechNumber(String inputNumber) {
    if (mobiles != null) {
      for (var i = 0; i < mobiles.length; i++) {
        if (mobiles[i].contains(inputNumber) &&
            inputNumber.contains(mobiles[i])) {
          return true;
        }
      }
    }
    _scaffoldKey.currentState.showSnackBar(SnackBar(
      content: Text(
        'Try again in 5 seconds',
        style: TextStyle(color: Colors.white),
      ),
      backgroundColor: Color(0xff6c757d),
      duration: Duration(seconds: 5),
    ));
    return false;
  }

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

    if (_stayLoggedIn) {
      print('staying');
      final encodedUser = prefs.getString('loggedInUser');
      User user = User();
      user.mapToUser(json.decode(encodedUser));

      int timeStamp = prefs.getInt('loginTime');
      Duration timeDiff = DateTime.now()
          .difference(DateTime.fromMillisecondsSinceEpoch(timeStamp));
      if (timeDiff.inHours < 24) {
        _handler
            .verifyOTPLogin(prefs.getString('mobile'), prefs.getString('otp'))
            .then((User user) {
          print(user.name);
          _storeData(user.token, true, user);
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
          status = ForgotPassword.forgotAndNotVerified;
          setState(() {});
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
    } else {
      setState(() {});
    }
    print(_stayLoggedIn);
  }

  void _resend() async {
    await progressDialog.show();
    _handler.sendOTP(_mobileController.text, 'login').then((bool value) async {
      await progressDialog.hide();
      if (value) {
        _scaffoldKey.currentState.showSnackBar(SnackBar(
          content: Text(
            'OTP Sent Again',
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: Color(0xff6c757d),
          duration: Duration(seconds: 5),
        ));
      } else {
        _scaffoldKey.currentState.showSnackBar(SnackBar(
          content: Text(
            'OTP couldn\'t be sent.',
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: Color(0xff6c757d),
          duration: Duration(seconds: 5),
        ));
      }
    }).catchError((e) {
      _scaffoldKey.currentState.showSnackBar(SnackBar(
        content: Text(
          'Network Error!',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Color(0xff6c757d),
        duration: Duration(seconds: 5),
      ));
    });
  }

  void saveOTP() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    prefs.setString('mobile', _mobileController.text);
    prefs.setString('otp', _code);
  }

  @override
  void initState() {
    super.initState();
    _retreiveData();
    SharedPreferences.getInstance().then((value) => prefs = value);
  }

  @override
  void dispose() {
    SmsAutoFill().unregisterListener();
    _otpController.dispose();
    super.dispose();
  }

  // Future<void> _registerSMSlistener() async {
  //   await SmsAutoFill().listenForCode;
  // }

  @override
  Widget build(BuildContext context) {
    // if (status != ForgotPassword.forgotAndNotVerified) _registerSMSlistener();
    print("flexyLog / login_screen.dat / Status: " + status.toString());
    if (status == ForgotPassword.forgotAndNotVerified) {
      print(
          "flexyLog / login_screen.dat /  if status == ForgotPassword.forgotAndNotVerified is true");
      _handler.getMobiles().then((value) {
        print("flexyLog / login_screen.dat /  getMobiles() values: " +
            value.first);
        this.mobiles = value;
      });
    }

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
          PinFieldAutoFill(
            decoration: UnderlineDecoration(
              textStyle: TextStyle(fontSize: 20, color: Colors.black),
              colorBuilder: FixedColorBuilder(Colors.black.withOpacity(0.3)),
            ),
            currentCode: _code,
            onCodeSubmitted: (code) {},
            onCodeChanged: (code) {
              _code = code;
              if (code.length == 6) {
                FocusScope.of(context).requestFocus(FocusNode());
              }
            },
          ),
          // TextFieldPin(
          //   borderStyeAfterTextChange: UnderlineInputBorder(
          //     borderRadius: BorderRadius.circular(5.0),
          //     borderSide: BorderSide(color: Colors.black87),
          //   ),
          //   borderStyle: UnderlineInputBorder(
          //     borderRadius: BorderRadius.circular(5.0),
          //     borderSide: BorderSide(color: Colors.black87),
          //   ),
          //   codeLength: 6,
          //   boxSize: 40,
          //   textStyle: TextStyle(
          //     color: Colors.black,
          //     fontSize: 20.0,
          //   ),
          //   filledAfterTextChange: true,
          //   filledColor: Colors.white,
          //   onOtpCallback: (code, isAutofill) {
          //     print("Code: " + code);
          //     setState(() {
          //       this._otpCode = code;
          //     });
          //   },
          // ),
          SizedBox(height: 15.0),
          GestureDetector(
            onTap: () => _resend(),
            child: Container(
              width: double.infinity,
              alignment: Alignment.center,
              child: Text(
                'Didn\'t receive OTP? Send Again',
                style: TextStyle(color: Colors.grey[400]),
              ),
            ),
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
                  if (_code.length < 6) {
                    _scaffoldKey.currentState.showSnackBar(SnackBar(
                      content: Text(
                        'Enter OTP first',
                        style: TextStyle(color: Colors.white),
                      ),
                      backgroundColor: Color(0xff6c757d),
                      duration: Duration(seconds: 5),
                    ));
                  } else {
                    await progressDialog.show();
                    _handler
                        .verifyOTPLogin(_mobileController.text, _code)
                        .then((User user) async {
                      await progressDialog.hide();
                      if (user != null) {
                        print(user.name);
                        saveOTP();
                        _storeData(user.token, _checkedValue, user);
                        Navigator.of(context).pushNamedAndRemoveUntil(
                          CategoriesScreen.routeName,
                          (Route<dynamic> route) => false,
                          arguments: user,
                        );
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
                    }).catchError((e) async {
                      await progressDialog.hide();
                      _scaffoldKey.currentState.showSnackBar(SnackBar(
                        content: Text(
                          e.toString(),
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

  Widget otpVerify() {
    String appSignature = "";
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        TextField(
          controller: _mobileController,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            labelText: 'Enter Mobile Number',
            prefixText: '+91 ',
          ),
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
                } else if (!_chechNumber(_mobileController.text)) {
                  _scaffoldKey.currentState.showSnackBar(SnackBar(
                    content: Text(
                      'Number not registered!',
                      style: TextStyle(color: Colors.white),
                    ),
                    backgroundColor: Color(0xff6c757d),
                    duration: Duration(seconds: 5),
                  ));
                } else {
                  listenForCode();
                  SmsAutoFill().getAppSignature.then((signature) {
                    setState(() {
                      appSignature = signature;
                    });
                  });

                  await progressDialog.show();
                  _handler
                      .sendOTP(_mobileController.text, 'login')
                      .then((bool uid) async {
                    await progressDialog.hide();
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
                    print(e);
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

  @override
  void codeUpdated() {
    setState(() {
      _code = code;
    });
  }
}
