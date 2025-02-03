import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart' as maps;
import 'dart:io' show Platform;
import 'package:flutter/foundation.dart' show kIsWeb;

class MapView extends StatefulWidget {
  const MapView({super.key});

  @override
  _MapViewState createState() => _MapViewState();
}

class _MapViewState extends State<MapView> {
  late maps.GoogleMapController _mapController;
  final Set<maps.Marker> _markers = {};

  @override
  void initState() {
    super.initState();
    _initializeMap();
  }

  void _initializeMap() {
    if (kIsWeb) {
      print("Executando no Web. Google Maps será carregado automaticamente.");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Mapa")),
      body: maps.GoogleMap(
        initialCameraPosition: const maps.CameraPosition(
          target: maps.LatLng(-23.55052, -46.633308), // São Paulo
          zoom: 10,
        ),
        markers: _markers,
        onMapCreated: (maps.GoogleMapController controller) {
          _mapController = controller;
        },
      ),
    );
  }
}
