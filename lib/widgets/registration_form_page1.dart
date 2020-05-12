import 'dart:io';
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:dropdown_formfield/dropdown_formfield.dart';
import 'package:image_picker/image_picker.dart';

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
  var _photoIdType = '';

  Future<File> imageFile;

  pickImageFromSystem(ImageSource source) {
    setState(() {
      imageFile = ImagePicker.pickImage(source: source);
    });
  }

  @override
  void initState() {
    super.initState();
    if (widget.currentUser.designation != null)
      _designation = widget.currentUser.designation;

    if (widget.currentUser.photoIdType != null)
      _photoIdType = widget.currentUser.photoIdType;
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
            onEditingComplete: _validateInput,
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
            onEditingComplete: _validateInput,
            keyboardType: TextInputType.number,
            validator: (value) => _validator.validateMobile(value),
            onSaved: (String val) => widget.currentUser.mobileNo = val,
          ),
          SizedBox(height: 10.0),
          TextFormField(
            initialValue: (widget.currentUser.email != null)
                ? widget.currentUser.email
                : '',
            decoration: const InputDecoration(
              labelText: 'Email ID',
            ),
            onEditingComplete: _validateInput,
            keyboardType: TextInputType.emailAddress,
            validator: (value) => _validator.validateEmail(value),
            onSaved: (String val) => widget.currentUser.email = val,
          ),
          SizedBox(height: 10.0),
          DropDownFormField(
            titleText: 'Designation',
            autovalidate: false,
            hintText: 'Please select any one',
            validator: (value) => _validator.validateDropDownSelector(value),
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
              _validateInput();
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
          DropDownFormField(
            titleText: 'Photo Id',
            autovalidate: false,
            hintText: 'Please select any one',
            validator: (value) => _validator.validateDropDownSelector(value),
            value: _photoIdType,
            onSaved: (value) {
              setState(() {
                _photoIdType = value;
                widget.currentUser.photoIdType = value as String;
                Future.delayed(Duration.zero, () {
                  _showModalSheet(context);
                });
              });
            },
            onChanged: (value) {
              setState(() {
                _photoIdType = value;
                Future.delayed(Duration.zero, () {
                  _showModalSheet(context);
                });
              });
              _validateInput();
            },
            dataSource: [
              {
                "display": "Pan Card",
                "value": "Pan Card",
              },
              {
                "display": "Aadhar Card",
                "value": "Aadhar Card",
              },
              {
                "display": "Voter Card",
                "value": "Voter Card",
              },
              {
                "display": "Passport",
                "value": "Passport",
              },
            ],
            textField: "display",
            valueField: "value",
          ),
          SizedBox(height: 10.0),
          (imageFile != null) ? imagePreview() : Container(),
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

  void _showModalSheet(BuildContext context) => showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          width: double.infinity,
          height: 150,
          color: Colors.blueGrey[150],
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              FlatButton(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Icon(Icons.camera),
                    Text('Camera'),
                  ],
                ),
                onPressed: () {
                  pickImageFromSystem(ImageSource.camera);
                  Navigator.pop(context);
                },
              ),
              FlatButton(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Icon(Icons.folder_open),
                    Text('Gallery'),
                  ],
                ),
                onPressed: () {
                  pickImageFromSystem(ImageSource.gallery);
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      });

  Widget imagePreview() {
    return FutureBuilder<File>(
      future: imageFile,
      builder: (BuildContext context, AsyncSnapshot<File> snapshot) {
        return Container(
          width: double.infinity,
          height: 400.0,
          decoration: (imageFile != null)
              ? BoxDecoration(
                  shape: BoxShape.rectangle,
                  borderRadius: BorderRadius.circular(5.0),
                  image: DecorationImage(
                    fit: BoxFit.cover,
                    image: FileImage(snapshot.data),
                  ),
                )
              : BoxDecoration(),
        );
      },
    );
  }
}
