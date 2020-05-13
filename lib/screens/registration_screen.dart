import 'package:flutter/material.dart';
import 'package:multi_page_form/multi_page_form.dart';

import '../models/user.dart';
import '../widgets/registration_form_page1.dart';
import '../widgets/registration_form_page2.dart';
import '../widgets/registration_form_page3.dart';

class RegistrationScreen extends StatelessWidget {

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
          RegistrationFormPage3(currentUser),
        ],
        onFormSubmitted: () {
          print("Form is submitted");
        },
      ),
    );
  }
}
