import 'package:flutter/material.dart';

import 'package:hambrout/paginas/app_principal_view.dart';
import 'package:hambrout/paginas/ayuda_view.dart';
import 'package:hambrout/paginas/casa_view.dart';
import 'package:hambrout/paginas/favs_view.dart';
import 'package:hambrout/paginas/fuera_view.dart';
import 'package:hambrout/paginas/lista_view.dart';
import 'package:hambrout/paginas/listas_view.dart';
import 'package:hambrout/paginas/login_view.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'enum/enum_usuario.dart';

final GlobalKey<CasaState> casaKey = GlobalKey();
final GlobalKey<FavsState> favKey = GlobalKey();
final GlobalKey<ListasState> listKey = GlobalKey();
final GlobalKey<ListaState> listaKey = GlobalKey();

List<GlobalKey<dynamic>> keys =[casaKey,favKey,listKey, listaKey];

 List<Widget> pages = <Widget>[
  const FueraWidget(),
  CasaWidget(key: keys[0],),
  FavsWidget(key: keys[1],),
  ListasWidget(key: keys[2],),
  const AyudaWidget()
];

void main() {
  runApp( const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Hambrout',
      home: /**FutureBuilder(
        future: SharedPreferences.getInstance(),
        builder: ((context, snapshot){
          if(snapshot.hasData){
            bool sesionIniciada = snapshot.data?.getBool(dU(DatosUsuario.sesionIniciada))??false;
            if(sesionIniciada){
              return const AppPrincipalWidget();
            } else {
              return const LogInWidget();
            }
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        }),
      ),**/const PaginaCarga(),
      //initialRoute: '/login',
      routes: {
        '/login': (context) => const LogInWidget(),
        '/principal' : (context) => const AppPrincipalWidget()
      },
    );
  }
}

class PaginaCarga extends StatefulWidget{
  const PaginaCarga({super.key});

  @override
  State<StatefulWidget> createState() => PaginaCargaState();

}

class PaginaCargaState extends State<PaginaCarga>{
  bool sesionIniciada=false;

  @override
  void initState() {
    super.initState();
    inicializar();
    Future.delayed(const Duration(seconds: 2)).then((value) => Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context)=>pagina())));
  }

  void inicializar()async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    sesionIniciada=prefs.getBool(dU(DatosUsuario.sesionIniciada))??false;
  }

  Widget pagina(){
    if(sesionIniciada){
      return const AppPrincipalWidget();
    } else {
      return const LogInWidget();
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: SizedBox(
          width: 200,
          height: 200,
          child: CircularProgressIndicator(),
        ),
      ),
    );
  }

}