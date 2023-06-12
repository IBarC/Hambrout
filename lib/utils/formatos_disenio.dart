import 'package:flutter/material.dart';

///Clase que contiene los estilos
class FormatosDisenio{

//----------BOTONES----------

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
        backgroundColor: const Color.fromRGBO(251, 208, 164, 1),
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

  ButtonStyle btnSeleccionAlert(){
    return ElevatedButton.styleFrom(
        elevation: 0,
        foregroundColor: Colors.orange,
        backgroundColor: Colors.white,
        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(5))),
        side: const BorderSide(color: Colors.orange,width: 1.2)
    );
  }

//----------CAJAS----------

  SizedBox separacionGrande(BuildContext context){
    return SizedBox(height: MediaQuery.of(context).size.width/12);
  }

  SizedBox separacionNormal(BuildContext context){
    return SizedBox(height: MediaQuery.of(context).size.width/15);
  }

  SizedBox separacionPequenia(BuildContext context){
    double base = MediaQuery.of(context).size.width;
    if(base<350){
      return SizedBox(height: base/33,);
    } else if(base>700){
      return SizedBox(height: base/40,);
    }
    return SizedBox(height: base/35);
  }

  SizedBox separacionMasPequenia(BuildContext context){
    return SizedBox(height: MediaQuery.of(context).size.width/80);
  }

//----------DECORACION DE CAJAS----------

  BoxDecoration cajaRecetas(){
    return const BoxDecoration(
        color: Color.fromRGBO(246, 209, 193, 1),
        boxShadow: [
          BoxShadow(
              color: Colors.black26,
              blurRadius: 2,
              offset: Offset(0, 4),
              blurStyle: BlurStyle.normal
          ),
        ]
    );
  }

  BoxDecoration cajaAjustes(){
    return const BoxDecoration(
      color: Color.fromRGBO(246, 209, 193, 1),
    );
  }

//--------------------TEXTOS--------------------

  TextStyle txtTituloPag(BuildContext context){
    double base = MediaQuery.of(context).size.width;
    double tam=base/12;
    if(base<350){
      tam=23;
    }else if(base>700){
      tam=37;
    }
    return TextStyle(
        overflow: TextOverflow.visible,
        fontWeight: FontWeight.w900,
        color: Colors.orange,
        letterSpacing: 1,
        fontSize: tam
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

  TextStyle txtInfoLogin1(bool texto){
    if(texto){
      return const TextStyle(
          overflow: TextOverflow.visible,
          fontSize: 20,
      );
    }
    return const TextStyle(
        overflow: TextOverflow.visible,
        fontSize: 20,
        color: Colors.white
    );
  }

  TextStyle txtInfoLogin2(BuildContext context, bool boton){
    double base = MediaQuery.of(context).size.width;
    double tam=base/20;
    if(base<350){
      tam=13;
    }else if(base>700){
      tam=17;
    }
    if(boton){
      return TextStyle(
          overflow: TextOverflow.visible,
          fontSize: tam,
          color: Colors.white,
          decoration: TextDecoration.underline
      );
    }
    return TextStyle(
        overflow: TextOverflow.visible,
        fontSize: tam,
        color: Colors.white
    );
  }

  TextStyle txtTituloCrearCuetna(BuildContext context){
    double base = MediaQuery.of(context).size.width;
    double tam=base/13;
    if(base<350){
      tam=20;
    }else if(base>700){
      tam=25;
    }
    return TextStyle(
        overflow: TextOverflow.visible,
        fontSize: tam,
        color: Colors.white,
        fontWeight: FontWeight.w600
    );
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
      overflow: TextOverflow.visible,
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
        overflow: TextOverflow.visible,
        fontSize: tam
    );
  }

  TextStyle txtAjustes(BuildContext context){
    double base = MediaQuery.of(context).size.width;
    double tam=base/21;
    if(base<350){
      tam=13;
    }else if(base>700){
      tam=23;
    }
    return TextStyle(
        overflow: TextOverflow.ellipsis,
        fontWeight: FontWeight.w500,
        fontSize: tam
    );
  }

  TextStyle txtTituloRec(BuildContext context){
    double base = MediaQuery.of(context).size.width;
    double tam=base/14;
    if(base<350){
      tam=20;
    }else if(base>700){
      tam=34;
    }
    return TextStyle(
        overflow: TextOverflow.visible,
        fontWeight: FontWeight.w800,
        color: Colors.orange,
        letterSpacing: 1,
        fontSize: tam
    );
  }

  TextStyle txtRecetas1(BuildContext context){
    double base = MediaQuery.of(context).size.width;
    double tam=base/20;
    if(base<350){
      tam=17;
    }else if(base>700){
      tam=28;
    }
    return TextStyle(
        overflow: TextOverflow.visible,
        fontWeight: FontWeight.bold,
        fontSize: tam
    );
  }

  TextStyle txtRecetas2(BuildContext context){
    double base = MediaQuery.of(context).size.width;
    double tam=base/25;
    if(base<350){
      tam=15;
    }else if(base>700){
      tam=25;
    }
    return TextStyle(
        overflow: TextOverflow.visible,
        fontWeight: FontWeight.w700,
        fontSize: tam
    );
  }

  TextStyle txtRecetas3(BuildContext context){
    double base = MediaQuery.of(context).size.width;
    double tam=base/25;
    if(base<350){
      tam=15;
    }else if(base>700){
      tam=25;
    }
    return TextStyle(
        overflow: TextOverflow.visible,
        fontSize: tam
    );
  }

  TextStyle txtTituloLista(BuildContext context){
    double base = MediaQuery.of(context).size.width;
    double tam=base/14;
    if(base<350){
      tam=20;
    }else if(base>700){
      tam=34;
    }
    return TextStyle(
        overflow: TextOverflow.visible,
        fontWeight: FontWeight.w500,
        color: Colors.black,
        letterSpacing: 1,
        fontSize: tam
    );
  }

  TextStyle txtLabelDatosUsu(BuildContext context){
    double base = MediaQuery.of(context).size.width;
    double tam=base/26;
    if(base<350){
      tam=14;
    }else if(base>700){
      tam=25;
    }
    return TextStyle(
        overflow: TextOverflow.visible,
        fontWeight: FontWeight.bold,
        color: Colors.black,
        fontSize: tam
    );
  }

  TextStyle txtInfoDatosUsu(BuildContext context){
    double base = MediaQuery.of(context).size.width;
    double tam=base/23;
    if(base<350){
      tam=15;
    }else if(base>700){
      tam=25;
    }
    return TextStyle(
        overflow: TextOverflow.visible,
        fontWeight: FontWeight.w600,
        fontSize: tam
    );
  }

  TextStyle txtTituloLugar(){
    return const TextStyle(
        fontSize: 23,
        fontWeight: FontWeight.bold
    );
  }

  TextStyle txtDatosLugar(BuildContext context){
    return const TextStyle(
        //overflow: TextOverflow.visible,
        fontSize: 20,
        fontWeight: FontWeight.bold
    );
  }

  TextStyle txtInfoAlert(BuildContext context){
    return const TextStyle(
      //overflow: TextOverflow.visible,
        fontSize: 17,
    );
  }

//--------------------TAMAÑOS--------------------

  double tamBtnEstrella(BuildContext context){
    double tam = MediaQuery.of(context).size.width;
    if(tam<350) {
      return 20;
    } if (tam>700){
      return 35;
    }
    return tam/13;
  }

//--------------------DECORACIONES CAMPOS DE TEXTO--------------------

  InputDecoration decoracionInputLogIn(String label, String hint){
    return InputDecoration(
        border: const OutlineInputBorder(borderSide: BorderSide(color: Colors.black54, width: 1),borderRadius: BorderRadius.all(Radius.circular(7))),
        hintText: hint,
        labelText: label,

    );
  }

  InputDecoration decoracionFormDatos(BuildContext context, String label){
    return InputDecoration(
        disabledBorder: const OutlineInputBorder(borderSide: BorderSide(color: Colors.orange, width: 1),borderRadius: BorderRadius.all(Radius.circular(7))),
        labelStyle: txtLabelDatosUsu(context),
        hintText: label,
        labelText: label);
  }
}