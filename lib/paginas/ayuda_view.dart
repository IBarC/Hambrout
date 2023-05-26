import 'package:flutter/material.dart';
import 'package:hambrout/enum/enum_usuario.dart';
import 'package:hambrout/paginas/datos_cuenta_view.dart';
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
                child: Text('Datos de la cuenta'),
              ),
            ),
            formatosDisenio.separacionNormal(context),
            GestureDetector(
              onTap:(){},
              child: Container(
                decoration: const BoxDecoration(color: Colors.cyanAccent),
                child: Text('Cerrar sesión'),
              ),
            ),
            formatosDisenio.separacionNormal(context),
            GestureDetector(
              onTap:(){},
              child: Container(
                decoration: const BoxDecoration(color: Colors.cyanAccent),
                child: Text('Eliminar cuenta'),
              ),
            ),
            formatosDisenio.separacionNormal(context),
            GestureDetector(
              onTap:(){},
              child: Container(
                decoration: const BoxDecoration(color: Colors.cyanAccent),
                child: Text('Creditos'),
              ),),],
        )
      )
    );
  }

}