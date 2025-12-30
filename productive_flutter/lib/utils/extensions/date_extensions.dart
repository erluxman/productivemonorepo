extension DateExtensions on DateTime {
  String toHHMM() {
    return "${hour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')}";
  }
}
