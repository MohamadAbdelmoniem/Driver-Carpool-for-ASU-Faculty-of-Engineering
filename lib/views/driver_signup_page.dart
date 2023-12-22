import 'package:flutter/material.dart';
import '../controllers/driver_auth_controller.dart';

class DriverSignUpPage extends StatefulWidget {
  @override
  _DriverSignUpPageState createState() => _DriverSignUpPageState();
}

class _DriverSignUpPageState extends State<DriverSignUpPage> {
  final DriverAuthController _driverAuthController = DriverAuthController();
  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  TextEditingController mobileNumberController = TextEditingController();

  bool isEmailValid = true;

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        title: Text('Driver Sign Up'),
        backgroundColor: Color(0xFF607D8B),
        elevation: 0,
        centerTitle: true,
      ),
      body: SafeArea(
        child: Container(
          height: screenHeight,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF607D8B), Color(0xFF455A64)],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(height: 20),
                  _buildTextField(
                    controller: firstNameController,
                    label: 'First Name',
                    icon: Icons.person,
                  ),
                  SizedBox(height: 12),
                  _buildTextField(
                    controller: lastNameController,
                    label: 'Last Name',
                    icon: Icons.person,
                  ),
                  SizedBox(height: 12),
                  _buildTextField(
                    controller: emailController,
                    label: 'Email',
                    icon: Icons.email,
                    isEmail: true,
                    errorText: isEmailValid ? null : 'Invalid email address',
                  ),
                  SizedBox(height: 12),
                  _buildTextField(
                    controller: mobileNumberController,
                    label: 'Mobile Number',
                    icon: Icons.phone,
                    keyboardType: TextInputType.phone,
                  ),
                  SizedBox(height: 12),
                  _buildTextField(
                    controller: passwordController,
                    label: 'Password',
                    icon: Icons.lock,
                    isPassword: true,
                  ),
                  SizedBox(height: 12),
                  _buildTextField(
                    controller: confirmPasswordController,
                    label: 'Confirm Password',
                    icon: Icons.lock,
                    isPassword: true,
                  ),
                  SizedBox(height: 32),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      primary: Color(0xFF78909C),
                      padding:
                          EdgeInsets.symmetric(horizontal: 40, vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    onPressed: () async {
                      String firstName = firstNameController.text;
                      String lastName = lastNameController.text;
                      String email = emailController.text;
                      String mobileNumber = mobileNumberController.text;
                      String password = passwordController.text;
                      String confirmPassword = confirmPasswordController.text;

                      // Validate the email format using the model
                      bool validEmail =
                          _driverAuthController.isValidEmail(email);

                      setState(() {
                        isEmailValid = validEmail;
                      });

                      if (firstName.isNotEmpty &&
                          lastName.isNotEmpty &&
                          validEmail &&
                          mobileNumber.isNotEmpty &&
                          password.isNotEmpty &&
                          confirmPassword.isNotEmpty &&
                          password == confirmPassword) {
                        try {
                          await _driverAuthController
                              .signUpWithEmailAndPassword(
                            email,
                            password,
                            firstName,
                            lastName,
                            mobileNumber,
                            context,
                          );

                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: Text('Success'),
                                content: Text('Signup completed successfully!'),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                      Navigator.pop(context);
                                    },
                                    child: Text('OK'),
                                  ),
                                ],
                              );
                            },
                          );
                        } on Exception catch (e) {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: Text('Error'),
                                content: Text(e.toString()),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                    child: Text('OK'),
                                  ),
                                ],
                              );
                            },
                          );
                        }
                      } else {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: Text('Error'),
                              content:
                                  Text('Please fill in all fields correctly'),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: Text('OK'),
                                ),
                              ],
                            );
                          },
                        );
                      }
                    },
                    child: Text(
                      'Sign Up',
                      style: TextStyle(fontSize: 16, color: Colors.white),
                    ),
                  ),
                  SizedBox(height: 16),
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text(
                      'Already have a driver account? Log In',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    bool isEmail = false,
    bool isPassword = false,
    TextInputType? keyboardType,
    String? errorText,
  }) {
    return TextField(
      controller: controller,
      style: TextStyle(color: Colors.white),
      keyboardType: keyboardType ??
          (isEmail ? TextInputType.emailAddress : TextInputType.text),
      obscureText: isPassword,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: Colors.white),
        errorText: isEmailValid ? null : errorText,
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.white),
          borderRadius: BorderRadius.circular(8),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.white),
          borderRadius: BorderRadius.circular(8),
        ),
        prefixIcon: Icon(icon, color: Colors.white),
      ),
    );
  }
}
