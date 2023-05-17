import 'package:flutter/material.dart';
import 'package:hambrout/paginas/ayuda_view.dart';
import 'package:hambrout/paginas/casa_view.dart';
import 'package:hambrout/paginas/favs_view.dart';
import 'package:hambrout/paginas/fuera_view.dart';
import 'package:hambrout/paginas/listas_view.dart';
import 'package:hambrout/utils/formatos_disenio.dart';

import '../firebase/conexion_firebase.dart';

import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';

final ConexionDatos conexionDatos = ConexionDatos();

class PaginaBaseWidget extends StatefulWidget{
  const PaginaBaseWidget({super.key});

  @override
  State<StatefulWidget> createState() {
    return _PaginaBase();
  }
}
//int _indiceSeleccionado = 0;
class _PaginaBase extends State<PaginaBaseWidget>{

  PersistentTabController _controller = PersistentTabController(initialIndex: 0);

  FormatosDisenio formatosDisenio=FormatosDisenio();

  static final List<PersistentBottomNavBarItem> _navBarsItems = <PersistentBottomNavBarItem>[
    PersistentBottomNavBarItem(
      icon: Icon(Icons.location_on_outlined,),
      title: ("Fuera"),
      activeColorPrimary: Colors.orange,
      inactiveColorPrimary: Colors.black12,
    ),
    PersistentBottomNavBarItem(
      icon: Icon(Icons.house_outlined),
      title: ("Casa"),
      activeColorPrimary: Colors.orange,
      inactiveColorPrimary: Colors.black12,
    ),
    PersistentBottomNavBarItem(
      icon: Icon(Icons.star_purple500_rounded,),
      title: ("Favs"),
      activeColorPrimary: Colors.orange,
      inactiveColorPrimary: Colors.black12,
    ),
    PersistentBottomNavBarItem(
      icon: Icon(Icons.event_note,),
      title: ("Listas"),
      activeColorPrimary: Colors.orange,
      inactiveColorPrimary: Colors.black12,
    ),
    PersistentBottomNavBarItem(
      icon: Icon(Icons.settings),
      title: ("Ayuda"),
      activeColorPrimary: Colors.orange,
      inactiveColorPrimary: Colors.black12,
    ),
  ];

  static const List<Widget> _pages = <Widget>[
    FueraWidget(),
    CasaWidget(),
    FavsWidget(),
    ListasWidget(),
    AyudaWidget()
  ];

  @override
  Widget build(BuildContext context) {

    _controller = PersistentTabController(initialIndex: 0);

    Size media = MediaQuery.of(context).size;
    ///double tamanioIcono = media.width/14;

    return PersistentTabView(
    /**onItemSelected: (index){
        _controller.index=index;
        (_controller.index==2) ? setState((){_controller.index=index;}): null ;
        print('----------------${_controller.index}');
      },

      (index){

        //con que el documento no este vacio ya ha habido cambio y hace setstate
        if(index==2) {
          //manda que busque en favs
          setState(() {
            _controller.index = index;
            print('---------Pulsa 2');
          });
        }
      },**/
      context,
      controller: _controller,
      screens: _pages,
      items: _navBarsItems,
      confineInSafeArea: true,
      backgroundColor: Colors.white, // Default is Colors.white.
      handleAndroidBackButtonPress: true, // Default is true.
      resizeToAvoidBottomInset: true, // This needs to be true if you want to move up the screen when keyboard appears. Default is true.
      stateManagement: true, // Default is true.
      hideNavigationBarWhenKeyboardShows: true, // Recommended to set 'resizeToAvoidBottomInset' as true while using this argument. Default is true.
      decoration: NavBarDecoration(
        borderRadius: BorderRadius.circular(10.0),
        colorBehindNavBar: Colors.white,
      ),
      popAllScreensOnTapOfSelectedTab: false,
      popActionScreens: PopActionScreensType.all,
      itemAnimationProperties: const ItemAnimationProperties( // Navigation Bar's items animation properties.
        duration: Duration(milliseconds: 200),
        curve: Curves.ease,
      ),
      screenTransitionAnimation: const ScreenTransitionAnimation( // Screen transition animation on change of selected tab.
        animateTabTransition: true,
        curve: Curves.ease,
        duration: Duration(milliseconds: 200),
      ),
      navBarStyle: NavBarStyle.style6, // Choose the nav bar style with this property.
    );
  }
}

/**
class _PaginaBase extends State<PaginaBaseWidget>{
  FormatosDisenio formatosDisenio=FormatosDisenio();

  int _indiceSeleccionado = 0;

  void _cambiarPantalla(int indice){
    setState(() {
      _indiceSeleccionado = indice;
    });
  }

  final List<Future<List>> _funciones = [
    conexionDatos.buscarRecetas()
  ];

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
      body: SizedBox(
          width: media.width,
          height: media.height,
          child: IndexedStack(
            index: _indiceSeleccionado,
            children: _pages,
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
              icon: Icon(Icons.location_on_outlined, size: tamanioIcono,),
              label: 'Fuera'
          ),
          BottomNavigationBarItem(
              icon:Icon(Icons.house_outlined, size: tamanioIcono,),
              label: 'Casa'
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.star_purple500_rounded, size: tamanioIcono,),
              label: 'Favs'
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.event_note, size: tamanioIcono,),
              label: 'Listas'
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.settings, size: tamanioIcono,),
              label: 'Ayuda'
          ),
        ],
      ),
    );
  }
}**/