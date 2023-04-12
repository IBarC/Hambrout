import 'package:flutter/material.dart';

class LogInWidget extends StatefulWidget{
  const LogInWidget({super.key});

  @override
  State<StatefulWidget> createState() {
    return _LogIn();
  }
}

class _LogIn extends State<LogInWidget>{
/**
  final _formKey = GlobalKey<FormState>();
  final List<TextEditingController> _textEditingControllers = [];
  final List<Widget> _widgets = [];
  String usuario = "usuario";
  String password = "1234";

  @override
  void initState(){
    super.initState();
    _setValoresIniciales();
  }

  _setValoresIniciales(){

  TextEditingController textEditingController =
    TextEditingController(text: "");
    _textEditingControllers.add(textEditingController);
    _widgets.add(Padding(
      padding: const EdgeInsets.all(7.0),
      child: _createTextFormField("Usuario", textEditingController, usuario),
    ));
    TextEditingController textEditingController2 = TextEditingController(text: "");
    _textEditingControllers.add(textEditingController2);
    _widgets.add(Padding(padding: const EdgeInsets.all(7.0),
      child: _createTextFormField("Contraseña", textEditingController2, password),
    ));

    _widgets.add(ElevatedButton(
      onPressed: () {
        _formKey.currentState?.validate();
      },
      child: const Text('Guardar'),
    ));
  }

  TextFormField _createTextFormField(
      String fieldName, TextEditingController controller, String valor) {
    return TextFormField(
      validator: (value) {
        if (value!.isEmpty) {
          return 'Por favor, introduzca $fieldName.';
        } else if (value != valor) {
          return "El valor no es correcto";
        }
        return null;
      },
      decoration: InputDecoration(
          icon: const Icon(Icons.person),
          hintText: fieldName,
          labelText: 'Introduzca $fieldName'),
      controller: controller,
      obscureText: oscurecerTexto(fieldName),
    );
  }

  bool oscurecerTexto(String fieldName){
    if(fieldName=="Contraseña"){
      return true;
    } else {
      return false;
    }
  }
**/



  @override
  Widget build(BuildContext context) {

  Size media = MediaQuery.of(context).size;
    return Scaffold(
      body: Container(
        ///Fondo degradado
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
              end: Alignment(0.0, 1.0),
              colors: <Color>[
                Color(0xFFF5B067),Color(0xFFAE7575),
              ])),
        child: ListView(
          scrollDirection: Axis.vertical,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Image(image: AssetImage("images/icons/write.png"), width: 30,),
                    SizedBox(width: 20,),
                    Text("Hambrout")
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  //crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      height: media.height,
                      width: media.width,
                      child: FormWidget(),
                    )
                    ],
                ),
                Row(),
                Row(),
                Row(),
                Row(),
              ],
            )
          ],
        ),
      )
    );
  }
}

class FormWidget extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();
  final List<TextEditingController> _textEditingControllers = [];
  final List<Widget> _widgets = [];
  String usuario = "usuario";
  String password = "1234";

  FormWidget({Key? key}) : super(key: key) {

    TextEditingController textEditingController =
    TextEditingController(text: "");
    _textEditingControllers.add(textEditingController);
    _widgets.add(Padding(
      padding: const EdgeInsets.all(7.0),
      child: _createTextFormField("Usuario", textEditingController, usuario),
    ));
    TextEditingController textEditingController2 = TextEditingController(text: "");
    _textEditingControllers.add(textEditingController2);
    _widgets.add(Padding(padding: const EdgeInsets.all(7.0),
      child: _createTextFormField("Contraseña", textEditingController2, password),
    ));

    _widgets.add(ElevatedButton(
      onPressed: () {
        _formKey.currentState?.validate();
      },
      child: const Text('Guardar'),
    ));
  }

  bool oscurecerTexto(String fieldName){
    if(fieldName=="Contraseña"){
      return true;
    } else {
      return false;
    }
  }

  TextFormField _createTextFormField(
      String fieldName, TextEditingController controller, String valor) {
    return TextFormField(
      validator: (value) {
        if (value!.isEmpty) {
          return 'Por favor, introduzca $fieldName.';
        } else if (value != valor){
          return "El valor no es correcto";
        }
        return null;
      },
      decoration: InputDecoration(
          icon: const Icon(Icons.person),
          hintText: fieldName,
          labelText: 'Introduzca $fieldName'),
      controller: controller,
      obscureText: oscurecerTexto(fieldName),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(20.0),
        child: Form(
            key: _formKey,
            child: ListView(

              children: _widgets,
            )));
  }
}
