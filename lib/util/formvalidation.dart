isEmpty(String value) {
  if (value.isEmpty) {
    return false;
  }
}

isValidateEmail(String value) {
  if (value.isEmpty) {
    return false;
  }

  Pattern pattern =
      r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
  RegExp regex = new RegExp(pattern);
  if (!regex.hasMatch(value))
    return false;
  else
    return true;
}

isValidMobile(String value) {
  String patttern = r'(^(?:[+0]9)?[0-9]{10,13}$)';
  RegExp regExp = new RegExp(patttern);
  if (value.length == 0) {
    return false;
  } else if (!regExp.hasMatch(value)) {
    return false;
  }
  return true;
}
