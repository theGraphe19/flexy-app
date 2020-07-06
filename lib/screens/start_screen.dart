import 'package:flutter/material.dart';

import './registration_form_page1.dart';
import './login_screen.dart';

class StartScreen extends StatelessWidget {
  static const routeName = '/start-screen';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image.asset(
              'assets/icon/icon.png',
              width: MediaQuery.of(context).size.width * 0.5,
              frameBuilder: (context, child, frame, wasSynchronouslyLoaded) =>
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
