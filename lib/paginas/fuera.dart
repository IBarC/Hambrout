import 'package:flutter/material.dart';
import 'package:hambrout/paginas/crear_cuenta.dart';
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

  @override
  Widget build(BuildContext context) {

    Size media = MediaQuery.of(context).size;
    double tamanioLogo = media.width/14;

    return Scaffold(
        bottomNavigationBar: BottomNavigationBar(
          elevation: 0,
          showUnselectedLabels: true,

          currentIndex: _indiceSeleccionado,
          onTap: _cambiarPantalla,
          items: <BottomNavigationBarItem>[
            BottomNavigationBarItem(
                icon: Image(
                  image: const AssetImage("images/icons/sun-umbrella-and-deck-chair.png"),
                  width: tamanioLogo,),
              label: 'Fuera'
            ),
            BottomNavigationBarItem(
                icon: Image(
                  image: const AssetImage("images/icons/hosting.png"),
                  width: tamanioLogo,),
                label: 'Casa'
            ),
            BottomNavigationBarItem(
                icon: Image(
                  image: const AssetImage("images/icons/heart.png"),
                  width: tamanioLogo,),
                label: 'Favs'
            ),
            BottomNavigationBarItem(
                icon: Image(
                  image: const AssetImage("images/icons/write.png"),
                  width: tamanioLogo,),
                label: 'Listas'
            ),
            BottomNavigationBarItem(

                icon: Image(
                  image: const AssetImage("images/icons/big-cogwheel.png"),
                  width: tamanioLogo,),
                label: 'Ayuda'
            ),
          ],
        ),
        body: Container(
            width: media.width,
            height: media.height,
            child: Center(
              child: ListView(
                shrinkWrap: true,
                padding: const EdgeInsets.all(40.0),
                scrollDirection: Axis.vertical,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Text("Las paginas")
                    ],
                  ),
                ],
              ),
            )
        )
    );
  }
}