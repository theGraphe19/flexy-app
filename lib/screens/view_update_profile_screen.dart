import 'dart:io';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dropdown_formfield/dropdown_formfield.dart';
import 'package:image_picker/image_picker.dart';
import 'package:toast/toast.dart';

import '../models/user.dart';
import '../HTTP_handler.dart';
import '../widgets/loading_body.dart';
import '../utils/form_validator.dart';
import '../utils/state_list.dart';

class ViewUpdateProfile extends StatefulWidget {
  static const routeName = '/view-update-profile';

  @override
  _ViewUpdateProfileState createState() => _ViewUpdateProfileState();
}

class _ViewUpdateProfileState extends State<ViewUpdateProfile> {
  bool userDataController = false;
  bool userSelectorController = false;
  HTTPHandler _handler = HTTPHandler();
  SharedPreferences prefs;
  User currentUser;
  FormValidator _validator = FormValidator();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final scaffoldKey = GlobalKey<ScaffoldState>();
  var _autoValidate = false;

  var _designation = '';
  var _photoIdType = '';
  var _firmNomenclature = '';
  var _tradeCategory = '';
  String path, path1;

  Future<File> imageFile, imageFile1;

  pickImageFromSystem(ImageSource source, int index) {
    setState(() {
      if (index == 0)
        imageFile = ImagePicker.pickImage(
          source: source,
          imageQuality: 50,
        );
      else
        imageFile1 = ImagePicker.pickImage(
          source: source,
          imageQuality: 50,
        );
    });
  }

  void _storeData(
    String token,
    bool loggedIn,
    String email,
    String password,
  ) async {
    prefs = await SharedPreferences.getInstance();
    await prefs.remove('loggedIn');
    await prefs.remove('loggedInEmail');
    await prefs.remove('loggedInPassword');
    await prefs.remove('token');
    await prefs.remove('loginTime');
    await prefs.setBool('loggedIn', loggedIn);
    await prefs.setString('loggedInEmail', email);
    await prefs.setString('loggedInPassword', password);
    await prefs.setString('token', token);
    await prefs.setInt('loginTime', DateTime.now().millisecondsSinceEpoch);
    print('data stored');
    print(prefs.getBool('loggedIn'));
    print(prefs.getString('token'));
  }

  void _getUserDetails() async {
    userDataController = true;
    prefs = await SharedPreferences.getInstance();
    final email = prefs.getString('loggedInEmail');
    final password = prefs.getString('loggedInPassword');

    _handler.loginUser(email, password).then((User user) {
      if (user != null) {
        print(user.name);
        _storeData(
          user.token,
          true,
          email,
          password,
        );
        this.currentUser = user;
        setState(() {});
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!userDataController) _getUserDetails();

    if (currentUser != null && !userSelectorController) {
      userSelectorController = true;

      if (currentUser.designation != null)
        _designation = currentUser.designation;

      if (currentUser.photoIdType != null)
        _photoIdType = currentUser.photoIdType;

      if (currentUser.firmNomenclature != null)
        _firmNomenclature = currentUser.firmNomenclature;

      if (currentUser.tradeCategory != null)
        _tradeCategory = currentUser.tradeCategory;

      path = currentUser.photoLocation;
      path1 = currentUser.visitingCardLocation;
    }

    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        title: Text('Update Profile'),
      ),
      body: SingleChildScrollView(
        child: (currentUser == null)
            ? LoadingBody()
            : Container(
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
          'Update',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Theme.of(context).primaryColorDark,
        icon: Icon(Icons.done),
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
            validator: (value) => _validator.validateName('Name', value),
            onSaved: (String val) => currentUser.name = val,
          ),
          SizedBox(height: 10.0),
          TextFormField(
            enabled: false,
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
            validator: (value) => _validator.validateDropDownSelector(value),
            value: _photoIdType,
            onSaved: (value) {
              setState(() {
                _photoIdType = value;
                currentUser.photoIdType = value as String;
              });
            },
            onChanged: (value) {
              Future.delayed(Duration.zero, () {
                _showModalSheet(context, 0);
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
          (imageFile != null)
              ? Container(
                  width: double.infinity,
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: FlatButton.icon(
                      onPressed: () {
                        print('close pressed');
                        imageFile = null;
                        currentUser.photoLocation = path;
                        setState(() {});
                      },
                      icon: Icon(Icons.clear),
                      label: Text('Remove'),
                    ),
                  ),
                )
              : Container(),
          SizedBox(height: 10.0),
          (imageFile != null)
              ? imagePreview()
              : (currentUser.photoLocation == null)
                  ? Container()
                  : Container(
                      width: double.infinity,
                      height: 400.0,
                      decoration: BoxDecoration(
                        shape: BoxShape.rectangle,
                        borderRadius: BorderRadius.circular(5.0),
                        image: DecorationImage(
                          fit: BoxFit.cover,
                          image: NetworkImage(
                              'https://developers.thegraphe.com/flexy/storage/app/photo_id/${currentUser.photoLocation}'),
                        ),
                      ),
                    ),
          SizedBox(height: 10.0),
          Container(
            width: double.infinity,
            child: FlatButton.icon(
              onPressed: () {
                Future.delayed(Duration.zero, () {
                  _showModalSheet(context, 1);
                });
              },
              icon: Icon(Icons.add),
              label: Text('Change Visiting Card'),
            ),
          ),
          SizedBox(height: 10.0),
          (imageFile1 != null)
              ? Container(
                  width: double.infinity,
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: FlatButton.icon(
                      onPressed: () {
                        print('close pressed');
                        imageFile1 = null;
                        currentUser.visitingCardLocation = path1;
                        setState(() {});
                      },
                      icon: Icon(Icons.clear),
                      label: Text('Remove'),
                    ),
                  ),
                )
              : Container(),
          SizedBox(height: 10.0),
          (imageFile1 != null)
              ? imagePreview1()
              : (currentUser.visitingCardLocation == null)
                  ? Container()
                  : Container(
                      width: double.infinity,
                      height: 400.0,
                      decoration: BoxDecoration(
                        shape: BoxShape.rectangle,
                        borderRadius: BorderRadius.circular(5.0),
                        image: DecorationImage(
                          fit: BoxFit.cover,
                          image: NetworkImage(
                              'https://developers.thegraphe.com/flexy/storage/app/visiting_card/${currentUser.visitingCardLocation}'),
                        ),
                      ),
                    ),
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
                "display": "Semi-Wholesaler",
                "value": "Semi-Wholesaler",
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
          TextFormField(
            initialValue:
                (currentUser.landlineNo != null) ? currentUser.landlineNo : '',
            decoration: const InputDecoration(
              labelText: 'Land-Line Number (Eg. 0657-1234567)',
            ),
            onEditingComplete: _validateInput,
            keyboardType: TextInputType.number,
            validator: (value) => _validator.validateLandLine(value),
            onSaved: (String val) => currentUser.landlineNo = val,
          ),
          SizedBox(height: 10.0),
          TextFormField(
            initialValue: (currentUser.gstNo != null) ? currentUser.gstNo : '',
            decoration: const InputDecoration(
              labelText: 'GST Number',
            ),
            onEditingComplete: _validateInput,
            keyboardType: TextInputType.number,
            validator: (value) => _validator.validateGST(value),
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
          TextFormField(
            initialValue: (currentUser.state != null) ? currentUser.state : '',
            decoration: const InputDecoration(
              labelText: 'State',
            ),
            onEditingComplete: _validateInput,
            keyboardType: TextInputType.text,
            validator: (value) => _validator.validateName('State', value),
            onSaved: (String val) => currentUser.state = val,
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
              labelText: 'Agent Name',
            ),
            onEditingComplete: _validateInput,
            keyboardType: TextInputType.text,
            validator: (value) => _validator.validateName('Name', value),
            onSaved: (String val) => currentUser.agentName = val,
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
            validator: (value) => _validator.validateName('Name', value),
            onSaved: (String val) => currentUser.purchasePerson = val,
          ),
          SizedBox(height: 50.0),
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
      else if (currentUser.visitingCardLocation == null)
        Toast.show(
          "Please add a visiting card!",
          context,
          duration: Toast.LENGTH_SHORT,
          gravity: Toast.CENTER,
        );
      else {
        _handler.updateUser(
          currentUser,
          (currentUser.photoLocation == path) ? false : true,
          (currentUser.visitingCardLocation == path1) ? false : true,
        );
      }
    } else {
      setState(() {
        _autoValidate = true;
      });
    }
  }

  void _showModalSheet(BuildContext context, int index) => showModalBottomSheet(
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
                  pickImageFromSystem(ImageSource.camera, index);
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
                  pickImageFromSystem(ImageSource.gallery, index);
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
                          _showModalSheet(context, 0);
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
        : Container();
  }

  Widget imagePreview1() {
    return (imageFile1 != null)
        ? FutureBuilder<File>(
            future: imageFile1,
            builder: (BuildContext context, AsyncSnapshot<File> snapshot) {
              if (snapshot.data != null)
                currentUser.visitingCardLocation = snapshot.data.path;
              return Stack(
                children: <Widget>[
                  Container(
                    width: double.infinity,
                    height: 400.0,
                    decoration: (imageFile1 != null && snapshot.data != null)
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
                          _showModalSheet(context, 1);
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
        : Container();
  }
}
