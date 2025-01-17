import 'dart:io';
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:dropdown_formfield/dropdown_formfield.dart';
import 'package:image_picker/image_picker.dart';
import 'package:toast/toast.dart';
import 'package:percent_indicator/percent_indicator.dart';

import '../utils/form_validator.dart';
import '../models/user.dart';
import './registration_form_page2.dart';
import '../HTTP_handler.dart';
import './start_screen.dart';

class RegistrationFormPag1 extends StatefulWidget {
  static const routeName = '/registration-form-page1';

  @override
  _RegistrationFormPag1State createState() => _RegistrationFormPag1State();
}

class _RegistrationFormPag1State extends State<RegistrationFormPag1> {
  User currentUser;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final scaffoldKey = GlobalKey<ScaffoldState>();
  var _autoValidate = false;
  var _validator = FormValidator();
  HTTPHandler _handler = HTTPHandler();
  var _designation = '';
  var _photoIdType = '';
  List<String> mobiles = [];
  List<String> emails = [];
  String path;

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
    if (mobiles != null) {
      for (var i = 0; i < mobiles.length; i++) {
        if (mobiles[i].contains(inputNumber) &&
            inputNumber.contains(mobiles[i])) {
          return false;
        }
      }
    } else {
      scaffoldKey.currentState.showSnackBar(SnackBar(
        content: Text(
          'Loading, try again in 5 seconds.',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Color(0xff6c757d),
        duration: Duration(seconds: 3),
      ));
    }

    return true;
  }

  bool _checkEmailAvailability(String inputEmail) {
    if (emails != null) {
      for (var i = 0; i < emails.length; i++) {
        if (emails[i].contains(inputEmail) && inputEmail.contains(emails[i])) {
          return false;
        }
      }
    } else {
      scaffoldKey.currentState.showSnackBar(SnackBar(
        content: Text(
          'Loading, try again in 5 seconds.',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Color(0xff6c757d),
        duration: Duration(seconds: 3),
      ));
    }

    return true;
  }

  @override
  void initState() {
    super.initState();
    _handler.getMobiles().then((List<String> serverValues) {
      print(serverValues.toString());
      mobiles = serverValues;
    }).catchError((e) {
      scaffoldKey.currentState.showSnackBar(SnackBar(
        content: Text(
          'Network error!',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Color(0xff6c757d),
        duration: Duration(seconds: 3),
      ));
    });

    _handler.getEmails().then((List<String> serverValues) {
      print(serverValues.toString());
      emails = serverValues;
    }).catchError((e) {
      scaffoldKey.currentState.showSnackBar(SnackBar(
        content: Text(
          'Network error!',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Color(0xff6c757d),
        duration: Duration(seconds: 3),
      ));
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

      if (currentUser.photoLocation != null) path = currentUser.photoLocation;
    } else {
      currentUser = new User();
    }

    return WillPopScope(
      onWillPop: () async {
        Navigator.of(context).popAndPushNamed(StartScreen.routeName);
        return false;
      },
      child: Scaffold(
        key: scaffoldKey,
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
          label: Text(
            'Next',
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: Theme.of(context).primaryColorDark,
          icon: Icon(
            Icons.chevron_right,
            color: Colors.white,
          ),
        ),
      ),
    );
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
              percent: 0.33,
              center: Text("1 / 3"),
              linearStrokeCap: LinearStrokeCap.roundAll,
              progressColor: Theme.of(context).primaryColorDark,
            ),
          ),
          TextFormField(
            initialValue: (currentUser != null && currentUser.name != null)
                ? currentUser.name
                : '',
            decoration: const InputDecoration(
              labelText: 'Name',
            ),
            onEditingComplete: _validateInput,
            keyboardType: TextInputType.text,
            validator: (value) => _validator.validateName('Name', value),
            onSaved: (String val) => currentUser.name = val,
          ),
          SizedBox(height: 10.0),
          TextFormField(
            initialValue: (currentUser != null && currentUser.mobileNo != null)
                ? currentUser.mobileNo
                : null,
            decoration: const InputDecoration(
              labelText: 'Phone Number',
              prefixText: '+91 ',
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
          (imageFile != null || path != null)
              ? Container(
                  width: double.infinity,
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: FlatButton.icon(
                      onPressed: () {
                        print('close pressed');
                        imageFile = null;
                        setState(() {});
                      },
                      icon: Icon(Icons.clear),
                      label: Text('Remove'),
                    ),
                  ),
                )
              : Container(),
          SizedBox(height: 10.0),
          (imageFile != null || path != null) ? imagePreview() : Container(),
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
      else if (!_checkEmailAvailability(currentUser.email))
        Toast.show(
          "Email already exists!",
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
              return Stack(
                children: <Widget>[
                  Container(
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
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10.0,
                      vertical: 10.0,
                    ),
                    width: double.infinity,
                    height: 400.0,
                    color: Colors.transparent,
                    child: Align(
                      alignment: Alignment.topRight,
                      child: FlatButton.icon(
                        onPressed: () {
                          _showModalSheet(context);
                        },
                        icon: Icon(Icons.edit),
                        label: Text(
                          'Change Image',
                        ),
                      ),
                    ),
                  ),
                ],
              );
            },
          )
        : (path != null)
            ? Stack(
                children: <Widget>[
                  Container(
                      width: double.infinity,
                      height: 400.0,
                      decoration: BoxDecoration(
                        shape: BoxShape.rectangle,
                        borderRadius: BorderRadius.circular(5.0),
                        image: DecorationImage(
                          fit: BoxFit.cover,
                          image: FileImage(File(path)),
                        ),
                      )),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10.0,
                      vertical: 10.0,
                    ),
                    width: double.infinity,
                    height: 400.0,
                    color: Colors.transparent,
                    child: Align(
                      alignment: Alignment.topRight,
                      child: FlatButton.icon(
                        onPressed: () {
                          _showModalSheet(context);
                        },
                        icon: Icon(Icons.edit),
                        label: Text(
                          'Change Image',
                        ),
                      ),
                    ),
                  ),
                ],
              )
            : Container();
  }
}
