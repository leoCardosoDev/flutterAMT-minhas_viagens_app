import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapsScreen extends StatefulWidget {
  @override
  _MapsScreenState createState() => _MapsScreenState();
}

class _MapsScreenState extends State<MapsScreen> {
  Completer<GoogleMapController> _mapController = Completer();
  Set<Marker> _markes = {};
  CameraPosition _positionCamera = CameraPosition(
    target: LatLng(-23.562436, -46.655005),
    zoom: 16,
  );

  void _onMapCreated(GoogleMapController mapController) {
    _mapController.complete(mapController);
  }

  void _exibirMarcador(LatLng latLng) {
    Marker marker = Marker(
      markerId: MarkerId('marcador-${latLng.latitude}-${latLng.longitude}'),
      position: latLng,
      infoWindow: InfoWindow(title: 'Local'),
    );

    setState(() {
      _markes.add(marker);
    });
  }

  _moveCamera() async {
    GoogleMapController googleMapController = await _mapController.future;
    googleMapController.animateCamera(
      CameraUpdate.newCameraPosition(_positionCamera),
    );
  }

  _addListenerLocation() {
    Geolocator geolocator = Geolocator();
    LocationOptions locationOptions = LocationOptions(accuracy: LocationAccuracy.high);
    geolocator.getPositionStream(locationOptions).listen((Position position) {
      setState(() {
        _positionCamera = CameraPosition(
          target: LatLng(position.latitude, position.longitude),
        );
        _moveCamera();
      });
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _addListenerLocation();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Mapa'),
        centerTitle: true,
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: Container(
        child: GoogleMap(
          markers: _markes,
          mapType: MapType.normal,
          initialCameraPosition: _positionCamera,
          onMapCreated: _onMapCreated,
          onLongPress: _exibirMarcador,
        ),
      ),
    );
  }
}
