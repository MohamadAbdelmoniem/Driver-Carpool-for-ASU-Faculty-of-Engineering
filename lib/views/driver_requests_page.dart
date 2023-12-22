import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/driver_profile_model.dart';

class DriverRequestsPage extends StatefulWidget {
  @override
  _DriverRequestsPageState createState() => _DriverRequestsPageState();
}

class _DriverRequestsPageState extends State<DriverRequestsPage> {
  final CollectionReference trips =
      FirebaseFirestore.instance.collection('trips');
  final CollectionReference requests =
      FirebaseFirestore.instance.collection('requests');
  final CollectionReference users =
      FirebaseFirestore.instance.collection('users');
  late DriverProfileModel _profileModel;

  @override
  void initState() {
    super.initState();
    _profileModel = DriverProfileModel();
    _loadDriverData();
  }

  Future<void> _loadDriverData() async {
    try {
      await _profileModel.loadUserData();
    } catch (e) {
      print('Error loading driver data: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Driver Requests'),
        backgroundColor: Color(0xFF607D8B),
      ),
      body: SafeArea(
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF607D8B), Color(0xFF455A64)],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: RefreshIndicator(
            onRefresh: () async {
              await _loadDriverData();
              setState(() {});
            },
            child: StreamBuilder<QuerySnapshot>(
              stream: trips
                  .where('driverId', isEqualTo: _profileModel.getUserId())
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }

                List<DocumentSnapshot> tripDocuments = snapshot.data!.docs;

                if (tripDocuments.isEmpty) {
                  return Center(
                    child: Text('No requests found.'),
                  );
                }

                return FutureBuilder<bool>(
                  future: _checkForPendingRequests(tripDocuments),
                  builder: (context, hasPendingRequestsSnapshot) {
                    if (!hasPendingRequestsSnapshot.hasData ||
                        !hasPendingRequestsSnapshot.data!) {
                      return Center(
                        child: Text('No pending requests for any trip.'),
                      );
                    }

                    return ListView.builder(
                      itemCount: tripDocuments.length,
                      itemBuilder: (context, index) {
                        DocumentSnapshot trip = tripDocuments[index];
                        return _buildTripRequestCard(trip);
                      },
                    );
                  },
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  Future<bool> _checkForPendingRequests(
      List<DocumentSnapshot> tripDocuments) async {
    for (var trip in tripDocuments) {
      bool hasPendingRequests = await requests
          .where('tripId', isEqualTo: trip.id)
          .where('status', isEqualTo: 'pending')
          .get()
          .then((snapshot) => snapshot.docs.isNotEmpty);

      if (hasPendingRequests) {
        return true;
      }
    }

    return false;
  }

  Widget _buildTripRequestCard(DocumentSnapshot trip) {
    return FutureBuilder<QuerySnapshot>(
      future: requests
          .where('tripId', isEqualTo: trip.id)
          .where('status', isEqualTo: 'pending')
          .get(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(child: CircularProgressIndicator());
        }
        var requestDocuments = snapshot.data!.docs;

        return Column(
          children: requestDocuments.map((DocumentSnapshot requestDoc) {
            String requestId = requestDoc.id;
            String userId = requestDoc['userId'];
            return FutureBuilder<DocumentSnapshot>(
              future: users.doc(userId).get(),
              builder: (context, userSnapshot) {
                if (!userSnapshot.hasData) {
                  return Center(child: CircularProgressIndicator());
                }

                String firstName = userSnapshot.data!['firstName'];
                String lastName = userSnapshot.data!['lastName'];
                return Card(
                  margin: EdgeInsets.all(5.0),
                  elevation: 8.0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  color: Colors.white,
                  child: Container(
                    constraints: BoxConstraints(maxWidth: 300.0),
                    child: Padding(
                      padding: EdgeInsets.all(5.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ListTile(
                            title: Row(
                              children: [
                                Icon(Icons.location_on, color: Colors.blue),
                                SizedBox(width: 8.0),
                                Expanded(
                                  child: Text(
                                    '${trip['from']} → ${trip['to']}',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          ListTile(
                            title: Row(
                              children: [
                                Icon(Icons.date_range, color: Colors.green),
                                SizedBox(width: 8.0),
                                Text('Date: ${trip['date']}'),
                              ],
                            ),
                          ),
                          ListTile(
                            title: Row(
                              children: [
                                Icon(Icons.access_time, color: Colors.orange),
                                SizedBox(width: 8.0),
                                Text('Time: ${trip['time']}'),
                              ],
                            ),
                          ),
                          ListTile(
                            title: Row(
                              children: [
                                Icon(Icons.person, color: Colors.purple),
                                SizedBox(width: 8.0),
                                Text(
                                  '$firstName $lastName',
                                  style: TextStyle(
                                    color: Colors.grey[700],
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 5.0),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              IconButton(
                                icon: Icon(Icons.check_circle,
                                    color: Colors.green, size: 25),
                                onPressed: () {
                                  _acceptRequest(requestId);
                                },
                              ),
                              SizedBox(width: 10),
                              IconButton(
                                icon: Icon(Icons.cancel,
                                    color: Colors.red, size: 25),
                                onPressed: () {
                                  _rejectRequest(requestId);
                                },
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          }).toList(),
        );
      },
    );
  }

  Future<void> _updateRequestStatus(String requestId, String status) async {
    try {
      await requests.doc(requestId).update({'status': status});
      setState(() {});
    } catch (e) {
      print('Error updating request status: $e');
    }
  }

  Future<void> _acceptRequest(String requestId) async {
    await _updateRequestStatus(requestId, 'accepted');
  }

  Future<void> _rejectRequest(String requestId) async {
    // Get the trip ID associated with the rejected request
    String tripId = await requests.doc(requestId).get().then((snapshot) {
      return snapshot['tripId'];
    });

    // Increment the number of available seats for the trip
    await _incrementAvailableSeats(tripId);

    // Update the request status to 'rejected'
    await _updateRequestStatus(requestId, 'rejected');
  }

  Future<void> _incrementAvailableSeats(String tripId) async {
    try {
      // Get the current number of available seats for the trip
      int currentAvailableSeats =
          await trips.doc(tripId).get().then((snapshot) {
        return snapshot['availableSeats'];
      });

      // Increment the number of available seats by 1
      int newAvailableSeats = currentAvailableSeats + 1;

      // Update the available seats in the trips collection
      await trips.doc(tripId).update({'availableSeats': newAvailableSeats});
    } catch (e) {
      print('Error incrementing available seats: $e');
    }
  }
}
