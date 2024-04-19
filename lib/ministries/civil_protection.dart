import 'dart:async';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class CivilProtection extends StatefulWidget {
  static const String routeName = 'civil-protection';

  @override
  State<CivilProtection> createState() => _CivilProtectionState();
}

class _CivilProtectionState extends State<CivilProtection> {
  late Stream<List<DocumentSnapshot>> carsStream;
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    carsStream = FirebaseFirestore.instance
        .collection('Ministries')
        .doc('CivilProtection')
        .collection('vehicles')
        .snapshots()
        .map((snapshot) => snapshot.docs);
    // Start the timer when the widget initializes
    _timer = Timer.periodic(Duration(seconds: 5), (timer) {
      startMovingNearestCar();
    });
  }

  @override
  void dispose() {
    super.dispose();
    // Dispose the timer when the widget is disposed
    _timer.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xffC40915),
        title: const Center(
          child: Text(
            'Ministry of Civil Protection',
            style: TextStyle(
              color: Colors.white,
            ),
          ),
        ),
      ),
      body: StreamBuilder<List<DocumentSnapshot>>(
        stream: carsStream,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
              child: Text('No data available.'),
            );
          }
          final List<DocumentSnapshot> documents = snapshot.data!;
          final carsLocations = Map.fromIterable(
            documents,
            key: (doc) => LatLng(
              (doc['location'] as GeoPoint).latitude,
              (doc['location'] as GeoPoint).longitude,
            ),
            value: (doc) => doc['plate_number'] as String,
          );
          final emergencyLocation = getEmergencyLocation();
          return Column(
            children: [
              Expanded(
                child: MapScreen(
                  userLocation: const LatLng(29.992017, 31.314806),
                  carsLocations: carsLocations,
                  carIcons: _generateCarIcons(documents),
                  emergencyLocation: emergencyLocation,
                ),
              ),
              const SizedBox(height: 10),
              Expanded(
                child: ListView.builder(
                  itemCount: documents.length + 1,
                  itemBuilder: (context, index) {
                    if (index == 0) {
                      return const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 25),
                        child: Center(
                          child: Text(
                            'Fire Trucks Available',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      );
                    }
                    final plateNumber = documents[index - 1]['plate_number'];
                    final latLng = LatLng(
                      (documents[index - 1]['location'] as GeoPoint).latitude,
                      (documents[index - 1]['location'] as GeoPoint).longitude,
                    );
                    final arrivalTime = calculateArrivalTime(latLng);
                    return Container(
                      margin: const EdgeInsets.symmetric(
                          horizontal: 25, vertical: 5),
                      width: MediaQuery.of(context).size.width,
                      height: 60,
                      child: Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 15),
                            child: Image.asset('assets/firetruck.png'),
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Car ID: $plateNumber',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 14,
                                ),
                              ),
                              Text(
                                'Arrives in $arrivalTime',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xffC40915),
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    minimumSize: Size(double.infinity, 0),
                  ),
                  onPressed: () {
                    // Dispatch Fire Truck logic
                  },
                  child: const Text(
                    'Dispatch Fire Truck',
                    style: TextStyle(
                      fontSize: 17,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  String calculateArrivalTime(LatLng carLocation) {
    final userLocation = const LatLng(29.992017, 31.314806);
    final distance = calculateDistance(userLocation, carLocation);
    final speed = 25; // in km/h
    final time = distance / speed; // in hours
    final minutes = (time * 60).round();
    return '$minutes min';
  }

  double calculateDistance(LatLng start, LatLng end) {
    final earthRadius = 6371; // in kilometers
    final dLat = _toRadians(end.latitude - start.latitude);
    final dLon = _toRadians(end.longitude - start.longitude);
    final a = sin(dLat / 2) * sin(dLat / 2) +
        cos(_toRadians(start.latitude)) *
            cos(_toRadians(end.latitude)) *
            sin(dLon / 2) *
            sin(dLon / 2);
    final c = 2 * asin(sqrt(a));
    return earthRadius * c;
  }

  double _toRadians(double degree) {
    return degree * pi / 180;
  }

  Map<String, Future<BitmapDescriptor>> _generateCarIcons(
      List<DocumentSnapshot> documents) {
    final Map<String, Future<BitmapDescriptor>> carIcons = {};
    for (var doc in documents) {
      final plateNumber = doc['plate_number'] as String;
      carIcons[plateNumber] = Future.value(BitmapDescriptor.fromAssetImage(
        ImageConfiguration.empty,
        "assets/firetruck.png",
      ));
    }
    return carIcons;
  }

  void startMovingNearestCar() async {
    final userLocation = LatLng(29.992017, 31.314806);
    final documents = await FirebaseFirestore.instance
        .collection('Ministries')
        .doc('CivilProtection')
        .collection('vehicles')
        .get()
        .then((querySnapshot) => querySnapshot.docs);

    if (documents.isNotEmpty) {
      double minDistance = double.infinity;
      DocumentSnapshot? nearestCarDoc;

      for (var doc in documents) {
        final carLocation = LatLng(
          (doc['location'] as GeoPoint).latitude,
          (doc['location'] as GeoPoint).longitude,
        );

        final distance = calculateDistance(userLocation, carLocation);
        if (distance < minDistance) {
          minDistance = distance;
          nearestCarDoc = doc;
        }
      }

      if (nearestCarDoc != null) {
        final newLocation = calculateNewLocation(userLocation, nearestCarDoc);
        await FirebaseFirestore.instance
            .collection('Ministries')
            .doc('CivilProtection')
            .collection('vehicles')
            .doc(nearestCarDoc.id)
            .update({
          'location': GeoPoint(newLocation.latitude, newLocation.longitude)
        });
        // Update the UI with the new estimated arrival time
        setState(() {});
      }
    }
  }

  LatLng calculateNewLocation(LatLng userLocation, DocumentSnapshot carDoc) {
    final double distanceFactor =
        0.3005; // Control the movement speed towards the user

    final double latDiff =
        userLocation.latitude - (carDoc['location'] as GeoPoint).latitude;
    final double lonDiff =
        userLocation.longitude - (carDoc['location'] as GeoPoint).longitude;

    final double newLat =
        (carDoc['location'] as GeoPoint).latitude + (latDiff * distanceFactor);
    final double newLon =
        (carDoc['location'] as GeoPoint).longitude + (lonDiff * distanceFactor);

    return LatLng(newLat, newLon);
  }

  LatLng getEmergencyLocation() {
    // Get the emergency location from wherever it's stored
    return LatLng(29.9955, 31.3395); // Example coordinates
  }
}

class MapScreen extends StatefulWidget {
  final LatLng userLocation;
  final Map<LatLng, String> carsLocations;
  final Map<String, Future<BitmapDescriptor>> carIcons;
  final LatLng emergencyLocation;

  const MapScreen({
    required this.userLocation,
    required this.carsLocations,
    required this.carIcons,
    required this.emergencyLocation,
  });

  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  late GoogleMapController mapController;
  Set<Polyline> _polylines = {};

  @override
  Widget build(BuildContext context) {
    return GoogleMap(
      initialCameraPosition: CameraPosition(
        target: widget.userLocation,
        zoom: 12,
      ),
      onMapCreated: (controller) {
        mapController = controller;
      },
      markers: _buildMarkers(),
      polylines: _polylines,
    );
  }

  Future<BitmapDescriptor> _getCarIcon(String plateNumber) async {
    final icon = await widget.carIcons[plateNumber];
    return icon!;
  }

  Set<Marker> _buildMarkers() {
    Set<Marker> markers = {};

    // Add markers for cars
    widget.carsLocations.forEach((location, plateNumber) async {
      final icon = await _getCarIcon(plateNumber);
      markers.add(
        Marker(
          markerId: MarkerId(plateNumber),
          position: location,
          icon: icon,
        ),
      );
    });

    // Add marker for emergency
    markers.add(
      Marker(
        markerId: MarkerId('emergency'),
        position: widget.emergencyLocation,
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
      ),
    );

    return markers;
  }

  void _updatePolylines() {
    Set<Polyline> newPolylines = {};

    // Find the moving car's location
    LatLng? movingCarLocation;
    for (LatLng location in widget.carsLocations.keys) {
      if (widget.carsLocations[location] == 'moving_car') {
        movingCarLocation = location;
        break;
      }
    }

    // Draw polyline from moving car to emergency location if the moving car's location is available
    if (movingCarLocation != null) {
      newPolylines.add(
        Polyline(
          polylineId: PolylineId('moving_car_polyline'),
          points: [movingCarLocation, widget.emergencyLocation],
          color: Colors.red,
          width: 2,
        ),
      );
    }

    setState(() {
      _polylines = newPolylines;
    });
  }

  @override
  void didUpdateWidget(covariant MapScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    _updatePolylines();
  }
}
