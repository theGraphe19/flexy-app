import 'package:flutter/material.dart';
import 'package:multi_page_form/multi_page_form.dart';

import '../models/user.dart';
import '../widgets/registration_form_page1.dart';
import '../widgets/registration_form_page2.dart';

class RegistrationScreen extends StatelessWidget {
  static const routeName = '/registration-screen';

  final User currentUser = User();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Flexy - Register'),
      ),
      body: MultiPageForm(
        totalPage: 3,
        nextButtonStyle: Icon(Icons.keyboard_arrow_right),
        pageList: <Widget>[
          RegistrationFormPag1(currentUser),
          RegistrationFormPart2(currentUser),
          page3(),
        ],
        onFormSubmitted: () {
          print("Form is submitted");
        },
      ),
    );
  }

  Widget page2() {
    return Container(
      child: ListView(
        children: [
          Container(
            height: 200.0,
            width: 200.0,
            color: Colors.yellow,
          )
        ],
      ),
    );
  }

  Widget page3() {
    return Container(
      child: ListView(
        children: [
          Container(
            height: 200.0,
            width: 200.0,
            color: Colors.green,
          )
        ],
      ),
    );
  }
}
