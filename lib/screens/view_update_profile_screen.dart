import 'dart:io';
import 'package:flexy/utils/form_validator.dart';
import 'package:flutter/material.dart';
import 'package:dropdown_formfield/dropdown_formfield.dart';
import 'package:image_picker/image_picker.dart';
import '../models/user.dart';
import '../HTTP_handler.dart';

class ViewUpdateProfile extends StatefulWidget {
  static const routeName = '/view-update-profile';

  @override
  _ViewUpdateProfileState createState() => _ViewUpdateProfileState();
}

class _ViewUpdateProfileState extends State<ViewUpdateProfile> {
  User currentUser;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final scaffoldKey = GlobalKey<ScaffoldState>();
  var _autoValidate = false;
  var _validator = FormValidator();
  String designation, photoIdType, firmNomenclature, tradeCategory;
  Future<File> imageFile1, imageFile2;
  bool image1Disturbed = false;
  bool image2Disturbed = false;
  bool unDisturbed = true;

  void setThingUp() {
    if (unDisturbed) {
      setState(() {
        currentUser = ModalRoute.of(context).settings.arguments as User;
        designation = currentUser.designation;
        photoIdType = currentUser.photoIdType;
        firmNomenclature = currentUser.firmNomenclature;
        tradeCategory = currentUser.tradeCategory;
      });
    }
    ;
    unDisturbed = false;
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    setThingUp();
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        title: Text('View/Update Profile'),
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
      /*floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          _validateInput(currentUser);
        },
        label: Text('Update Profile'),
        icon: Icon(Icons.file_upload),
      ),*/
    );
  }

  Widget formUI() => Column(
        children: <Widget>[
          TextFormField(
            enabled: false,
            initialValue: currentUser.name,
            decoration: const InputDecoration(
              labelText: 'Name',
            ),
            keyboardType: TextInputType.text,
          ),
          SizedBox(height: 10.0),
          TextFormField(
            enabled: false,
            initialValue: currentUser.mobileNo,
            decoration: const InputDecoration(
              labelText: 'Phone Number',
            ),
            keyboardType: TextInputType.number,
          ),
          SizedBox(height: 10.0),
          TextFormField(
            enabled: false,
            initialValue: currentUser.email,
            decoration: const InputDecoration(
              labelText: 'Email ID',
            ),
            keyboardType: TextInputType.emailAddress,
          ),
          SizedBox(height: 10.0),
          TextFormField(
            enabled: false,
            initialValue: currentUser.designation,
            decoration: const InputDecoration(
              labelText: 'Designation',
            ),
            keyboardType: TextInputType.emailAddress,
          ),
          SizedBox(height: 10.0),
          TextFormField(
            enabled: false,
            initialValue: currentUser.photoIdType,
            decoration: const InputDecoration(
              labelText: 'Photo ID Type',
            ),
            keyboardType: TextInputType.emailAddress,
          ),
          SizedBox(height: 10.0),
          Container(
            width: double.infinity,
            height: 400.0,
            decoration: BoxDecoration(
              shape: BoxShape.rectangle,
              borderRadius: BorderRadius.circular(5.0),
            ),
            child: Image.network(
              'https://developers.thegraphe.com/flexy/storage/app/photo_id/${currentUser.photoIdType}-${currentUser.id}',
              fit: BoxFit.contain,
            ),
          ),
          SizedBox(height: 10.0),
          Text("Visiting Card Photo" + currentUser.photoLocation.toString()),
          SizedBox(height: 10.0),
          Container(
            width: double.infinity,
            height: 400.0,
            decoration: BoxDecoration(
              shape: BoxShape.rectangle,
              borderRadius: BorderRadius.circular(5.0),
            ),
            child: Image.network(
              'https://developers.thegraphe.com/flexy/storage/app/visiting_card/VisitingCard-${currentUser.id}',
              fit: BoxFit.contain,
            ),
          ),
          SizedBox(height: 10.0),
          TextFormField(
            enabled: false,
            initialValue: currentUser.firmName,
            decoration: const InputDecoration(
              labelText: 'Firm Name',
            ),
            keyboardType: TextInputType.text,
          ),
          SizedBox(height: 10.0),
          TextFormField(
            enabled: false,
            initialValue: currentUser.firmNomenclature,
            decoration: const InputDecoration(
              labelText: 'Firm Nomenclature',
            ),
            keyboardType: TextInputType.emailAddress,
          ),
          SizedBox(height: 10.0),
          TextFormField(
            enabled: false,
            initialValue: currentUser.tradeCategory,
            decoration: const InputDecoration(
              labelText: 'Trade Category',
            ),
            keyboardType: TextInputType.emailAddress,
          ),
          (currentUser.tradeCategory.endsWith("Boutique") ||
                  currentUser.tradeCategory.endsWith("Retailer"))
              ? TextFormField(
                  enabled: false,
                  initialValue: currentUser.noOfStores,
                  decoration: const InputDecoration(
                    labelText: 'Number of Stores',
                  ),
                  keyboardType: TextInputType.number,
                )
              : Container(),
          SizedBox(height: 10.0),
          TextFormField(
            enabled: false,
            initialValue: currentUser.landlineNo,
            decoration: const InputDecoration(
              labelText: 'Land-Line Number (Eg. 0657-1234567)',
            ),
            keyboardType: TextInputType.number,
          ),
          SizedBox(height: 10.0),
          TextFormField(
            enabled: false,
            initialValue: currentUser.gstNo,
            decoration: const InputDecoration(
              labelText: 'GST Number',
            ),
            keyboardType: TextInputType.number,
          ),
          SizedBox(height: 10.0),
          TextFormField(
            enabled: false,
            initialValue: currentUser.companyAddress,
            decoration: const InputDecoration(
              labelText: 'Company Address',
            ),
            minLines: 1,
            maxLines: 3,
            keyboardType: TextInputType.text,
          ),
          TextFormField(
            enabled: false,
            initialValue: currentUser.city,
            decoration: const InputDecoration(
              labelText: 'City',
            ),
            keyboardType: TextInputType.text,
          ),
          SizedBox(height: 10.0),
          TextFormField(
            enabled: false,
            initialValue: currentUser.state,
            decoration: const InputDecoration(
              labelText: 'State',
            ),
            keyboardType: TextInputType.text,
          ),
          SizedBox(height: 10.0),
          TextFormField(
            enabled: false,
            initialValue: currentUser.pincode,
            decoration: const InputDecoration(
              labelText: 'PIN',
            ),
            keyboardType: TextInputType.number,
          ),
          SizedBox(height: 10.0),
          TextFormField(
            enabled: false,
            initialValue: currentUser.agentName,
            decoration: const InputDecoration(
              labelText: 'Agent Name',
            ),
            keyboardType: TextInputType.text,
          ),
          SizedBox(height: 10.0),
          TextFormField(
            enabled: false,
            initialValue: currentUser.purchasePerson,
            decoration: const InputDecoration(
              labelText: 'Person incharge of Purchase Department',
            ),
            keyboardType: TextInputType.text,
          ),
          SizedBox(height: 50.0),
        ],
      );

  Widget formUIUpdate() => Column(
        children: <Widget>[
          TextFormField(
            enabled: false,
            initialValue: currentUser.name,
            decoration: const InputDecoration(
              labelText: 'Name',
            ),
            keyboardType: TextInputType.text,
          ),
          SizedBox(height: 10.0),
          TextFormField(
            enabled: false,
            initialValue: currentUser.mobileNo,
            decoration: const InputDecoration(
              labelText: 'Phone Number',
            ),
            keyboardType: TextInputType.number,
          ),
          SizedBox(height: 10.0),
          TextFormField(
            enabled: false,
            initialValue: currentUser.email,
            decoration: const InputDecoration(
              labelText: 'Email ID',
            ),
            keyboardType: TextInputType.emailAddress,
          ),
          SizedBox(height: 10.0),
          DropDownFormField(
            titleText: 'Designation',
            autovalidate: false,
            value: designation,
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
            onSaved: (value) {
              setState(() {
                designation = value;
                currentUser.designation = value as String;
              });
            },
            onChanged: (value) {
              setState(() {
                designation = value;
              });
            },
            textField: "display",
            valueField: "value",
          ),
          SizedBox(height: 10.0),
          DropDownFormField(
            titleText: 'Photo Id',
            autovalidate: false,
            value: photoIdType,
            onSaved: (value) {
              setState(() {
                photoIdType = value;
                currentUser.photoIdType = value as String;
              });
            },
            onChanged: (value) {
              Future.delayed(Duration.zero, () {
                _showModalSheet1(context);
              });
              setState(() {
                photoIdType = value;
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
          image1Disturbed
              ? FutureBuilder<File>(
                  future: imageFile1,
                  builder:
                      (BuildContext context, AsyncSnapshot<File> snapshot) {
                    if (snapshot.data != null)
                      currentUser.photoLocation = snapshot.data.path;
                    print(currentUser.photoLocation);
                    return Stack(
                      children: <Widget>[
                        Container(
                          width: double.infinity,
                          height: 400.0,
                          decoration:
                              (imageFile1 != null && snapshot.data != null)
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
                                _showModalSheet1(context);
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
              : Stack(
                  children: <Widget>[
                    Container(
                      width: double.infinity,
                      height: 400.0,
                      decoration: BoxDecoration(
                        shape: BoxShape.rectangle,
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                      child: Image.network(
                        'https://developers.thegraphe.com/flexy/storage/app/product_images/${currentUser.photoLocation.toString()}',
                        fit: BoxFit.contain,
                      ),
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
                            _showModalSheet1(context);
                          },
                          icon: Icon(Icons.edit),
                          label: Text(
                            'Change Image',
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
          image2Disturbed
              ? FutureBuilder<File>(
                  future: imageFile2,
                  builder:
                      (BuildContext context, AsyncSnapshot<File> snapshot) {
                    if (snapshot.data != null)
                      currentUser.visitingCardLocation = snapshot.data.path;
                    print(currentUser.photoLocation);
                    return Stack(
                      children: <Widget>[
                        Container(
                          width: double.infinity,
                          height: 400.0,
                          decoration:
                              (imageFile2 != null && snapshot.data != null)
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
                                _showModalSheet2(context);
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
              : Stack(
                  children: <Widget>[
                    Container(
                      width: double.infinity,
                      height: 400.0,
                      decoration: BoxDecoration(
                        shape: BoxShape.rectangle,
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                      child: Image.network(
                        'https://developers.thegraphe.com/flexy/storage/app/product_images/${currentUser.visitingCardLocation.toString()}',
                        fit: BoxFit.contain,
                      ),
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
                            _showModalSheet2(context);
                          },
                          icon: Icon(Icons.edit),
                          label: Text(
                            'Change Image',
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
          SizedBox(height: 10.0),
          TextFormField(
            enabled: false,
            initialValue: currentUser.firmName,
            decoration: const InputDecoration(
              labelText: 'Firm Name',
            ),
            keyboardType: TextInputType.text,
            validator: (value) => _validator.validateName('Firm Name', value),
            onSaved: (String val) => currentUser.firmName = val,
          ),
          SizedBox(height: 10.0),
          DropDownFormField(
            titleText: 'Firm Nomenclature',
            autovalidate: false,
            hintText: 'Please select any one',
            value: firmNomenclature,
            onSaved: (value) {
              setState(() {
                firmNomenclature = value;
                currentUser.firmNomenclature = value as String;
              });
            },
            onChanged: (value) {
              setState(() {
                firmNomenclature = value;
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
            value: tradeCategory,
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
            onSaved: (value) {
              setState(() {
                tradeCategory = value;
                currentUser.tradeCategory = value as String;
              });
            },
            onChanged: (value) {
              setState(() {
                tradeCategory = value;
              });
            },
            textField: "display",
            valueField: "value",
          ),
          (currentUser.tradeCategory.endsWith("Boutique") ||
                  currentUser.tradeCategory.endsWith("Retailer"))
              ? TextFormField(
                  initialValue: (currentUser.noOfStores != null)
                      ? currentUser.noOfStores
                      : '',
                  decoration: const InputDecoration(
                    labelText: 'Number of Stores',
                  ),
                  keyboardType: TextInputType.number,
                  validator: (value) => _validator.validateNumber(value),
                  onSaved: (String val) => currentUser.noOfStores = val,
                )
              : Container(),
          SizedBox(height: 10.0),
          TextFormField(
            initialValue: currentUser.landlineNo,
            decoration: const InputDecoration(
              labelText: 'Land-Line Number (Eg. 0657-1234567)',
            ),
            keyboardType: TextInputType.number,
            validator: (value) => _validator.validateLandLine(value),
            onSaved: (String val) => currentUser.landlineNo = val,
          ),
          SizedBox(height: 10.0),
          TextFormField(
            initialValue: currentUser.gstNo,
            decoration: const InputDecoration(
              labelText: 'GST Number',
            ),
            keyboardType: TextInputType.number,
            validator: (value) => _validator.validateGST(value),
            onSaved: (String val) => currentUser.gstNo = val,
          ),
          SizedBox(height: 10.0),
          TextFormField(
            initialValue: currentUser.companyAddress,
            decoration: const InputDecoration(
              labelText: 'Company Address',
            ),
            minLines: 1,
            maxLines: 3,
            keyboardType: TextInputType.text,
            validator: (value) =>
                _validator.validateName('Company Address', value),
            onSaved: (String val) => currentUser.companyAddress = val,
          ),
          TextFormField(
            initialValue: currentUser.city,
            decoration: const InputDecoration(
              labelText: 'City',
            ),
            keyboardType: TextInputType.text,
            validator: (value) {
              if (value.isEmpty) {
                return "Cannot be empty";
              }
              return null;
            },
            onSaved: (String val) => currentUser.city = val,
          ),
          SizedBox(height: 10.0),
          TextFormField(
            initialValue: currentUser.state,
            decoration: const InputDecoration(
              labelText: 'State',
            ),
            keyboardType: TextInputType.text,
            validator: (value) {
              if (value.isEmpty) {
                return "Cannot be empty";
              }
              return null;
            },
            onSaved: (String val) => currentUser.state = val,
          ),
          SizedBox(height: 10.0),
          TextFormField(
            initialValue: currentUser.pincode,
            decoration: const InputDecoration(
              labelText: 'PIN',
            ),
            keyboardType: TextInputType.number,
            validator: (value) => _validator.validatePIN(value),
            onSaved: (String val) => currentUser.pincode = val,
          ),
          SizedBox(height: 10.0),
          TextFormField(
            initialValue: currentUser.agentName,
            decoration: const InputDecoration(
              labelText: 'Agent Name',
            ),
            keyboardType: TextInputType.text,
            validator: (value) => _validator.validateName('Name', value),
            onSaved: (String val) => currentUser.agentName = val,
          ),
          SizedBox(height: 10.0),
          TextFormField(
            initialValue: currentUser.purchasePerson,
            decoration: const InputDecoration(
              labelText: 'Person incharge of Purchase Department',
            ),
            keyboardType: TextInputType.text,
            validator: (value) => _validator.validateName('Name', value),
            onSaved: (String val) => currentUser.purchasePerson = val,
          ),
          SizedBox(height: 50.0),
        ],
      );

  pickImageFromSystem1(ImageSource source) {
    imageFile1 = ImagePicker.pickImage(
      source: source,
      imageQuality: 50,
    );
    imageFile1.then((value) {
      if (value.existsSync()) {
        setState(() {
          image1Disturbed = true;
        });
      }
    });
  }

  void _showModalSheet1(BuildContext context) => showModalBottomSheet(
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
                  pickImageFromSystem1(ImageSource.camera);
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
                  pickImageFromSystem1(ImageSource.gallery);
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      });

  pickImageFromSystem2(ImageSource source) {
    imageFile2 = ImagePicker.pickImage(
      source: source,
      imageQuality: 50,
    );
    imageFile2.then((value) {
      if (value.existsSync()) {
        setState(() {
          image2Disturbed = true;
        });
      }
    });
  }

  void _showModalSheet2(BuildContext context) => showModalBottomSheet(
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
                  pickImageFromSystem2(ImageSource.camera);
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
                  pickImageFromSystem2(ImageSource.gallery);
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      });

  void _validateInput(User currentUser) {
    print(currentUser.noOfStores + currentUser.city + currentUser.state);
    if (_formKey.currentState.validate()) {
      print("valid");
      _formKey.currentState.save();
      print(currentUser.noOfStores + currentUser.city + currentUser.state);
      HTTPHandler().updateProfile(currentUser).then((value) {
        if (value == true) {
          scaffoldKey.currentState.showSnackBar(SnackBar(
            content: Text('Profile Updated!'),
            backgroundColor: Colors.green,
            duration: Duration(seconds: 3),
          ));
        } else {
          scaffoldKey.currentState.showSnackBar(SnackBar(
            content: Text('Failed to Updated Profile.'),
            backgroundColor: Colors.red,
            duration: Duration(seconds: 3),
          ));
        }
      });
    }
  }
}
