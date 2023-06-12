import 'package:flutter/material.dart';
import 'package:hambrout/firebase/conexion_firebase.dart';
import 'package:hambrout/paginas/receta_view.dart';
import 'package:lottie/lottie.dart';

import 'dart:math';

import '../enum/enum_receta.dart';
import '../main.dart';
import '../models/receta.dart';
import '../utils/formatos_disenio.dart';
import '../utils/formularios.dart';

/// Clase que genera la vista de Favoritos
class FavsWidget extends StatefulWidget {
  const FavsWidget({super.key});

  @override
  State<StatefulWidget> createState() {
    return FavsState();
  }
}

class FavsState extends State<FavsWidget> {
  late List<ElevatedButton> _botones = [];

  late List recetas = [];

  final TextStyle estiloTxt = const TextStyle(fontSize: 20);

  late String nombreBtnPulsado = 'Todo';
  late ElevatedButton btnTodo = ElevatedButton(
      onPressed: () {
        cambiarBtnPulsado('Todo', btnTodoS, btnTodo);
      },
      style: FormatosDisenio().btnCatNoSel(),
      child: Text('Todo', style: estiloTxt));
  late ElevatedButton btnEsp = ElevatedButton(
      onPressed: () {
        cambiarBtnPulsado('España', btnEspS, btnEsp);
      },
      style: FormatosDisenio().btnCatNoSel(),
      child: Text('España', style: estiloTxt));
  late ElevatedButton btnRum = ElevatedButton(
      onPressed: () {
        cambiarBtnPulsado('Rumanía', btnRumS, btnRum);
      },
      style: FormatosDisenio().btnCatNoSel(),
      child: Text('Rumanía', style: estiloTxt));
  late ElevatedButton btnMarr = ElevatedButton(
      onPressed: () {
        cambiarBtnPulsado('Marruecos', btnMarrS, btnMarr);
      },
      style: FormatosDisenio().btnCatNoSel(),
      child: Text('Marruecos', style: estiloTxt));
  late ElevatedButton btnMex = ElevatedButton(
      onPressed: () {
        cambiarBtnPulsado('México', btnMexS, btnMex);
      },
      style: FormatosDisenio().btnCatNoSel(),
      child: Text('EE.UU', style: estiloTxt));
  late ElevatedButton btnJap = ElevatedButton(
      onPressed: () {
        cambiarBtnPulsado('Japón', btnJapS, btnJap);
      },
      style: FormatosDisenio().btnCatNoSel(),
      child: Text('Japón', style: estiloTxt));

  late ElevatedButton btnTodoS = ElevatedButton(
      onPressed: () {},
      style: FormatosDisenio().btnCatSel(),
      child: Text('Todo', style: estiloTxt));
  late ElevatedButton btnEspS = ElevatedButton(
      onPressed: () {},
      style: FormatosDisenio().btnCatSel(),
      child: Text('España', style: estiloTxt));
  late ElevatedButton btnRumS = ElevatedButton(
      onPressed: () {},
      style: FormatosDisenio().btnCatSel(),
      child: Text('Rumanía', style: estiloTxt));
  late ElevatedButton btnMarrS = ElevatedButton(
      onPressed: () {},
      style: FormatosDisenio().btnCatSel(),
      child: Text('Marruecos', style: estiloTxt));
  late ElevatedButton btnMexS = ElevatedButton(
      onPressed: () {},
      style: FormatosDisenio().btnCatSel(),
      child: Text('México', style: estiloTxt));
  late ElevatedButton btnJapS = ElevatedButton(
      onPressed: () {},
      style: FormatosDisenio().btnCatSel(),
      child: Text('Japón', style: estiloTxt));

  ///Botón pulsado actualmente sin el estilo de pulsado
  late ElevatedButton btnActual = btnTodo;

  ///Botón pulsado actualmente con el estilo de pulsado
  late ElevatedButton btnActualS = btnTodoS;

  @override
  void initState() {
    super.initState();
    _botones = [btnTodoS, btnEsp, btnRum, btnMarr, btnMex, btnJap];
  }

  ///Cambia el estilo del botón señalado actualmente por el botón que se acaba de pulsar
  ///
  ///[btnPulsadoS] es el botón que se acaba de pulsar con el estilo de pulsado
  ///
  ///[btnPulsado] es el botón que se acaba de pulsar sin el estilo de pulsado
  void cambiarBtnPulsado(
      String nombre, ElevatedButton btnPulsadoS, ElevatedButton btnPulsado) {
    if (btnPulsadoS != btnActualS) {
      nombreBtnPulsado = nombre;

      //Coge el indice del btn señalado en este momento
      int indiceBtn = _botones.indexOf(btnActualS);

      // Quita el boton señalado con estilo de pulsado
      _botones.remove(btnActualS);

      //Añade el botón sin estilo de pulsado
      _botones.insert(indiceBtn, btnActual);

      //Coge el indice del boton pulsado
      int indiceBtnPulsado = _botones.indexOf(btnPulsado);

      //Quita el boton pulsado sin estilo de pulsado
      _botones.remove(btnPulsado);

      //Añade el botón con estilo de pulsado
      _botones.insert(indiceBtnPulsado, btnPulsadoS);
      btnActual = btnPulsado;
      btnActualS = btnPulsadoS;
      setState(() {});
    }
  }

  ///Cambia las recetas que se muestran dependiendo del filtro
  ///
  /// Si en el filtro señalado no hay recetas se devuelve una lista con un
  /// solo elemento para poder crear un widget
  Future<List?>? cambiarRecetas() async {
    recetas = await ConexionDatos().buscarRecetasFavs();
    if (nombreBtnPulsado == 'Todo') {
      if (recetas.isEmpty) {
        return ['ERROR'];
      }
      return recetas;
    }
    List recetasActuales = [];
    for (var receta in recetas) {
      if (receta[datosReceta(DatosReceta.origen)] == nombreBtnPulsado) {
        recetasActuales.add(receta);
      }
    }

    if (recetasActuales.isEmpty) {
      return ['ERROR'];
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
      appBar: AppBar(
        elevation: 1,
        title: Text(
          'Favoritos',
          style: FormatosDisenio().txtTituloPag(context),
        ),
        backgroundColor: Colors.white,
      ),
      body: Padding(
          padding: const EdgeInsets.only(left: 20, right: 20),
          child: Wrap(children: [
            Container( ///Botones de filtro
            alignment: Alignment.center,
              height: media.height / 20,
              margin: const EdgeInsets.only(top: 25, bottom: 25),
              child: ListView.builder(
                itemCount: _botones.length,
                shrinkWrap: true,
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, index) {
                  return Row(
                    children: [
                      Container(
                        child: _botones[index],
                      ),
                      const SizedBox(
                        width: 10,
                      )
                    ],
                  );
                },
              ),
            ),
            SizedBox( ///Todas las recetas
              height: media.height - 200,
              child: FutureBuilder(
                  future: cambiarRecetas(),
                  builder: ((context, snapshot) {
                    if (snapshot.hasData) {
                      return ListView.builder(
                          shrinkWrap: true,
                          itemCount: snapshot.data?.length,
                          itemBuilder: (context, index) {
                            if (snapshot.data?[0] == 'ERROR') {
                              return Center(
                                child: Text(
                                  '¡Ups! No hemos encontrado datos aquí',
                                  style: FormatosDisenio()
                                      .txtLabelDatosUsu(context),
                                ),
                              );
                            } else {
                              return GestureDetector(
                                onTap: () {
                                  Navigator.push(context,
                                      MaterialPageRoute(builder: (context) {
                                    return RecetaWidget(
                                        receta: Receta(
                                      dificultad: snapshot.data?[index]
                                          ['dificultad'],
                                      tipo: snapshot.data?[index]['tipo'],
                                      elaboracion: snapshot.data?[index]
                                          ['elaboracion'],
                                      foto: snapshot.data?[index]['foto'],
                                      ingredientes: snapshot.data?[index]
                                          ['ingredientes'],
                                      nombre: snapshot.data?[index]['nombre'],
                                      npersonas: snapshot.data?[index]
                                          ['npersonas'],
                                      origen: snapshot.data?[index]['origen'],
                                      tiempo: snapshot.data?[index]['tiempo'],
                                    ));
                                  }));
                                },
                                child: Padding(
                                  padding: EdgeInsets.only(
                                      bottom: media.height / 30),
                                  child: Container(
                                      decoration: FormatosDisenio().cajaRecetas(),
                                      child: Column(
                                        children: [
                                          SizedBox(
                                            height: 80,
                                            width: media.width,
                                            child: FittedBox(
                                              fit: BoxFit.fitWidth,
                                              alignment: Alignment.center,
                                              clipBehavior: Clip.hardEdge,
                                              child: Image(
                                                image: NetworkImage(
                                                    snapshot.data?[index]
                                                        [datosReceta(DatosReceta.foto)]),
                                              ),
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.all(7),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Row(
                                                      children: [
                                                        Text(
                                                          snapshot.data?[index][
                                                              datosReceta(DatosReceta
                                                                  .nombre)],
                                                          style: FormatosDisenio()
                                                              .txtTituloRecPrev(
                                                                  context),
                                                        )
                                                      ],
                                                    ),
                                                    Row(
                                                      children: [
                                                        Text(
                                                          snapshot.data?[index][
                                                                  datosReceta(DatosReceta
                                                                      .origen)] +
                                                              "  ·  " +
                                                              snapshot.data?[
                                                                      index][
                                                                  datosReceta(DatosReceta
                                                                      .tipo)],
                                                          style: FormatosDisenio()
                                                              .txtDatoRecPrev(
                                                                  context),
                                                        )
                                                      ],
                                                    ),
                                                    Row(
                                                      children: [
                                                        Text(
                                                            "${snapshot.data?[index][datosReceta(DatosReceta.npersonas)].toString()} personas  ·  ${snapshot.data?[index][datosReceta(DatosReceta.dificultad)]}",
                                                            style: FormatosDisenio()
                                                                .txtDatoRecPrev(
                                                                    context)),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                                Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.end,
                                                  children: [
                                                    //ESTRELLA QUE INDICA SI ES FAV
                                                    IconButton(
                                                        onPressed: () async {
                                                          await ConexionDatos()
                                                              .borrarRecetaFav(snapshot
                                                                          .data?[
                                                                      index][
                                                                  datosReceta(DatosReceta
                                                                      .nombre)]);
                                                          setState(() {});
                                                          try {
                                                            //Refresca la página de favoritos para tener actualizados los datos
                                                            keys[0]
                                                                .currentState!
                                                                .refreshPage();
                                                          } catch (_) {}
                                                        },
                                                        iconSize:
                                                        FormatosDisenio()
                                                                .tamBtnEstrella(
                                                                    context),
                                                        icon: const Stack(
                                                          children: [
                                                            Icon(
                                                              Icons.star,
                                                              color:
                                                                  Colors.orange,
                                                            ),
                                                            Icon(
                                                              Icons.star_border,
                                                              color: Color
                                                                  .fromRGBO(
                                                                      255,
                                                                      122,
                                                                      0,
                                                                      100),
                                                            )
                                                          ],
                                                        ))
                                                  ],
                                                )
                                              ],
                                            ),
                                          )
                                        ],
                                      )),
                                ),
                              );
                            }
                          });
                    } else {
                      return Center(
                        child: SizedBox(
                          width: 400,
                          height: 400,
                          child: LottieBuilder.asset(
                              'images/animacion/106177-food-loading.json'),
                        ),
                      );
                    }
                  })),
            )
          ])),
    );
  }
}
