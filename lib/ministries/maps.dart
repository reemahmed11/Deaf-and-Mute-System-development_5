import 'dart:math' show atan2, cos, pi, pow, sin, sqrt;
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';

class MapScreen extends StatefulWidget {
  final LatLng userLocation;
  final Map<LatLng, String> carsLocations;
  final Map<String, Future<BitmapDescriptor>> carIcons;

  const MapScreen({
    Key? key,
    required this.userLocation,
    required this.carsLocations,
    required this.carIcons,
    required Map<String, Polyline> carPolylines,
  }) : super(key: key);

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  Set<Marker> myMarkers = {};
  Map<PolylineId, Polyline> polylines = {};

  static const double averageSpeedKmPerHour = 40.0;

  double calculateDistance(LatLng point1, LatLng point2) {
    const R = 6371.0; // Radius of the Earth in km

    double dLat = (point2.latitude - point1.latitude) * (pi / 180);
    double dLon = (point2.longitude - point1.longitude) * (pi / 180);
    double lat1 = point1.latitude * (pi / 180);
    double lat2 = point2.latitude * (pi / 180);

    double a = sin(dLat / 2) * sin(dLat / 2) +
        cos(lat1) * cos(lat2) * sin(dLon / 2) * sin(dLon / 2);
    double c = 2 * atan2(sqrt(a), sqrt(1 - a));
    double distance = R * c; // Distance in km
    return distance;
  }

  @override
  void initState() {
    super.initState();
    initializeMarkers();
    getPolyline();
  }

  Future<void> initializeMarkers() async {
    myMarkers.clear();
    myMarkers.add(
      Marker(
        markerId: const MarkerId('user'),
        position: widget.userLocation,
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueAzure),
        infoWindow: const InfoWindow(title: "Your Location"),
      ),
    );

    for (MapEntry<LatLng, String> entry in widget.carsLocations.entries) {
      final icon =
          await widget.carIcons[entry.value] ?? BitmapDescriptor.defaultMarker;
      myMarkers.add(
        Marker(
          markerId: MarkerId(entry.value),
          position: entry.key,
          icon: icon,
          infoWindow: InfoWindow(title: "Car ID: ${entry.value}"),
        ),
      );
    }

    setState(() {});
  }

  Future<void> getPolyline() async {
    polylines.clear(); // Clear existing polylines
    for (MapEntry<LatLng, String> entry in widget.carsLocations.entries) {
      List<LatLng> routeCoords = [widget.userLocation, entry.key];
      addPolyLine(routeCoords, entry.value);
    }
  }

  void addPolyLine(List<LatLng> polylineCoordinates, String id) {
    PolylineId polyId = PolylineId(id);
    Polyline polyline = Polyline(
      polylineId: polyId,
      color: Colors.blue,
      points: polylineCoordinates,
      width: 5,
      onTap: () {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Car ID: $id")),
        );
      },
    );
    polylines[polyId] = polyline;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GoogleMap(
        initialCameraPosition: CameraPosition(
          target: widget.userLocation,
          zoom: 14.0,
        ),
        markers: myMarkers,
        polylines: Set<Polyline>.of(polylines.values),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: getPolyline,
        tooltip: 'Draw Polylines',
        child: const Icon(Icons.map),
      ),
    );
  }
}
