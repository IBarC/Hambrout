import 'package:flutter/material.dart';
import 'package:hambrout/enum/enum_usuario.dart';
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

  @override
  void initState() {
    super.initState();
    inicializar();
  }

  void inicializar()async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    username=prefs.getString(dU(DatosUsuario.username))!;
  }
  
  @override
  Widget build(BuildContext context) {

    Size media = MediaQuery.of(context).size;
    
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(media.height/30),
        child: FutureBuilder(
          future: conexionDatos.getUsuario(username),
          builder: ((context, snapshot){
            return ListView(
              children: [
                Text(snapshot.data?[dU(DatosUsuario.nombre)], textAlign: TextAlign.center,),
                Text(snapshot.data?[dU(DatosUsuario.username)], textAlign: TextAlign.center,),
                formatosDisenio.separacionNormal(context),
                GestureDetector(
                  onTap:(){print('Tocado datos de la cuenta');},
                  child: Container(
                    decoration: const BoxDecoration(color: Colors.cyanAccent),
                    child: Text('Datos de la cuenta'),
                  ),
                ),
                formatosDisenio.separacionNormal(context),
                GestureDetector(
                  onTap:(){print('Tocado datos de la cuenta');},
                  child: Container(
                    decoration: const BoxDecoration(color: Colors.cyanAccent),
                    child: Text('Cerrar sesión'),
                  ),
                ),
                formatosDisenio.separacionNormal(context),
                GestureDetector(
                  onTap:(){print('Tocado datos de la cuenta');},
                  child: Container(
                    decoration: const BoxDecoration(color: Colors.cyanAccent),
                    child: Text('Eliminar cuenta'),
                  ),
                ),
                formatosDisenio.separacionNormal(context),
                GestureDetector(
                  onTap:(){print('Tocado datos de la cuenta');},
                  child: Container(
                    decoration: const BoxDecoration(color: Colors.cyanAccent),
                    child: Text('Creditos'),
                  ),
                ),
              ],
            );
          }),
        ),
      )
    );
  }

}