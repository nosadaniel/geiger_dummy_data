class CustomFormatException implements Exception {
  final String message;

  CustomFormatException({required this.message});

  @override
  String toString() {
    super.toString();
    return "Oops WRONG INPUT FORMAT: $message";
  }
}
