enum DatosListas{titulo, elementos, nombre, tachado, id}

String listas(var dato){
  switch(dato){
    case DatosListas.titulo:
      return 'titulo';
    case DatosListas.elementos:
      return 'elementos';
    case DatosListas.nombre:
      return 'nombre';
    case DatosListas.tachado:
      return 'tachado';
    case DatosListas.id:
      return 'id';
    default:
      return '';
  }
}