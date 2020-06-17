class FormValidator {
  String validateName(String value) {
    if (value.length < 3)
      return 'Name must be more than 2 charater';
    else
      return null;
  }

  String validateMobile(String value) {
    if (value.length != 10)
      return 'Enter 10 digit Mobile Number';
    else
      return null;
  }

  String validateEmail(String value) {
    Pattern pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = new RegExp(pattern);
    if (!regex.hasMatch(value))
      return 'Enter Valid Email';
    else
      return null;
  }

  String validateDropDownSelector(dynamic value) {
    if (value == null)
      return 'Please select a value';
    else
      return null;
  }

  String validateNumber(String value) {
    if (value == null)
      return 'Please select a number';
    else
      return null;
  }

  String validateGST(String value) {
    Pattern pattern =
        r'/^[0-9]{2}[A-Z]{5}[0-9]{4}[A-Z]{1}[1-9A-Z]{1}Z[0-9A-Z]{1}$/';
    RegExp regex = new RegExp(pattern);
    if (!regex.hasMatch(value))
      return 'Enter Valid GST Number';
    else
      return null;
  }

  String validatePIN(String value) {
    Pattern pattern =
        r'^[1-9][0-9]{5}$';
    RegExp regex = new RegExp(pattern);
    if (!regex.hasMatch(value))
      return 'Enter Valid PINCODE';
    else
      return null;
  }
}
