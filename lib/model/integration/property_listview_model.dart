import 'package:devkitflutter/model/integration/moneda_listview_model.dart';
import 'package:devkitflutter/model/integration/property_type_listview_model.dart';
import 'package:devkitflutter/model/integration/zona_listview_model.dart';

class PropertyListviewModel {
  int? idinmueble;
  late String ref;
  late String titulo;
  int? anoConstruccion;
  late int cocheras;
  late int dormitoriosNormales;
  late int dormitoriosSuit;
  late bool comisionVenta;
  late bool comisionAlquiler;
  late String condicionInmueble;
  late bool directo;
  DateTime? fechaIngreso;
  late String obs;
  late bool piscina;
  late bool planoInmuble;
  late double precio;
  late bool cartel;
  late bool telefono;
  late String telefonoNro;
  late bool tituloPropiedad;
  late String estado;
  late double montoComisionAlquiler;
  late double montoComisionVenta;
  late bool autVenta;
  late bool autAlquiler;
  late int cantPisos;
  late String detallesInmueble;
  DateTime? fechaCartel;
  late bool incluyeIva;
  late String nombreCondominio;
  late String nombreEdificio;
  late double precioExpensas;
  late double precioM2;
  late String telefonosPortero;
  late bool contrato;
  late bool expensas;
  late bool inventario;
  late bool muebles;
  late bool portero;
  late bool publicado;
  late bool process;
  late bool exclusividad;
  late bool parrilla;
  late bool guardia;
  late bool jardin;
  late bool pisoParquet;
  late bool gimnasio;
  late double totalImporteAlquiler;
  late double precioHa;
  late int areasComunes;
  late String casiCalle;
  late String entreCalle;
  late String nombreCalle;
  late String? pathPrincipal;
  ZonaListViewModel? zonas;
  late int numeracion;
  late String referencia;
  double? superficieConstruido;
  late String medidas;
  late String distrito;
  late String ctaCteCatastral;
  late String paraMostrar;
  late int finca;
  late double supAreasComunes;
  late double supPropia;
  double? supTotal;
  late double supTerreno;
  late double supHectareas;
  late double supCubierta;
  late int piso;
  late int casaNro;
  String? ambientes;
  late String areasComunesDescripcion;
  double? latitud;
  double? longitud;
  late int zoom;
  late String urlPublicacion;
  late bool oferta;
  late double montoIva;
  late MoneyListviewModel monedas;
  MoneyListviewModel? monedaAlquiler;
  MoneyListviewModel? monedaVenta;
  late PropertyTypeListviewModel tipoInmueble;
  late bool archivado;


  PropertyListviewModel({
    required this.idinmueble,
    required this.titulo,
    required this.obs,
    required this.comisionVenta,
    required this.comisionAlquiler,
    required this.incluyeIva,
    required this.precio,
    required this.montoComisionVenta,
    required this.montoComisionAlquiler,
    required this.montoIva,
    required this.estado,
    required this.pathPrincipal,
  });

  PropertyListviewModel.fromJson(Map<String, dynamic> json) {
    idinmueble= json['idinmueble']==null?null:json['idinmueble'];
    titulo = json['titulo']==null?"":json['titulo'];
    estado = json['estado'];
    publicado = json['publicado']==null?false:json['publicado'];
    obs = json['obs']==null?"":json['obs'];
    precio = json['precio']==null?0.00:json['precio'].toDouble();
    comisionVenta = json['comisionVenta']==null?false:json['comisionVenta'];
    comisionAlquiler = json['comisionAlquiler']==null?false:json['comisionAlquiler'];
    incluyeIva = json['incluyeIva']==null?false:json['incluyeIva'];
    montoComisionVenta = json['montoComisionVenta']==null?0.00:json['montoComisionVenta'].toDouble();
    montoComisionAlquiler = json['montoComisionAlquiler']==null?0.00:json['montoComisionAlquiler'].toDouble();
    montoIva = json['montoIva']==null?0.00:json['montoIva'].toDouble();
    if(json['zonas']!=null) {
      zonas = ZonaListViewModel.fromJson(json['zonas']);
    }
    ref=json['ref']==null?"":json['ref'];
    pathPrincipal=json['pathPrincipal']==null?"":json['pathPrincipal'];
    if(json['monedas']==null){
      monedas = MoneyListviewModel(idMoneda: 2, nombre: 'GUARANI', simbolo: 'GS');
    }else{
      monedas = MoneyListviewModel.fromJson(json['monedas']);
    }
    if (json['monedaAlquiler'] != null){
      monedaAlquiler = MoneyListviewModel.fromJson(json['monedaAlquiler']);
    }
    if (json['monedaVenta'] != null){
      monedaVenta = MoneyListviewModel.fromJson(json['monedaVenta']);
    }

    tipoInmueble=PropertyTypeListviewModel.fromJson(json['tipoInmueble']);
    //nuevos
    fechaIngreso= DateTime.parse(json['fechaIngreso']);
    if (json['latitud'] != null) latitud = json['latitud'];
    if(json['longitud'] != null) longitud = json['longitud'];
    entreCalle = json['entreCalle']!=null? json['entreCalle']:'';
    casiCalle = json['casiCalle']!=null? json['casiCalle']:'';
    nombreCalle = json['nombreCalle']!=null? json['nombreCalle']:'';
    contrato = json['contrato']==null? false: json['contrato'];
    exclusividad = json['exclusividad'] == null? false: json['exclusividad'];
    directo = json['directo'] == null? false: json['directo'];
    incluyeIva = json['incluyeIva'] == null? false: json['incluyeIva'];
    expensas = json['expensas'] == null? false: json['expensas'];
    precioExpensas = json['precioExpensas'] == null? 0.00 : json['precioExpensas'];
    nombreEdificio = json['nombreEdificio'] == null? '' : json['nombreEdificio'];
    nombreCondominio = json['nombreCondominio'] == null? '' : json['nombreCondominio'];
    numeracion = json['numeracion'] == null? 0 : json['numeracion'];
    referencia = json['referencia'] == null? '' : json['referencia'];
    distrito = json['distrito'] == null? '' : json['distrito'];
    ctaCteCatastral = json['ctaCteCatastral'] == null? '' : json['ctaCteCatastral'];
    finca = json['finca'] == null? 0 : json['finca'];
    piso = json['piso'] == null? 1: json['piso'];
    condicionInmueble = json['condicionInmueble'] == null? '' : json['condicionInmueble'];
    areasComunes = json['areasComunes'] == null? 0 : json['areasComunes'];
    areasComunesDescripcion = json['areasComunesDescripcion'] == null? '' : json['areasComunesDescripcion'];
    if (json['ambientes'] != null) {ambientes = json['ambientes'];}
    if (json['anoConstruccion'] != null) {anoConstruccion = json['anoConstruccion'];}
    cantPisos = json['cantPisos'] == null? 0 : json['cantPisos'];
    cocheras = json['cocheras'] == null? 0 : json['cocheras'];
    dormitoriosNormales = json['dormitoriosNormales'] == null? 0 : json['dormitoriosNormales'];
    dormitoriosSuit = json['dormitoriosSuit'] == null? 0 : json['dormitoriosSuit'];
    piscina = json['piscina'] == null? false : json['piscina'];
    inventario = json['inventario'] ==  null? false : json['inventario'];
    tituloPropiedad = json['tituloPropiedad'] == null? false : json['tituloPropiedad'];
    portero = json['portero'] == null? false : json['portero'];
    telefonosPortero = json['telefonosPortero'] == null? '' : json['telefonosPortero'];
    telefono = json['telefono'] == null? false : json['telefono'];
    telefonoNro = json['telefonoNro'] == null ? '' : json['telefonoNro'];
    parrilla = json['parrilla'] == null? false : json['parrilla'];
    guardia = json['guardia'] == null? false : json['guardia'];
    jardin = json['jardin'] == null? false : json['jardin'];
    pisoParquet = json['pisoParquet'] == null ? false : json['pisoParquet'];
    gimnasio = json['gimnasio'] == null? false : json['gimnasio'];
    planoInmuble = json['planoInmueble'] == null? false : json['planoInmueble'];
    medidas = json['medidas'] == null? '' : json['medidas'];
    if (json['supTotal'] != null){supTotal = json['supTotal'];}
    if (json['superficieConstruido'] != null){superficieConstruido = json['superficieConstruido'];}
    cartel = json['cartel'] != null? false : json['cartel'];
    if(json['fechaCartel'] != null){fechaCartel = DateTime.parse(json['fechaCartel']);}
    detallesInmueble = json['detallesInmueble'] == null? '' : json['detallesInmueble'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['titulo'] = this.titulo;
    data['obs'] = this.obs;
    data['comisionVenta'] = this.comisionVenta;
    data['comisionAlquiler'] = this.comisionAlquiler;
    data['incluyeIva'] = this.incluyeIva;
    data['precio'] = this.precio;
    data['montoComisionVenta'] = this.montoComisionVenta;
    data['montoComisionAlquiler'] = this.montoComisionAlquiler;
    data['montoIva'] = this.montoIva;
    data['monedas'] = this.monedas;
    data['ref']=this.ref;
    data['zonas'] = this.zonas!;
    data['tipoInmueble'] = this.tipoInmueble;
    data['estado'] = this.estado;
    data['pathPrincipal'] = this.pathPrincipal;
    data['publicado'] = this.publicado;
    return data;
  }
}
