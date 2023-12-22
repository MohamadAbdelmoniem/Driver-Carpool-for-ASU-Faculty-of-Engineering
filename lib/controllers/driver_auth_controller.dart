import 'package:firebase_auth/firebase_auth.dart';
import '../models/driver_auth_model.dart';
import 'package:flutter/material.dart';

class DriverAuthController {
  final DriverAuthModel _driverAuthModel = DriverAuthModel();

  bool isValidEmail(String email) {
    return _driverAuthModel.isValidEmail(email);
  }

  Future<void> signUpWithEmailAndPassword(
    String email,
    String password,
    String firstName,
    String lastName,
    String mobileNumber,
    BuildContext context,
  ) async {
    try {
      await _driverAuthModel.signUpWithEmailAndPassword(
        email,
        password,
        firstName,
        lastName,
        mobileNumber,
      );
    } catch (e) {
      print('Error during sign up: $e');
      throw Exception('Error during sign up: $e');
    }
  }

  Future<void> signInWithEmailAndPassword(
    String email,
    String password,
    Function(String) errorCallback,
    BuildContext context,
  ) async {
    try {
      if (email.isEmpty || password.isEmpty) {
        errorCallback('Please enter both email and password.');
        return;
      }

      await _driverAuthModel.signInWithEmailAndPassword(email, password);

      // If the sign-in is successful, navigate to the driver dashboard
      print('Sign in successful, navigating to dashboard');
      Navigator.pushReplacementNamed(context, '/driver_dashboard');
    } catch (e) {
      if (e is FirebaseAuthException) {
        if (e.code == 'user-not-found') {
          errorCallback('No driver found for that email.');
        } else if (e.code == 'wrong-password') {
          errorCallback('Wrong password provided.');
        } else {
          errorCallback('Error: ${e.message}');
        }
      } else {
        print('Error during sign in: $e');
        errorCallback('Error during sign in: $e');
      }
    }
  }
}
