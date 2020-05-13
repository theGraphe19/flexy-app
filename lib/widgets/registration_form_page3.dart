import 'package:flutter/material.dart';

import '../models/user.dart';
import '../utils/form_validator.dart';

class RegistrationFormPage3 extends StatefulWidget {
  final User currentUser;

  RegistrationFormPage3(this.currentUser);

  @override
  _RegistrationFormPage3State createState() => _RegistrationFormPage3State();
}

class _RegistrationFormPage3State extends State<RegistrationFormPage3> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  var _autoValidate = false;
  var _validator = FormValidator();

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
            initialValue: (widget.currentUser.landlineNo != null)
                ? widget.currentUser.landlineNo
                : '',
            decoration: const InputDecoration(
              labelText: 'Land-Line Number',
            ),
            onEditingComplete: _validateInput,
            keyboardType: TextInputType.number,
            validator: (value) => _validator.validateMobile(value),
            onSaved: (String val) => widget.currentUser.landlineNo = val,
          ),
          SizedBox(height: 10.0),
          TextFormField(
            initialValue: (widget.currentUser.gstNo != null)
                ? widget.currentUser.gstNo
                : '',
            decoration: const InputDecoration(
              labelText: 'GST Number',
            ),
            onEditingComplete: _validateInput,
            keyboardType: TextInputType.number,
            validator: (value) => _validator.validateGST(value),
            onSaved: (String val) => widget.currentUser.gstNo = val,
          ),
          SizedBox(height: 10.0),
          TextFormField(
            initialValue: (widget.currentUser.companyAddress != null)
                ? widget.currentUser.companyAddress
                : '',
            decoration: const InputDecoration(
              labelText: 'Company Address',
            ),
            minLines: 1,
            maxLines: 3,
            onEditingComplete: _validateInput,
            keyboardType: TextInputType.text,
            validator: (value) => _validator.validateName(value),
            onSaved: (String val) => widget.currentUser.companyAddress = val,
          ),
          TextFormField(
            initialValue: (widget.currentUser.city != null)
                ? widget.currentUser.city
                : '',
            decoration: const InputDecoration(
              labelText: 'City',
            ),
            onEditingComplete: _validateInput,
            keyboardType: TextInputType.text,
            validator: (value) => _validator.validateName(value),
            onSaved: (String val) => widget.currentUser.city = val,
          ),
          SizedBox(height: 10.0),
          TextFormField(
            initialValue: (widget.currentUser.state != null)
                ? widget.currentUser.state
                : '',
            decoration: const InputDecoration(
              labelText: 'State',
            ),
            onEditingComplete: _validateInput,
            keyboardType: TextInputType.text,
            validator: (value) => _validator.validateName(value),
            onSaved: (String val) => widget.currentUser.state = val,
          ),
          SizedBox(height: 10.0),
          TextFormField(
            initialValue: (widget.currentUser.pincode != null)
                ? widget.currentUser.pincode
                : '',
            decoration: const InputDecoration(
              labelText: 'PIN',
            ),
            onEditingComplete: _validateInput,
            keyboardType: TextInputType.number,
            validator: (value) => _validator.validatePIN(value),
            onSaved: (String val) => widget.currentUser.pincode = val,
          ),
          SizedBox(height: 10.0),
          TextFormField(
            initialValue: (widget.currentUser.agentName != null)
                ? widget.currentUser.agentName
                : '',
            decoration: const InputDecoration(
              labelText: 'Agent Name',
            ),
            onEditingComplete: _validateInput,
            keyboardType: TextInputType.text,
            validator: (value) => _validator.validateName(value),
            onSaved: (String val) => widget.currentUser.agentName = val,
          ),
          SizedBox(height: 10.0),
          TextFormField(
            initialValue: (widget.currentUser.purchasePerson != null)
                ? widget.currentUser.purchasePerson
                : '',
            decoration: const InputDecoration(
              labelText: 'Person incharge of Purchase Department',
            ),
            onEditingComplete: _validateInput,
            keyboardType: TextInputType.text,
            validator: (value) => _validator.validateName(value),
            onSaved: (String val) => widget.currentUser.purchasePerson = val,
          ),
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
