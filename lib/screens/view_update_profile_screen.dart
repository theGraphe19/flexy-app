import 'dart:io';

import 'package:flexy/utils/form_validator.dart';
import 'package:flutter/material.dart';

import '../models/user.dart';

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
              labelText: 'Land-Line Number',
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
}
