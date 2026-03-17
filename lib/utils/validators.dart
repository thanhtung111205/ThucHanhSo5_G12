class Validators {
  static String? validateNotEmpty(String? value) {
    if (value == null || value.isEmpty) {
      return 'This field cannot be empty';
    }
    return null;
  }

  static String? validateNumber(String? value) {
    if (value == null || double.tryParse(value) == null) {
      return 'Please enter a valid number';
    }
    return null;
  }
}
