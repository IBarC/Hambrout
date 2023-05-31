import 'package:flutter/material.dart';
import 'package:hambrout/enum/enum_listas.dart';
import 'package:hambrout/paginas/lista_view.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/lista.dart';
import '../utils/formularios.dart';

class ListasWidget extends StatefulWidget{
  const ListasWidget({super.key});

  @override
  State<StatefulWidget> createState() {
    return ListasState();
  }
}

class ListasState extends State<ListasWidget>{

  late int id;

  @override
  void initState() {
    super.initState();
    inicializar();
  }

  void inicializar()async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    id=prefs.getInt(l(DatosListas.id))??1;
  }

  List creaElementos(var elementos){
    List lista = [];
    for(var elemento in elementos){
      lista.add(Elemento(
          nombre: elemento[l(DatosListas.nombre)],
          tachado: elemento[l(DatosListas.tachado)],
          controlador: TextEditingController(text: elemento[l(DatosListas.nombre)],)));
    }
    return lista;
  }

  refreshPage() {
    setState(() {});
  }

    @override
    Widget build(BuildContext context) {

      Size media = MediaQuery.of(context).size;
      setState(() {});
  
      return Scaffold(
        body: Padding(
            padding: EdgeInsets.all(media.height/30),
            child:
            FutureBuilder(
                future: conexionDatos.buscarListas(),//esta es la funcion que tiene que devolver la lista necesaria de datos
                builder: ((context, snapshot){
                  if(snapshot.hasData){
                    return ListView.builder(
                      reverse: true,
                        shrinkWrap: true,
                        itemCount: snapshot.data?.length,
                        itemBuilder: (context, index){
                          return GestureDetector(
                            onTap: (){
                              Navigator.push(context, MaterialPageRoute(builder: (context) {
                                return ListaWidget(
                                    esNueva: false,
                                    lista: Lista(
                                        titulo: snapshot.data?[index][l(DatosListas.titulo)],
                                        elementos: creaElementos(snapshot.data?[index][l(DatosListas.elementos)]),
                                        id: snapshot.data?[index][l(DatosListas.id)]
                                    ));
                              }));
                              },
                            child: Padding(
                                padding: EdgeInsets.only(bottom: media.height/30),
                                child: Container(
                                  decoration: const BoxDecoration(color: Colors.cyanAccent),
                                  child: Column(
                                    children: [
                                      Text(snapshot.data?[index][l(DatosListas.titulo)]),
                                      Text(snapshot.data?[index][l(DatosListas.elementos)][0][l(DatosListas.nombre)])
                                    ],
                                  ),
                                )
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
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: (){
            Navigator.push(context, MaterialPageRoute(builder: (context) {
              return ListaWidget(
                esNueva: true,
                  lista: Lista(
                      titulo: '',
                      elementos: [Elemento(nombre: '', tachado: false, controlador: TextEditingController(text: ''))],
                      id: 1
                  ));
            }));
          },
          tooltip: 'Crear una lista nueva',
          child: const Icon(Icons.add),
        ),
      );
    }
}