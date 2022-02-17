
import 'package:devkitflutter/model/integration/departamentos_listview_model.dart';

class CiudadesListviewModel {
  late String nombre;
  late DepartamentosListviewModel departamentos;

  CiudadesListviewModel({required this.nombre, required this.departamentos});

  CiudadesListviewModel.fromJson(Map<String, dynamic>? json) {
    if(json!=null) {
      nombre = json['nombre'];
      departamentos =
          DepartamentosListviewModel.fromJson(json['departamentos']);
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['nombre'] = this.nombre;
    data['departamentos'] = this.departamentos;
    return data;
  }
}