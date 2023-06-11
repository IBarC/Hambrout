import 'package:flutter/material.dart';
import 'package:hambrout/enum/enum_usuario.dart';
import 'package:hambrout/paginas/datos_cuenta_view.dart';
import 'package:hambrout/paginas/login_view.dart';
import 'package:hambrout/utils/formatos_disenio.dart';
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
  String apellidos='';
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
    apellidos=prefs.getString(dU(DatosUsuario.apellidos))??'';
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
            buttonPadding: EdgeInsets.only(left: 30, right: 30),
            title: Text('Se cerrará sesión'),
            content: Text('¿Quiere cerrar la sesión de la cuenta $username?',
              style: FormatosDisenio().txtInfoAlert(context),),
            actions: <Widget>[
              ElevatedButton(onPressed: (){Navigator.pop(context);}, child: Text('CANCELAR'), style: FormatosDisenio().btnSeleccionAlert(),),
              ElevatedButton(onPressed: accionCerrarOEliminar, child: Text('SI, CERRAR'), style: FormatosDisenio().btnSeleccionAlert(),),
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
            buttonPadding: EdgeInsets.only(left: 30, right: 30),
            title: Text('Se eliminará la cuenta'),
            content: Text('¡Cuidado! La cuenta de $username está a punto de ser eliminada. ¿Está seguro de su decisión?',
            style: FormatosDisenio().txtInfoAlert(context),),
            actions: <Widget>[
              ElevatedButton(onPressed: (){Navigator.pop(context);}, child: Text('CANCELAR'), style: FormatosDisenio().btnSeleccionAlert(),),
              ElevatedButton(onPressed: (){conexionDatos.borrarUsuario(username);accionCerrarOEliminar();}, child: Text('SI, ELIMINAR'), style: FormatosDisenio().btnSeleccionAlert(),),
            ],
          );
        }
    );
  }
  
  @override
  Widget build(BuildContext context) {

    Size media = MediaQuery.of(context).size;
    
    return Scaffold(
        appBar: AppBar(elevation: 1,title: Text('Ayuda', style: formatosDisenio.txtTituloPag(context),),backgroundColor: Colors.white,),
        body: Padding(
            padding: EdgeInsets.all(media.height/30),
            child: ListView(
              children: [
                Container(
                  padding: EdgeInsets.only(top: 10, bottom: 10,left: 13),
                  decoration: formatosDisenio.cajaAjustes(),
                  child: Column(
                    children: [
                      Text(nombre, textAlign: TextAlign.center, style: formatosDisenio.txtTituloRecPrev(context),),
                      const SizedBox(height: 7,),
                      Text(username, textAlign: TextAlign.center, style: formatosDisenio.txtAjustes(context),),
                    ],
                  ),
                ),
                formatosDisenio.separacionNormal(context),
                GestureDetector(
                  onTap:(){Navigator.push(context, MaterialPageRoute(builder: (context){
                    return DatosCuentaWidget();
                  }));},
                  child: Container(
                    padding: EdgeInsets.only(top: 10, bottom: 10,left: 13, right: 13),
                    decoration: formatosDisenio.cajaAjustes(),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Datos de la cuenta', style: formatosDisenio.txtAjustes(context),),
                        Icon(Icons.arrow_forward_ios)
                      ],
                    ),
                  ),
                ),
                formatosDisenio.separacionNormal(context),
                GestureDetector(
                onTap:(){
                  alertCerarSesion();
                },
                child: Container(
                  padding: const EdgeInsets.only(top: 10, bottom: 10,left: 13),
                  decoration: formatosDisenio.cajaAjustes(),
                  child: Text('Cerrar sesión', style: formatosDisenio.txtAjustes(context),),
                  ),
                ),
                formatosDisenio.separacionNormal(context),
                GestureDetector(
                  onTap:(){
                    alertEliminarCuenta();
                  },
                  child: Container(
                    padding: EdgeInsets.only(top: 10, bottom: 10,left: 13),
                    decoration: formatosDisenio.cajaAjustes(),
                    child: Text('Eliminar cuenta', style: formatosDisenio.txtAjustes(context),),
                  ),
                ),
                formatosDisenio.separacionNormal(context),
                ],
            )
        )
    );
  }

}