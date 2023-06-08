import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

class MapServices{

  Future<dynamic> getDetallesLugar(LatLng coord, int radio) async{
    var key='AIzaSyC5YstKsWGxE_29dDccBbRe17VkpxtYymw';
    var lat = coord.latitude;
    var long = coord.longitude;

    final String url = 'https://maps.googleapis.com/maps/api/place/nearbysearch/json&location=$lat,$long&radius=$radio&key=$key';

    var respuesta = await http.get(Uri.parse(url));
    var json = convert.jsonDecode(respuesta.body);

    return json;
  }
}