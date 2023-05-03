import 'package:flutter/material.dart';
import 'package:hambrout/paginas/login.dart';
import 'package:hambrout/utils/formularios.dart';

class CrearCuentaWidget extends StatefulWidget{
  const CrearCuentaWidget({super.key});

  @override
  State<StatefulWidget> createState(){
    return _CrearCuenta();
  }
}

class _CrearCuenta extends State<CrearCuentaWidget>{


  @override
  Widget build(BuildContext context) {
    Size media = MediaQuery.of(context).size;

    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.startTop,
      floatingActionButton: IconButton(
        icon: Icon(Icons.arrow_back_ios_new),
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(builder: (context) {
                return const LogInWidget();
              })
          );
        },
      ),
      body: Container(
        width: media.width,
        height: media.height,
        ///Fondo degradado
        decoration: const BoxDecoration(
          gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment(0.0, 1.0),
          colors: <Color>[
            Color(0xFFF5B067),Color(0xFFAE7575),
          ])),
        child: Center(
          child: ListView(
              shrinkWrap: true,
              padding: const EdgeInsets.all(40.0),
              scrollDirection: Axis.vertical,
              children: [
                SizedBox(
                  child: FormularioCrearCuenta(context),
                )
              ]
          ),
        ),
      )
    );
  }

}