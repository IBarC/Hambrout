enum Colecciones {userdata, recetas, recetasFavs, listas}

String c(var dato){
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