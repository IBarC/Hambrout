import 'package:flutter/material.dart';

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

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: conexionDatos.buscarRecetas(),
        builder: ((context, snapshot){
          if(snapshot.hasData){
            return ListView.builder(
                itemCount: snapshot.data?.length,
                itemBuilder: (context, index){
                  return Text(snapshot.data?[index]['nombre']);
                }
            );
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        })
    );
  }
/**
  @override
  void initState() {
    super.initState();
    crearCajas();
  }

  void crearCajas() async{
    recetas = await conexionDatos.buscarRecetas();
    print(recetas);
    for(var receta in recetas){
      _widgets.add(Container(child: Text('LLLL'),decoration: BoxDecoration(color: Colors.amberAccent),));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 10, right: 10, bottom: 10,top: 70),
      child: Column(
        children: _widgets,
      ),
    );
  }**/



}