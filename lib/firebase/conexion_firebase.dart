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

  Future<void> crearUsuario(String username, String password) async {
    WidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );

    try{
      final collection = FirebaseFirestore.instance.collection('userdata');

      final datos = <String, dynamic>{
        'username': username,
        'password': password
      };
      collection.doc(username).set(datos);
    } catch(_){

    }
  }

  late bool existeUsu=true;

  void existeUser(String username, String password) async{
    existeUsu = await existeUsuario(username, password);
  }

  Future<bool> existeUsuario(String username, String password) async {
    WidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );

    try{
      final collection = FirebaseFirestore.instance.collection('userdata');

      final documento = collection.doc(username);
      documento.get().then((DocumentSnapshot? docSnap) {

        if(docSnap?.data()!=null){
          final datos = docSnap?.data() as Map<String, dynamic>;
          if(datos['username']==username && datos['password']==password){
            print("---------------------------------------------> $datos BIEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEN");

            return true;
          }
          print("---------------------------------------------> $datos MAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAL");

        }
      });
    } catch(_){
    }
    print("---------------------------------------------> MAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAL");
    return false;
  }

}