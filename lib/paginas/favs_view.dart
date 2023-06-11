import 'package:flutter/material.dart';
import 'package:hambrout/paginas/receta_view.dart';
import 'package:lottie/lottie.dart';

import 'dart:math';

import '../enum/enum_receta.dart';
import '../main.dart';
import '../models/receta.dart';
import '../utils/formatos_disenio.dart';
import '../utils/formularios.dart';

class FavsWidget extends StatefulWidget{
  const FavsWidget({super.key});

  @override
  State<StatefulWidget> createState() {
    return FavsState();
  }
}

var list;
var random;

var refreshKey = GlobalKey<RefreshIndicatorState>();

class FavsState extends State<FavsWidget>{

  late List<ElevatedButton> _botones = [];

  //final List<Widget> _widgets = [];
  late List recetas=[];

  final TextStyle estiloTxt=const TextStyle(fontSize: 20);

  late List recetasFavs=[];

  late String nombreBtnPulsado='Todo';
  late ElevatedButton btnTodo = ElevatedButton(onPressed: (){cambiarBtnPulsado('Todo',btnTodoS,btnTodo);},style: formatosDisenio.btnCatNoSel(), child: Text('Todo',style: estiloTxt));
  late ElevatedButton btnEsp =  ElevatedButton(onPressed: (){cambiarBtnPulsado('España', btnEspS, btnEsp);},style: formatosDisenio.btnCatNoSel(), child: Text('España',style: estiloTxt));
  late ElevatedButton btnRum = ElevatedButton(onPressed: (){cambiarBtnPulsado('Rumanía', btnRumS, btnRum);},style: formatosDisenio.btnCatNoSel(), child: Text('Rumanía',style: estiloTxt));
  late ElevatedButton btnMarr = ElevatedButton(onPressed: (){cambiarBtnPulsado('Marruecos', btnMarrS, btnMarr);},style: formatosDisenio.btnCatNoSel(), child: Text('Marruecos',style: estiloTxt));
  late ElevatedButton btnEEUU = ElevatedButton(onPressed: (){cambiarBtnPulsado('EE.UU', btnEEUUS, btnEEUU);},style: formatosDisenio.btnCatNoSel(), child: Text('EE.UU',style: estiloTxt));
  late ElevatedButton btnJap = ElevatedButton(onPressed: (){cambiarBtnPulsado('Japón', btnJapS, btnJap);},style: formatosDisenio.btnCatNoSel(), child: Text('Japón',style: estiloTxt));

  late ElevatedButton btnTodoS=ElevatedButton(onPressed:(){}, style: formatosDisenio.btnCatSel(), child: Text('Todo',style: estiloTxt));
  late ElevatedButton btnEspS = ElevatedButton(onPressed:(){}, style: formatosDisenio.btnCatSel(), child: Text('España',style: estiloTxt));
  late ElevatedButton btnRumS= ElevatedButton(onPressed:(){}, style: formatosDisenio.btnCatSel(), child: Text('Rumanía',style: estiloTxt));
  late ElevatedButton btnMarrS = ElevatedButton(onPressed:(){}, style: formatosDisenio.btnCatSel(), child: Text('Marruecos',style: estiloTxt));
  late ElevatedButton btnEEUUS = ElevatedButton(onPressed:(){}, style: formatosDisenio.btnCatSel(), child: Text('EE.UU',style: estiloTxt));
  late ElevatedButton btnJapS = ElevatedButton(onPressed:(){}, style: formatosDisenio.btnCatSel(), child: Text('Japón',style: estiloTxt));


  late ElevatedButton btnActual=btnTodo;
  late ElevatedButton btnActualS=btnTodoS;

  @override
  void initState() {
    super.initState();
    _botones = [
      btnTodoS,btnEsp,btnRum,btnMarr,btnEEUU,btnJap
    ];
    //_inicializar();
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

  Future<List?>? cambiarRecetas()async {
    recetas = await conexionDatos.buscarRecetasFavs();
    if(nombreBtnPulsado=='Todo'){
      if(recetas.isEmpty){
        return ['Ups! No hemos encontrado datos aquí'];
      }
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
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {

    Size media = MediaQuery.of(context).size;
    setState(() {});

    return Scaffold(
      appBar: AppBar(elevation: 1,title: Text('Favoritos', style: formatosDisenio.txtTituloPag(context),),backgroundColor: Colors.white,),
      body: Padding(
          padding: const EdgeInsets.only(left: 20, right: 20),
          child: Wrap(
              children: [
                //formatosDisenio.separacionNormal(context),
                Container(
                  alignment: Alignment.center,
                  height: media.height/20,
                  margin: const EdgeInsets.only(top: 25, bottom: 25),
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
                SizedBox(
                  height: media.height-200,
                  child: FutureBuilder(
                      future: cambiarRecetas(),//esta es la funcion que tiene que devolver la lista necesaria de datos
                      builder: ((context, snapshot){
                        if(snapshot.hasData){
                          return ListView.builder(
                              shrinkWrap: true,
                              itemCount: snapshot.data?.length,
                              itemBuilder: (context, index){
                                if(snapshot.data?[0] == 'Ups! No hemos encontrado datos aquí'){
                                  return Center(child: Text('¡Ups! No hemos encontrado datos aquí',
                                    style: FormatosDisenio().txtLabelDatosUsu(context),),);
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
                                          decoration: formatosDisenio.cajaRecetas(),
                                          child: Column(
                                            children: [
                                              SizedBox(
                                                height: 80,
                                                width: media.width,
                                                child: FittedBox(
                                                  fit: BoxFit.fitWidth,
                                                  alignment: Alignment.center,
                                                  clipBehavior: Clip.hardEdge,
                                                  child: Image(image: NetworkImage(snapshot.data?[index][dR(DatosReceta.foto)]),),
                                                ),
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.all(7),
                                                child: Row(
                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  children: [
                                                    Column(
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: [
                                                        Row(children: [Text(snapshot.data?[index][dR(DatosReceta.nombre)], style: formatosDisenio.txtTituloRecPrev(context),)],),
                                                        Row(children: [Text(snapshot.data?[index][dR(DatosReceta.origen)] +"  ·  "+ snapshot.data?[index][dR(DatosReceta.tipo)],style: formatosDisenio.txtDatoRecPrev(context),)],),
                                                        Row(children: [Text("${snapshot.data?[index][dR(DatosReceta.npersonas)].toString()} personas  ·  ${snapshot.data?[index][dR(DatosReceta.dificultad)]}",style: formatosDisenio.txtDatoRecPrev(context)),],),
                                                      ],
                                                    ),
                                                    Column(
                                                      crossAxisAlignment: CrossAxisAlignment.end,
                                                      children: [
                                                        //ESTRELLA QUE INDICA SI ES FAV
                                                        IconButton(
                                                            onPressed:()async{
                                                              await conexionDatos.borrarRecetaFav(snapshot.data?[index][dR(DatosReceta.nombre)]);
                                                              setState(() {});
                                                              keys[0].currentState!.refreshPage();
                                                            },
                                                            iconSize: formatosDisenio.tamBtnEstrella(context),
                                                            icon: Stack(children: const [
                                                              Icon(Icons.star, color: Colors.orange,),
                                                              Icon(Icons.star_border, color: Color.fromRGBO(255, 122, 0, 100),)
                                                            ],)
                                                        )
                                                      ],
                                                    )
                                                  ],
                                                ),
                                              )
                                            ],
                                          )
                                      ),
                                    ),
                                  );}
                              });
                        } else {
                          return Center(
                            child: SizedBox(
                              width: 400,
                              height: 400,
                              child: LottieBuilder.asset('images/animacion/106177-food-loading.json'),
                            ),
                          );
                        }
                      })

                  ),
                )
              ]
          )
      ),
    );
  }

}