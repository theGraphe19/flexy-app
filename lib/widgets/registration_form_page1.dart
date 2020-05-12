import 'package:flutter/material.dart';
import 'package:dropdown_formfield/dropdown_formfield.dart';

import '../utils/form_validator.dart';
import '../models/user.dart';

class RegistrationFormPag1 extends StatefulWidget {
  final User currentUser;

  RegistrationFormPag1(this.currentUser);

  @override
  _RegistrationFormPag1State createState() => _RegistrationFormPag1State();
}

class _RegistrationFormPag1State extends State<RegistrationFormPag1> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  var _autoValidate = false;
  var _validator = FormValidator();

  var _designation = '';

  @override
  void initState() {
    super.initState();
    if (widget.currentUser.designation != null)
      _designation = widget.currentUser.designation;
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        margin: const EdgeInsets.all(15.0),
        padding: const EdgeInsets.all(10.0),
        child: Form(
          key: _formKey,
          autovalidate: _autoValidate,
          child: formUI(),
        ),
      ),
    );
  }

  Widget formUI() => Column(
        children: <Widget>[
          TextFormField(
            initialValue: (widget.currentUser.name != null)
                ? widget.currentUser.name
                : '',
            decoration: const InputDecoration(
              labelText: 'Name',
            ),
            keyboardType: TextInputType.text,
            validator: (value) => _validator.validateName(value),
            onSaved: (String val) => widget.currentUser.name = val,
          ),
          SizedBox(height: 10.0),
          TextFormField(
            initialValue: (widget.currentUser.mobileNo != null)
                ? widget.currentUser.mobileNo
                : null,
            decoration: const InputDecoration(
              labelText: 'Phone Number',
            ),
            keyboardType: TextInputType.number,
            validator: (value) => _validator.validateMobile(value),
            onSaved: (String val) =>
                widget.currentUser.mobileNo = val,
          ),
          SizedBox(height: 10.0),
          TextFormField(
            initialValue: (widget.currentUser.email != null)
                ? widget.currentUser.email
                : '',
            decoration: const InputDecoration(
              labelText: 'Email ID',
            ),
            keyboardType: TextInputType.emailAddress,
            validator: (value) => _validator.validateEmail(value),
            onSaved: (String val) => widget.currentUser.email = val,
          ),
          SizedBox(height: 10.0),
          DropDownFormField(
            titleText: 'Designation',
            autovalidate: false,
            hintText: 'Please select any one',
            validator: (value) => _validator.validateDescription(value),
            value: _designation,
            onSaved: (value) {
              setState(() {
                _designation = value;
                widget.currentUser.designation = value as String;
              });
            },
            onChanged: (value) {
              setState(() {
                _designation = value;
              });
            },
            dataSource: [
              {
                "display": "Director",
                "value": "Director",
              },
              {
                "display": "Partner",
                "value": "Partner",
              },
              {
                "display": "Proprietor",
                "value": "Proprietor",
              },
              {
                "display": "Salesman",
                "value": "Salesman",
              },
              {
                "display": "Purchaser",
                "value": "Purchaser",
              },
              {
                "display": "Branch Head",
                "value": "Branch Head",
              },
              {
                "display": "Others",
                "value": "Others",
              },
            ],
            textField: "display",
            valueField: "value",
          ),
          SizedBox(height: 10.0),
          RaisedButton(
            child: Text('Validate'),
            onPressed: _validateInput,
          )
        ],
      );

  void _validateInput() {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
    } else {
      setState(() {
        _autoValidate = true;
      });
    }
  }
}
