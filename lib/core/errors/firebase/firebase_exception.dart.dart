import '../app_exception.dart';

class FirebaseAuthException extends AuthException {
  const FirebaseAuthException( String message)
      : super('Firebase Auth: $message');

  factory FirebaseAuthException.fromFirebase(Exception e) {
    if (e is FirebaseAuthException) {
      return FirebaseAuthException(
       e.message
      );
    }
    return  FirebaseAuthException(e.toString());
  }
}