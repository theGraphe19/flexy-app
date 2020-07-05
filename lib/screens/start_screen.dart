import 'package:flutter/material.dart';

import './registration_form_page1.dart';
import './login_screen.dart';

class StartScreen extends StatelessWidget {
  static const routeName = '/start-screen';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('FLEXY'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image.asset(
              'assets/icon/icon.png',
              width: MediaQuery.of(context).size.width*0.6,
              frameBuilder: (context, child, frame, wasSynchronouslyLoaded) =>
                  Padding(
                padding: const EdgeInsets.all(10.0),
                child: child,
              ),
            ),
            SizedBox(height: 80.0),
            GestureDetector(
              onTap: () => Navigator.of(context)
                  .popAndPushNamed(RegistrationFormPag1.routeName),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  vertical: 20.0,
                  horizontal: 50.0,
                ),
                decoration: BoxDecoration(
                  color: Colors.blue,
                  shape: BoxShape.rectangle,
                  borderRadius: BorderRadius.circular(35.0),
                ),
                child: Text(
                  'Register',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            SizedBox(height: 20.0),
            GestureDetector(
              onTap: () =>
                  Navigator.of(context).pushNamed(LoginScreen.routeName),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  vertical: 20.0,
                  horizontal: 65.0,
                ),
                decoration: BoxDecoration(
                  color: Colors.blue,
                  shape: BoxShape.rectangle,
                  borderRadius: BorderRadius.circular(35.0),
                ),
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
          ],
        ),
      ),
    );
  }
}
