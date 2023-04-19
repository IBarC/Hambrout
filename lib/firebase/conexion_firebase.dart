import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:hambrout/firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  try{
    final collection = FirebaseFirestore.instance.collection('userdata');

    await collection.doc().set({
      'username':"pepe",
      'password': 'hola'
    });
  } catch(_){

  }
}

class ConexionDatos {

}