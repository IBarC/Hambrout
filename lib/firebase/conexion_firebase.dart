import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:hambrout/enum/enum_colecciones.dart';
import 'package:hambrout/enum/enum_listas.dart';
import 'package:hambrout/enum/enum_receta.dart';
import 'package:hambrout/enum/enum_usuario.dart';
import 'package:hambrout/firebase_options.dart';
import 'package:hambrout/models/lista.dart';
import 'package:hambrout/models/receta.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../main.dart';

class ConexionDatos {

  Future<void> crearUsuario(String nombre, String apellidos, String username, String password, String tel) async {
    WidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );

    try{
      final collection = FirebaseFirestore.instance.collection(colecciones(Colecciones.userdata));

      final datos = <String, dynamic>{
        datosUsu(DatosUsuario.nombre): nombre,
        datosUsu(DatosUsuario.apellidos): apellidos,
        datosUsu(DatosUsuario.username): username,
        datosUsu(DatosUsuario.password): password,
        datosUsu(DatosUsuario.telefono):tel
      };
      collection.doc(username).set(datos);
      collection.doc(username).collection(colecciones(Colecciones.listas)).doc('id').set({'id':0});
    } catch(_){

    }
  }

  Future<List> buscarUsuarios(String username, String password) async {
    WidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );

    List usuario = [];
    CollectionReference collectionReferenceUsuario = FirebaseFirestore.instance.collection(colecciones(Colecciones.userdata));

    QuerySnapshot queryUsuario = await collectionReferenceUsuario.get();

    for (var documento in queryUsuario.docs) {
      usuario.add(documento.data());
    }
    return usuario;
  }

  Future<Map<String,dynamic>> getUsuario(String username) async {
    WidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );

    CollectionReference collectionReferenceUsuario = FirebaseFirestore.instance.collection(colecciones(Colecciones.userdata));

    QuerySnapshot queryUsuario = await collectionReferenceUsuario.get();

    for (var documento in queryUsuario.docs) {
      var dato = documento.data() as Map<String, dynamic>;
      if(dato[datosUsu(DatosUsuario.username)]==username){
        return dato;
      }
    }
    return {};
  }

  Future<bool> existeUsuario(String username) async {
    WidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );

    CollectionReference collectionReferenceUsuario = FirebaseFirestore.instance.collection(colecciones(Colecciones.userdata));

    QuerySnapshot queryUsuario = await collectionReferenceUsuario.get();

    for (var documento in queryUsuario.docs) {
      var dato = documento.data() as Map<String, dynamic>;
      if(dato[datosUsu(DatosUsuario.username)]==username){
        return true;
      }
    }
    return false;
  }


  Future<void> borrarUsuario(String nombre) async {
    WidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );

    try{
      final collection = FirebaseFirestore.instance.collection(colecciones(Colecciones.userdata));
      await collection.doc(nombre).delete();
    } catch(_){

    }
  }

  Future<List> buscarRecetas() async{
    WidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );

    List recetas = [];
    CollectionReference collectionReferenceRecetas = FirebaseFirestore.instance.collection(colecciones(Colecciones.recetas));

    QuerySnapshot queryRecetas = await collectionReferenceRecetas.get();

    for (var documento in queryRecetas.docs) {
      recetas.add(documento.data());
    }
    return recetas;
  }

  Future<void> crearRecetaFav(Receta r) async {
    WidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? username = prefs.getString(datosUsu(DatosUsuario.username));

    try{
      final collection = FirebaseFirestore.instance.collection(colecciones(Colecciones.userdata));

      final datos = <String, dynamic>{
        datosReceta(DatosReceta.nombre):r.nombre,
        datosReceta(DatosReceta.dificultad):r.dificultad,
        datosReceta(DatosReceta.elaboracion):r.elaboracion,
        datosReceta(DatosReceta.foto):r.foto,
        datosReceta(DatosReceta.ingredientes):r.ingredientes,
        datosReceta(DatosReceta.npersonas):r.npersonas,
        datosReceta(DatosReceta.origen):r.origen,
        datosReceta(DatosReceta.tiempo):r.tiempo,
        datosReceta(DatosReceta.tipo):r.tipo,
      };
      collection.doc(username).collection(colecciones(Colecciones.recetasFavs)).doc(r.nombre).set(datos);
    } catch(_){

    }
  }

  Future<List> buscarRecetasFavs() async{
    WidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? username = prefs.getString(datosUsu(DatosUsuario.username));

    List recetas = [];
    CollectionReference collectionReferenceRecetas = FirebaseFirestore.instance.collection(colecciones(Colecciones.userdata));

    QuerySnapshot queryRecetas = await collectionReferenceRecetas.doc(username).collection(colecciones(Colecciones.recetasFavs)).get();

    for (var documento in queryRecetas.docs) {
      recetas.add(documento.data());
    }
    return recetas;
  }

  Future<void> borrarRecetaFav(String nombre) async {
    WidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? username = prefs.getString(datosUsu(DatosUsuario.username));

    try{
      final collection = FirebaseFirestore.instance.collection(colecciones(Colecciones.userdata));
      await collection.doc(username).collection(colecciones(Colecciones.recetasFavs)).doc(nombre).delete();
    } catch(_){

    }
  }

  Future<List> buscarListas() async{
    WidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? username = prefs.getString(datosUsu(DatosUsuario.username));

    List listas = [];
    CollectionReference collectionReferenceRecetas = FirebaseFirestore.instance.collection(colecciones(Colecciones.userdata));

    QuerySnapshot queryListas = await collectionReferenceRecetas.doc(username).collection(colecciones(Colecciones.listas)).get();
    for (var documento in queryListas.docs) {
      if(documento.id!='id'){
        listas.add(documento.data());
      }
    }
    listas.sort((a, b)=>DateTime.parse(b['modificacion']).compareTo(DateTime.parse(a['modificacion'])));
    return listas;
  }

  Future<void> guardarLista(Lista lista) async{
    WidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? username = prefs.getString(datosUsu(DatosUsuario.username));

    try{
      final collection = FirebaseFirestore.instance.collection(colecciones(Colecciones.userdata));

      final datos = <String, dynamic>{
        listas(DatosListas.titulo):lista.titulo,
        listas(DatosListas.elementos):guardarElementos(lista.elementos),
        listas(DatosListas.id):lista.id,
        'modificacion':DateTime.now().toUtc().toString()
      };
      collection.doc(username).collection(colecciones(Colecciones.listas)).doc(lista.id.toString()).set(datos);

    } catch(_) {}
  }

  Future<void> guardarListaNueva(Lista lista) async{
    WidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? username = prefs.getString(datosUsu(DatosUsuario.username));

    try{
      final collection = FirebaseFirestore.instance.collection(colecciones(Colecciones.userdata));

      List id = [];
      CollectionReference crId = FirebaseFirestore.instance.collection(colecciones(Colecciones.userdata));

      QuerySnapshot queryListas = await crId.doc(username).collection(colecciones(Colecciones.listas)).get();
      for (var documento in queryListas.docs) {
        if(documento.id=='id'){
          id.add(documento.data());
          break;
        }
      }
      id[0]['id']++;

      lista.id=id[0]['id'];

      final datos = <String, dynamic>{
        listas(DatosListas.titulo):lista.titulo,
        listas(DatosListas.elementos):guardarElementos(lista.elementos),
        listas(DatosListas.id):lista.id,
        'modificacion':DateTime.now().toUtc().toString()
      };
      collection.doc(username).collection(colecciones(Colecciones.listas)).doc(lista.id.toString()).set(datos);
      collection.doc(username).collection(colecciones(Colecciones.listas)).doc(listas(DatosListas.id)).set({'id':lista.id});

    } catch(_) {}
    keys[2].currentState!.refreshPage();
  }

  List<Map<String, dynamic>> guardarElementos(List elementos){
    List<Map<String, dynamic>> lista = [];
    for(var elem in elementos){
      if(elem.controlador.text!=''){
        lista.add({
          listas(DatosListas.nombre):elem.controlador.text,
          listas(DatosListas.tachado):elem.tachado,

        });
      }
    }

    return lista;
  }
}