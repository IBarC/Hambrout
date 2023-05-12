import 'package:flutter/material.dart';
import 'package:hambrout/paginas/receta_view.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'dart:math';

import '../enum/enumReceta.dart';
import '../models/receta.dart';
import '../utils/formularios.dart';

class FavsWidget extends StatefulWidget{
  const FavsWidget({super.key});

  @override
  State<StatefulWidget> createState() {
    return _Favs();
  }
}

var list;
var random;

var refreshKey = GlobalKey<RefreshIndicatorState>();

class _Favs extends State<FavsWidget>{

  late List<ElevatedButton> _botones = [];

  //final List<Widget> _widgets = [];
  late List recetas=[];

  late String btnPulsado='todo';

  late List recetasFavs=[];

  @override
  void initState() {
    super.initState();
    _botones = [
      ElevatedButton(onPressed: (){btnPulsado='todo';  setState((){});}, child: const Text('Todo')),
      ElevatedButton(onPressed: (){btnPulsado='España'; setState((){});}, child: const Text('España')),
      ElevatedButton(onPressed: (){btnPulsado='Rumanía'; setState((){});}, child: const Text('Rumanía')),
      ElevatedButton(onPressed: (){btnPulsado='Marruecos'; setState((){});}, child: const Text('Marruecos')),
      ElevatedButton(onPressed: (){btnPulsado='EE.UU'; setState((){});}, child: const Text('EE.UU')),
      ElevatedButton(onPressed: (){btnPulsado='Japón'; setState((){});}, child: const Text('Japón')),
    ];
    //_inicializar();
    _buscaRecetasFavs();
    random = Random();
    refreshList();
  }

  Future<void> refreshList() async {
    refreshKey.currentState?.show();
    await Future.delayed(const Duration(seconds: 1));
    setState(() {
      list = List.generate(random.nextInt(10), (i) => "Item $i");
    });
    //return null;
  }

  ///_inicializar() async{
    ///SharedPreferences prefs = await SharedPreferences.getInstance();
  ///}**/

  _buscaRecetasFavs() async{
    recetasFavs = await conexionDatos.buscarRecetasFavs();
  }

  Future<List?>? cambiarRecetas()async {
    recetas = await conexionDatos.buscarRecetasFavs();
    if(btnPulsado=='todo'){
      return recetas;
    }
    List recetasActuales = [];
    for(var receta in recetas){
      if(receta[dR(DatosReceta.origen)]==btnPulsado){
        recetasActuales.add(receta);
      }
    }
    return recetasActuales;
  }


  @override
  Widget build(BuildContext context) {

    Size media = MediaQuery.of(context).size;
    setState(() {});

    return Padding(
      padding: EdgeInsets.only(top: media.height/30),
      child: list != null
        ? RefreshIndicator(
        key: refreshKey,
          onRefresh: refreshList,
          child: ListView(
            //shrinkWrap: true,
              padding: const EdgeInsets.all(40),
              scrollDirection: Axis.vertical,
              children: [
                formatosDisenio.separacionNormal(context),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
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
                                      decoration: const BoxDecoration(color: Colors.cyanAccent),
                                      child: Column(
                                        children: [
                                          Row(children: const [Text('Imagen')],),
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
                                                        await conexionDatos.borrarRecetaFav(snapshot.data?[index][dR(DatosReceta.nombre)]);
                                                        //_buscaRecetasFavs();
                                                        setState(() {});
                                                      },
                                                      icon: const Icon(Icons.star, color: Colors.orange,)
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
          )
      ) : const Center(child: CircularProgressIndicator(),)
    );
  }

}