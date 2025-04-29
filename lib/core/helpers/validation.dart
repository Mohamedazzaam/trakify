import 'package:flutter/material.dart';

import 'extensions.dart';

String? validatePassword(BuildContext context, String? value) {
  if (value == null || value.isEmpty) {
    return "Password is required";
  }
  if (value.length < 8) {
    return "Password must be at least 8 characters long";
  }
  if (!RegExp(r'^(?=.*[a-z])(?=.*[A-Z]).+$').hasMatch(value)) {
    return "Password must contain both uppercase and lowercase letters";
  }
  return null;
}

String? validateName(BuildContext context, String? value) {
  // Pattern to match Arabic and English letters and spaces, excluding digits
  String pattern = r'^[a-zA-Z\u0600-\u06FF\s]+$';
  String numberPattern = r'[0-9\u0660-\u0669\u06F0-\u06F9]';
  RegExp regExp = RegExp(pattern);
  RegExp numberRegExp = RegExp(numberPattern);

  if (value.isNullOrEmpty()) {
    return "This field is required";
  }
  if (!regExp.hasMatch(value!) || numberRegExp.hasMatch(value)) {
    return "Please enter a valid name (Arabic or English letters only)";
  }

  return null;
}

String? validateEmail(BuildContext context, String? value) {
  if (value.isNullOrEmpty()) {
    return "Email is required";
  }
  String pattern = r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$';
  RegExp regExp = RegExp(pattern);
  if (!regExp.hasMatch(value!)) {
    return "Please enter a valid email address";
  }
  return null;
}

String? validateEmailOptional(BuildContext context, String? value) {
  if (value != null && value.isNotEmpty) {
    String pattern = r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$';
    RegExp regExp = RegExp(pattern);
    if (!regExp.hasMatch(value)) {
      return "Please enter a valid email address";
    }
  }
  return null;
}

String? validateNameOptional(BuildContext context, String? value) {
  String pattern = r'^[a-zA-Z\u0600-\u06FF\s]+$';
  String numberPattern = r'[0-9\u0660-\u0669\u06F0-\u06F9]';
  RegExp regExp = RegExp(pattern);
  RegExp numberRegExp = RegExp(numberPattern);

  if (value != null && value.isNotEmpty) {
    if (!regExp.hasMatch(value) || numberRegExp.hasMatch(value)) {
      return "Please enter a valid name (Arabic or English letters only)";
    }
  }
  return null;
}
