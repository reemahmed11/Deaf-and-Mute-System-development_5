import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ClerkScreen extends StatefulWidget {
  static const String routeName = 'map';

  const ClerkScreen({Key? key}) : super(key: key);

  @override
  State<ClerkScreen> createState() => _ClerkScreenState();
}

class _ClerkScreenState extends State<ClerkScreen> {
  CameraPosition routeCameraPosition = const CameraPosition(
    target: LatLng(29.992017, 31.314806),
    zoom: 15,
  );

  Set<Marker> myMarker = {};
  LatLng? selectedMarkerPosition; // Variable to store selected marker position

  CollectionReference emergencyCollection =
      FirebaseFirestore.instance.collection('Emergency');

  @override
  void initState() {
    fetchEmergencyLocations();
    super.initState();
  }

  Future<void> fetchEmergencyLocations() async {
    QuerySnapshot emergencySnapshot =
        await emergencyCollection.orderBy('timestamp', descending: true).get();

    for (QueryDocumentSnapshot document in emergencySnapshot.docs) {
      double latitude = document['latitude'];
      double longitude = document['longitude'];

      // Use document ID as marker ID
      String markerId = document.id;

      myMarker.add(
        Marker(
          markerId: MarkerId(markerId),
          position: LatLng(latitude, longitude),
          icon: BitmapDescriptor.defaultMarker,
          infoWindow: InfoWindow(title: "Emergency $markerId"),
          onTap: () {
            _handleMarkerTap(LatLng(latitude, longitude));
          },
        ),
      );
    }

    setState(() {
      // Trigger a rebuild to update the map with the new markers
    });
  }

  void _handleMarkerTap(LatLng position) {
    // Store the selected marker's position
    setState(() {
      selectedMarkerPosition = position;
    });
  }

  Future<void> _reportEmergency(String ministry, String userId) async {
    if (selectedMarkerPosition != null) {
      LatLng position = selectedMarkerPosition!;

      // Find the emergency document corresponding to the selected marker
      QuerySnapshot querySnapshot = await emergencyCollection
          .where('latitude', isEqualTo: position.latitude)
          .where('longitude', isEqualTo: position.longitude)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        // Get the reference to the emergency document
        DocumentSnapshot emergencyDoc = querySnapshot.docs.first;
        DocumentReference emergencyRef = emergencyDoc.reference;

        // Add the emergency details to the Emergency_history collection
        await FirebaseFirestore.instance.collection('Emergency_history').add({
          'emergencyId': emergencyDoc.id, // Include the ID of the emergency
          'latitude': position.latitude,
          'longitude': position.longitude,
          'ministry': ministry,
          'userId': userId, // Include the userId
          'timestamp': FieldValue.serverTimestamp(),
        });

        // Delete the emergency document from the Emergency collection
        await emergencyRef.delete();

        // Remove the selected marker from the map
        myMarker.removeWhere((marker) => marker.position == position);

        // Clear selected marker position
        setState(() {
          selectedMarkerPosition = null;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xffC40915),
        title: const Center(
          child: Text(
            'Clerk',
            style: TextStyle(color: Colors.white),
          ),
        ),
      ),
      body: Column(
        children: [
          SizedBox(
            height: 300,
            child: GoogleMap(
              initialCameraPosition: routeCameraPosition,
              markers: myMarker,
              mapType: MapType.normal,
              onTap: (position) {
                // Clear selected marker position when the map is tapped
                setState(() {
                  selectedMarkerPosition = null;
                });
              },
            ),
          ),
          const SizedBox(height: 20),
          Expanded(
            child: Column(
              children: [
                const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.arrow_drop_down),
                    SizedBox(
                      width: 15,
                    ),
                    Text(
                      'Emergencies',
                      style:
                          TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                const SizedBox(height: 30),
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 25),
                  width: MediaQuery.of(context).size.width,
                  height: 40,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xffC40915),
                    ),
                    onPressed: () {
                      _reportEmergency('NAS', 'userId');
                    },
                    child: const Text(
                      'Report To NAS',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 15),
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 25),
                  width: MediaQuery.of(context).size.width,
                  height: 40,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xffC40915),
                    ),
                    onPressed: () {
                      _reportEmergency('Ministry of Health', 'userId');
                    },
                    child: const Text(
                      'Report To Ministry of Health',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 15),
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 25),
                  width: MediaQuery.of(context).size.width,
                  height: 40,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xffC40915),
                    ),
                    onPressed: () {
                      _reportEmergency('Ministry of Interior', 'userId');
                    },
                    child: const Text(
                      'Report To Ministry of Interior',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 15),
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 25),
                  width: MediaQuery.of(context).size.width,
                  height: 40,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xffC40915),
                    ),
                    onPressed: () {
                      _reportEmergency(
                          'Ministry of Civil Protection', 'userId');
                    },
                    child: const Text(
                      'Report To Ministry of Civil Protection',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
