import 'package:flutter/material.dart';
import 'package:hambrout/paginas/ayuda.dart';
import 'package:hambrout/paginas/casa.dart';
import 'package:hambrout/paginas/crear_cuenta.dart';
import 'package:hambrout/paginas/favs.dart';
import 'package:hambrout/paginas/fuera.dart';
import 'package:hambrout/paginas/listas.dart';
import 'package:hambrout/utils/formatos_disenio.dart';
import 'package:hambrout/utils/formularios.dart';

class PaginaBaseWidget extends StatefulWidget{
  const PaginaBaseWidget({super.key});

  @override
  State<StatefulWidget> createState() {
    return _PaginaBase();
  }
}

class _PaginaBase extends State<PaginaBaseWidget>{
  FormatosDisenio formatosDisenio=FormatosDisenio();

  int _indiceSeleccionado = 0;

  void _cambiarPantalla(int indice){
    setState(() {
      _indiceSeleccionado = indice;
    });
  }

  static const List<Widget> _pages = <Widget>[
    FueraWidget(),
    CasaWidget(),
    FavsWidget(),
    ListasWidget(),
    AyudaWidget()
  ];

  @override
  Widget build(BuildContext context) {

    Size media = MediaQuery.of(context).size;
    double tamanioIcono = media.width/14;

    return Scaffold(
      body: Container(
          width: media.width,
          height: media.height,
          child: Center(
              child: _pages.elementAt(_indiceSeleccionado)
          )
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: const Color(0xFFF5B067),
        elevation: 8,
        type: BottomNavigationBarType.fixed,
        //showUnselectedLabels: true,
        selectedIconTheme: const IconThemeData(color: Colors.black,),
        selectedItemColor: Colors.black,
        //showSelectedLabels: true,
        selectedFontSize:  media.width/28,
        unselectedIconTheme: const IconThemeData(color: Colors.black38),
        currentIndex: _indiceSeleccionado,
        onTap: _cambiarPantalla,
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
              icon: Icon(Icons.location_on_outlined, size: tamanioIcono,)/**Image(
              image: const AssetImage("images/icons/sun-umbrella-and-deck-chair.png"),
              width: tamanioLogo,)**/,
              label: 'Fuera'
          ),
          BottomNavigationBarItem(
              icon:Icon(Icons.house_outlined, size: tamanioIcono,) /**Image(
                image: const AssetImage("images/icons/hosting.png"),
                width: tamanioLogo,)**/,
              label: 'Casa'
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.star_purple500_rounded, size: tamanioIcono,)/**Image(
                image: const AssetImage("images/icons/heart.png"),
                width: tamanioLogo,)**/,
              label: 'Favs'
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.event_note, size: tamanioIcono,)/**Image(
                image: const AssetImage("images/icons/write.png"),
                width: tamanioLogo,)**/,
              label: 'Listas'
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.settings, size: tamanioIcono,)/**Image(
                image: const AssetImage("images/icons/big-cogwheel.png"),
                width: tamanioLogo,)**/,
              label: 'Ayuda'
          ),
        ],
      ),
    );
  }
}