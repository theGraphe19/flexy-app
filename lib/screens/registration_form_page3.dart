import 'package:flexy/screens/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:dropdown_formfield/dropdown_formfield.dart';

import '../models/user.dart';
import '../utils/form_validator.dart';
import './registration_form_page2.dart';

import '../utils/state_list.dart';

class RegistrationFormPage3 extends StatefulWidget {
  static const routeName = '/registration-form-part3';

  @override
  _RegistrationFormPage3State createState() => _RegistrationFormPage3State();
}

class _RegistrationFormPage3State extends State<RegistrationFormPage3> {
  User currentUser;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  var _autoValidate = false;
  var _validator = FormValidator();
  var _state = '';

  @override
  Widget build(BuildContext context) {
    currentUser = ModalRoute.of(context).settings.arguments as User;
    print(currentUser.firmName);

    if (currentUser.state != null) _state = currentUser.state;

    return Scaffold(
        appBar: AppBar(
          title: Text('Flexy - Register'),
        ),
        body: SingleChildScrollView(
          child: Container(
            margin: const EdgeInsets.all(15.0),
            padding: const EdgeInsets.all(10.0),
            child: Form(
              key: _formKey,
              autovalidate: _autoValidate,
              child: formUI(),
            ),
          ),
        ),
        floatingActionButton: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Container(
              margin: const EdgeInsets.only(left: 25.0),
              child: FloatingActionButton.extended(
                onPressed: () {
                  Navigator.of(context).popAndPushNamed(
                    RegistrationFormPart2.routeName,
                    arguments: currentUser,
                  );
                },
                label: Text('Prev'),
                icon: Icon(Icons.chevron_left),
              ),
            ),
            FloatingActionButton.extended(
              onPressed: _validateInput,
              label: Text(
                'Submit',
                style: TextStyle(color: Colors.white),
              ),
              backgroundColor: Theme.of(context).primaryColorDark,
              icon: Icon(
                Icons.done,
                color: Colors.white,
              ),
            ),
          ],
        ));
  }

  Widget formUI() => Column(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.all(15.0),
            child: new LinearPercentIndicator(
              width: MediaQuery.of(context).size.width - 80,
              animation: true,
              lineHeight: 20.0,
              animationDuration: 1500,
              percent: 1.0,
              center: Text("3 / 3"),
              linearStrokeCap: LinearStrokeCap.roundAll,
              progressColor: Theme.of(context).primaryColorDark,
            ),
          ),
          TextFormField(
            initialValue:
                (currentUser.landlineNo != null) ? currentUser.landlineNo : '',
            decoration: const InputDecoration(
              labelText: 'Land-Line Number (Eg. 0657-1234567)',
            ),
            onEditingComplete: _validateInput,
            keyboardType: TextInputType.number,
            onSaved: (String val) => currentUser.landlineNo = val,
          ),
          SizedBox(height: 10.0),
          TextFormField(
            initialValue: (currentUser.gstNo != null) ? currentUser.gstNo : '',
            decoration: const InputDecoration(
              labelText: 'GST Number',
            ),
            onEditingComplete: _validateInput,
            keyboardType: TextInputType.text,
            onSaved: (String val) => currentUser.gstNo = val,
          ),
          SizedBox(height: 10.0),
          TextFormField(
            initialValue: (currentUser.companyAddress != null)
                ? currentUser.companyAddress
                : '',
            decoration: const InputDecoration(
              labelText: 'Company Address',
            ),
            minLines: 1,
            maxLines: 3,
            onEditingComplete: _validateInput,
            keyboardType: TextInputType.text,
            validator: (value) =>
                _validator.validateName('Company Address', value),
            onSaved: (String val) => currentUser.companyAddress = val,
          ),
          TextFormField(
            initialValue: (currentUser.city != null) ? currentUser.city : '',
            decoration: const InputDecoration(
              labelText: 'City',
            ),
            onEditingComplete: _validateInput,
            keyboardType: TextInputType.text,
            validator: (value) => _validator.validateName('City', value),
            onSaved: (String val) => currentUser.city = val,
          ),
          SizedBox(height: 10.0),
          DropDownFormField(
            titleText: 'State',
            autovalidate: false,
            hintText: 'Please select any one',
            validator: (value) => _validator.validateDropDownSelector(value),
            value: _state,
            onSaved: (value) {
              setState(() {
                _state = value;
                currentUser.state = value as String;
              });
            },
            onChanged: (value) {
              setState(() {
                _state = value;
              });
            },
            dataSource: stateList,
            textField: "display",
            valueField: "value",
          ),
          SizedBox(height: 10.0),
          TextFormField(
            initialValue:
                (currentUser.pincode != null) ? currentUser.pincode : '',
            decoration: const InputDecoration(
              labelText: 'PIN',
            ),
            onEditingComplete: _validateInput,
            keyboardType: TextInputType.number,
            validator: (value) => _validator.validatePIN(value),
            onSaved: (String val) => currentUser.pincode = val,
          ),
          SizedBox(height: 10.0),
          TextFormField(
            initialValue:
                (currentUser.agentName != null) ? currentUser.agentName : '',
            decoration: const InputDecoration(
              labelText: 'Distributor/Agent Name',
            ),
            onEditingComplete: _validateInput,
            keyboardType: TextInputType.text,
            onSaved: (String val) => currentUser.agentName = val,
          ),
          SizedBox(height: 10.0),
          TextFormField(
            initialValue: (currentUser.ageentMobileNo != null)
                ? currentUser.ageentMobileNo
                : '',
            decoration: const InputDecoration(
              labelText: 'Distributor/Agent Mobile Number',
            ),
            onEditingComplete: _validateInput,
            keyboardType: TextInputType.number,
            onSaved: (String val) => currentUser.ageentMobileNo = val,
          ),
          SizedBox(height: 10.0),
          TextFormField(
            initialValue: (currentUser.purchasePerson != null)
                ? currentUser.purchasePerson
                : '',
            decoration: const InputDecoration(
              labelText: 'Person incharge of Purchase Department',
            ),
            onEditingComplete: _validateInput,
            keyboardType: TextInputType.text,
            onSaved: (String val) => currentUser.purchasePerson = val,
          ),
          SizedBox(height: 50.0),
        ],
      );

  void _validateInput() {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      Navigator.of(context).popAndPushNamed(
        LoginScreen.routeName,
        arguments: currentUser,
      );
    } else {
      setState(() {
        _autoValidate = true;
      });
    }
  }
}
