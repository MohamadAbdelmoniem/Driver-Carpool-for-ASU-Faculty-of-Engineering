import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class DriverProfileModel {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  late User? _user;
  late Map<String, dynamic> _userData;

  User? get user => _user;
  Map<String, dynamic> get userData => _userData;

  Future<void> loadUserData() async {
    _user = _auth.currentUser;
    try {
      DocumentSnapshot<Map<String, dynamic>> userData =
          await _firestore.collection('users').doc(_user!.uid).get();
      _userData = userData.data()!;
    } catch (e) {
      print('Error loading user data: $e');
      rethrow;
    }
  }

  String getFirstName() {
    return _userData['firstName'] ?? '';
  }

  String getLastName() {
    return _userData['lastName'] ?? '';
  }

  String getUserId() {
    return _user?.uid ?? '';
  }
}
