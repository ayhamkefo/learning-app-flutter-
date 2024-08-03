class Validte {
  static String? validateEmail(String? email) {
    if (email == null || email.isEmpty) {
      return 'Please Enter Your Email Address';
    }
    const emailPattern =
        r'^[^@\s]+@([^@\s]+\.)+[^@\s]+$'; // Simple email pattern
    final regex = RegExp(emailPattern);
    if (!regex.hasMatch(email)) {
      return 'Please Enter Valid Email Address';
    }
    return null;
  }

  static String? validatePassword(String? password) {
    if (password == null || password.isEmpty) {
      return 'Pleas Enter The Password';
    }
    if (password.length < 6) {
      return 'Password Must Be More Than 6 Letters ';
    }
    return null;
  }

  static String? validateName(String? name) {
    if (name == null || name.isEmpty) {
      return 'Pleas Enter The Name';
    }
    if (!RegExp(r'^.*[a-zA-Z]').hasMatch(name)) {
      return 'The Name Must Contain At Least One Letter';
    }
    if (name.length > 255) {
      return 'Name Must Be less Than 255 Letters ';
    }
    return null;
  }
}
