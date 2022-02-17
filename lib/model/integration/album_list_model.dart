
import 'package:devkitflutter/model/integration/album_by_inmueble_model.dart';

class AlbumListModel {
  late AlbumByInmuebleModel archivo;
  late String data;
  int? inmueble;

  AlbumListModel({
    required this.data,
    required this.inmueble,
  });

  AlbumListModel.fromJson(Map<String, dynamic> json){
      archivo = AlbumByInmuebleModel.fromJson(json['archivo']);
      archivo.data = json['data'];
      data = json['data'];
      inmueble = json['inmueble'];
  }

}

