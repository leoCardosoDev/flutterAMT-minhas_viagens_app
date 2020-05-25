import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapsScreen extends StatefulWidget {
  String id;

  MapsScreen({this.id});

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
  Firestore _db = Firestore.instance;

  void _onMapCreated(GoogleMapController mapController) {
    _mapController.complete(mapController);
  }

  void _addMarker(LatLng latLng) async {
    List<Placemark> _listAddress =
        await Geolocator().placemarkFromCoordinates(latLng.latitude, latLng.longitude);

    if (_listAddress != null && _listAddress.length > 0) {
      Placemark address = _listAddress[0];
      String street = address.thoroughfare;
      Marker marker = Marker(
        markerId: MarkerId('marcador-${latLng.latitude}-${latLng.longitude}'),
        position: latLng,
        infoWindow: InfoWindow(title: street),
      );

      setState(() {
        _markes.add(marker);
        Map<String, dynamic> viagem = Map();
        viagem['title'] = street;
        viagem['latitude'] = latLng.latitude;
        viagem['longitude'] = latLng.longitude;
        _db.collection('viagens').add(viagem);
      });
    }
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
          zoom: 18,
        );
        _moveCamera();
      });
    });
  }

  Future _recoveyTravelingId(String id) async {
    if (id != null) {
      DocumentSnapshot documentSnapshot = await _db.collection('viagens').document(id).get();
      var data = documentSnapshot.data;
      String title = data['title'];
      LatLng latLng  = LatLng(
        data['latitude'],
        data['longitude']
      );
      
      setState(() {
        Marker marker = Marker(
          markerId: MarkerId('marcador-${latLng.latitude}-${latLng.longitude}'),
          position: latLng,
          infoWindow: InfoWindow(title: title),
        );
        
        _markes.add(marker);
        _positionCamera = CameraPosition(
          target: latLng,
          zoom: 18,
        );
      });
    } else {
      _addListenerLocation();
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _recoveyTravelingId(widget.id);
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
          onLongPress: _addMarker,
          myLocationEnabled: true,
        ),
      ),
    );
  }
}
