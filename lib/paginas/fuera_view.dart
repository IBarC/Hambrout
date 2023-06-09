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
  Completer<GoogleMapController> _googleMapController = Completer();

  Timer? _temporizador;

  static const _localizacionInicial = LatLng(40.4165000, -3.7025600);

  //late GoogleMapController _googleMapController;
  Map<String,Marker> _markers = {};
  Map<String, Marker> _markersDupe = {};

  double lat=0;
  double long=0;
  var markerIdCounter=1;

  Set<Circle> circulo = Set<Circle>();
  var radioCirculo = 700.0;
  bool cambiarRadio=true;

  List<dynamic> allLugares=[];

  String tokenKey = '';

  static const List<String> datosLugares=<String>['Restaurantes', 'Bares', 'Cafeterias', 'Pastelerias'];
  String lugar = 'Restaurantes';

  late PageController pageController;
  int paginaAnterior=0;
  var tappedPlaceDetail;
  String imagenSitio='';
  var indiceGaleriaFoto = 0;
  bool cardTapped = false;

  final key = 'AIzaSyC5YstKsWGxE_29dDccBbRe17VkpxtYymw';

  var selectedPlaceDetails;

  Marker marcadorAntiguo = Marker(markerId: MarkerId(''));

  @override
  void initState() {
    super.initState();
    //pageController = PageController(
      //initialPage: 1, viewportFraction: 0.85)..addListener(alDeslizar);
  }

  void alDeslizar(){
    if(pageController.page!.toInt() != paginaAnterior){
      paginaAnterior = pageController.page!.toInt();
      indiceGaleriaFoto = 1;
      irASitio();
      traerImagen();
      cardTapped = false;
    }
  }

  void traerImagen() async{
    if(pageController.page!=null){
      if(allLugares[pageController.page!.toInt()]['photos'] != null){
        setState(() {
          imagenSitio=allLugares[pageController.page!.toInt()]['photos'][0]['photo_reference'];
        });
      } else {
        imagenSitio='';
      }
    }
  }

  Future<void> irASitio() async{
    final GoogleMapController controlador = await _googleMapController.future;

    var lugarSeleccionado = allLugares[pageController.page!.toInt()];

    addBigMarker(lugarSeleccionado['name'], LatLng(lugarSeleccionado['geometry']['location']['lat'],lugarSeleccionado['geometry']['location']['lng']));

    controlador.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
        target: LatLng(lugarSeleccionado['geometry']['location']['lat'],lugarSeleccionado['geometry']['location']['lng']),zoom:17)));
  }

  @override
  void dispose() {
    super.dispose();
    //_googleMapController.dispose();
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

  void setLugaresMarker(LatLng pos, String label, List tipos, String estado) {
    var counter = markerIdCounter++;

    final Marker marker;

    //if(tipos.contains('restaurant')||tipos.contains('food')||tipos.contains('bar')||tipos.contains('bakery')
        //||tipos.contains('cafe')){
      marker = Marker(
        markerId: MarkerId('marcador_$counter'),
        position: pos,
        onTap: (){},
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
        infoWindow: InfoWindow(title: label, onTap: () async {
          GoogleMapController controlador = await _googleMapController.future;
          controlador.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(target: pos,zoom: 20)));
        })
      );
      setState(() {
        _markers['marcador_$counter']=marker;
      });
    //}

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: GoogleMap(
            myLocationButtonEnabled: false,
            zoomControlsEnabled: false,
            compassEnabled: false,
            circles: circulo,
            initialCameraPosition: const CameraPosition(
                target: _localizacionInicial,
                zoom: 7
            ),
            onMapCreated: (controller) {
              _googleMapController.complete(controller);
              _getLocalizacionActual().then((value) {
                lat=value.latitude.toDouble();
                long=value.longitude.toDouble();
                controller.animateCamera(
                    CameraUpdate.newCameraPosition(
                        CameraPosition(target: LatLng(lat, long), zoom:15))
                );
                crearCirculo(LatLng(lat, long));
                cambiarRadio=true;
                addMarker('Tu ubicación', LatLng(lat, long));
              });
            },
            markers: _markers.values.toSet(),
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
                      crearCirculo(LatLng(lat, long));
                      addMarker('Tu ubicación', LatLng(lat, long));
                      setState(() {});
                    },
                  )),
                  DropdownButton(
                      items: datosLugares.map<DropdownMenuItem<String>>((String value){
                        return DropdownMenuItem<String>(child: Text(value),value: value,);
                      }).toList(),
                      value: lugar,
                      onChanged: (String? value){
                        tokenKey='';
                        lugar=value!;
                        setState(() {});
                      }),
                  Padding(
                    padding: EdgeInsets.only(right: 20),
                    child: ElevatedButton(
                        onPressed: (){
                          if(lugar==datosLugares[0]){
                            getAllLugares('restaurant');
                          } else if(lugar==datosLugares[1]){
                            getAllLugares('bar');
                          } else if(lugar==datosLugares[2]){
                            getAllLugares('cafe');
                          } else if(lugar==datosLugares[3]){
                            getAllLugares('bakery');
                          }
                        },
                        child: Text('Ver')),
                  )
                ],
              ),
            ),
          ),

        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: ()  async{
          final GoogleMapController controlador = await _googleMapController.future;
          _markers.clear();
          controlador.animateCamera(
              CameraUpdate.newCameraPosition(
                  CameraPosition(target: _localizacionEnVivo(), zoom:15))
          );
        },
        child: const Icon(Icons.center_focus_strong),
      ),
    );
  }

  void getAllLugares(String tipo){
    if(tokenKey==''){
      if(_temporizador?.isActive ?? false){
        _temporizador?.cancel();
      }
      _temporizador= Timer(Duration(seconds: 2), () async{
        print('dentro de la funcion asincrona');
        var lugares =
        await MapServices().getDetallesLugar(_localizacionEnVivo(), radioCirculo.toInt(), tipo);
        List<dynamic> lugaresCercanos = lugares['results'] as List;

        allLugares=lugaresCercanos;
        tokenKey=lugares['next_page_token']??'none';
        _markers={};
        addMarker('Tu ubicación', LatLng(lat, long));
        print(lugaresCercanos.length);
        print(radioCirculo);
        lugaresCercanos.forEach((element) {
          setLugaresMarker(
              LatLng(element['geometry']['location']['lat'], element['geometry']['location']['lng']),
              element['name'],
              element['types'],
              element['business_status'] ?? 'No disponible'
          );
        });
      });
      marcadorAntiguo = _markers['marcador_2']!;
      _markersDupe=_markers;
    } else if(tokenKey!='none'){
      if(_temporizador?.isActive ?? false){
        _temporizador?.cancel();
      }
      _temporizador= Timer(Duration(seconds: 2), () async {
        var resulLugares = await MapServices()
            .getMorePlaceDetails(tokenKey);
        List<
            dynamic> lugaresCercanos = resulLugares['results'] as List;

        allLugares.addAll(lugaresCercanos);

        tokenKey =
            resulLugares['next_page_token'] ?? 'none';
        lugaresCercanos.forEach((element) {
          setLugaresMarker(
              LatLng(element['geometry']['location']['lat'],
                  element['geometry']['location']['lng']),
              element['name'],
              element['types'],
              element['business_status'] ??
                  'No disponible');
        });
      }
      );
    }
  }

  Future<void> moveCameraSlightly() async {
    final GoogleMapController controller = await _googleMapController.future;

    controller.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
        target: LatLng(
            allLugares[pageController.page!.toInt()]['geometry']
            ['location']['lat'] +
                0.0125,
            allLugares[pageController.page!.toInt()]['geometry']
            ['location']['lng'] +
                0.005),
        zoom: 14.0,
        bearing: 45.0,
        tilt: 45.0)));
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

  void addBigMarker(String markerId, LatLng pos){
    var marker = Marker(
        markerId: MarkerId(markerId),
        position: pos,
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueCyan),
        infoWindow:  InfoWindow(title: markerId)
    );
    var markerRojo = Marker(
        markerId: MarkerId(markerId),
        position: pos,
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
        infoWindow:  InfoWindow(title: markerId)
    );
    _markers[marcadorAntiguo.markerId.toString()]=marcadorAntiguo;
    marcadorAntiguo=markerRojo;
    _markers[markerId] = marker;
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