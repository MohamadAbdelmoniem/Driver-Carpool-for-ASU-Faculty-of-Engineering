import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DriverAuthModel {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  bool isValidEmail(String email) {
    return RegExp(
      r'^[a-zA-Z0-9._%+-]+@eng\.asu\.edu\.eg$',
    ).hasMatch(email);
  }

  Future<void> signUpWithEmailAndPassword(
    String email,
    String password,
    String firstName,
    String lastName,
    String mobileNumber,
  ) async {
    if (!isValidEmail(email)) {
      throw FirebaseAuthException(
        code: 'invalid-email',
        message: 'Invalid email address',
      );
    }

    try {
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Store additional driver information in Firestore
      await FirebaseFirestore.instance
          .collection('users')
          .doc(userCredential.user!.uid)
          .set({
        'firstName': firstName,
        'lastName': lastName,
        'email': email,
        'mobileNumber': mobileNumber,
      });
    } catch (e) {
      throw Exception('Error during sign up: $e');
    }
  }

  Future<void> signInWithEmailAndPassword(String email, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } catch (e) {
      throw Exception('Error during sign in: $e');
    }
  }
}
