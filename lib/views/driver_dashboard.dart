import 'package:flutter/material.dart';
import '../controllers/driver_dashboard_controller.dart';

class DriverDashboard extends StatelessWidget {
  final DriverDashboardController _controller = DriverDashboardController();

  final Color appBarColor = Color(0xFF607D8B);
  final Color gradientStartColor = Color(0xFF607D8B);
  final Color gradientEndColor = Color(0xFF455A64);
  final Color cardColor1 = Color(0xFF78909C);
  final Color cardColor2 = Color(0xFF607D8B);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Driver Dashboard'),
        backgroundColor: appBarColor,
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [gradientStartColor, gradientEndColor],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildDashboardCard(
                  context,
                  'Add Trip',
                  Icons.add,
                  cardColor1,
                  () => _controller.handleAddTripTap(context),
                ),
                SizedBox(height: 16),
                _buildDashboardCard(
                  context,
                  'Profile',
                  Icons.person,
                  cardColor2,
                  () => _controller.handleProfileTap(context),
                ),
                SizedBox(height: 16),
                _buildDashboardCard(
                  context,
                  'Trip Requests',
                  Icons.assignment,
                  cardColor1,
                  () => _controller.handleTripRequestsTap(context),
                ),
                SizedBox(height: 16),
                _buildDashboardCard(
                  context,
                  'Done Trips',
                  Icons.check_circle,
                  cardColor2,
                  () => _controller.handleDoneTripsTap(context),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDashboardCard(
    BuildContext context,
    String title,
    IconData icon,
    Color color,
    VoidCallback onTap,
  ) {
    return Container(
      width: double.infinity,
      height: 150,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(8),
      ),
      child: InkWell(
        onTap: onTap,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 50,
              color: Colors.white,
            ),
            SizedBox(height: 10),
            Text(
              title,
              style: TextStyle(
                fontSize: 18,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
