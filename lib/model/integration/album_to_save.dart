
import 'package:devkitflutter/model/integration/album_by_inmueble_model.dart';

class AlbumToSave{
  late List<AlbumByInmuebleModel> archivos;
  late int idInmueble;

  Map<String, dynamic> toJson(){
    Map<String, dynamic> data = Map<String, dynamic>();
    data['archivos'] = archivos.map((e) => e.toJson()).toList();
    data['idInmueble'] = idInmueble;

    return data;
  }

}