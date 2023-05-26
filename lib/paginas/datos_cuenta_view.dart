import 'package:back_button_interceptor/back_button_interceptor.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../enum/enum_usuario.dart';

class DatosCuentaWidget extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return DatosCuentaState();
  }

}

class DatosCuentaState extends State<DatosCuentaWidget>{

  late SharedPreferences prefs;
  String username='';
  String nombre='';
  String apellidos='';

  @override
  void initState() {
    super.initState();
    inicializar();
    BackButtonInterceptor.add(interceptor);
  }

  @override
  void dispose() {
    BackButtonInterceptor.remove(interceptor);
    super.dispose();
  }

  void inicializar()async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    username=prefs.getString(dU(DatosUsuario.username))??'no user';
    nombre = prefs.getString(dU(DatosUsuario.nombre))??'no nombre';
    apellidos = prefs.getString(dU(DatosUsuario.apellidos))??'no apellidos';
    setState(() {});
  }

  bool interceptor(bool stopDefaultButtonEvent, RouteInfo info) {
    Navigator.pop(context);
    return true;
  }

  @override
  Widget build(BuildContext context) {
    Size media = MediaQuery.of(context).size;

    return Scaffold(
      body: Container(
        height: media.height,
        width: media.width,
        decoration: const BoxDecoration(color: Colors.white70),
        child: Padding(
          padding: EdgeInsets.all(media.height/50),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [ IconButton(onPressed: (){
                  Navigator.pop(context);},
                    icon: const Icon(Icons.arrow_back_ios_new))
                ],
              ),
              Row(children: [Text('$nombre $apellidos $username')],)
            ],
          ),
        ),
      ) ,
    );
  }

}