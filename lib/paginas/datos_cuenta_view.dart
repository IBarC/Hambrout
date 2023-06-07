import 'package:back_button_interceptor/back_button_interceptor.dart';
import 'package:flutter/material.dart';
import 'package:hambrout/utils/formularios.dart';
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
  String telefono='';

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
    telefono=prefs.getString(dU(DatosUsuario.telefono))??'no telefono';
    setState(() {});
  }

  bool interceptor(bool stopDefaultButtonEvent, RouteInfo info) {
    Navigator.pop(context);
    return true;
  }
  
  InputDecoration decoracionTxt(String label){
    return InputDecoration(
        disabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.orange, width: 1),borderRadius: BorderRadius.all(Radius.circular(7))),
        labelStyle: formatosDisenio.txtLabelDatosUsu(context),
        hintText: label,
        labelText: label);
  }

  @override
  Widget build(BuildContext context) {
    Size media = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: GestureDetector(
        child: const Icon(Icons.arrow_back_ios, color: Colors.black,),
        onTap: (){Navigator.pop(context);},
      ),),
      body: Container(
        height: media.height,
        width: media.width,
        decoration: const BoxDecoration(color: Colors.white70),
        child: Padding(
          padding: EdgeInsets.only(left: media.height/50,right: media.height/50),
          child: ListView(
            shrinkWrap: true,
            scrollDirection: Axis.vertical,
            children: [
              Text('Datos de la cuenta', style: formatosDisenio.txtTituloRec(context)),
              formatosDisenio.separacionNormal(context),
              TextFormField(
                decoration: decoracionTxt('Nombre'),
                style: formatosDisenio.txtInfoDatosUsu(context),
                controller: TextEditingController(text: nombre),
                enabled: false,
              ),
              formatosDisenio.separacionPequenia(context),
              TextFormField(
                decoration: decoracionTxt('Apellidos'),
                style: formatosDisenio.txtInfoDatosUsu(context),
                controller: TextEditingController(text: apellidos),
                enabled: false,
              ),
              formatosDisenio.separacionPequenia(context),
              TextFormField(
                decoration: decoracionTxt('Correo'),
                style: formatosDisenio.txtInfoDatosUsu(context),
                controller: TextEditingController(text: username),
                enabled: false,
              ),
              formatosDisenio.separacionPequenia(context),
              TextFormField(
                decoration: decoracionTxt('Teléfono'),
                style: formatosDisenio.txtInfoDatosUsu(context),
                controller: TextEditingController(text: telefono),
                enabled: false,
              ),
            ],
          )
        ),
      ) ,
    );
  }

}