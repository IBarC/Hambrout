import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:hambrout/firebase_options.dart';

class ConexionDatos {

  Future<void> crearUsuario(String nombre, String apellidos, String username, String password) async {
    WidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );

    try{
      final collection = FirebaseFirestore.instance.collection('userdata');

      final datos = <String, dynamic>{
        'nombre': nombre,
        'apellidos': apellidos,
        'username': username,
        'password': password
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
    CollectionReference collectionReferenceUsuario = FirebaseFirestore.instance.collection('userdata');

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
    CollectionReference collectionReferenceRecetas = FirebaseFirestore.instance.collection('recetas');

    QuerySnapshot queryRecetas = await collectionReferenceRecetas.get();

    for (var documento in queryRecetas.docs) {
      recetas.add(documento.data());
    }

    return recetas;
  }

}