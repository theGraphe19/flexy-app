import 'package:flutter/material.dart';
import 'package:dropdown_formfield/dropdown_formfield.dart';

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
  var _autoValidate = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    currentUser = ModalRoute.of(context).settings.arguments as User;
    return Scaffold(
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
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          _validateInput(currentUser);
        },
        label: Text('Update Profile'),
        icon: Icon(Icons.file_upload),
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
          DropDownFormField(
            titleText: 'Designation',
            autovalidate: false,
            value: currentUser.designation,
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
            value: currentUser.photoIdType,
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
          DropDownFormField(
            titleText: 'Firm Nomenclature',
            autovalidate: false,
            hintText: 'Please select any one',
            value: currentUser.firmNomenclature,
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
            value: currentUser.tradeCategory,
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
                  validator: (value) {
                    if (value.isEmpty) {
                      return "Cannot be empty";
                    }
                    return null;
                  },
                  onSaved: (String val) => currentUser.noOfStores = val,
                )
              : Container(),
          SizedBox(height: 10.0),
          TextFormField(
            readOnly: true,
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

  void _validateInput(User currentUser) {
    print(currentUser.noOfStores + currentUser.city + currentUser.state);
    if (_formKey.currentState.validate()) {
      print("valid");
      _formKey.currentState.save();
      print(currentUser.noOfStores + currentUser.city + currentUser.state);
      HTTPHandler().updateProfile(currentUser.token, currentUser.noOfStores,
          currentUser.city, currentUser.state);
    }
  }
}
