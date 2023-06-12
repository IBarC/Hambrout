import 'package:flutter/material.dart';
import 'package:hambrout/enum/enum_usuario.dart';
import 'package:hambrout/paginas/datos_cuenta_view.dart';
import 'package:hambrout/paginas/login_view.dart';
import 'package:hambrout/utils/formatos_disenio.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../firebase/conexion_firebase.dart';

/// Clase que genera la vista de Ayuda
class AyudaWidget extends StatefulWidget {
  const AyudaWidget({super.key});

  @override
  State<StatefulWidget> createState() {
    return AyudaState();
  }
}

class AyudaState extends State<AyudaWidget> {
  String username = '';
  String nombre = '';
  String apellidos = '';
  late SharedPreferences prefs;

  @override
  void initState() {
    super.initState();
    inicializar();
  }

  void inicializar() async {
    prefs = await SharedPreferences.getInstance();
    username = prefs.getString(datosUsu(DatosUsuario.username)) ?? '';
    nombre = prefs.getString(datosUsu(DatosUsuario.nombre)) ?? '';
    apellidos = prefs.getString(datosUsu(DatosUsuario.apellidos)) ?? '';
    setState(() {});
  }

  /// Establece los valores a nada y lleva a la pantalla de LogIn cuando se
  /// pulsa 'si' en los Alerts de cerrar sesión o eliminar cuenta
  void accionCerrarOEliminar() {
    prefs.setString(datosUsu(DatosUsuario.username), '');
    prefs.setBool(datosUsu(DatosUsuario.sesionIniciada), false);
    prefs.setString(datosUsu(DatosUsuario.nombre), '');
    prefs.setString(datosUsu(DatosUsuario.apellidos), '');
    Navigator.of(context, rootNavigator: true).pushAndRemoveUntil(
      MaterialPageRoute(
        builder: (BuildContext context) {
          return const LogInWidget();
        },
      ),
      (_) => false,
    );
  }

  ///Crea un Alert con la lógica para cerrar la sesión
  void alertCerarSesion() {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            buttonPadding: const EdgeInsets.only(left: 30, right: 30),
            title: const Text('Se cerrará sesión'),
            content: Text(
              '¿Quiere cerrar la sesión de la cuenta $username?',
              style: FormatosDisenio().txtInfoAlert(context),
            ),
            actions: <Widget>[
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                style: FormatosDisenio().btnSeleccionAlert(),
                child: const Text('CANCELAR'),
              ),
              ElevatedButton(
                onPressed: accionCerrarOEliminar,
                style: FormatosDisenio().btnSeleccionAlert(),
                child: const Text('SI, CERRAR'),
              ),
            ],
          );
        });
  }

  ///Crea un Alert con la lógica para eliminar la cuenta
  void alertEliminarCuenta() {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            buttonPadding: const EdgeInsets.only(left: 30, right: 30),
            title: const Text('Se eliminará la cuenta'),
            content: Text(
              "¡Cuidado! La cuenta de $username está a punto de ser eliminada. "
              "¿Está seguro de su decisión?",
              style: FormatosDisenio().txtInfoAlert(context),
            ),
            actions: <Widget>[
              ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: FormatosDisenio().btnSeleccionAlert(),
                child: const Text('CANCELAR'),
              ),
              ElevatedButton(
                onPressed: () {
                  ConexionDatos().borrarUsuario(username);
                  accionCerrarOEliminar();
                },
                style: FormatosDisenio().btnSeleccionAlert(),
                child: const Text('SI, ELIMINAR'),
              ),
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    Size media = MediaQuery.of(context).size;

    return Scaffold(
        appBar: AppBar(
          elevation: 1,
          title: Text(
            ///Titulo de la vista
            'Ayuda',
            style: FormatosDisenio().txtTituloPag(context),
          ),
          backgroundColor: Colors.white,
        ),
        body: Padding(
            padding: EdgeInsets.all(media.height / 30),
            child: ListView(
              children: [
                Container(
                  padding: const EdgeInsets.only(top: 10, bottom: 10, left: 13),
                  decoration: FormatosDisenio().cajaAjustes(),
                  child: Column(
                    children: [
                      Text(
                        ///Nombre del usuario
                        nombre,
                        textAlign: TextAlign.center,
                        style: FormatosDisenio().txtTituloRecPrev(context),
                      ),
                      const SizedBox(
                        height: 7,
                      ),
                      Text(
                        ///Correo del usuario
                        username,
                        textAlign: TextAlign.center,
                        style: FormatosDisenio().txtAjustes(context),
                      ),
                    ],
                  ),
                ),
                FormatosDisenio().separacionNormal(context),
                GestureDetector( ///Contiene la caja y la lógica de datos de la cuenta
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
                      return const DatosCuentaWidget();
                    }));
                  },
                  child: Container(
                    padding: const EdgeInsets.only(
                        top: 10, bottom: 10, left: 13, right: 13),
                    decoration: FormatosDisenio().cajaAjustes(),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Datos de la cuenta',
                          style: FormatosDisenio().txtAjustes(context),
                        ),
                        const Icon(Icons.arrow_forward_ios)
                      ],
                    ),
                  ),
                ),
                FormatosDisenio().separacionNormal(context),
                GestureDetector( ///Contiene la caja de cerrar sesión
                  onTap: () => alertCerarSesion(),
                  child: Container(
                    padding:
                        const EdgeInsets.only(top: 10, bottom: 10, left: 13),
                    decoration: FormatosDisenio().cajaAjustes(),
                    child: Text(
                      'Cerrar sesión',
                      style: FormatosDisenio().txtAjustes(context),
                    ),
                  ),
                ),
                FormatosDisenio().separacionNormal(context),
                GestureDetector( ///Contien la caja de eliminar cuenta
                  onTap: () => alertEliminarCuenta(),
                  child: Container(
                    padding:
                        const EdgeInsets.only(top: 10, bottom: 10, left: 13),
                    decoration: FormatosDisenio().cajaAjustes(),
                    child: Text(
                      'Eliminar cuenta',
                      style: FormatosDisenio().txtAjustes(context),
                    ),
                  ),
                ),
                FormatosDisenio().separacionNormal(context),
              ],
            )));
  }
}
