import 'package:flutter/material.dart';
import '../views/driver_profile.dart';
import '../views/add_trip_page.dart';
import '../views/driver_requests_page.dart';
import '../views/done_trips_page.dart';

class DriverDashboardController {
  void handleAddTripTap(BuildContext context) {
    // Navigate to the AddTrip page
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => AddTripPage()),
    );
  }

  void handleProfileTap(BuildContext context) {
    // Navigate to the DriverProfile page
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => DriverProfileView()),
    );
  }

  void handleTripRequestsTap(BuildContext context) {
    // Navigate to the DriverRequestPage for managing trip requests
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => DriverRequestsPage()),
    );
  }

  void handleDoneTripsTap(BuildContext context) {
    // Navigate to the DriverRequestPage for managing trip requests
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => DoneTripsPage()),
    );
  }
}
