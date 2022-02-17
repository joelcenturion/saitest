import 'package:devkitflutter/model/integration/ciudades_listview_model.dart';

class ZonaListViewModel {
  late String nombre;
  late CiudadesListviewModel ciudades;

  ZonaListViewModel({required this.nombre, required this.ciudades});

  ZonaListViewModel.fromJson(Map<String, dynamic>? json) {
    if(json != null){
      nombre = json['nombre'];
      ciudades = CiudadesListviewModel.fromJson(json['ciudades']);
    }

  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['nombre'] = this.nombre;
    data['ciudades'] = this.ciudades;
    return data;
  }
}
