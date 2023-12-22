import 'package:flutter/material.dart';
import '../models/driver_profile_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AddTripPage extends StatefulWidget {
  @override
  _AddTripPageState createState() => _AddTripPageState();
}

class _AddTripPageState extends State<AddTripPage> {
  late String selectedFrom;
  late String selectedTo;
  late String selectedTime;
  late int selectedGate;
  late int availableSeats;
  late int price;
  TextEditingController dateController = TextEditingController();
  late DriverProfileModel _profileModel;
  late bool isTimeFieldLocked;

  @override
  void initState() {
    super.initState();
    selectedFrom = '';
    selectedTo = '';
    selectedTime = '';
    selectedGate = 2;
    availableSeats = 1;
    price = 0;
    dateController = TextEditingController();
    _profileModel = DriverProfileModel();
    isTimeFieldLocked = false;
    _profileModel.loadUserData();
  }

  Future<void> _addTripToFirestore() async {
    try {
      String firstName = _profileModel.getFirstName();
      String lastName = _profileModel.getLastName();
      String driverId = _profileModel.getUserId();

      CollectionReference trips =
          FirebaseFirestore.instance.collection('trips');

      DocumentReference tripDocRef = await trips.add({
        'from': selectedFrom,
        'to': selectedTo,
        'date': dateController.text,
        'time': selectedTime,
        'gate': selectedGate,
        'availableSeats': availableSeats,
        'price': price,
        'driverName': '$firstName $lastName',
        'driverId': driverId,
      });

      String tripId = tripDocRef.id;

      await tripDocRef.update({'tripId': tripId});

      print('Trip added successfully with ID: $tripId');
    } catch (e) {
      print('Error adding trip to Firestore: $e');
      _showErrorDialog('Error adding trip to Firestore', 'Error');
    }
  }

  void _showErrorDialog(String message, String title) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(message),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text('Add Trip'),
        backgroundColor: Color(0xFF607D8B),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 80.0),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF607D8B), Color(0xFF455A64)],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildDropdown(
                label: 'From',
                items: [
                  'Nasr City',
                  'Heliopolis',
                  '5th Settlement New Cairo',
                  'Maadi',
                  'Mokattam',
                  'Abdo Basha',
                ],
                onChanged: (value) {
                  setState(() {
                    selectedFrom = value.toString();
                    isTimeFieldLocked = selectedFrom == 'Abdo Basha';
                    if (isTimeFieldLocked) {
                      selectedTime = '05:30 PM';
                    }
                  });
                },
                icon: Icons.location_on,
              ),
              SizedBox(height: 12),
              _buildDropdown(
                label: 'To',
                items: [
                  'Nasr City',
                  'Heliopolis',
                  '5th Settlement New Cairo',
                  'Maadi',
                  'Mokattam',
                  'Abdo Basha',
                ],
                onChanged: (value) {
                  setState(() {
                    selectedTo = value.toString();
                    isTimeFieldLocked = selectedTo == 'Abdo Basha';
                    if (isTimeFieldLocked) {
                      selectedTime = '07:30 AM';
                    }
                  });
                },
                icon: Icons.location_on,
              ),
              SizedBox(height: 12),
              _buildDateField(
                label: 'Date',
              ),
              SizedBox(height: 12),
              _buildDropdown(
                label: 'Time',
                items: ['07:30 AM', '05:30 PM'],
                onChanged: (value) {
                  setState(() {
                    if (!isTimeFieldLocked) {
                      selectedTime = value.toString();
                    }
                  });
                },
                icon: Icons.access_time,
              ),
              SizedBox(height: 12),
              _buildDropdown(
                label: 'Gate',
                items: ['2', '3'],
                onChanged: (value) {
                  setState(() {
                    selectedGate = int.parse(value);
                  });
                },
                icon: Icons.location_on,
              ),
              SizedBox(height: 12),
              _buildDropdown(
                label: 'Available Seats',
                items: ['1', '2', '3', '4'],
                onChanged: (value) {
                  setState(() {
                    availableSeats = int.parse(value);
                  });
                },
                icon: Icons.event_seat,
              ),
              SizedBox(height: 12),
              _buildTextField(
                label: 'Price',
                icon: Icons.attach_money,
                keyboardType: TextInputType.number,
                onChanged: (value) {
                  setState(() {
                    price = int.parse(value);
                  });
                },
              ),
              SizedBox(height: 32),
              Center(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF78909C),
                    padding: EdgeInsets.symmetric(horizontal: 40, vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onPressed: () {
                    if (selectedFrom != 'Abdo Basha' &&
                        selectedTo != 'Abdo Basha') {
                      _showErrorDialog('Trip must start or end at Abdo Basha',
                          'Invalid Trip');
                    }
                    if (selectedFrom == selectedTo) {
                      _showErrorDialog(
                          'Trip cannot start and end at the same place',
                          'Invalid Trip');
                    } else {
                      _addTripToFirestore();
                      _showErrorDialog('Trip Added Successfully', 'Success');
                    }
                  },
                  child: Text(
                    'Add Trip',
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDropdown({
    required String label,
    required List<String> items,
    required void Function(dynamic) onChanged,
    required IconData icon,
  }) {
    return label == 'Time'
        ? TextFormField(
            readOnly: true,
            controller: TextEditingController(text: selectedTime),
            decoration: InputDecoration(
              labelText: label,
              labelStyle: TextStyle(color: Colors.black),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.black),
                borderRadius: BorderRadius.circular(8),
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.black),
                borderRadius: BorderRadius.circular(8),
              ),
              prefixIcon: Icon(icon, color: Colors.black),
            ),
          )
        : DropdownButtonFormField(
            decoration: InputDecoration(
              labelText: label,
              labelStyle: TextStyle(color: Colors.black),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.black),
                borderRadius: BorderRadius.circular(8),
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.black),
                borderRadius: BorderRadius.circular(8),
              ),
              prefixIcon: Icon(icon, color: Colors.black),
            ),
            items: items.map((item) {
              return DropdownMenuItem(
                value: item,
                child: Text(
                  item,
                  style: TextStyle(color: Colors.black),
                ),
              );
            }).toList(),
            onChanged: (value) {
              setState(() {
                if (label == 'From') {
                  selectedFrom = value.toString();
                  if (selectedFrom == 'Abdo Basha') {
                    selectedTime = '05:30 PM';
                  }
                } else if (label == 'To') {
                  selectedTo = value.toString();
                  if (selectedTo == 'Abdo Basha') {
                    selectedTime = '07:30 AM';
                  }
                }
              });
              onChanged(value);
            },
          );
  }

  Widget _buildDateField({required String label}) {
    return TextField(
      controller: dateController,
      readOnly: true,
      onTap: () async {
        DateTime? selectedDate = await showDatePicker(
          context: context,
          initialDate: DateTime.now(),
          firstDate: DateTime.now(),
          lastDate: DateTime(2101),
        );

        if (selectedDate != null && selectedDate != DateTime.now()) {
          dateController.text = selectedDate.toLocal().toString().split(' ')[0];
        }
      },
      style: TextStyle(color: Colors.black),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: Colors.black),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.black),
          borderRadius: BorderRadius.circular(8),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.black),
          borderRadius: BorderRadius.circular(8),
        ),
        prefixIcon: Icon(Icons.calendar_today, color: Colors.black),
      ),
    );
  }

  Widget _buildTextField({
    required String label,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
    required void Function(String) onChanged,
  }) {
    return TextField(
      style: TextStyle(color: Colors.black),
      keyboardType: keyboardType,
      onChanged: onChanged,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: Colors.black),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.black),
          borderRadius: BorderRadius.circular(8),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.black),
          borderRadius: BorderRadius.circular(8),
        ),
        prefixIcon: Icon(icon, color: Colors.black),
      ),
    );
  }
}
