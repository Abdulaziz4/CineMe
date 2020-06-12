// create an exeption to be throwed when POST request return an error from the server
class HttpException implements Exception {
  final String message;
  HttpException(this.message);

  String toString() {
    return message;
  }
}
