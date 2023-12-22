// views/driver_profile_view.dart
import 'package:flutter/material.dart';
import '../controllers/driver_profile_controller.dart';
import '../models/driver_profile_model.dart';

class DriverProfileView extends StatefulWidget {
  @override
  _DriverProfileViewState createState() => _DriverProfileViewState();
}

class _DriverProfileViewState extends State<DriverProfileView> {
  late DriverProfileController _controller;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _controller = DriverProfileController(model: DriverProfileModel());
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    try {
      await _controller.loadUserData();
    } catch (e) {
      // Handle error
      print('Error loading user data: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Driver Profile'),
        backgroundColor: Color(0xFF607D8B),
      ),
      body: _isLoading ? _buildLoadingScreen() : _buildProfileScreen(),
    );
  }

  Widget _buildLoadingScreen() {
    return Container(
      padding: EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF607D8B), Color(0xFF455A64)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: Center(
          child: CircularProgressIndicator(
        color: Colors.white,
      )),
    );
  }

  Widget _buildProfileScreen() {
    return Container(
      padding: EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF607D8B), Color(0xFF455A64)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _buildProfileItem(
            'First Name',
            _controller.model.userData['firstName'],
            Icons.person,
          ),
          _buildProfileItem(
            'Last Name',
            _controller.model.userData['lastName'],
            Icons.person,
          ),
          _buildProfileItem(
            'Email',
            _controller.model.userData['email'],
            Icons.email,
          ),
          _buildProfileItem(
            'Mobile Number',
            _controller.model.userData['mobileNumber'],
            Icons.phone,
          ),
        ],
      ),
    );
  }

  Widget _buildProfileItem(String label, dynamic value, IconData icon) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.0),
      child: Card(
        color: Colors.white,
        elevation: 5,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
        child: ListTile(
          leading: Icon(
            icon,
            size: 30,
            color: Color(0xFF607D8B),
          ),
          title: Text(
            label,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Color(0xFF607D8B),
            ),
          ),
          subtitle: Text(
            value.toString(),
            style: TextStyle(
              fontSize: 18,
              color: Color(0xFF607D8B),
            ),
          ),
        ),
      ),
    );
  }
}
