String validateRequired(String value) {
  if (value.isEmpty) {
    return "Required";
  } else {
    return null;
  }
}

String validateEmail(String value) {
  value = value.trim();

  Pattern pattern =
      r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
  RegExp regex = new RegExp(pattern);

  if (value.isEmpty) {
    return "Required";
  } else if (!regex.hasMatch(value)) {
    return "Email is not valid";
  } else {
    return null;
  }
}

String validatemustHave8Characters(String value) {
  if (value.isEmpty) {
    return "Required";
  } else if (value.length < 8) {
    return "Must have at least 8 characters";
  } else {
    return null;
  }
}

String validatePassword(String value) {
  if (value.isEmpty) {
    return "Password Required";
  } else if (value.length < 8) {
    return "Must have at least 8 characters";
  } else {
    return null;
  }
}

String validatePasswordConfirmation(String pass, String cnf) {
  if (pass == cnf && pass.isNotEmpty)
    return null;
  else {
    return "Password and Confirm Password must be the same.";
  }
}
