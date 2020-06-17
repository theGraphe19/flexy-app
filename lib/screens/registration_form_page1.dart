import 'dart:io';
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:dropdown_formfield/dropdown_formfield.dart';
import 'package:image_picker/image_picker.dart';
import 'package:toast/toast.dart';

import '../utils/form_validator.dart';
import '../models/user.dart';
import './registration_form_page2.dart';
import '../HTTP_handler.dart';

class RegistrationFormPag1 extends StatefulWidget {
  static const routeName = '/registration-form-page1';

  @override
  _RegistrationFormPag1State createState() => _RegistrationFormPag1State();
}

class _RegistrationFormPag1State extends State<RegistrationFormPag1> {
  User currentUser;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  var _autoValidate = false;
  var _validator = FormValidator();

  var _designation = '';
  var _photoIdType = '';
  List<String> mobiles = [];

  Future<File> imageFile;

  pickImageFromSystem(ImageSource source) {
    setState(() {
      imageFile = ImagePicker.pickImage(
        source: source,
        imageQuality: 50,
      );
    });
  }

  bool _checkMobileAvailability(String inputNumber) {
    for (var i = 0; i < mobiles.length; i++) {
      if (mobiles[i].contains(inputNumber) &&
          inputNumber.contains(mobiles[i])) {
        return false;
      }
    }

    return true;
  }

  @override
  void initState() {
    super.initState();
    HTTPHandler().getMobiles().then((List<String> serverValues) {
      print(serverValues.toString());
      mobiles = serverValues;
    });
  }

  @override
  Widget build(BuildContext context) {
    currentUser = ModalRoute.of(context).settings.arguments as User;
    if (currentUser != null) {
      if (currentUser.designation != null)
        _designation = currentUser.designation;

      if (currentUser.photoIdType != null)
        _photoIdType = currentUser.photoIdType;
    } else {
      currentUser = new User();
    }

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
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _validateInput,
        label: Text('Next'),
        icon: Icon(Icons.chevron_right),
      ),
    );
  }

  Widget formUI() => Column(
        children: <Widget>[
          TextFormField(
            initialValue: (currentUser != null && currentUser.name != null)
                ? currentUser.name
                : '',
            decoration: const InputDecoration(
              labelText: 'Name',
            ),
            onEditingComplete: _validateInput,
            keyboardType: TextInputType.text,
            validator: (value) => _validator.validateName(value),
            onSaved: (String val) => currentUser.name = val,
          ),
          SizedBox(height: 10.0),
          TextFormField(
            initialValue: (currentUser != null && currentUser.mobileNo != null)
                ? currentUser.mobileNo
                : null,
            decoration: const InputDecoration(
              labelText: 'Phone Number',
            ),
            onEditingComplete: _validateInput,
            keyboardType: TextInputType.number,
            validator: (value) => _validator.validateMobile(value),
            onSaved: (String val) => currentUser.mobileNo = val,
          ),
          SizedBox(height: 10.0),
          TextFormField(
            initialValue: (currentUser != null && currentUser.email != null)
                ? currentUser.email
                : '',
            decoration: const InputDecoration(
              labelText: 'Email ID',
            ),
            onEditingComplete: _validateInput,
            keyboardType: TextInputType.emailAddress,
            validator: (value) => _validator.validateEmail(value),
            onSaved: (String val) => currentUser.email = val,
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
                currentUser.designation = value as String;
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
          DropDownFormField(
            titleText: 'Photo Id',
            autovalidate: false,
            hintText: 'Please select any one',
            // validator: (value) => _validator.validateDropDownSelector(value),
            value: _photoIdType,
            onSaved: (value) {
              setState(() {
                _photoIdType = value;
                currentUser.photoIdType = value as String;
              });
            },
            onChanged: (value) {
              Future.delayed(Duration.zero, () {
                _showModalSheet(context);
              });
              setState(() {
                _photoIdType = value;
              });
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
      if (currentUser.photoLocation == null)
        Toast.show(
          "Please add a photo ID",
          context,
          duration: Toast.LENGTH_SHORT,
          gravity: Toast.CENTER,
        );
      else if (!_checkMobileAvailability(currentUser.mobileNo))
        Toast.show(
          "Mobile Number already exists!",
          context,
          duration: Toast.LENGTH_SHORT,
          gravity: Toast.CENTER,
        );
      else
        Navigator.of(context).popAndPushNamed(
          RegistrationFormPart2.routeName,
          arguments: currentUser,
        );
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
    return (imageFile != null)
        ? FutureBuilder<File>(
            future: imageFile,
            builder: (BuildContext context, AsyncSnapshot<File> snapshot) {
              if (snapshot.data != null)
                currentUser.photoLocation = snapshot.data.path;
              return Container(
                width: double.infinity,
                height: 400.0,
                decoration: (imageFile != null && snapshot.data != null)
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
          )
        : Container();
  }
}
