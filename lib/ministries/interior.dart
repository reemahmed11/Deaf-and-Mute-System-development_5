import 'dart:math' show asin, cos, pi, sin, sqrt;

import 'package:deaf_mute_system/ministries/maps.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class InteriorScreen extends StatefulWidget {
  static const String routeName = 'interior-screen';

  @override
  State<InteriorScreen> createState() => _InteriorScreenState();
}

class _InteriorScreenState extends State<InteriorScreen> {
  late Stream<List<DocumentSnapshot>> carsStream;

  @override
  void initState() {
    super.initState();
    carsStream = FirebaseFirestore.instance
        .collection('Ministries')
        .doc('Interior')
        .collection('vehicles')
        .snapshots()
        .map((snapshot) => snapshot.docs);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xffC40915),
        title: const Center(
          child: Text(
            'Ministry of Interior',
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
              doc['location'].latitude as double,
              doc['location'].longitude as double,
            ),
            value: (doc) => doc['plate_number'] as String,
          );
          return Column(
            children: [
              Expanded(
                child: MapScreen(
                  userLocation: const LatLng(29.992017, 31.314806),
                  carsLocations: carsLocations,
                  carIcons: _generateCarIcons(documents),
                  carPolylines: {},
                ),
              ),
              const SizedBox(height: 10),
              Expanded(
                child: ListView.builder(
                  itemCount:
                      documents.length + 1, // +1 for the police available text
                  itemBuilder: (context, index) {
                    if (index == 0) {
                      return const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 25),
                        child: Center(
                          child: Text(
                            'Police Available',
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
                      documents[index - 1]['location'].latitude as double,
                      documents[index - 1]['location'].longitude as double,
                    );
                    return Container(
                      margin: const EdgeInsets.symmetric(
                          horizontal: 25, vertical: 5),
                      width: MediaQuery.of(context).size.width,
                      height: 60,
                      child: Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 15),
                            child: Image.asset('assets/policecar.png'),
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
                                'Arrives in ${calculateArrivalTime(latLng)}',
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
                    // اترك هذا المكان لتحديد ما سيحدث عند الضغط على الزر
                  },
                  child: const Text(
                    'Dispatch Car',
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
        "assets/policecar.png",
      ));
    }
    return carIcons;
  }
}
