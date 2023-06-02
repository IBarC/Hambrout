import 'package:flutter/material.dart';

class FormatosDisenio{

  /**
   * Estilo de botón de login burdeos
   */
  ButtonStyle btnBurdeos(){
    return ElevatedButton.styleFrom(
      shadowColor: Colors.black,
      elevation: 7,
      foregroundColor: Colors.white,
      backgroundColor: const Color.fromRGBO(101, 62, 61, 100)
    );
  }

  ButtonStyle btnCatSel(){
    return ElevatedButton.styleFrom(
        elevation: 0,
        foregroundColor: Colors.black,
        backgroundColor: const Color.fromRGBO(251, 208, 164, 100),
        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(5))),
        side: const BorderSide(color: Colors.orange,width: 1.2)
    );
  }

  ButtonStyle btnCatNoSel(){
    return ElevatedButton.styleFrom(
        elevation: 0,
        foregroundColor: Colors.black,
        backgroundColor: Colors.white,
        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(5))),
        side: const BorderSide(color: Colors.orange,width: 1.2)
    );
  }

  SizedBox separacionNormal(BuildContext context){
    return SizedBox(height: MediaQuery.of(context).size.width/15);
  }

  SizedBox separacionPequenia(BuildContext context){
    return SizedBox(height: MediaQuery.of(context).size.width/35);
  }

  TextStyle txtTituloPag(BuildContext context){
    double base = MediaQuery.of(context).size.width;
    double tam=base/12;
    if(base<350){
      tam=23;
    }else if(base>700){
      tam=37;
    }
    return TextStyle(
        overflow: TextOverflow.ellipsis,
        fontWeight: FontWeight.w900,
        //color: Color.fromRGBO(233, 134, 34, 100),
        color: Colors.orange,
        letterSpacing: 1,
        /**foreground: Paint()
        ..style=PaintingStyle.stroke
        ..strokeWidth=2.3
        ..color=Color.fromRGBO(252, 128, 2, 100),**/
        fontSize: tam
    );
  }

  BoxDecoration cajaRecetas(){
    return const BoxDecoration(
      color: Color.fromRGBO(246, 209, 193, 100)
    );
  }

  TextStyle txtTituloCat(BuildContext context){
    double base = MediaQuery.of(context).size.width;
    double tam=base/13;
    if(base<350){
      tam=20;
    }else if(base>700){
      tam=35;
    }
    return TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: tam
    );
  }

  double tamBtnEstrella(BuildContext context){
    double tam = MediaQuery.of(context).size.width;
    if(tam<350) {
      return 20;
    } if (tam>700){
      return 35;
    }
    return tam/13;
  }

  TextStyle txtTituloRecPrev(BuildContext context){
    double base = MediaQuery.of(context).size.width;
    double tam=base/17;
    if(base<350){
      tam=15;
    }else if(base>700){
      tam=30;
    }
    return TextStyle(
      overflow: TextOverflow.ellipsis,
        fontWeight: FontWeight.bold,
        fontSize: tam
    );
  }

  TextStyle txtDatoRecPrev(BuildContext context){
    double base = MediaQuery.of(context).size.width;
    double tam=base/26;
    if(base<350){
      tam=10;
    }else if(base>700){
      tam=20;
    }
    return TextStyle(
        overflow: TextOverflow.ellipsis,
        fontSize: tam
    );
  }
}