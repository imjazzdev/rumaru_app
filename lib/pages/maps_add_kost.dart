import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../utils/utils.dart';

class MapSample extends StatefulWidget {
  const MapSample({super.key});

  @override
  State<MapSample> createState() => MapSampleState();
}

class MapSampleState extends State<MapSample> {
  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();

  static const CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(1.1455625, 104.0136126),
    zoom: 17.4746,
  );

  List<Marker> marker = [
    Marker(
        markerId: MarkerId('1'),
        position: LatLng(1.1455625, 104.0136126),
        draggable: true,
        onDragEnd: (newPosition) {
          Utils.lokasi_latitude = newPosition.latitude;
          Utils.lokasi_longitude = newPosition.longitude;
        })
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GoogleMap(
        mapType: MapType.hybrid,
        markers: marker.toSet(),
        initialCameraPosition: _kGooglePlex,
        onMapCreated: (GoogleMapController controller) {
          _controller.complete(controller);
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Utils.isMap = true;

          Navigator.pop(context);
        },
        child: Icon(Icons.done_rounded),
      ),
    );
  }
}
