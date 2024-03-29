import 'package:back_button_interceptor/back_button_interceptor.dart';
import 'package:flutter/material.dart';
import 'package:hambrout/utils/formatos_disenio.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../enum/enum_usuario.dart';

/// Clase que genera la vista de Datos de la cuenta
class DatosCuentaWidget extends StatefulWidget {
  const DatosCuentaWidget({super.key});

  @override
  State<StatefulWidget> createState() {
    return DatosCuentaState();
  }
}

class DatosCuentaState extends State<DatosCuentaWidget> {
  late SharedPreferences prefs;
  String username = '';
  String nombre = '';
  String apellidos = '';
  String telefono = '';

  @override
  void initState() {
    super.initState();
    inicializar();

    ///Añade un interceptor que permite controlar el listener del botón atrás del dispositivo
    BackButtonInterceptor.add(interceptor);
  }

  @override
  void dispose() {
    BackButtonInterceptor.remove(interceptor);
    super.dispose();
  }

  void inicializar() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    username = prefs.getString(datosUsu(DatosUsuario.username)) ?? 'no user';
    nombre = prefs.getString(datosUsu(DatosUsuario.nombre)) ?? 'no nombre';
    apellidos = prefs.getString(datosUsu(DatosUsuario.apellidos)) ?? 'no apellidos';
    telefono = prefs.getString(datosUsu(DatosUsuario.telefono)) ?? 'no telefono';
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
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: GestureDetector(
          child: const Icon(
            Icons.arrow_back_ios,
            color: Colors.black,
          ),
          onTap: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Container(
        height: media.height,
        width: media.width,
        decoration: const BoxDecoration(color: Colors.white70),
        child: Padding(
            padding: EdgeInsets.only(
                left: media.height / 50, right: media.height / 50),
            child: ListView(
              shrinkWrap: true,
              scrollDirection: Axis.vertical,
              children: [
                Text('Datos de la cuenta',
                    style: FormatosDisenio().txtTituloRec(context)),
                FormatosDisenio().separacionNormal(context),
                TextFormField(
                  decoration:
                      FormatosDisenio().decoracionFormDatos(context, 'Nombre'),
                  style: FormatosDisenio().txtInfoDatosUsu(context),
                  controller: TextEditingController(text: nombre),
                  enabled: false,
                ),
                FormatosDisenio().separacionPequenia(context),
                TextFormField(
                  decoration: FormatosDisenio()
                      .decoracionFormDatos(context, 'Apellidos'),
                  style: FormatosDisenio().txtInfoDatosUsu(context),
                  controller: TextEditingController(text: apellidos),
                  enabled: false,
                ),
                FormatosDisenio().separacionPequenia(context),
                TextFormField(
                  decoration:
                      FormatosDisenio().decoracionFormDatos(context, 'Correo'),
                  style: FormatosDisenio().txtInfoDatosUsu(context),
                  controller: TextEditingController(text: username),
                  enabled: false,
                ),
                FormatosDisenio().separacionPequenia(context),
                TextFormField(
                  decoration: FormatosDisenio()
                      .decoracionFormDatos(context, 'Teléfono'),
                  style: FormatosDisenio().txtInfoDatosUsu(context),
                  controller: TextEditingController(text: telefono),
                  enabled: false,
                ),
              ],
            )),
      ),
    );
  }
}
