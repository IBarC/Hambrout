import 'package:flutter/material.dart';
import 'package:hambrout/enum/enum_receta.dart';
import 'package:hambrout/main.dart';
import 'package:hambrout/models/receta.dart';
import 'package:hambrout/paginas/favs_view.dart';
import 'package:hambrout/paginas/receta_view.dart';
import 'dart:math';

import '../firebase/conexion_firebase.dart';
import '../utils/formularios.dart';

class CasaWidget extends StatefulWidget{
  const CasaWidget({super.key});

  @override
  State<StatefulWidget> createState() {
    return CasaState();
  }
}

var list;
var random;

var refreshKey = GlobalKey<RefreshIndicatorState>();

class CasaState extends State<CasaWidget> {

  late List<ElevatedButton> _botones = [];

  late List recetas=[];

  late List recetasFavs=[];

  late String nombreBtnPulsado='Todo';
  late ElevatedButton btnTodo = ElevatedButton(onPressed: (){cambiarBtnPulsado('Todo',btnTodoS,btnTodo);}, child: const Text('Todo'));
  late ElevatedButton btnEsp =  ElevatedButton(onPressed: (){cambiarBtnPulsado('España', btnEspS, btnEsp);}, child: const Text('España'));
  late ElevatedButton btnRum = ElevatedButton(onPressed: (){cambiarBtnPulsado('Rumanía', btnRumS, btnRum);}, child: const Text('Rumanía'));
  late ElevatedButton btnMarr = ElevatedButton(onPressed: (){cambiarBtnPulsado('Marruecos', btnMarrS, btnMarr);}, child: const Text('Marruecos'));
  late ElevatedButton btnEEUU = ElevatedButton(onPressed: (){cambiarBtnPulsado('EE.UU', btnEEUUS, btnEEUU);}, child: const Text('EE.UU'));
  late ElevatedButton btnJap = ElevatedButton(onPressed: (){cambiarBtnPulsado('Japón', btnJapS, btnJap);}, child: const Text('Japón'));

  late ElevatedButton btnTodoS=ElevatedButton(onPressed:(){}, child: const Text('Todo'), style:ElevatedButton.styleFrom(backgroundColor: Colors.purple),);
  late ElevatedButton btnEspS = ElevatedButton(onPressed:(){}, child: const Text('España'), style:ElevatedButton.styleFrom(backgroundColor: Colors.purple),);
  late ElevatedButton btnRumS= ElevatedButton(onPressed:(){}, child: const Text('Rumanía'), style:ElevatedButton.styleFrom(backgroundColor: Colors.purple),);
  late ElevatedButton btnMarrS = ElevatedButton(onPressed:(){}, child: const Text('Marruecos'), style:ElevatedButton.styleFrom(backgroundColor: Colors.purple),);
  late ElevatedButton btnEEUUS = ElevatedButton(onPressed:(){}, child: const Text('EE.UU'), style:ElevatedButton.styleFrom(backgroundColor: Colors.purple),);
  late ElevatedButton btnJapS = ElevatedButton(onPressed:(){}, child: const Text('Japón'), style:ElevatedButton.styleFrom(backgroundColor: Colors.purple),);


  late ElevatedButton btnActual=btnTodo;
  late ElevatedButton btnActualS=btnTodoS;

  @override
  void initState() {
    super.initState();

    _botones = [
      btnTodoS,btnEsp,btnRum,btnMarr,btnEEUU,btnJap
    ];
    _buscaRecetasFavs();
    random = Random();
  }

  void cambiarBtnPulsado(String nombre,ElevatedButton btnPulsadoS, ElevatedButton btnPulsado){
    if(btnPulsadoS!=btnActualS){
      nombreBtnPulsado = nombre;
      int indiceBtn = _botones.indexOf(btnActualS); //Coge el indice del btn señalado en este momento
      _botones.remove(btnActualS); // lo quita de la lista
      _botones.insert(indiceBtn, btnActual); //mete el btn sin señalar
      int indiceBtnPulsado = _botones.indexOf(btnPulsado);
      _botones.remove(btnPulsado);
      _botones.insert(indiceBtnPulsado, btnPulsadoS);
      btnActual=btnPulsado;
      btnActualS=btnPulsadoS;
      setState(() {});
    }
  }

  _buscaRecetasFavs() async{
    recetasFavs = await conexionDatos.buscarRecetasFavs();
  }

  Icon establecerFavs(var receta){
    for(var rf in recetasFavs){
      if(receta[dR(DatosReceta.nombre)]==rf[dR(DatosReceta.nombre)]){
        return const Icon(Icons.star, color: Colors.orange,);
      }
    }
    return const Icon(Icons.star_border);
  }

  bool esFav(String nombre){
    for(var rf in recetasFavs){
      if(rf[dR(DatosReceta.nombre)]==nombre){
        return true;
      }
    }
    return false;
  }

  Future<List?>? cambiarRecetas()async {
    recetas = await conexionDatos.buscarRecetas();
    if(nombreBtnPulsado=='Todo'){
      return recetas;
    }
    List recetasActuales = [];
    for(var receta in recetas){
      if(receta[dR(DatosReceta.origen)]==nombreBtnPulsado){
        recetasActuales.add(receta);
      }
    }
    
    if(recetasActuales.isEmpty){
      return ['Ups! No hemos encontrado datos aquí'];
    }
    return recetasActuales;
  }

  refreshPage() {
    setState(() {
      _buscaRecetasFavs();
    });
  }

  @override
  Widget build(BuildContext context) {

    Size media = MediaQuery.of(context).size;
    setState(() {});

    return Padding(
        padding: EdgeInsets.only(top: 60, left: 20, right: 20),
        child: Wrap(
              children: [
                formatosDisenio.separacionNormal(context),
                Container(
                  alignment: Alignment.center,
                  height: media.height/20,
                  margin: EdgeInsets.only(bottom: 25),
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
                Text(nombreBtnPulsado),
                FutureBuilder(
                    future: cambiarRecetas(),//esta es la funcion que tiene que devolver la lista necesaria de datos
                    builder: ((context, snapshot){
                      if(snapshot.hasData){
                        return ListView.builder(
                            shrinkWrap: true,
                            itemCount: snapshot.data?.length,
                            itemBuilder: (context, index){
                              if(snapshot.data?[0] == 'Ups! No hemos encontrado datos aquí'){
                                return Text('Ups! No hemos encontrado datos aquí');
                              } else {
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
                                                          keys[1].currentState!.refreshPage();
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
                              }
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

}