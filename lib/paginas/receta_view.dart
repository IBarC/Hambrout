import 'package:back_button_interceptor/back_button_interceptor.dart';
import 'package:flutter/material.dart';
import 'package:hambrout/utils/formatos_disenio.dart';

import '../models/receta.dart';

/// Clase que genera la vista de Receta
class RecetaWidget extends StatefulWidget{
  final Receta receta;

  const RecetaWidget({super.key,
    required this.receta
  });

  @override
  State<StatefulWidget> createState() {
    return _Receta(receta: receta);
  }
}

class _Receta extends State<RecetaWidget>{
  Receta receta;
  FormatosDisenio estilo = FormatosDisenio();

  _Receta({
    required this.receta
  });

  @override
  void initState() {
    super.initState();
    BackButtonInterceptor.add(interceptor);
  }

  @override
  void dispose() {
    BackButtonInterceptor.remove(interceptor);
    super.dispose();
  }

  bool interceptor(bool stopDefaultButtonEvent, RouteInfo info) {
    Navigator.pop(context);
    return true;
  }

  ///Genera los widget de los ingredientes
  List<Widget> listaIngredientes(BuildContext context, Size media){
    List<Widget> listaIngredientes=[];
    for(var ingrediente in receta.ingredientes){
      listaIngredientes.add(Row(children: [Container(
        width: media.width-(media.height/50)*3,
        margin: EdgeInsets.only(left: media.height/50),
        child: Text('· $ingrediente', style: estilo.txtRecetas3(context)),
      )],));
      if(ingrediente!=receta.ingredientes.last){
        listaIngredientes.add(estilo.separacionMasPequenia(context));
      }
    }
    return listaIngredientes;
  }

  ///Genera los widget de los ingredientes
  List<Widget> listaPasos(BuildContext context, Size media){
    List<Widget> listaPasos=[];
    for(var paso in receta.elaboracion){
      listaPasos.add(Row(children: [SizedBox(
        width: media.width-media.height/50-media.height/50,
        child: Text('$paso',overflow: TextOverflow.visible, style: estilo.txtRecetas3(context)),)],));
      if(paso!=receta.elaboracion.last){
        listaPasos.add(estilo.separacionNormal(context));
      } else {
        listaPasos.add(estilo.separacionMasPequenia(context));
      }
    }
    return listaPasos;
  }

  @override
  Widget build(BuildContext context) {
    Size media = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
          title: Text(receta.nombre, style: estilo.txtTituloRec(context), textAlign: TextAlign.center),
          backgroundColor: Colors.white,
          elevation: 0,
          leading: GestureDetector(
            child: const Icon(Icons.arrow_back_ios, color: Colors.black,),
            onTap: () {
              Navigator.pop(context);
            },
          )
      ),
      body: Container(
        height: media.height,
        width: media.width,
        decoration: const BoxDecoration(color: Colors.white70),
        child: Padding(
          padding: EdgeInsets.all(media.height/50),
          child: ListView(
            scrollDirection: Axis.vertical,
            children: [
              Container(
                height: 80,
                width: media.width,
                decoration: BoxDecoration(border: Border.all(color: Colors.orange,width: 3)),
                child: FittedBox(
                  fit: BoxFit.fitWidth,
                  alignment: Alignment.center,
                  clipBehavior: Clip.hardEdge,
                  child: Image(image: NetworkImage(receta.foto),),
                ),
              ),
              estilo.separacionNormal(context),
              Row(children: [Text('Información', style: estilo.txtRecetas1(context),)],),
              estilo.separacionPequenia(context),
              Row(children: [
                Text('   · Tiempo de preparación: ', style: estilo.txtRecetas2(context),),
                Text(receta.tiempo,  style: estilo.txtRecetas3(context))
              ],),
              estilo.separacionMasPequenia(context),
              Row(children: [
                Text('   · Ración: ', style: estilo.txtRecetas2(context)),
                Text(receta.npersonas.toString())
              ],),
              estilo.separacionMasPequenia(context),
              Row(children: [
                Text('   · Categoria: ', style: estilo.txtRecetas2(context)),
                Text(receta.tipo, style: estilo.txtRecetas3(context))
              ],),
              estilo.separacionMasPequenia(context),
              Row(children: [
                Text('   · Origen: ', style: estilo.txtRecetas2(context)),
                Text(receta.origen, style: estilo.txtRecetas3(context))
              ],),
              estilo.separacionMasPequenia(context),
              Row(children: [
                Text('   · Dificultad: ', style: estilo.txtRecetas2(context)),
                Text(receta.dificultad, style: estilo.txtRecetas3(context))
              ],),
              estilo.separacionNormal(context),
              Row(children: [Text('Ingredientes', style: estilo.txtRecetas1(context))],),
              estilo.separacionPequenia(context),
              Column(children: listaIngredientes(context,media),),
              estilo.separacionNormal(context),
              Row(children: [Text('Modo de preparación', style: estilo.txtRecetas1(context))],),
              estilo.separacionPequenia(context),
              Column(children: listaPasos(context, media),)
            ],
          )
        ),
      ) ,
    );
  }
}