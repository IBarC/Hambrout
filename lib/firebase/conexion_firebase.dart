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
import 'package:hambrout/paginas/casa_view.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../main.dart';

class ConexionDatos {

  Future<void> crearUsuario(String nombre, String apellidos, String username, String password) async {
    WidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );

    try{
      final collection = FirebaseFirestore.instance.collection(c(Colecciones.userdata));

      final datos = <String, dynamic>{
        dU(DatosUsuario.nombre): nombre,
        dU(DatosUsuario.apellidos): apellidos,
        dU(DatosUsuario.username): username,
        dU(DatosUsuario.password): password
      };
      collection.doc(username).set(datos);
    } catch(_){

    }
  }

  Future<List> buscarUsuarios(String username, String password) async {
    WidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );

    List usuario = [];
    CollectionReference collectionReferenceUsuario = FirebaseFirestore.instance.collection(c(Colecciones.userdata));

    QuerySnapshot queryUsuario = await collectionReferenceUsuario.get();

    for (var documento in queryUsuario.docs) {
      usuario.add(documento.data());
    }
    return usuario;
  }

  Future<bool> existeUsuario(String username) async {
    WidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );

    List usuario = [];
    CollectionReference collectionReferenceUsuario = FirebaseFirestore.instance.collection(c(Colecciones.userdata));

    QuerySnapshot queryUsuario = await collectionReferenceUsuario.get();

    for (var documento in queryUsuario.docs) {
      var dato = documento.data() as Map<String, dynamic>;
      if(dato[dU(DatosUsuario.username)]==username){
        return true;
      }
    }
    return false;
  }

  Future<List> buscarRecetas() async{
    WidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );

    List recetas = [];
    CollectionReference collectionReferenceRecetas = FirebaseFirestore.instance.collection(c(Colecciones.recetas));

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
    String? username = prefs.getString(dU(DatosUsuario.username));

    try{
      final collection = FirebaseFirestore.instance.collection(c(Colecciones.userdata));

      final datos = <String, dynamic>{
        dR(DatosReceta.nombre):r.nombre,
        dR(DatosReceta.dificultad):r.dificultad,
        dR(DatosReceta.elaboracion):r.elaboracion,
        dR(DatosReceta.foto):r.foto,
        dR(DatosReceta.ingredientes):r.ingredientes,
        dR(DatosReceta.npersonas):r.npersonas,
        dR(DatosReceta.origen):r.origen,
        dR(DatosReceta.tiempo):r.tiempo,
        dR(DatosReceta.tipo):r.tipo,
      };
      collection.doc(username).collection(c(Colecciones.recetasFavs)).doc(r.nombre).set(datos);
    } catch(_){

    }
  }

  Future<List> buscarRecetasFavs() async{
    WidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? username = prefs.getString(dU(DatosUsuario.username));

    List recetas = [];
    CollectionReference collectionReferenceRecetas = FirebaseFirestore.instance.collection(c(Colecciones.userdata));

    QuerySnapshot queryRecetas = await collectionReferenceRecetas.doc(username).collection(c(Colecciones.recetasFavs)).get();

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
    String? username = prefs.getString(dU(DatosUsuario.username));

    try{
      final collection = FirebaseFirestore.instance.collection(c(Colecciones.userdata));
      await collection.doc(username).collection(c(Colecciones.recetasFavs)).doc(nombre).delete();
    } catch(_){

    }
  }

  Future<List> buscarListas() async{
    WidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? username = prefs.getString(dU(DatosUsuario.username));

    List listas = [];
    CollectionReference collectionReferenceRecetas = FirebaseFirestore.instance.collection(c(Colecciones.userdata));

    QuerySnapshot queryListas = await collectionReferenceRecetas.doc(username).collection(c(Colecciones.listas)).get();
    for (var documento in queryListas.docs) {
      if(documento.id!='id'){
        listas.add(documento.data());
      }
    }
    return listas;
  }
/**
  Future<List> documentosActualizados() async{
    WidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? username = prefs.getString(dU(DatosUsuario.username));

    List docs = [];
    CollectionReference collectionReferenceDocumentos = FirebaseFirestore.instance.collection(c(Colecciones.userdata));

    QuerySnapshot queryDocumentos = await collectionReferenceDocumentos.doc(username).collection(c(Colecciones.listas)).get();
    for (var documento in queryDocumentos.docChanges) {
      print('------------------${documento.doc}');
      docs.add(documento.doc);
    }
    return docs;
  }**/

  Future<void> guardarListas(Lista lista) async{
    WidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? username = prefs.getString(dU(DatosUsuario.username));

    try{
      final collection = FirebaseFirestore.instance.collection(c(Colecciones.userdata));

      List id = [];
      CollectionReference crId = FirebaseFirestore.instance.collection(c(Colecciones.userdata));

      QuerySnapshot queryListas = await crId.doc(username).collection(c(Colecciones.listas)).get();
      for (var documento in queryListas.docs) {
        if(documento.id=='id'){
          id.add(documento.data());
          break;
        }
      }
      id[0]['id']++;

      lista.id=id[0]['id'];

      final datos = <String, dynamic>{
        l(DatosListas.titulo):lista.titulo,
        l(DatosListas.elementos):guardarElementos(lista.elementos),
        l(DatosListas.id):lista.id
      };
      collection.doc(username).collection(c(Colecciones.listas)).doc(lista.id.toString()).set(datos);
      collection.doc(username).collection(c(Colecciones.listas)).doc(l(DatosListas.id)).set({'id':lista.id});

    } catch(_) {}
    keys[2].currentState!.refreshPage();
  }

  List<Map<String, dynamic>> guardarElementos(List elementos){
    List<Map<String, dynamic>> lista = [];
    for(var elem in elementos){
      if(elem.controlador.text!=''){
        lista.add({
          l(DatosListas.nombre):elem.controlador.text,
          l(DatosListas.tachado):elem.tachado,

        });
      }
    }

    return lista;
  }
}