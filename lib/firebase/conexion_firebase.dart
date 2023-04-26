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

  //FirebaseFirestore db = FirebaseFirestore.instance;

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

  //late bool existeUsu=true;

  //void existeUser(String username, String password) async{
    //existeUsu = await existeUsuario(username, password);
  //}

  Future<List> existeUsuario(String username, String password) async {
    WidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );

    List usuario = [];
    CollectionReference collectionReferenceUsuario = FirebaseFirestore.instance.collection('userdata');

    final document = collectionReferenceUsuario.doc(username);
    //document.get();

    QuerySnapshot queryUsuario = await collectionReferenceUsuario.get();

    queryUsuario.docs.forEach((documento) {
      print(documento.data());
      usuario.add(documento.data());
    });
    print("---------------------------------------------> $usuario BIEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEN");

    return usuario;pe

    /**try{
      final collection = FirebaseFirestore.instance.collection('userdata');

      final documento = collection.doc(username);
      documento.get().then((DocumentSnapshot? docSnap) async{

        if(await docSnap?.data()!=null){
          final datos = docSnap?.data() as Map<String, dynamic>;
          if(datos['username']==username && datos['password']==password){

            return true;
          }
          print("---------------------------------------------> $datos MAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAL");

        }
      });
    } catch(_){
    }
    print("---------------------------------------------> MAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAL");
    return {};
     **/

  }

}