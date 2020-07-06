import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:dropdown_formfield/dropdown_formfield.dart';
import 'package:toast/toast.dart';
import 'package:percent_indicator/percent_indicator.dart';

import '../models/user.dart';
import '../utils/form_validator.dart';
import './registration_form_page1.dart';
import './registration_form_page3.dart';

class RegistrationFormPart2 extends StatefulWidget {
  static const routeName = '/registration-form-part2';

  @override
  _RegistrationFormPart2State createState() => _RegistrationFormPart2State();
}

class _RegistrationFormPart2State extends State<RegistrationFormPart2> {
  User currentUser;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  var _autoValidate = false;
  var _validator = FormValidator();

  bool visitingPressed = false;

  var _firmNomenclature = '';
  var _tradeCategory = '';
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

  @override
  Widget build(BuildContext context) {
    currentUser = ModalRoute.of(context).settings.arguments as User;
    print(currentUser.email);

    if (currentUser.firmNomenclature != null)
      _firmNomenclature = currentUser.firmNomenclature;

    if (currentUser.tradeCategory != null)
      _tradeCategory = currentUser.tradeCategory;

    if (currentUser.visitingCardLocation != null)
      path = currentUser.visitingCardLocation;

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
                  RegistrationFormPag1.routeName,
                  arguments: currentUser,
                );
              },
              label: Text('Prev'),
              icon: Icon(Icons.chevron_left),
            ),
          ),
          FloatingActionButton.extended(
            onPressed: _validateInput,
            label: Text('Next'),
            backgroundColor: Theme.of(context).primaryColorDark,
            icon: Icon(Icons.chevron_right),
          ),
        ],
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
              percent: 0.66,
              center: Text("2 / 3"),
              linearStrokeCap: LinearStrokeCap.roundAll,
              progressColor: Theme.of(context).primaryColorDark,
            ),
          ),
          Container(
            width: double.infinity,
            child: FlatButton.icon(
              onPressed: () {
                Future.delayed(Duration.zero, () {
                  _showModalSheet(context);
                });
                visitingPressed = true;
              },
              icon: Icon(Icons.add),
              label: Text((visitingPressed)
                  ? 'Change Visiting Card'
                  : 'Add Visiting Card'),
            ),
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
          (imageFile != null || path != null) ? imagePreview() : Container(),
          SizedBox(height: 10.0),
          TextFormField(
            initialValue:
                (currentUser.firmName != null) ? currentUser.firmName : '',
            decoration: const InputDecoration(
              labelText: 'Firm Name',
            ),
            onEditingComplete: _validateInput,
            keyboardType: TextInputType.text,
            validator: (value) => _validator.validateName('Firm Name', value),
            onSaved: (String val) => currentUser.firmName = val,
          ),
          SizedBox(height: 10.0),
          DropDownFormField(
            titleText: 'Firm Nomenclature',
            autovalidate: false,
            hintText: 'Please select any one',
            validator: (value) => _validator.validateDropDownSelector(value),
            value: _firmNomenclature,
            onSaved: (value) {
              setState(() {
                _firmNomenclature = value;
                currentUser.firmNomenclature = value as String;
              });
            },
            onChanged: (value) {
              setState(() {
                _firmNomenclature = value;
              });
            },
            dataSource: [
              {
                "display": "Partnership",
                "value": "Partnership",
              },
              {
                "display": "Proprietorship",
                "value": "Proprietorship",
              },
              {
                "display": "Pvt. Ltd",
                "value": "Pvt. Ltd",
              },
              {
                "display": "LLP",
                "value": "LLP",
              },
              {
                "display": "Ltd.",
                "value": "Ltd.",
              },
            ],
            textField: "display",
            valueField: "value",
          ),
          SizedBox(height: 10.0),
          DropDownFormField(
            titleText: 'Trade Category',
            autovalidate: false,
            hintText: 'Please select any one',
            validator: (value) => _validator.validateDropDownSelector(value),
            value: _tradeCategory,
            onSaved: (value) {
              setState(() {
                _tradeCategory = value;
                currentUser.tradeCategory = value as String;
              });
            },
            onChanged: (value) {
              setState(() {
                _tradeCategory = value;
              });
            },
            dataSource: [
              {
                "display": "Boutique",
                "value": "Boutique",
              },
              {
                "display": "Retailer",
                "value": "Retailer",
              },
              {
                "display": "Wholesaler",
                "value": "Wholesaler",
              },
              {
                "display": "Distributor",
                "value": "Distributor",
              },
            ],
            textField: "display",
            valueField: "value",
          ),
          (_tradeCategory.endsWith("Boutique") ||
                  _tradeCategory.endsWith("Retailer"))
              ? TextFormField(
                  initialValue: (currentUser.noOfStores != null)
                      ? currentUser.noOfStores
                      : '',
                  decoration: const InputDecoration(
                    labelText: 'Number of Stores',
                  ),
                  onEditingComplete: _validateInput,
                  keyboardType: TextInputType.number,
                  validator: (value) => _validator.validateNumber(value),
                  onSaved: (String val) => currentUser.noOfStores = val,
                )
              : Container(),
          SizedBox(height: 50.0),
        ],
      );

  void _validateInput() {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      if (currentUser.visitingCardLocation != null)
        Navigator.of(context).popAndPushNamed(
          RegistrationFormPage3.routeName,
          arguments: currentUser,
        );
      else
        Toast.show(
          "Please add a visiting card!",
          context,
          duration: Toast.LENGTH_SHORT,
          gravity: Toast.CENTER,
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
                currentUser.visitingCardLocation = snapshot.data.path;
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
