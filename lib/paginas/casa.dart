import 'package:flutter/material.dart';

import '../firebase/conexion_firebase.dart';
import '../utils/formularios.dart';

class CasaWidget extends StatefulWidget{
  const CasaWidget({super.key});

  @override
  State<StatefulWidget> createState() {
    return _Casa();
  }
}

final ConexionDatos conexionDatos = ConexionDatos();



class _Casa extends State<CasaWidget> with SingleTickerProviderStateMixin {

  late List<ElevatedButton> _botones = [];

  final List<Widget> _widgets = [];
  late List recetas=[];

  late String btnPulsado='todo';

  @override
  void initState() {
    _botones = [
      ElevatedButton(onPressed: (){btnPulsado='todo'; cambiarRecetas(); setState((){});}, child: Text('Todo')),
      ElevatedButton(onPressed: (){btnPulsado='España'; cambiarRecetas();setState((){});}, child: Text('España')),
      ElevatedButton(onPressed: (){btnPulsado='Rumania'; cambiarRecetas();}, child: Text('Rumanía')),
      ElevatedButton(onPressed: (){btnPulsado='marruecos'; cambiarRecetas();}, child: Text('Marruecos')),
      ElevatedButton(onPressed: (){btnPulsado='eeuu'; cambiarRecetas();}, child: Text('EE.UU')),
      ElevatedButton(onPressed: (){btnPulsado='japon'; cambiarRecetas();}, child: Text('Japón')),
    ];
  }

  @override
  Widget build(BuildContext context) {

    Size media = MediaQuery.of(context).size;

    return Padding(
        padding: EdgeInsets.only(top: media.height/30),
        child: ListView(
          //shrinkWrap: true,
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
              Container(
                height: media.height/20,
                child: ListView.builder(
                  itemCount: _botones.length,
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, index){
                    return Row(
                      children: [
                        Container(
                          child: _botones[index],
                        ),
                        const SizedBox(width: 10,)
                      ],
                    );
                  },
                ),
              ),
              //const SizedBox(width: 10,),
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
                            return GestureDetector(
                                onTap: (){
                                  //Lleva a la página donde muestra las recetas indvididuales
                                },
                                child: Padding(
                                    padding: EdgeInsets.only(bottom: media.height/30),
                                    child: Container(
                                      decoration: BoxDecoration(color: Colors.cyanAccent),
                                      child: Column(
                                        children: [
                                          Row(children: [Text('Imagen')],),
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Column(
                                                children: [
                                                  Row(children: [Text(snapshot.data?[index]['nombre'])],),
                                                  Row(children: [Text(snapshot.data?[index]['origen'] +" · "+ snapshot.data?[index]['tipo'])],),
                                                  Row(children: [Text("${snapshot.data?[index]['npersonas'].toString()} personas · ${snapshot.data?[index]['dificultad']}")],),
                                                ],
                                              ),
                                              Column(
                                                children: [IconButton(onPressed:(){},icon: Icon(Icons.star_border_purple500_sharp),)],
                                              )
                                            ],
                                          ),
                                        ],
                                      )
                                    ),
                                ),
                            );
                          });
                    } else {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                  })

              )
            ]
        ),
    );
  }

  //EL SET STATE SE HACE EN EL ONPRESSED DE LOS BOTONES

  Future<List?>? cambiarRecetas()async {
    recetas = await conexionDatos.buscarRecetas();
    if(btnPulsado=='todo'){
      return recetas;
    }
    List recetasActuales = [];
    for(var receta in recetas){
      if(receta['origen']==btnPulsado){
        recetasActuales.add(receta);
      }
    }
    return recetasActuales;
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