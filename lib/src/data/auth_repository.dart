import 'package:firebase_auth/firebase_auth.dart';

abstract class AuthRepository {
  Future<void> signInWithEmailAndPassword(String email, String pw);
  Future<void> createUserWithEmailAndPassword(String email, String pw);
  Future<void> signOut();
  Future<void> sendVerificationEmail();
  Stream<User?> authStateChanges();
  Future<void> sendPasswordResetEmail(String email);
}
