enum DatosListas{titulo, elementos, nombre, tachado}

String l(var dato){
  switch(dato){
    case DatosListas.titulo:
      return 'titulo';
    case DatosListas.elementos:
      return 'elementos';
    case DatosListas.nombre:
      return 'nombre';
    case DatosListas.tachado:
      return 'tachado';
    default:
      return '';
  }
}