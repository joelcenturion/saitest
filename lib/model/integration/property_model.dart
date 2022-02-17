
import 'package:devkitflutter/model/integration/historico_actividades_model.dart';
import 'package:devkitflutter/model/integration/historico_estados_model.dart';
import 'package:devkitflutter/model/integration/property_type_listview_model.dart';
import 'package:devkitflutter/model/integration/zona_listview_model.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:multi_image_picker/multi_image_picker.dart';

class PropertyModel {
  int? idinmueble;
  late String ref;
  late String fechaIngreso;
  late String titulo;
  late String direccion;
  late LatLng gps;
  double? latitud;
  double? longitud;
  String? descripcion;
  double? precioVenta;
  double? precioAlquiler;
  List<Asset> images=[];
  Asset? coverImage;
  int coverImageIndex = 0;
  // List<List<dynamic>>? images64;
  // List<String?>? coverImage64;
  String? monedaAlquiler;
  String? monedaVenta;
  late PropertyTypeListviewModel tipoInmueble;
  //tab caracteristicas
  String? areasComunesDescripcion;
  List<String?>? destinosAlquiler;
  int? anoConstruccion;
  bool piscina=false;
  bool generador=false;
  bool inventario=false;
  bool tituloPropiedad=false;
  bool telefono=false;
  String? telefonoNro;
  bool portero=false;
  String? telefonosPortero;
  bool parrilla=false;
  bool guardia=false;
  bool jardin=false;
  bool pisoParquet=false;
  bool gimnasio=false;
  bool cartel=false;
  bool planoInmuble=false;
  int areasComunes=0;
  int cantPisos=0;
  int cantDpto=0;
  bool cochera=false;
  int cocheras=0;
  bool baulera=false;
  int bauleras=0;
  int dormitoriosSuite=0;
  int dormitoriosNormales=0;
  int dormitoriosPlantaBaja = 0;
  String? ambientes;
  String? generadorDescripcion;
  String? medidas;
  double? supTotal;
  double? superficieConstruido;
  String? fechaCartel;
  String? descrInmueble;
  //tab adicionales
  bool directo=false;
  bool contrato=false;
  bool iva=false;
  bool exclusividad=false;
  bool expensas=false;
  double? precioExpensas = 0.0;
  bool cocheraAdicional = false;
  double? precioCocheraAdicional = 0.0;
  bool bauleraAdicional = false;
  double? precioBauleraAdicional = 0.0;
  bool muebles = false;
  double? precioMueblesAdicional = 0.0;
  double? precioM2 = 0.0;
  double? precioHa = 0.0;
  String? condicionInmueble;
//tab direccion
  String? departamento;
  String? ciudad;
  String? barrio;
  String? zona;
  String? nombreEdificio;
  String? nombreCondominio;
  int?  numeracion;
  String? nombreCalle;
  String? entreCalle;
  String? casiCalle;
  String? distrito;
  int? finca=0;
  String? ctaCteCatastral;
  int? piso;
  String? referencia;
  bool comisionVenta = false;
  bool comisionAlquiler = false;
  double porcentajeComisionVenta = 0.0;
  double porcentajeComisionAlquiler = 0.0;
  ZonaListViewModel? zonas;
  //no en app
  late String estado;
  late bool publicado;
  late String pathPrincipal;
  //para edit
  List<HistoricoEstadosModel> estados = [];
  List<HistoricoActividadesModel> actividades = [];
  //estados
  bool archivado = false;
  String? duracionAlq;
  int? diasNotif;

  PropertyModel({required this.titulo, required this.fechaIngreso,
    required this.direccion,
    required this.gps,
    required this.monedaAlquiler,
    required this.monedaVenta,
    required this.precioVenta,
    required this.precioAlquiler
  });

  PropertyModel.fromJson(Map<String, dynamic> json) {
      idinmueble = json['idinmueble'];
      ref = json['ref']??'';
      fechaIngreso = json['fechaIngreso']??'';
      titulo = json['titulo']??'Sin Titulo';
      direccion = json['direccion']??'Sin Dirección';
      latitud = json['latitud'] == null ? 0.0 : json['latitud'];
      longitud = json['longitud'] == null ? 0.0 : json['longitud'];
      gps = json['gps'] != null ? json['gps'] : (json['latitud'] != null &&
          json['longitud'] != null)
          ? LatLng(json['latitud'], json['longitud'])
          : LatLng(0.0, 0.0);
      descripcion = json['descripcion'] == null ? '' : json['descripcion'];
      precioVenta =
      json['precioVenta'] != null ? json['precioVenta'] : (json['precio'] !=
          null) ? json['precio'] : 0.0;
      precioAlquiler = json['precioAlquiler'] != null
          ? json['precioAlquiler']
          : json['precio'] != null ? json['precio'] : 0.0;
      if (json['monedaAlquiler'] != null) {
        monedaAlquiler =
        json['monedaAlquiler']['simbolo'] == 'GS' ? 'Gs.' : '\$';
      } else if (json['monedas'] != null) {
        monedaAlquiler = json['monedas']['simbolo'] == 'GS' ? 'Gs.' : '\$';
      } else {
        monedaAlquiler = 'Gs.';
      }
      if (json['monedaVenta'] != null) {
        monedaVenta = json['monedaVenta']['simbolo'] == 'GS' ? 'Gs.' : '\$';
      } else if (json['monedas'] != null) {
        monedaVenta = json['monedas']['simbolo'] == 'GS' ? 'Gs.' : '\$';
      } else {
        monedaVenta = '\$';
      }
      tipoInmueble = PropertyTypeListviewModel.fromJson(json['tipoInmueble']);
      areasComunesDescripcion = json['areasComunesDescripcion'];
      destinosAlquiler = json['destinosAlquiler'];
      anoConstruccion = json['anoConstruccion'];
      piscina = json ['piscina'] == null ? false : json['piscina'];
      generador = json['generador'] == null ? false : json['generador'];
      inventario = json['inventario'] == null ? false : json['inventario'];
      tituloPropiedad =
      json['tituloPropiedad'] == null ? false : json['tituloPropiedad'];
      telefono = json['telefono'] ?? false;
      telefonoNro = json['telefonoNro'];
      portero = json['portero'] ?? false;
      telefonosPortero = json['telefonosPortero'];
      parrilla = json['parrilla'] ?? false;
      guardia = json['guardia'] ?? false;
      jardin = json['jardin'] ?? false;
      pisoParquet = json['pisoParquet'] ?? false;
      gimnasio = json['gimnasio'] ?? false;
      cartel = json['cartel'] ?? false;
      planoInmuble = json['planoInmuble'] ?? false;
      areasComunes = json['areasComunes'] ?? 0;
      cantPisos = json['cantPisos'] ?? 0;
      cantDpto = json['cantDpto'] ?? 0;
      cochera = json['cochera'] ?? false;
      cocheras = json['cocheras'] ?? 0;
      baulera = json['baulera'] ?? false;
      bauleras = json['bauleras'] ?? 0;
      dormitoriosSuite = json['dormitoriosSuit'] ?? 0;
      dormitoriosNormales = json['dormitoriosNormales'] ?? 0;
      dormitoriosPlantaBaja = json['dormitoriosPlantaBaja'] ?? 0;
      ambientes = json['ambientes'];
      generadorDescripcion = json['generadorDescripcion'];
      medidas = json['medidas'];
      supTotal = json['supTotal'];
      superficieConstruido = json['superficieConstruido'];
      fechaCartel = json['fechaCartel'];
      descrInmueble = json['descrInmueble'];
      directo = json['directo'] ?? false;
      contrato = json['contrato'] ?? false;
      iva = json['iva'] ?? false;
      exclusividad = json['exclusividad'] ?? false;
      expensas = json['expensas'] ?? false;
      precioExpensas = json['precioExpensas'] ?? 0.0;
      cocheraAdicional = json['cocheraAdicional'] ?? false;
      precioCocheraAdicional = json['precioCocheraAdicional'] ?? 0.0;
      bauleraAdicional = json['bauleraAdicional'] ?? false;
      precioBauleraAdicional = json['precioBauleraAdicional'] ?? 0.0;
      muebles = json['muebles'] ?? false;
      precioMueblesAdicional = json['precioMueblesAdicional'] ?? 0.0;
      precioM2 = json['precioM2'] ?? 0.0;
      precioHa = json['precioHa'] ?? 0.0;
      condicionInmueble = json['condicionInmueble'];
      nombreEdificio = json['nombreEdificio'];
      nombreCondominio = json['nombreCondominio'];
      numeracion = json['numeracion'] ?? 0;
      nombreCalle = json['nombreCalle'];
      entreCalle = json['entreCalle'];
      casiCalle = json['casiCalle'];
      distrito = json['distrito'];
      finca = json['finca'] ?? 0;
      ctaCteCatastral = json['ctaCteCatastral'];
      piso = json['piso'] ?? 0;
      referencia = json['referencia'];
      comisionVenta = json['comisionVenta'] ?? false;
      comisionAlquiler = json['comisionAlquiler'] ?? false;
      porcentajeComisionVenta = json['porcComisionVta'] ?? 0.0;
      porcentajeComisionAlquiler = json['porcComisionAlq'] ?? 0.0;

      //no en app
      estado = json['estado'] ?? '';
      publicado = json['publicado'] ?? false;
      pathPrincipal = json['pathPrincipal']??'';
      if (json['zonas'] != null) {
        zonas = ZonaListViewModel.fromJson(json['zonas']);
      }
  }

  //Json para Guardar
  Map<String, dynamic> toJson() {
    Map data = assembleData();
    return {"inmueble": data};
  }

  //Json para Editar
  Map<String, dynamic> toJsonEdited(){
    Map data = assembleData();
    data['idinmueble'] = idinmueble;
    data['actividades'] = actividades.map((e) => e.toJson()).toList();
    data['estado'] = estado;
    return {"inmueble": data};
  }

  Map<String, dynamic> assembleData(){
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['idinmueble'] = null;
    data['fechaIngreso'] = fechaIngreso;
    data['titulo'] = titulo;
    data['direccion'] = direccion;
    data['latitud'] = gps.latitude;
    data['longitud'] = gps.longitude;
    data['descripcion'] = descripcion;
    data['precioVenta'] = precioVenta;
    data['monedaVenta'] = monedaVenta;
    data['precioAlquiler'] = precioAlquiler;
    data['monedaAlquiler'] = monedaAlquiler;
    // data['images'] = images64;
    // data['coverImage'] = coverImage64;
    data['tipoInmueble'] = tipoInmueble.toJson();
    data['areasComunesDescripcion'] = areasComunesDescripcion;
    data['destinosAlquiler'] = destinosAlquiler;
    data['anoConstruccion'] = anoConstruccion;
    data['piscina'] = piscina;
    data['generador'] = generador;
    data['inventario'] = inventario;
    data['tituloPropiedad'] = tituloPropiedad;
    data['telefono'] = telefono;
    data['telefonoNro'] = telefonoNro;
    data['portero'] = portero;
    data['telefonosPortero'] = telefonosPortero;
    data['parrilla'] = parrilla;
    data['guardia'] = guardia;
    data['jardin'] = jardin;
    data['pisoParquet'] = pisoParquet;
    data['gimnasio'] = gimnasio;
    data['cartel'] = cartel;
    data['planoInmuble'] = planoInmuble;
    data['areasComunes'] = areasComunes;
    data['cantPisos'] = cantPisos;
    data['cantDpto'] = cantDpto;
    data['cochera'] = cochera;
    data['cocheras'] = cocheras;
    data['baulera'] = baulera;
    data['bauleras'] = bauleras;
    data['dormitoriosSuite'] = dormitoriosSuite;
    data['dormitoriosNormales'] = dormitoriosNormales;
    data['dormitoriosPlantaBaja'] = dormitoriosPlantaBaja;
    data['ambientes'] = ambientes;
    data['generadorDescripcion'] = generadorDescripcion;
    data['medidas'] = medidas;
    data['supTotal'] = supTotal;
    data['superficieConstruido'] = superficieConstruido;
    data['fechaCartel'] = fechaCartel;
    data['descrInmueble'] = descrInmueble;
    data['directo'] = directo;
    data['contrato'] = contrato;
    data['iva'] = iva;
    data['exclusividad'] = exclusividad;
    data['expensas'] = expensas;
    data['precioExpensas'] = precioExpensas;
    data['cocheraAdicional'] = cocheraAdicional;
    data['precioCocheraAdicional'] = precioCocheraAdicional;
    data['bauleraAdicional'] = bauleraAdicional;
    data['precioBauleraAdicional'] = precioBauleraAdicional;
    data['muebles'] = muebles;
    data['precioMueblesAdicional'] = precioMueblesAdicional;
    data['precioM2'] = precioM2;
    data['precioHa'] = precioHa;
    data['condicionInmueble'] = condicionInmueble;
    data['departamento'] = departamento;
    data['ciudad'] = ciudad;
    data['barrio'] = barrio;
    data['zona'] = zona;
    data['nombreEdificio'] = nombreEdificio;
    data['nombreCondominio'] = nombreCondominio;
    data['numeracion'] = numeracion;
    data['nombreCalle'] = nombreCalle;
    data['entreCalle'] = entreCalle;
    data['casiCalle'] = casiCalle;
    data['distrito'] = distrito;
    data['finca'] = finca;
    data['ctaCteCatastral'] = ctaCteCatastral;
    data['piso'] = piso;
    data['referencia'] = referencia;
    data['comisionVenta'] = comisionVenta;
    data['comisionAlquiler'] = comisionAlquiler;
    data['porcComisionVta'] = porcentajeComisionVenta;
    data['porcComisionAlq'] = porcentajeComisionAlquiler;
    data['archivado'] = archivado;
    data['duracionAlq'] = duracionAlq;
    data['diasNotif'] = diasNotif;
    data['estados'] = estados.map((e) => e.toJson()).toList();

    return data;
  }

}
