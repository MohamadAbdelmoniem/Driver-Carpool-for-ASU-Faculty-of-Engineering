import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/driver_profile_model.dart';

class DoneTripsPage extends StatefulWidget {
  @override
  _DoneTripsPageState createState() => _DoneTripsPageState();
}

class _DoneTripsPageState extends State<DoneTripsPage> {
  final CollectionReference requests =
      FirebaseFirestore.instance.collection('requests');
  final CollectionReference trips =
      FirebaseFirestore.instance.collection('trips');
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
        title: Text('Done Trips'),
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

                return FutureBuilder<QuerySnapshot>(
                  future: requests
                      .where('status', whereIn: ['pending', 'accepted']).get(),
                  builder: (context, requestSnapshot) {
                    if (!requestSnapshot.hasData) {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    }

                    List<DocumentSnapshot> requestDocuments =
                        requestSnapshot.data!.docs;

                    if (requestDocuments.isEmpty) {
                      return Center(
                        child: Text('No pending trips found.'),
                      );
                    }

                    List<DocumentSnapshot> pendingTrips =
                        tripDocuments.where((trip) {
                      return requestDocuments
                          .where((request) => request['tripId'] == trip.id)
                          .isNotEmpty;
                    }).toList();

                    if (pendingTrips.isEmpty) {
                      return Center(
                        child: Text('No pending trips found.'),
                      );
                    }

                    return ListView.builder(
                      itemCount: pendingTrips.length,
                      itemBuilder: (context, index) {
                        DocumentSnapshot trip = pendingTrips[index];
                        return _buildPendingTripCard(trip);
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

  Widget _buildPendingTripCard(DocumentSnapshot trip) {
    return Card(
      margin: EdgeInsets.all(10.0),
      elevation: 8.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      color: Colors.white,
      child: Container(
        padding: EdgeInsets.all(15.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ListTile(
              title: Row(
                children: [
                  Icon(Icons.location_on, color: Colors.blue),
                  SizedBox(width: 8.0),
                  Text(
                    '${trip['from']} → ${trip['to']}',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
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
            SizedBox(height: 15.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton.icon(
                  onPressed: () {
                    _completeTrip(trip.id);
                  },
                  icon: Icon(Icons.check, color: Colors.white),
                  label: Text(
                    'Mark as Done',
                    style: TextStyle(color: Colors.white),
                  ),
                  style: ElevatedButton.styleFrom(
                    primary: Colors.green,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _completeTrip(String tripId) async {
    try {
      await requests
          .where('tripId', isEqualTo: tripId)
          .get()
          .then((querySnapshot) {
        querySnapshot.docs.forEach((doc) {
          String requestStatus = doc['status'];
          if (requestStatus == 'rejected') {
            requests.doc(doc.id).update({'status': 'canceled by driver'});
          } else {
            requests.doc(doc.id).update({'status': 'done'});
          }
          setState(() {});
        });
      });
    } catch (e) {
      print('Error completing trip: $e');
    }
  }
}
