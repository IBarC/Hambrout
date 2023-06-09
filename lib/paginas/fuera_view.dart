<<<<<<< HEAD
=======
import 'dart:async';

>>>>>>> parent of 3cd4cfd (Intento de muestra de restaurantes solo)
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class FueraWidget extends StatefulWidget{
  const FueraWidget({super.key});

  @override
  State<StatefulWidget> createState() {
    return FueraState();
  }
}

class FueraState extends State<FueraWidget>{
<<<<<<< HEAD
=======
  Completer<GoogleMapController> controler = Completer();

>>>>>>> parent of 3cd4cfd (Intento de muestra de restaurantes solo)
  static const _localizacionInicial = LatLng(40.4165000, -3.7025600);

  late GoogleMapController _googleMapController;
  final Map<String, Marker> _markers = {};

  double lat=0;
  double long=0;

<<<<<<< HEAD
=======
  Set<Circle> circulo = Set<Circle>();
  var radioCirculo = 500.0;
  bool cambiarRadio=true;

>>>>>>> parent of 3cd4cfd (Intento de muestra de restaurantes solo)
  @override
  void dispose() {
    super.dispose();
    _googleMapController.dispose();
  }

  Future<Position>_getLocalizacionActual()async{
    bool servicioHabilitado = await Geolocator.isLocationServiceEnabled();
    if(!servicioHabilitado){
      return Future.error(('El servicio de geolocalización está deshabilitado'));
    }

    LocationPermission permiso = await Geolocator.checkPermission();

    if(permiso==LocationPermission.denied){
      permiso = await Geolocator.requestPermission();
      if(permiso==LocationPermission.denied){
        return Future.error('Los permisos de geolocalización están denegados');
      }
    }

    if(permiso==LocationPermission.deniedForever){
      return Future.error('Los permisos de localización están denegados permanentemente');
    }

    return await Geolocator.getCurrentPosition();
  }

  LatLng _localizacionEnVivo(){
    LocationSettings locationSettings = const LocationSettings(
      accuracy: LocationAccuracy.high,
      distanceFilter: 3
    );

    Geolocator.getPositionStream(locationSettings: locationSettings)
    .listen((Position posicion) {
      lat=posicion.latitude.toDouble();
      long=posicion.longitude.toDouble();
    });
    return LatLng(lat, long);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
<<<<<<< HEAD
      body: GoogleMap(
        myLocationButtonEnabled: false,
        zoomControlsEnabled: false,
        compassEnabled: true,
        initialCameraPosition: const CameraPosition(
            target: _localizacionInicial,
            zoom: 7
        ),
        onMapCreated: (controller) {
          _googleMapController = controller;
          _getLocalizacionActual().then((value) {
            lat=value.latitude.toDouble();
            long=value.longitude.toDouble();
            _googleMapController.animateCamera(
                CameraUpdate.newCameraPosition(
                    CameraPosition(target: LatLng(lat, long), zoom:17))
            );
            addMarker('Tu ubicación', LatLng(lat, long));
          });
        },
        markers: _markers,
        //onTap: (latLong) {addDestinoMarker('Destino', latLong);}, ///Añade el destino
=======
      body: Stack(
        children: [Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: GoogleMap(
            mapType: MapType.normal,
            myLocationButtonEnabled: false,
            zoomControlsEnabled: false,
            compassEnabled: false,
            circles: circulo,
            initialCameraPosition: const CameraPosition(
                target: _localizacionInicial,
                zoom: 7
            ),
            onMapCreated: (controller) {
              _googleMapController = controller;
              _getLocalizacionActual().then((value) {
                lat=value.latitude.toDouble();
                long=value.longitude.toDouble();
                _googleMapController.animateCamera(
                    CameraUpdate.newCameraPosition(
                        CameraPosition(target: LatLng(lat, long), zoom:17))
                );
                addMarker('Tu ubicación', LatLng(lat, long));
              });
              },
            markers: _markers.values.toSet(),
            onTap: (latLong) {addDestinoMarker('Destino', latLong);}, ///Añade el destino
          ),
        ),
          Padding(padding: EdgeInsets.all(30),
            child: Container(
              height: 50,
              color: Colors.black.withOpacity(0.3),
              child: Row(
                children: [
                  Expanded(child: Slider(
                    max: 5000,
                    min: 300,
                    value: radioCirculo,
                    onChanged: (nuevoValor){
                      radioCirculo=nuevoValor;
                      addMarker('Tu ubicación', LatLng(lat, long));
                      setState(() {});
                      },
                  ))
                ],
              ),
            ),
          )],
>>>>>>> parent of 3cd4cfd (Intento de muestra de restaurantes solo)
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: ()  {
          _markers.clear();
          _googleMapController.animateCamera(
              CameraUpdate.newCameraPosition(
                  CameraPosition(target: _localizacionEnVivo(), zoom:17))
              );
          },
        child: const Icon(Icons.center_focus_strong),
      ),
    );
  }

  void addMarker(String markerId, LatLng pos){
    var marker = Marker(
      markerId: MarkerId(markerId),
      position: pos,
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueOrange),
      infoWindow:  InfoWindow(title: markerId)
    );

    _markers[markerId] = marker;
    setState(() {});
  }

  void addDestinoMarker(String markerId, LatLng pos){
    var marker = Marker(
        markerId: MarkerId(markerId),
        position: pos,
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
        infoWindow:  InfoWindow(title: markerId)
    );

    _markers[markerId] = marker;
    setState(() {});
  }

}