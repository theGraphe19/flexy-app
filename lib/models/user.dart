class User {
  int id;
  String name;
  String mobileNo;
  String email;
  String designation;
  String photoIdType;
  String photoLocation;
  String visitingCardLocation;
  String firmName;
  String firmNomenclature;
  String tradeCategory;
  String noOfStores;
  String landlineNo;
  String gstNo;
  String companyAddress;
  String city;
  String state;
  String pincode;
  String agentName;
  String purchasePerson;
  String password;
  String token;

  User({
    this.id,
    this.name,
    this.mobileNo,
    this.email,
    this.designation,
    this.photoIdType,
    this.photoLocation,
    this.visitingCardLocation,
    this.firmName,
    this.firmNomenclature,
    this.tradeCategory,
    this.noOfStores,
    this.landlineNo,
    this.gstNo,
    this.companyAddress,
    this.state,
    this.city,
    this.pincode,
    this.agentName,
    this.purchasePerson,
    this.password,
    this.token,
  });

  Map<String, dynamic> userToMap() {
    return <String, dynamic>{
      'id': this.id,
      'name': this.name,
      'mobileNo': this.mobileNo,
      'email': this.email,
      'designation': this.designation,
      'photoIdType': this.photoIdType,
      'photoLocation': this.photoLocation,
      'visitingCardLocation': this.visitingCardLocation,
      'firmName': this.firmName,
      'firmNomenclature': this.firmNomenclature,
      'tradeCategory': this.tradeCategory,
      'noOfStores': this.noOfStores,
      'landlineNo': this.landlineNo,
      'gstNo': this.gstNo,
      'companyAddress': this.companyAddress,
      'city': this.city,
      'state': this.state,
      'pincode': this.pincode,
      'agentName': this.agentName,
      'purchasePerson': this.purchasePerson,
    };
  }

  void mapToUser(Map<dynamic, dynamic> map) {
    this.id = map['id'];
    this.name = map['name'];
    this.mobileNo = map['mobileNo'];
    this.email = map['email'];
    this.token = map['api_token'];
    this.designation = map['designation'];
    this.photoIdType = map['photoIdType'];
    this.photoLocation = map['photoLocation'];
    this.visitingCardLocation = map['visitingCardLocation'];
    this.firmName = map['firmName'];
    this.firmNomenclature = map['firmNomenclature'];
    this.tradeCategory = map['tradeCategory'];
    this.noOfStores = map['noOfStores'];
    this.landlineNo = map['landlineNo'];
    this.gstNo = map['gstNo'];
    this.companyAddress = map['companyAddress'];
    this.city = map['city'];
    this.state = map['state'];
    this.pincode = map['pincode'];
    this.agentName = map['agentName'];
    this.purchasePerson = map['purchasePerson'];
  }
}
