/// Error returned by auth-service HTTP layer (OAuth / userinfo / federated).
class AuthApiException implements Exception {
  AuthApiException(this.message, this.statusCode);

  final String message;
  final int statusCode;

  @override
  String toString() => 'AuthApiException($statusCode): $message';
}
