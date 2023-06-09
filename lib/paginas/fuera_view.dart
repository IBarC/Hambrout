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
    pageController = PageController(
      initialPage: 1, viewportFraction: 0.85)..addListener(alDeslizar);
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

  void setLugaresMarker(LatLng pos, String label, List tipos, String estado) async{
    var counter = markerIdCounter++;

    final Marker marker;

    //if(tipos.contains('restaurant')||tipos.contains('food')||tipos.contains('bar')||tipos.contains('bakery')
        //||tipos.contains('cafe')){
      marker = Marker(
        markerId: MarkerId('marcador_$counter'),
        position: pos,
        onTap: (){},
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
        infoWindow: InfoWindow(title: label, onTap: (){

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
          Positioned(
            bottom: 20.0,
            child: Container(
              height: 200,
              width: MediaQuery.of(context).size.width,
              child: PageView.builder(
                controller: pageController,
                itemCount: allLugares.length,
                itemBuilder: (BuildContext context, int index){
                  return nearbyPlacesList(index);
                },
              ),
            ),
          )
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

  nearbyPlacesList(index) {
    return AnimatedBuilder(
      animation: pageController,
      builder: (BuildContext context, Widget? widget) {
        double value = 1;
        if (pageController.position.haveDimensions) {
          value = (pageController.page! - index);
          value = (1 - (value.abs() * 0.3) + 0.06).clamp(0.0, 1.0);
        }
        return Center(
          child: SizedBox(
            height: Curves.easeInOut.transform(value) * 125.0,
            width: Curves.easeInOut.transform(value) * 350.0,
            child: widget,
          ),
        );
      },
      child: InkWell(
        onTap: () async {
          cardTapped = !cardTapped;
          if (cardTapped) {
            tappedPlaceDetail = await MapServices()
                .getPlace(allLugares[index]['place_id']);
            setState(() {});
          }
          moveCameraSlightly();
        },
        child: Stack(
          children: [
            Center(
              child: Container(
                margin: EdgeInsets.symmetric(
                  horizontal: 10.0,
                  vertical: 20.0,
                ),
                height: 125.0,
                width: 275.0,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.0),
                    boxShadow: [
                      BoxShadow(
                          color: Colors.black54,
                          offset: Offset(0.0, 4.0),
                          blurRadius: 10.0)
                    ]),
                child: Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.0),
                      color: Colors.white),
                  child: Row(
                    children: [
                      pageController.position.haveDimensions
                          ? pageController.page!.toInt() == index
                          ? Container(
                        height: 90.0,
                        width: 90.0,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(10.0),
                              topLeft: Radius.circular(10.0),
                            ),
                            image: DecorationImage(
                                image: NetworkImage(imagenSitio != ''
                                    ? 'https://maps.googleapis.com/maps/api/place/photo?maxwidth=400&photo_reference=$imagenSitio&key=$key'
                                    : 'https://pic.onlinewebfonts.com/svg/img_546302.png'),
                                fit: BoxFit.cover)),
                      )
                          : Container(
                        height: 90.0,
                        width: 20.0,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(10.0),
                              topLeft: Radius.circular(10.0),
                            ),
                            color: Colors.blue),
                      )
                          : Container(),
                      SizedBox(width: 5.0),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: 170.0,
                            child: Text(allLugares[index]['name'],
                                style: TextStyle(
                                    fontSize: 12.5,
                                    fontFamily: 'WorkSans',
                                    fontWeight: FontWeight.bold)),
                          ),
                          /**RatingStars(
                            value: allLugares[index]['rating']
                                .runtimeType ==
                                int
                                ? allLugares[index]['rating'] * 1.0
                                : allLugares[index]['rating'] ?? 0.0,
                            starCount: 5,
                            starSize: 10,
                            valueLabelColor: const Color(0xff9b9b9b),
                            valueLabelTextStyle: TextStyle(
                                color: Colors.white,
                                fontFamily: 'WorkSans',
                                fontWeight: FontWeight.w400,
                                fontStyle: FontStyle.normal,
                                fontSize: 12.0),
                            valueLabelRadius: 10,
                            maxValue: 5,
                            starSpacing: 2,
                            maxValueVisibility: false,
                            valueLabelVisibility: true,
                            animationDuration: Duration(milliseconds: 1000),
                            valueLabelPadding: const EdgeInsets.symmetric(
                                vertical: 1, horizontal: 8),
                            valueLabelMargin: const EdgeInsets.only(right: 8),
                            starOffColor: const Color(0xffe7e8ea),
                            starColor: Colors.yellow,
                          ),**/
                          Container(
                            width: 170.0,
                            child: Text(
                              allLugares[index]['business_status'] ??
                                  'none',
                              style: TextStyle(
                                  color: allLugares[index]
                                  ['business_status'] ==
                                      'OPERATIONAL'
                                      ? Colors.green
                                      : Colors.red,
                                  fontSize: 11.0,
                                  fontWeight: FontWeight.w700),
                            ),
                          )
                        ],
                      )
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
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