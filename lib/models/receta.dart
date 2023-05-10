class Receta{
  String nombre;
  String dificultad;
  List ingredientes;
  List elaboracion;
  String foto;
  int npersonas;
  String origen;
  String tiempo;
  String tipo;

  Receta({
    required this.nombre, required this.dificultad, required this.ingredientes,
    required this.elaboracion, required this.foto, required this.npersonas,
    required this.origen, required this.tiempo, required this.tipo
  });
}