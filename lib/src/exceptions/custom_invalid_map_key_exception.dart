class CustomInvalidMapKeyException implements Exception {
  final Object message;

  CustomInvalidMapKeyException({required this.message});

  @override
  String toString() {
    super.toString();
    return "INVALID MAP KEY USED: $message";
  }
}
