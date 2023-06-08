import 'dart:async';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hambrout/services/map_services.dart';

import '../main.dart';

class FueraWidget extends StatefulWidget{
  const FueraWidget({super.key});

  @override
  State<StatefulWidget> createState() {
    return FueraState();
  }
}

class FueraState extends State<FueraWidget>{
  //Completer<GoogleMapController> controler = Completer();

  Timer? _temporizador;

  static const _localizacionInicial = LatLng(40.4165000, -3.7025600);

  late GoogleMapController _googleMapController;
  final Set<Marker> _markers = Set<Marker>();

  double lat=0;
  double long=0;

  Set<Circle> circulo = Set<Circle>();
  var radioCirculo = 700.0;
  bool cambiarRadio=true;

  @override
  void initState() {
    super.initState();
  }

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

  void setLugaresMarker(LatLng pos, String label, List tipos, String estado) async{
    var counter=1;

    final Marker marker;

    if(tipos.contains('restaurants')||tipos.contains('food')||tipos.contains('bar')||tipos.contains('bakery')
        ||tipos.contains('cafe')){
      marker = Marker(
        markerId: MarkerId('marcador_$counter'),
        position: pos,
        onTap: (){},
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
      );
      setState(() {
        _markers.add(marker);
      });
    }

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                        CameraPosition(target: LatLng(lat, long), zoom:15))
                );
                addMarker('Tu ubicación', LatLng(lat, long));
              });
              },
            markers: _markers,
            //onTap: (latLong) {addDestinoMarker('Destino', latLong);}, ///Añade el destino
          ),
        ),
          Padding(padding: EdgeInsets.all(30),
            child: Container(
              height: 50,
              color: Colors.black.withOpacity(0.3),
              child: Row(
                children: [
                  Expanded(child: Slider(
                    activeColor: Colors.white,
                    max: 5000,
                    min: 300,
                    value: radioCirculo,
                    onChanged: (nuevoValor){
                      radioCirculo=nuevoValor;
                      addMarker('Tu ubicación', LatLng(lat, long));
                      setState(() {});
                      },
                  )),
                  IconButton(
                      onPressed: (){
                        if(_temporizador?.isActive ?? false){
                          _temporizador?.cancel();
                          _temporizador= Timer(
                              Duration(seconds: 2), () async{
                                var lugares =
                                    await MapServices().getDetallesLugar(_localizacionEnVivo(), radioCirculo.toInt());
                                List<dynamic> lugaresCercanos = lugares['results'] as List;
                                lugaresCercanos.forEach((element) {
                                  setLugaresMarker(
                                    LatLng(element['geometry']['location']['lat'], element['geometry']['location']['lng']),
                                    element['name'],
                                    element['types'],
                                    element['business_status'] ?? 'No disponible'
                                  );
                                });
                          });
                        }
                        },
                      icon: Icon(Icons.near_me))
                ],
              ),
            ),
          )],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: ()  {
          _markers.clear();
          _googleMapController.animateCamera(
              CameraUpdate.newCameraPosition(
                  CameraPosition(target: _localizacionEnVivo(), zoom:15))
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
    crearCirculo(pos);
    cambiarRadio=true;

    _markers.add(marker);
    setState(() {});
  }
  
  void crearCirculo(LatLng pos){
    circulo.add(Circle(circleId: CircleId('Persona'),
        center: pos,
        fillColor: Colors.orange.withOpacity(0.1),
        radius: radioCirculo,
        strokeColor: Colors.orange,
        strokeWidth: 1));
  }

  /**void addDestinoMarker(String markerId, LatLng pos){
    var marker = Marker(
        markerId: MarkerId(markerId),
        position: pos,
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
        infoWindow:  InfoWindow(title: markerId)
    );

    _markers[markerId] = marker;
    setState(() {});
  }**/

}