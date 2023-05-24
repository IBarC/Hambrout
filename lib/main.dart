import 'package:flutter/material.dart';

import 'package:hambrout/paginas/app_principal_view.dart';
import 'package:hambrout/paginas/ayuda_view.dart';
import 'package:hambrout/paginas/casa_view.dart';
import 'package:hambrout/paginas/favs_view.dart';
import 'package:hambrout/paginas/fuera_view.dart';
import 'package:hambrout/paginas/lista_view.dart';
import 'package:hambrout/paginas/listas_view.dart';
import 'package:hambrout/paginas/login_view.dart';

final GlobalKey<CasaState> casaKey = GlobalKey();
final GlobalKey<FavsState> favKey = GlobalKey();
final GlobalKey<ListasState> listKey = GlobalKey();
final GlobalKey<ListaState> listaKey = GlobalKey();

List<GlobalKey<dynamic>> keys =[casaKey,favKey,listKey, listaKey];

 List<Widget> pages = <Widget>[
  FueraWidget(),
  CasaWidget(key: keys[0],),
  FavsWidget(key: keys[1],),
  ListasWidget(key: keys[2],),
  AyudaWidget()
];

void main() {
  runApp( MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  //funcion que decida si abre al inicio la pagina principal o el login
  //dependiendo de si el token ya existe

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Hambrout',
      //home: const LogInWidget(),
      initialRoute: '/login',
      routes: {
        '/login': (context) => const LogInWidget(),
        '/principal' : (context) => const AppPrincipalWidget()
      },
    );
  }
}