extension StringExtension on String {
  bool isValidEmail() {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(this);
  }

  bool isValidUsername() {
    return RegExp(r'^[a-zA-Z0-9_]{4,}$').hasMatch(this);
  }
}
