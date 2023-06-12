import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

///Clase que contiene los métodos que conectan con la API
class MapServices{
  var key='AIzaSyC5YstKsWGxE_29dDccBbRe17VkpxtYymw';

  ///Obtiene los datos de los lugares
  Future<dynamic> getDetallesLugar(LatLng coord, int radio, String tipo) async{
    var lat = coord.latitude;
    var long = coord.longitude;

    final String url = 'https://maps.googleapis.com/maps/api/place/nearbysearch/json?&location=$lat,$long&radius=$radio&type=$tipo&key=$key';

    var respuesta = await http.get(Uri.parse(url));
    var json = convert.jsonDecode(respuesta.body);

    return json;
  }

  ///Obtiene más datos de lugares usando 'next_page_token'
  Future<dynamic> geMasDetallesLugar(String token) async{

    final String url = 'https://maps.googleapis.com/maps/api/place/nearbysearch/json?&pagetoken=$token&key=$key';

    var respuesta = await http.get(Uri.parse(url));
    var json = convert.jsonDecode(respuesta.body);

    return json;
  }

  ///Obtiene información más detallada de un lugar
  Future<Map<String, dynamic>> getLugar(String? palceId) async {
    final String url =
        'https://maps.googleapis.com/maps/api/place/details/json?place_id=$palceId&key=$key';

    var response = await http.get(Uri.parse(url));

    var json = convert.jsonDecode(response.body);

    var results = json['result'] as Map<String, dynamic>;

    return results;
  }

  ///Obtiene los datos de una ruta andando
  Future<dynamic> getDireccionAndando(double latOrigen, double longOrigen, double latDestino, double longDestino) async {
    final String url =
        "https://maps.googleapis.com/maps/api/directions/json?origin=$latOrigen,$longOrigen&destination=$latDestino,$longDestino"
        "&mode=walking&key=$key";

    var response = await http.get(Uri.parse(url));

    var json = convert.jsonDecode(response.body);

    return json;
  }

  ///Obtiene los datos de una ruta en coche
  Future<dynamic> getDireccionCoche(double latOrigen, double longOrigen, double latDestino, double longDestino) async {
    final String url =
        "https://maps.googleapis.com/maps/api/directions/json?origin=$latOrigen,$longOrigen&destination=$latDestino,$longDestino"
        "&mode=driving&key=$key";

    var response = await http.get(Uri.parse(url));

    var json = convert.jsonDecode(response.body);

    return json;
  }

}