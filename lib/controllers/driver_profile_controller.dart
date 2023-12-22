import '../models/driver_profile_model.dart';

class DriverProfileController {
  final DriverProfileModel model;

  DriverProfileController({required this.model});

  Future<void> loadUserData() async {
    try {
      await model.loadUserData();
    } catch (e) {
      print('Error loading user data: $e');
      rethrow;
    }
  }
}
