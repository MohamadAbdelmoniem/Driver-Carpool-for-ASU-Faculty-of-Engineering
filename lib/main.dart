import 'package:flutter/material.dart';
import 'views/driver_dashboard.dart';
import 'views/driver_login_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: '/driver_login', // Set the initial route
      routes: {
        '/driver_login': (context) => DriverLoginPage(),
        '/driver_dashboard': (context) => DriverDashboard(),
      },
    );
  }
}
