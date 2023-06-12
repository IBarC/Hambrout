import 'dart:async';

import 'package:custom_info_window/custom_info_window.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hambrout/services/map_services.dart';
import 'package:lottie/lottie.dart' as lottie;

import '../utils/formatos_disenio.dart';

/// Clase que genera la vista de Fuera
class FueraWidget extends StatefulWidget {
  const FueraWidget({super.key});

  @override
  State<StatefulWidget> createState() {
    return FueraState();
  }
}

class FueraState extends State<FueraWidget> {
  Timer? _temporizador;

  static const _localizacionInicial = LatLng(40.4165000, -3.7025600);

  //Controladores
  late GoogleMapController _googleMapController;
  final CustomInfoWindowController _customInfoWindowController =
      CustomInfoWindowController();

  Map<String, Marker> _marcadores = {};
  Marker marcadorAntiguo = const Marker(markerId: MarkerId(''));

  double lat = 0;
  double long = 0;
  var markerIdCounter = 1;

  Set<Circle> circulo = <Circle>{};
  var radioCirculo = 2000.0;
  bool cambiarRadio = true;
  bool cargando = false;

  List<dynamic> allLugares = [];

  String tokenKey = '';

  static const List<String> datosLugares = <String>[
    'Restaurantes',
    'Bares',
    'Cafeterias',
    'Pastelerias'
  ];
  String lugar = 'Restaurantes';

  String imagenSitio = '';

  ///key de la API
  final key = 'AIzaSyC5YstKsWGxE_29dDccBbRe17VkpxtYymw';

  @override
  void dispose() {
    super.dispose();
    _googleMapController.dispose();
    _customInfoWindowController.dispose();
  }

  ///Obtiene el string de la imagen, si existe
  void traerImagen(int cont) async {
    if (allLugares[cont - 1]['photos'] != null) {
      setState(() {
        imagenSitio = allLugares[cont - 1]['photos'][0]['photo_reference'];
      });
    } else {
      imagenSitio = '';
    }
  }

  ///Obtiene el objeto Posicion del dispositivo comprobando que se de permiso para ello
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

  ///Devuelve la latitud y longitud en vivo
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

  /// Establece un marcador de los lugares que pide la API
  void setLugaresMarker(LatLng pos, String nombre, List tipos, String abierto,
      String valoracion, String id) {
    var counter = markerIdCounter++;

    Widget widgetAbierto;
    TextStyle estiloAbierto;

    if (abierto == 'true') {
      abierto = 'Abierto';
      estiloAbierto = const TextStyle(color: Colors.green, fontSize: 17);
    } else if (abierto == 'false') {
      abierto = 'Cerrado';
      estiloAbierto = const TextStyle(color: Colors.red, fontSize: 17);
    } else {
      abierto = 'Apertura no disponible';
      estiloAbierto = const TextStyle(color: Colors.black54, fontSize: 17);
    }
    widgetAbierto = Text(
      abierto,
      style: estiloAbierto,
    );

    TextStyle estiloValoracion;
    if (valoracion == '-/5.0') {
      estiloValoracion = const TextStyle(color: Colors.black54, fontSize: 17);
    } else {
      valoracion = '$valoracion/5.0';
      estiloValoracion = const TextStyle(fontSize: 17);
    }

    Marker marker = Marker(
      markerId: MarkerId('marcador_$counter'),
      position: pos,
      onTap: () async {
        var info = await MapServices().getLugar(id);
        LatLng origen = _localizacionEnVivo();
        var tiempoAndando = await MapServices().getDireccionAndando(
            origen.latitude, origen.longitude, pos.latitude, pos.longitude);
        var tiempoCoche = await MapServices().getDireccionCoche(
            origen.latitude, origen.longitude, pos.latitude, pos.longitude);
        traerImagen(counter);

        ///Ventana de información del marcador
        _customInfoWindowController.addInfoWindow!(
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                  width: 320,
                  height: 190,
                  decoration: const BoxDecoration(color: Colors.white),
                  child: SingleChildScrollView(
                    physics: const PageScrollPhysics(),
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
                                        style:
                                        FormatosDisenio().txtTituloLugar()),
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
                                            const Image(
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
                                        const Text('·',
                                            style: TextStyle(fontSize: 17)),
                                        Wrap(
                                          children: [
                                            const Image(
                                              image: AssetImage(
                                                  'images/icons/relaxing-walk.png'),
                                              width: 20,
                                            ),
                                            Text(
                                              tiempoAndando['routes'][0]['legs']
                                                  [0]['duration']['text'],
                                              style:
                                                  const TextStyle(fontSize: 17),
                                            ),
                                          ],
                                        ),
                                        const Text('·',
                                            style: TextStyle(fontSize: 17)),
                                        Wrap(
                                          spacing: 7,
                                          children: [
                                            const Image(
                                              image: AssetImage(
                                                  'images/icons/car-fill-from-frontal-view.png'),
                                              width: 20,
                                            ),
                                            Text(
                                              tiempoCoche['routes'][0]['legs']
                                                  [0]['duration']['text'],
                                              style:
                                                  const TextStyle(fontSize: 17),
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
                                        style: const TextStyle(fontSize: 17),
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
              const Image(
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
      _marcadores['marcador_$counter'] = marker;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          SizedBox(
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
                  aniadirUserMarker('Tu ubicación', LatLng(lat, long));
                });
              },
              onCameraMove: (pos) {
                _customInfoWindowController.onCameraMove!();
              },
              markers: _marcadores.values.toSet(),
              onTap: (latLong) {
                _customInfoWindowController.hideInfoWindow!();
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(30),
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
                      aniadirUserMarker('Tu ubicación', LatLng(lat, long));
                      setState(() {});
                    },
                  )),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      DropdownButton(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          style: const TextStyle(
                              color: Colors.black, fontSize: 20),
                          dropdownColor: Colors.white,
                          items: datosLugares
                              .map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
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
                        child: const Text(
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
          cargando
              ? Container(
                  height: MediaQuery.of(context).size.height,
                  width: MediaQuery.of(context).size.width,
                  alignment: Alignment.center,
                  decoration: const BoxDecoration(color: Colors.black38),
                  child: SizedBox(
                    height: 250,
                    width: 250,
                    child: lottie.LottieBuilder.asset(
                        'images/animacion/106177-food-loading.json'),
                  ),
                )
              : Container()
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.orange,
        tooltip: 'Ir a tu ubicación',
        onPressed: () async {
          _marcadores.clear();
          _googleMapController.animateCamera(CameraUpdate.newCameraPosition(
              CameraPosition(target: _localizacionEnVivo(), zoom: 15)));
        },
        child: const Icon(Icons.center_focus_strong),
      ),
    );
  }

  ///Obtiene todos los lugares que recibe de la API en cada llamda
  ///
  /// Cada vez que se llama a la API devuelve como máximo 20 elementos.
  /// Si la API trae un valor llamado 'next_page_token' significa que puede traer otros 20.
  ///
  /// El número máximo de elementos que trae la API es 60
  void getAllLugares(String tipo) {
    if (tokenKey == '') {
      if (_temporizador?.isActive ?? false) {
        _temporizador?.cancel();
      }
      setState(() {
        cargando = true;
      });
      markerIdCounter = 0;
      _temporizador = Timer(const Duration(seconds: 2), () async {
        var lugares = await MapServices().getDetallesLugar(
            _localizacionEnVivo(), radioCirculo.toInt(), tipo);
        List<dynamic> lugaresCercanos = lugares['results'] as List;

        allLugares = lugaresCercanos;
        tokenKey = lugares['next_page_token'] ?? 'none';
        _marcadores = {};
        aniadirUserMarker('Tu ubicación', LatLng(lat, long));
        for (var element in lugaresCercanos) {
          setLugaresMarker(
              LatLng(element['geometry']['location']['lat'],
                  element['geometry']['location']['lng']),
              element['name'],
              element['types'],
              element['opening_hours'] != null
                  ? element['opening_hours']['open_now'].toString() ??
                      'No disponible' //El elemento open_now no es obligatorio por lo que a veces no lo trae
                  : 'No disponible',
              element['rating'] != null
                  ? element['rating'].toString()
                  : 'No disponible',
              element['place_id']);
        }
        setState(() {
          cargando = false;
        });
      });
    } else if (tokenKey != 'none') {
      if (_temporizador?.isActive ?? false) {
        _temporizador?.cancel();
      }
      setState(() {
        cargando = true;
      });
      _temporizador = Timer(const Duration(seconds: 2), () async {
        var resulLugares = await MapServices().geMasDetallesLugar(tokenKey);
        List<dynamic> lugaresCercanos = resulLugares['results'] as List;

        allLugares.addAll(lugaresCercanos);

        tokenKey = resulLugares['next_page_token'] ?? 'none';
        for (var element in lugaresCercanos) {
          setLugaresMarker(
              LatLng(element['geometry']['location']['lat'],
                  element['geometry']['location']['lng']),
              element['name'],
              element['types'],
              element['opening_hours'] != null
                  ? element['opening_hours']['open_now'].toString() ??
                      'No disponible' //El elemento open_now no es obligatorio por lo que a veces no lo trae
                  : 'No disponible',
              element['rating'] != null
                  ? element['rating'].toString()
                  : 'No disponible',
              element['place_id']);
        }
        setState(() {
          cargando = false;
        });
      });
    } else {}
  }

  ///Añade el marcador de la posicion del usuario
  void aniadirUserMarker(String markerId, LatLng pos) {
    var marker = Marker(
        markerId: MarkerId(markerId),
        position: pos,
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueOrange),
        infoWindow: InfoWindow(title: markerId));

    _marcadores[markerId] = marker;
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
