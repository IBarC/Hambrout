import 'package:flutter/material.dart';
import 'package:hambrout/utils/formularios.dart';

import '../firebase/conexion_firebase.dart';

class CasaWidget extends StatefulWidget{
  const CasaWidget({super.key});

  @override
  State<StatefulWidget> createState() {
    return _Casa();
  }
}

final ConexionDatos conexionDatos = ConexionDatos();

class _Casa extends State<CasaWidget>{

  final List<Widget> _widgets = [];
  late List recetas=[];

  final String btnPulsado='todo';

  @override
  Widget build(BuildContext context) {

    Size media = MediaQuery.of(context).size;

    return
        ListView(
          shrinkWrap: true,
          padding: const EdgeInsets.all(40),
          scrollDirection: Axis.vertical,
          children: [
            formatosDisenio.separacionNormal(context),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('buscador')
              ],
            ),
            formatosDisenio.separacionNormal(context),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [Text('listview horizontal que muestra el origen'),],
            ),
            formatosDisenio.separacionNormal(context),
            FutureBuilder(
                      future: cambiarRecetas(),//esta es la funcion que tiene que devolver la lista necesaria de datos
                      builder: ((context, snapshot){
                        if(snapshot.hasData){
                          return ListView.builder(
                                shrinkWrap: true,
                                itemCount: snapshot.data?.length,
                                itemBuilder: (context, index){
                                  //TIENE QUE LLAMAR A UNA FUNCION QUE CONSTRUYA LOS DATOS
                                  //DEPENDIENDO DE QUE BOTON SE PULSA
                                  return Center(child: Text(snapshot.data?[index]['nombre']),);
                                });
                        } else {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                      })

                  )
        ]
        );
  }

  //EL SET STATE SE HACE EN EL ONPRESSED DE LOS BOTONES

  Future<List>? cambiarRecetas(){
    if(btnPulsado=='todo'){
      return conexionDatos.buscarRecetas();
    }
    return null;
  }



/**
 * FUNCION QUE TIENE QUE HACER VARIAS COSAS
 * - Cambia las recetas que muestra
 * - cambia el color de la categoria que esta señalizada
 */

/**
 * Funcion que cambia las recetas que se muestran
 */

}