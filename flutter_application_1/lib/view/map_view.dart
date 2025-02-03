import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';

import '../database/database_helper.dart';
import '../model/contact.dart';

class MapView extends StatefulWidget {
  const MapView({super.key});

  @override
  _MapViewState createState() => _MapViewState();
}

class _MapViewState extends State<MapView> {
  GoogleMapController? _mapController;
  LatLng? _currentPosition;
  List<Contact> _contacts = [];
  Set<Marker> _markers = {};
  bool _isDrawerOpen = false;
  bool _loadingLocation = true; // Adicionado para controlar o carregamento

  @override
  void initState() {
    super.initState();
    _getUserLocation();
  }

  /// Obtém a posição atual do usuário
  Future<void> _getUserLocation() async {
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Ative o GPS para usar o mapa.')),
        );
        return;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.deniedForever) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Permissão de localização negada permanentemente.')),
          );
          return;
        }
      }

      Position position = await Geolocator.getCurrentPosition();
      setState(() {
        _currentPosition = LatLng(position.latitude, position.longitude);
        _loadingLocation = false;
      });

      _loadContacts(); // Carrega os contatos após obter a localização

    } catch (e) {
      setState(() {
        _loadingLocation = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Erro ao obter localização.')),
      );
    }
  }

  /// Carrega os contatos do banco e adiciona marcadores no mapa
  Future<void> _loadContacts() async {
    List<Contact> contacts = await DatabaseHelper.instance.getAllContacts();
    Set<Marker> markers = {};

    for (var contact in contacts) {
      markers.add(
        Marker(
          markerId: MarkerId(contact.id.toString()),
          position: LatLng(contact.latitude, contact.longitude),
          infoWindow: InfoWindow(title: contact.name),
        ),
      );
    }

    setState(() {
      _contacts = contacts;
      _markers = markers;
    });
  }

  /// Move a câmera para a posição do contato selecionado
  void _goToContact(Contact contact) {
    _mapController?.animateCamera(
      CameraUpdate.newLatLng(LatLng(contact.latitude, contact.longitude)),
    );
    setState(() {
      _isDrawerOpen = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.amber,
        title: const Text(
          "App de Contatos",
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
        ),
        centerTitle: true,
      ),
      body: _loadingLocation
          ? const Center(child: CircularProgressIndicator()) // Exibe um loading enquanto busca a localização
          : Stack(
              children: [
                GoogleMap(
                  initialCameraPosition: CameraPosition(
                    target: _currentPosition ?? const LatLng(-15.793889, -47.882778), // Se falhar, usa Brasília
                    zoom: 14.0,
                  ),
                  onMapCreated: (GoogleMapController controller) {
                    _mapController = controller;
                    if (_currentPosition != null) {
                      _mapController!.animateCamera(CameraUpdate.newLatLng(_currentPosition!));
                    }
                  },
                  markers: _markers,
                  myLocationEnabled: true,
                ),

                // Botão para abrir a lista de contatos
                Positioned(
                  top: 40,
                  left: 10,
                  child: FloatingActionButton(
                    backgroundColor: Colors.amber,
                    onPressed: () {
                      setState(() {
                        _isDrawerOpen = !_isDrawerOpen;
                      });
                    },
                    child: const Icon(Icons.contacts, color: Colors.black),
                  ),
                ),

                // Lista lateral de contatos
                if (_isDrawerOpen)
                  Positioned(
                    top: 0,
                    left: 0,
                    bottom: 0,
                    child: Container(
                      width: 250,
                      color: Colors.white,
                      child: Column(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(16),
                            color: Colors.amber,
                            child: const Text(
                              "Contatos",
                              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                          ),
                          Expanded(
                            child: ListView.builder(
                              itemCount: _contacts.length,
                              itemBuilder: (context, index) {
                                final contact = _contacts[index];
                                return ListTile(
                                  title: Text(contact.name),
                                  onTap: () => _goToContact(contact),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
    );
  }
}
