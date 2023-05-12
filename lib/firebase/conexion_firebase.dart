import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:hambrout/enum/enum_colecciones.dart';
import 'package:hambrout/enum/enum_receta.dart';
import 'package:hambrout/enum/enum_usuario.dart';
import 'package:hambrout/firebase_options.dart';
import 'package:hambrout/models/receta.dart';
import 'package:shared_preferences/shared_preferences.dart';

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

  Future<List> existeUsuario(String username, String password) async {
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
      listas.add(documento.data());
    }
    return listas;
  }

}