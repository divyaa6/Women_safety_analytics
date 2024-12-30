import 'dart:developer';
import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth auth = FirebaseAuth.instance;


  Future<User?> createUserWithEmailAndPassword(String email, String password) async {
    try {
      final cred = await auth.createUserWithEmailAndPassword(email: email, password: password);
      log("User created successfully: ${cred.user?.email}");
      return cred.user;
    } on FirebaseAuthException catch (e) {
      log("Firebase Auth Exception: ${e.message}");
      if (e.code == 'email-already-in-use') {
        log('The email address is already in use by another account.');
      } else if (e.code == 'weak-password') {
        log('The password provided is too weak.');
      } else {
        log("FirebaseAuthException: ${e.code}");
      }
    } catch (e) {
      log("Something went wrong: $e");
    }
    return null;
  }


  Future<User?> loginUserWithEmailAndPassword(String email, String password) async {
    try {
      final cred = await auth.signInWithEmailAndPassword(email: email, password: password);
      log("User signed in successfully: ${cred.user?.email}");
      return cred.user;
    } on FirebaseAuthException catch (e) {
      log("Firebase Auth Exception: ${e.message}");
      if (e.code == 'user-not-found') {
        log('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        log('Wrong password provided for that user.');
      } else {
        log("FirebaseAuthException: ${e.code}");
      }
    } catch (e) {
      log("Something went wrong: $e");
    }
    return null;
  }

  Future<void> signOut() async {
    try {
      await auth.signOut();
      log("User signed out successfully.");
    } catch (e) {
      log("Something went wrong during signout: $e");
    }
  }
}
