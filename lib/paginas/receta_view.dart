import 'package:back_button_interceptor/back_button_interceptor.dart';
import 'package:flutter/material.dart';
import 'package:hambrout/utils/formularios.dart';

import '../models/receta.dart';

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

  List<Widget> listaIngredientes(BuildContext context, Size media){
    List<Widget> listaIngredientes=[];
    for(var ingrediente in receta.ingredientes){
      listaIngredientes.add(Row(children: [Container(
        width: media.width-(media.height/50)*3,
        margin: EdgeInsets.only(left: media.height/50),
        child: Text('· ${ingrediente}', style: formatosDisenio.txtRecetas3(context)),
      )],));
      if(ingrediente!=receta.ingredientes.last){
        listaIngredientes.add(formatosDisenio.separacionMasPequenia(context));
      }
    }
    return listaIngredientes;
  }

  List<Widget> listaPasos(BuildContext context, Size media){
    List<Widget> listaPasos=[];
    for(var paso in receta.elaboracion){
      listaPasos.add(Row(children: [SizedBox(
        width: media.width-media.height/50-media.height/50,
        child: Text('$paso',overflow: TextOverflow.visible, style: formatosDisenio.txtRecetas3(context)),)],));
      if(paso!=receta.elaboracion.last){
        listaPasos.add(formatosDisenio.separacionNormal(context));
      } else {
        listaPasos.add(formatosDisenio.separacionMasPequenia(context));
      }
    }
    return listaPasos;
  }

  @override
  Widget build(BuildContext context) {
    Size media = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
          title: Text(receta.nombre, style: formatosDisenio.txtTituloRec(context), textAlign: TextAlign.center),
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
              formatosDisenio.separacionNormal(context),
              Row(children: [Text('Información', style: formatosDisenio.txtRecetas1(context),)],),
              formatosDisenio.separacionPequenia(context),
              Row(children: [
                Text('   · Tiempo de preparación: ', style: formatosDisenio.txtRecetas2(context),),
                Text(receta.tiempo,  style: formatosDisenio.txtRecetas3(context))
              ],),
              formatosDisenio.separacionMasPequenia(context),
              Row(children: [
                Text('   · Ración: ', style: formatosDisenio.txtRecetas2(context)),
                Text(receta.npersonas.toString())
              ],),
              formatosDisenio.separacionMasPequenia(context),
              Row(children: [
                Text('   · Categoria: ', style: formatosDisenio.txtRecetas2(context)),
                Text(receta.tipo, style: formatosDisenio.txtRecetas3(context))
              ],),
              formatosDisenio.separacionMasPequenia(context),
              Row(children: [
                Text('   · Origen: ', style: formatosDisenio.txtRecetas2(context)),
                Text(receta.origen, style: formatosDisenio.txtRecetas3(context))
              ],),
              formatosDisenio.separacionMasPequenia(context),
              Row(children: [
                Text('   · Dificultad: ', style: formatosDisenio.txtRecetas2(context)),
                Text(receta.dificultad, style: formatosDisenio.txtRecetas3(context))
              ],),
              formatosDisenio.separacionNormal(context),
              Row(children: [Text('Ingredientes', style: formatosDisenio.txtRecetas1(context))],),
              formatosDisenio.separacionPequenia(context),
              Column(children: listaIngredientes(context,media),),
              formatosDisenio.separacionNormal(context),
              Row(children: [Text('Modo de preparación', style: formatosDisenio.txtRecetas1(context))],),
              formatosDisenio.separacionPequenia(context),
              Column(children: listaPasos(context, media),)
            ],
          )
        ),
      ) ,
    );
  }
}