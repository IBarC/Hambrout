import 'package:flutter/material.dart';

import '../enum/enum_listas.dart';
import '../models/lista.dart';

class ListaWidget extends StatefulWidget{
  final Lista lista;

  const ListaWidget({super.key, required this.lista});

  @override
  State<StatefulWidget> createState() {
    return _Lista(lista: lista);
  }
}

class _Lista extends State<ListaWidget>{
  Lista lista;

  _Lista({required this.lista});
  List<Widget> _widgets = [];

  @override
  void initState() {
    super.initState();
  }

  Widget crearElemento(var elemento){
    if(elemento[l(DatosListas.tachado)]){
      return Row(
        children: [
          Column(children: [IconButton(onPressed: (){}, icon: Icon(Icons.check_box_outlined))],),
          Column(children: [Text(elemento[l(DatosListas.nombre)], style: TextStyle(decoration: TextDecoration.lineThrough))],)
        ],
      );
    }
    return Row(
      children: [
        Column(children: [IconButton(onPressed: (){}, icon: Icon(Icons.crop_square))],),
        Column(children: [Text(elemento[l(DatosListas.nombre)],)])
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    Size media = MediaQuery.of(context).size;

    return Scaffold(
      body: Container(
        height: media.height,
        width: media.width,
        decoration: const BoxDecoration(color: Colors.white70),
        child: Padding(
          padding: EdgeInsets.all(media.height/50),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [ IconButton(onPressed: (){Navigator.pop(context);}, icon: const Icon(Icons.arrow_back_ios_new))
                ],
              ),
              Row(children: [Text(lista.titulo)],),
              ListView.builder(
                shrinkWrap: true,
                  itemCount: lista.elementos.length,
                  itemBuilder: (context, index){
                    return crearElemento(lista.elementos[index]);
                  }
              )
            ],
          ),
        ),
      ) ,
    );
  }

}