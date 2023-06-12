import 'package:flutter/material.dart';
import 'package:hambrout/enum/enum_listas.dart';
import 'package:hambrout/firebase/conexion_firebase.dart';
import 'package:hambrout/paginas/lista_view.dart';
import 'package:hambrout/utils/formatos_disenio.dart';

import '../models/lista.dart';

/// Clase que genera la vista de Listas
class ListasWidget extends StatefulWidget {
  const ListasWidget({super.key});

  @override
  State<StatefulWidget> createState() {
    return ListasState();
  }
}

class ListasState extends State<ListasWidget> {

  @override
  void initState() {
    super.initState();
  }

  ///Crea los objetos elemento de la lista
  List creaElementos(var elementos) {
    List lista = [];
    for (var elemento in elementos) {
      lista.add(Elemento(
          nombre: elemento[listas(DatosListas.nombre)],
          tachado: elemento[listas(DatosListas.tachado)],
          controlador: TextEditingController(
            text: elemento[listas(DatosListas.nombre)],
          )));
    }
    return lista;
  }

  refreshPage() {
    setState(() {});
  }

  ///Busca las listas
  Future<List?>? comprobarListas()async {
    List listas = await ConexionDatos().buscarListas();
      if(listas.isEmpty){
        return ['VACIO'];
      }
    return listas;
    }

  @override
  Widget build(BuildContext context) {
    Size media = MediaQuery.of(context).size;
    setState(() {});

    return Scaffold(
      appBar: AppBar(
        elevation: 1,
        title: Text(
          'Listas',
          style: FormatosDisenio().txtTituloPag(context),
        ),
        backgroundColor: Colors.white,
      ),
      body: Padding(
          padding: EdgeInsets.only(
              top: media.height / 30,
              left: media.height / 30,
              right: media.height / 30),
          child: FutureBuilder(
              future: comprobarListas(),
              builder: ((context, snapshot) {
                if (snapshot.hasData) {
                  return ListView.builder(
                      itemCount: snapshot.data?.length,
                      itemBuilder: (context, index) {
                        if (snapshot.data?[0] == 'VACIO') {
                          return Center(
                            child: Text(
                              'Crea tu primera lista pulsando en el botón + abajo :)',
                              style:
                                  FormatosDisenio().txtLabelDatosUsu(context),
                            ),
                          );
                        }
                        return GestureDetector(
                          onTap: () {
                            Navigator.push(context,
                                MaterialPageRoute(builder: (context) {
                              return ListaWidget(
                                  esNueva: false,
                                  lista: Lista(
                                      titulo: snapshot.data?[index]
                                          [listas(DatosListas.titulo)],
                                      elementos: creaElementos(
                                          snapshot.data?[index]
                                              [listas(DatosListas.elementos)]),
                                      id: snapshot.data?[index]
                                          [listas(DatosListas.id)]));
                            }));
                          },
                          child: Padding(
                              padding:
                                  EdgeInsets.only(bottom: media.height / 30),
                              child: Container(
                                padding: const EdgeInsets.all(10),
                                decoration: FormatosDisenio().cajaRecetas(),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      snapshot.data?[index]
                                          [listas(DatosListas.titulo)],
                                      style: FormatosDisenio()
                                          .txtTituloRecPrev(context),
                                    ),
                                    FormatosDisenio().separacionPequenia(context),
                                    Text(
                                      snapshot.data?[index]
                                              [listas(DatosListas.elementos)][0]
                                          [listas(DatosListas.nombre)],
                                      style: FormatosDisenio()
                                          .txtDatoRecPrev(context),
                                    )
                                  ],
                                ),
                              )),
                        );
                      });
                } else {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
              }))),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.orange,
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return ListaWidget(
                esNueva: true,
                lista: Lista(
                    titulo: '',
                    elementos: [
                      Elemento(
                          nombre: '',
                          tachado: false,
                          controlador: TextEditingController(text: ''))
                    ],
                    id: 1));
          }));
        },
        tooltip: 'Crear una lista nueva',
        child: const Icon(Icons.add),
      ),
    );
  }
}
