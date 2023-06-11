import 'dart:async';

import 'package:custom_info_window/custom_info_window.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hambrout/services/map_services.dart';
import 'package:hambrout/utils/formularios.dart';
import 'package:lottie/lottie.dart' as Lottie;

class FueraWidget extends StatefulWidget {
  const FueraWidget({super.key});

  @override
  State<StatefulWidget> createState() {
    return FueraState();
  }
}

class FueraState extends State<FueraWidget> {
  //Completer<GoogleMapController> _googleMapController = Completer();

  Timer? _temporizador;

  static const _localizacionInicial = LatLng(40.4165000, -3.7025600);

  late GoogleMapController _googleMapController;
  Map<String, Marker> _markers = {};
  Map<String, Marker> _markersDupe = {};

  double lat = 0;
  double long = 0;
  var markerIdCounter = 1;

  Set<Circle> circulo = Set<Circle>();
  var radioCirculo = 2000.0;
  bool cambiarRadio = true;

  List<dynamic> allLugares = [];

  String tokenKey = '';

  static const List<String> datosLugares = <String>[
    'Restaurantes',
    'Bares',
    'Cafeterias',
    'Pastelerias'
  ];
  String lugar = 'Restaurantes';

  //late PageController pageController;
  int paginaAnterior = 0;
  var tappedPlaceDetail;
  String imagenSitio = '';
  var indiceGaleriaFoto = 0;
  bool cardTapped = false;

  final key = 'AIzaSyC5YstKsWGxE_29dDccBbRe17VkpxtYymw';

  var selectedPlaceDetails;

  Marker marcadorAntiguo = Marker(markerId: MarkerId(''));

  final CustomInfoWindowController _customInfoWindowController =
      CustomInfoWindowController();

  @override
  void initState() {
    super.initState();
    //pageController = PageController(
    //initialPage: 1, viewportFraction: 0.85)..addListener(alDeslizar);
  }

  /** void alDeslizar(){
      if(pageController.page!.toInt() != paginaAnterior){
      paginaAnterior = pageController.page!.toInt();
      indiceGaleriaFoto = 1;
      //irASitio();
      traerImagen();
      cardTapped = false;
      }
      }**/

  void traerImagen(int cont) async {
    //if(pageController.page!=null){
    //if(allLugares[pageController.page!.toInt()]['photos'] != null){
    //setState(() {
    //imagenSitio=allLugares[pageController.page!.toInt()]['photos'][0]['photo_reference'];
    //});
    //} else {
    //imagenSitio='';
    //}
    //}
    if (allLugares[cont - 1]['photos'] != null) {
      setState(() {
        imagenSitio = allLugares[cont - 1]['photos'][0]['photo_reference'];
      });
    } else {
      imagenSitio = '';
    }
  }

  /**Future<void> irASitio() async{
      //final GoogleMapController controlador = await _googleMapController.future;

      var lugarSeleccionado = allLugares[pageController.page!.toInt()];

      //addBigMarker(lugarSeleccionado['name'], LatLng(lugarSeleccionado['geometry']['location']['lat'],lugarSeleccionado['geometry']['location']['lng']));

      _googleMapController.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
      target: LatLng(lugarSeleccionado['geometry']['location']['lat'],lugarSeleccionado['geometry']['location']['lng']),zoom:17)));
      }**/

  @override
  void dispose() {
    super.dispose();
    _googleMapController.dispose();
    _customInfoWindowController.dispose();
  }

  ///Obtiene el objeto Posicion del dispositivo en tiempo real
  Future<Position> _getLocalizacionActual() async {
    bool servicioHabilitado = await Geolocator.isLocationServiceEnabled();
    if (!servicioHabilitado) {
      return Future.error(
          ('El servicio de geolocalización está deshabilitado'));
    }
    LocationPermission permiso = await Geolocator.checkPermission();

    if (permiso == LocationPermission.denied) {
      permiso = await Geolocator.requestPermission();
      if (permiso == LocationPermission.denied) {
        return Future.error('Los permisos de geolocalización están denegados');
      }
    }
    if (permiso == LocationPermission.deniedForever) {
      return Future.error(
          'Los permisos de localización están denegados permanentemente');
    }
    return await Geolocator.getCurrentPosition();
  }

  ///
  LatLng _localizacionEnVivo() {
    LocationSettings locationSettings = const LocationSettings(
        accuracy: LocationAccuracy.high, distanceFilter: 3);

    Geolocator.getPositionStream(locationSettings: locationSettings)
        .listen((Position posicion) {
      lat = posicion.latitude.toDouble();
      long = posicion.longitude.toDouble();
    });
    return LatLng(lat, long);
  }

  /// Establece los marcadores de los lugares que pide la API
  void setLugaresMarker(LatLng pos, String nombre, List tipos, String abierto,
      String precio, String valoracion, String id) {
    var counter = markerIdCounter++;

    Widget widgetAbierto;
    TextStyle estiloAbierto;

    if (abierto == 'true') {
      abierto = 'Abierto';
      estiloAbierto = TextStyle(color: Colors.green, fontSize: 17);
    } else if (abierto == 'false') {
      abierto = 'Cerrado';
      estiloAbierto = TextStyle(color: Colors.red, fontSize: 17);
    } else {
      abierto = 'Apertura no disponible';
      estiloAbierto = TextStyle(color: Colors.black54, fontSize: 17);
    }
    widgetAbierto = Text(
      abierto,
      style: estiloAbierto,
    );

    TextStyle estiloValoracion;
    if (valoracion == '-/5.0') {
      estiloValoracion = TextStyle(color: Colors.black54, fontSize: 17);
    } else {
      valoracion = '$valoracion/5.0';
      estiloValoracion = TextStyle(fontSize: 17);
    }

    Marker marker = Marker(
      markerId: MarkerId('marcador_$counter'),
      position: pos,
      onTap: () async {
        var info = await MapServices().getPlace(id);
        LatLng origen = _localizacionEnVivo();
        var tiempoAndando = await MapServices().getDireccionAndando(
            origen.latitude, origen.longitude, pos.latitude, pos.longitude);
        var tiempoCoche = await MapServices().getDireccionCoche(
            origen.latitude, origen.longitude, pos.latitude, pos.longitude);
        traerImagen(counter);

        _customInfoWindowController.addInfoWindow!(
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                  width: 320,
                  height: 190,
                  decoration: BoxDecoration(color: Colors.white),
                  child: SingleChildScrollView(
                    physics: PageScrollPhysics(),
                    scrollDirection: Axis.vertical,
                    child: Column(
                      children: [
                        SizedBox(
                          height: 70,
                          width: 320,
                          child: FittedBox(
                            fit: BoxFit.fitWidth,
                            alignment: Alignment.center,
                            clipBehavior: Clip.hardEdge,
                            child: Image(
                              image: NetworkImage(imagenSitio != ''
                                  ? 'https://maps.googleapis.com/maps/api/place/photo?maxwidth=400&photo_reference=$imagenSitio&key=$key'
                                  : 'https://cdn-icons-png.flaticon.com/512/813/813789.png?w=826&t=st=1686398815~exp=1686399415~hmac=b23e01bdd231369d0b79b2094ebacbe4427d6746ab481b46a5740e98da1868a0'),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(7),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Row(
                                children: [
                                  SizedBox(
                                    width: 306,
                                    child: Text(nombre,
                                        style: formatosDisenio
                                            .txtTituloLugar(context)),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  SizedBox(
                                    width: 306,
                                    child: Wrap(
                                      spacing: 10,
                                      children: [
                                        Wrap(
                                          spacing: 7,
                                          children: [
                                            Image(
                                              image: AssetImage(
                                                  'images/icons/favourite.png'),
                                              width: 20,
                                            ),
                                            Text(
                                              valoracion,
                                              style: estiloValoracion,
                                            ),
                                          ],
                                        ),
                                        Text('·',
                                            style: TextStyle(fontSize: 17)),
                                        Wrap(
                                          children: [
                                            Image(
                                              image: AssetImage(
                                                  'images/icons/relaxing-walk.png'),
                                              width: 20,
                                            ),
                                            Text(
                                              tiempoAndando['routes'][0]['legs']
                                                  [0]['duration']['text'],
                                              style: TextStyle(fontSize: 17),
                                            ),
                                          ],
                                        ),
                                        Text('·',
                                            style: TextStyle(fontSize: 17)),
                                        Wrap(
                                          spacing: 7,
                                          children: [
                                            Image(
                                              image: AssetImage(
                                                  'images/icons/car-fill-from-frontal-view.png'),
                                              width: 20,
                                            ),
                                            Text(
                                              tiempoCoche['routes'][0]['legs']
                                                  [0]['duration']['text'],
                                              style: TextStyle(fontSize: 17),
                                            )
                                          ],
                                        ),
                                      ],
                                    ),
                                  )
                                ],
                              ),
                              Row(
                                children: [
                                  SizedBox(
                                      width: 306,
                                      child: Text(
                                        info['formatted_address'],
                                        style: TextStyle(fontSize: 17),
                                      ))
                                ],
                              ),
                              Row(
                                children: [
                                  SizedBox(
                                    width: 306,
                                    child: widgetAbierto,
                                  )
                                ],
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  )),
              Image(
                image: AssetImage('images/icons/triangulo-blanco.png'),
                height: 15,
              ),
            ],
          ),
          pos,
        );
        setState(() {});
      },
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
    );
    setState(() {
      _markers['marcador_$counter'] = marker;
    });
    //}
  }

  bool cargando = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: GoogleMap(
              myLocationButtonEnabled: false,
              zoomControlsEnabled: false,
              compassEnabled: true,
              circles: circulo,
              initialCameraPosition:
              const CameraPosition(target: _localizacionInicial, zoom: 7),
              onMapCreated: (controller) {
                _customInfoWindowController.googleMapController = controller;
                _googleMapController = controller;
                _getLocalizacionActual().then((value) {
                  lat = value.latitude.toDouble();
                  long = value.longitude.toDouble();
                  controller.animateCamera(CameraUpdate.newCameraPosition(
                      CameraPosition(target: LatLng(lat, long), zoom: 13)));
                  crearCirculo(LatLng(lat, long));
                  cambiarRadio = true;
                  addMarker('Tu ubicación', LatLng(lat, long));
                });
              },
              onCameraMove: (pos) {
                _customInfoWindowController.onCameraMove!();
              },
              markers: _markers.values.toSet(),
              onTap: (latLong) {
                _customInfoWindowController.hideInfoWindow!();
              },
            ),
          ),
          Padding(
            padding: EdgeInsets.all(30),
            child: Container(
              height: 80,
              color: Colors.white.withOpacity(0.98),
              child: Column(
                children: [
                  Expanded(
                      child: Slider(
                        activeColor: Colors.black,
                        max: 5000,
                        min: 300,
                        value: radioCirculo,
                        onChanged: (nuevoValor) {
                          tokenKey = '';
                          radioCirculo = nuevoValor;
                          crearCirculo(LatLng(lat, long));
                          addMarker('Tu ubicación', LatLng(lat, long));
                          setState(() {});
                        },
                      )),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      DropdownButton(
                          padding: EdgeInsets.symmetric(horizontal: 20),
                          style: TextStyle(color: Colors.black, fontSize: 20),
                          dropdownColor: Colors.white,
                          items: datosLugares
                              .map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              child: Text(value),
                              value: value,
                            );
                          }).toList(),
                          value: lugar,
                          iconSize: 30,
                          iconEnabledColor: Colors.black,
                          //padding: EdgeInsets.only(left: 20),
                          onChanged: (String? value) {
                            tokenKey = '';
                            lugar = value!;
                            setState(() {});
                          }),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.orange,
                            foregroundColor: Colors.white),
                        onPressed: () {
                          if (lugar == datosLugares[0]) {
                            getAllLugares('restaurant');
                          } else if (lugar == datosLugares[1]) {
                            getAllLugares('bar');
                          } else if (lugar == datosLugares[2]) {
                            getAllLugares('cafe');
                          } else if (lugar == datosLugares[3]) {
                            getAllLugares('bakery');
                          }
                        },
                        child: Text(
                          'Buscar',
                          style: TextStyle(fontSize: 20),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          CustomInfoWindow(
            controller: _customInfoWindowController,
            width: 320,
            height: 250,
            offset: 1,
          ),
          cargando?
              Container(height:MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                alignment: Alignment.center,
                decoration: const BoxDecoration(color: Colors.black12),
                child: SizedBox(height: 200, width: 200, child: Lottie.LottieBuilder.asset('images/animacion/106177-food-loading.json'),),)
              : Container()
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.orange,
        tooltip: 'Ir a tu ubicación',
        onPressed: () async {
          _markers.clear();
          _googleMapController.animateCamera(CameraUpdate.newCameraPosition(
              CameraPosition(target: _localizacionEnVivo(), zoom: 15)));
        },
        child: const Icon(Icons.center_focus_strong),
      ),
    );
  }

  void getAllLugares(String tipo) {
    if (tokenKey == '') {
      if (_temporizador?.isActive ?? false) {
        _temporizador?.cancel();
      }
      setState(() {
        cargando=true;
      });
      markerIdCounter = 0;
      _temporizador = Timer(Duration(seconds: 2), () async {
        print('dentro de la funcion asincrona');
        var lugares = await MapServices().getDetallesLugar(
            _localizacionEnVivo(), radioCirculo.toInt(), tipo);
        List<dynamic> lugaresCercanos = lugares['results'] as List;

        allLugares = lugaresCercanos;
        tokenKey = lugares['next_page_token'] ?? 'none';
        _markers = {};
        addMarker('Tu ubicación', LatLng(lat, long));
        print(lugaresCercanos.length);
        print(radioCirculo);
        lugaresCercanos.forEach((element) {
          setLugaresMarker(
              LatLng(element['geometry']['location']['lat'],
                  element['geometry']['location']['lng']),
              element['name'],
              element['types'],
              element['opening_hours'] != null
                  ? element['opening_hours']['open_now'].toString() ??
                      'No disponible'
                  : 'No disponible',
              element['price_level'].toString() ?? 'No disponible',
              element['rating'] != null
                  ? element['rating'].toString()
                  : 'No disponible',
              element['place_id']);
        });
        setState(() {
          cargando=false;
        });
      });

      //marcadorAntiguo = markers['marcador_2'] as Marker;
      //_markersDupe = _markers;
    } else if (tokenKey != 'none') {
      if (_temporizador?.isActive ?? false) {
        _temporizador?.cancel();
      }
      setState(() {
        cargando=true;
      });
      _temporizador = Timer(Duration(seconds: 2), () async {
        var resulLugares = await MapServices().getMorePlaceDetails(tokenKey);
        List<dynamic> lugaresCercanos = resulLugares['results'] as List;

        allLugares.addAll(lugaresCercanos);

        tokenKey = resulLugares['next_page_token'] ?? 'none';
        lugaresCercanos.forEach((element) {
          setLugaresMarker(
              LatLng(element['geometry']['location']['lat'],
                  element['geometry']['location']['lng']),
              element['name'],
              element['types'],
              element['opening_hours'] != null
                  ? element['opening_hours']['open_now'].toString() ??
                      'No disponible'
                  : 'No disponible',
              element['price_level'].toString() ?? 'No disponible',
              element['rating'] != null
                  ? element['rating'].toString()
                  : 'No disponible',
              element['place_id']);
        });
        setState(() {
          cargando=false;
        });
      });
    } else {
    }
  }

  void addMarker(String markerId, LatLng pos) {
    var marker = Marker(
        markerId: MarkerId(markerId),
        position: pos,
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueOrange),
        infoWindow: InfoWindow(title: markerId));

    _markers[markerId] = marker;
    setState(() {});
  }

  void crearCirculo(LatLng pos) {
    circulo.add(Circle(
        circleId: const CircleId('Persona'),
        center: pos,
        fillColor: Colors.orange.withOpacity(0.1),
        radius: radioCirculo,
        strokeColor: Colors.orange,
        strokeWidth: 1));
  }
}
