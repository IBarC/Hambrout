import 'package:flutter/material.dart';
import 'package:hambrout/enum/enumReceta.dart';
import 'package:hambrout/models/receta.dart';
import 'package:hambrout/paginas/receta_view.dart';
import 'package:shared_preferences/shared_preferences.dart';

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

  late List recetasFavs=[];

  @override
  void initState() {
    _botones = [
      ElevatedButton(onPressed: (){btnPulsado='todo';  setState((){});}, child: Text('Todo')),
      ElevatedButton(onPressed: (){btnPulsado='España'; setState((){});}, child: Text('España')),
      ElevatedButton(onPressed: (){btnPulsado='Rumanía'; setState((){});}, child: Text('Rumanía')),
      ElevatedButton(onPressed: (){btnPulsado='Marruecos'; setState((){});}, child: Text('Marruecos')),
      ElevatedButton(onPressed: (){btnPulsado='EE.UU'; setState((){});}, child: Text('EE.UU')),
      ElevatedButton(onPressed: (){btnPulsado='Japón'; setState((){});}, child: Text('Japón')),
    ];
    _inicializar();
    _buscaRecetasFavs();
  }

  _inicializar() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
  }

  _buscaRecetasFavs() async{
    recetasFavs = await conexionDatos.buscarRecetasFavs();
  }

  Icon establecerFavs(var receta){
    for(var rf in recetasFavs){
      if(receta[dR(DatosReceta.nombre)]==rf[dR(DatosReceta.nombre)]){
        return Icon(Icons.star, color: Colors.orange,);
      }
    }
    return Icon(Icons.star_border);
  }

  bool esFav(String nombre){
    for(var rf in recetasFavs){
      if(rf[dR(DatosReceta.nombre)]==nombre){
        return true;
      }
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {

    Size media = MediaQuery.of(context).size;
    setState(() {

    });

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
                            return GestureDetector(
                                onTap: (){
                                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                                    return RecetaWidget(receta: Receta(dificultad: snapshot.data?[index]['dificultad'], tipo: snapshot.data?[index]['tipo'],
                                      elaboracion: snapshot.data?[index]['elaboracion'], foto: snapshot.data?[index]['foto'], ingredientes: snapshot.data?[index]['ingredientes'],
                                      nombre: snapshot.data?[index]['nombre'], npersonas: snapshot.data?[index]['npersonas'], origen: snapshot.data?[index]['origen'],
                                      tiempo: snapshot.data?[index]['tiempo'],));
                                  }));
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
                                                  Row(children: [Text(snapshot.data?[index][dR(DatosReceta.nombre)])],),
                                                  Row(children: [Text(snapshot.data?[index]['origen'] +" · "+ snapshot.data?[index]['tipo'])],),
                                                  Row(children: [Text("${snapshot.data?[index]['npersonas'].toString()} personas · ${snapshot.data?[index]['dificultad']}")],),
                                                ],
                                              ),
                                              Column(
                                                children: [
                                                  //ESTRELLA QUE INDICA SI ES FAV
                                                  IconButton(
                                                    onPressed:()async{
                                                      if(esFav(snapshot.data?[index][dR(DatosReceta.nombre)])){
                                                        await conexionDatos.borrarRecetaFav(snapshot.data?[index][dR(DatosReceta.nombre)]);
                                                      } else {
                                                        await conexionDatos
                                                            .crearRecetaFav(
                                                            Receta(
                                                              dificultad: snapshot
                                                                  .data?[index]['dificultad'],
                                                              tipo: snapshot
                                                                  .data?[index]['tipo'],
                                                              elaboracion: snapshot
                                                                  .data?[index]['elaboracion'],
                                                              foto: snapshot
                                                                  .data?[index]['foto'],
                                                              ingredientes: snapshot
                                                                  .data?[index]['ingredientes'],
                                                              nombre: snapshot
                                                                  .data?[index]['nombre'],
                                                              npersonas: snapshot
                                                                  .data?[index]['npersonas'],
                                                              origen: snapshot
                                                                  .data?[index]['origen'],
                                                              tiempo: snapshot
                                                                  .data?[index]['tiempo'],));
                                                      }
                                                      _buscaRecetasFavs();
                                                      setState(() {});
                                                    },
                                                    icon: establecerFavs(snapshot.data?[index])
                                                  )
                                                ],
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