import 'package:flutter/material.dart';
import 'package:progress_dialog/progress_dialog.dart';

import './products_screen.dart';
import '../HTTP_handler.dart';
import '../models/user.dart';

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

  ProgressDialog progressDialog;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
        title: Text('Enter Credentials'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: emailAndPassword(),
      ),
    );
  }

  Widget emailAndPassword() => Column(
        children: <Widget>[
          TextField(
            controller: _emailController,
            keyboardType: TextInputType.emailAddress,
            decoration: InputDecoration(hintText: 'Email'),
          ),
          SizedBox(height: 20.0),
          TextField(
            controller: _passwordController,
            keyboardType: TextInputType.visiblePassword,
            decoration: InputDecoration(hintText: 'Password'),
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
                      await progressDialog.hide();
                      Navigator.of(context).pushNamed(ProductsScreen.routeName);
                    }
                  });
                },
              ),
            ),
          ),
        ],
      );
}
