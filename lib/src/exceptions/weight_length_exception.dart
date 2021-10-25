class WeightLengthException implements Exception {
  @override
  String toString() {
    super.toString();
    return "length of weights and Description must to be equal to length of threats.";
  }
}
