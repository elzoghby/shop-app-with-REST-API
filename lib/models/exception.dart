class Httpex implements Exception{
  final String message;
  Httpex(this.message);
  @override
  String toString() {

    return message;
  }
}