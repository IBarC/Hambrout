import 'package:flutter/material.dart';
import 'package:hambrout/enum/enum_usuario.dart';
import 'package:hambrout/paginas/datos_cuenta_view.dart';
import 'package:hambrout/paginas/login_view.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../utils/formularios.dart';

class AyudaWidget extends StatefulWidget{
  const AyudaWidget({super.key});

  @override
  State<StatefulWidget> createState() {
    return AyudaState();
  }
}

class AyudaState extends State<AyudaWidget>{
  String username='';
  String nombre ='';
  late SharedPreferences prefs;

  @override
  void initState() {
    super.initState();
    inicializar();

  }

  void inicializar()async{
    prefs = await SharedPreferences.getInstance();
    username=prefs.getString(dU(DatosUsuario.username))??'';
    nombre=prefs.getString(dU(DatosUsuario.nombre))??'';
    setState(() {});
  }

  void accionCerrarOEliminar(){
    prefs.setString(dU(DatosUsuario.username), '');
    prefs.setBool(dU(DatosUsuario.sesionIniciada),false);
    prefs.setString(dU(DatosUsuario.nombre), '');
    prefs.setString(dU(DatosUsuario.apellidos), '');
    Navigator.of(context, rootNavigator: true)
        .pushAndRemoveUntil(
      MaterialPageRoute(
        builder: (BuildContext context) {
          return const LogInWidget();
        },),
          (_) => false,);
  }

  void alertCerarSesion(){
    showDialog(
        context: context,
        builder: (context){
          return AlertDialog(
            title: Text('Se cerrará sesión'),
            content: Text('¿Quiere cerrar la sesión de la cuenta $username?'),
            actions: <Widget>[
              ElevatedButton(onPressed: accionCerrarOEliminar, child: Text('Si')),
              ElevatedButton(onPressed: (){Navigator.pop(context);}, child: Text('No'))
            ],
          );
        }
    );
  }

  void alertEliminarCuenta(){
    showDialog(
        context: context,
        builder: (context){
          return AlertDialog(
            title: Text('Se eliminará la cuenta'),
            content: Text('¡Cuidado! La cuenta de $username está a punto de ser eliminada. ¿Está seguro de su decisión?'),
            actions: <Widget>[
              ElevatedButton(onPressed: (){conexionDatos.borrarUsuario(username);accionCerrarOEliminar();}, child: Text('Si')),
              ElevatedButton(onPressed: (){Navigator.pop(context);}, child: Text('No'))
            ],
          );
        }
    );
  }
  
  @override
  Widget build(BuildContext context) {

    Size media = MediaQuery.of(context).size;
    
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(media.height/30),
        child: ListView(
          children: [
            Text(nombre, textAlign: TextAlign.center,),
            Text(username, textAlign: TextAlign.center,),
            formatosDisenio.separacionNormal(context),
            GestureDetector(
              onTap:(){Navigator.push(context, MaterialPageRoute(builder: (context){
                return DatosCuentaWidget();
              }));},
              child: Container(
                decoration: const BoxDecoration(color: Colors.cyanAccent),
                child: const Text('Datos de la cuenta'),
              ),
            ),
            formatosDisenio.separacionNormal(context),
            GestureDetector(
              onTap:(){
                alertCerarSesion();
              },
              child: Container(
                decoration: const BoxDecoration(color: Colors.cyanAccent),
                child: const Text('Cerrar sesión'),
              ),
            ),
            formatosDisenio.separacionNormal(context),
            GestureDetector(
              onTap:(){
                alertEliminarCuenta();
              },
              child: Container(
                decoration: const BoxDecoration(color: Colors.cyanAccent),
                child: const Text('Eliminar cuenta'),
              ),
            ),
            formatosDisenio.separacionNormal(context),
            GestureDetector(
              onTap:(){},
              child: Container(
                decoration: const BoxDecoration(color: Colors.cyanAccent),
                child: const Text('Creditos'),
              ),),],
        )
      )
    );
  }

}