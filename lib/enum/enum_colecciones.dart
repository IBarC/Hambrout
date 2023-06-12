enum Colecciones {userdata, recetas, recetasFavs, listas}

String colecciones(var dato){
  switch(dato){
    case Colecciones.userdata:
      return 'userdata';
    case Colecciones.recetas:
      return 'recetas';
    case Colecciones.recetasFavs:
      return 'recetasFavs';
    case Colecciones.listas:
      return 'listas';
    default:
      return '';
  }
}