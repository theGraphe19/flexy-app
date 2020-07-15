class User {
  Map<String, dynamic> data;
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
  int status;
  int category;

  User({
    this.data,
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
    this.status,
    this.category,
  });

  void mapToUser(Map<dynamic, dynamic> map) {
    this.data = map;
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
    this.status = int.parse(map['status']);
    this.category = int.parse(map['mem']);
  }
}
