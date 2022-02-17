import 'package:devkitflutter/config/constant.dart';
import 'package:devkitflutter/library/smooth_star_rating/smooth_star_rating.dart';
import 'package:devkitflutter/network/api_provider.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinbox/flutter_spinbox.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';

import '../edit_property_page.dart';

class EditCaracteristicasTabPage extends StatefulWidget {
  @override
  _EditCaracteristicasTabPageState createState() => _EditCaracteristicasTabPageState();
}

class _EditCaracteristicasTabPageState extends State<EditCaracteristicasTabPage> with AutomaticKeepAliveClientMixin {

  @override
  bool get wantKeepAlive => true;
  // initialize global widget
  final DateFormat format=DateFormat("yyyy-MM-dd");
  double _condicionIndex = 6;



  final _controllerTelefonos = TextEditingController();
  final  _condicion = ["Malo", "Regular", "Bueno", "Muy Bueno", "Excelente","A Estrenar", "En Pozo"];
  final CancelToken apiToken = CancelToken();
  List<String?> destinosViewData = [];
  var _controllerMedidas = TextEditingController();
  var _controllerSupTotal = TextEditingController();
  var _controllerSupConstruida = TextEditingController();
  var _controllerPortero = TextEditingController();
  DateTime _selectedDateCartel=DateTime.now();
  var _controllerCartel = TextEditingController();
  var _controllerDescripcionAreasComunes= TextEditingController();
  var _controllerDescInmueble = TextEditingController();

  @override
  void initState() {
    _getDestinosFromApi();
    _initializeForm();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _initializeForm(){
    String? cond = Property.data.condicionInmueble?.toUpperCase();
    _condicionIndex = cond == 'MALO'? 0 : cond == 'REGULAR'? 1 : (cond == 'BUENO')? 2 : (cond=='MUYBUENO') ? 3 : (cond == 'EXCELENTE') ? 4 : (cond == 'AESTRENAR')? 5 : 6;
    _controllerDescripcionAreasComunes.text = Property.data.areasComunesDescripcion??'';
    _controllerPortero.text = Property.data.telefonosPortero??'';
    _controllerTelefonos.text = Property.data.telefonoNro??'';
    _controllerMedidas.text = Property.data.medidas??'';
    if (Property.data.supTotal != null){_controllerSupTotal.text = Property.data.supTotal.toString();}
    if (Property.data.superficieConstruido != null){_controllerSupConstruida.text = Property.data.superficieConstruido.toString();}
    if (Property.data.fechaCartel != null) {_controllerCartel.text = Property.data.fechaCartel!;}
    _controllerDescInmueble.text = Property.data.descrInmueble??'';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(20),
      child:ListView(
        children: _items(),
      ),
    );
  }

  Future  _getDestinosFromApi() async {
    if(Property.data.destinosAlquiler!=null){
      if(Property.data.destinosAlquiler!.isEmpty){
        ApiProvider _apiProvider = ApiProvider();
        _apiProvider.getDestinosState(apiToken).then((response) {
          setState(() {
            destinosViewData.addAll(response);
          });
        });
      }
    }
    print('destinos: ${Property.data.destinosAlquiler}');
  }

  List<Widget> _items(){
    return [
      Container(
        width: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: [
            Text('Destino del alquiler'),
            SizedBox(height: 4),
            Container(
              width: double.infinity,
              child: destinosViewData.isEmpty? Text("Cargando..."):
              MultiSelectChipField<String?>(
                decoration: BoxDecoration(
                  border: null,
                ),
                textStyle: GoogleFonts.nunito(
                  fontSize: 10,
                  fontWeight: FontWeight.normal,
                ),
                selectedTextStyle: GoogleFonts.nunito(
                  fontSize:9,
                  fontWeight: FontWeight.normal,
                ),
                showHeader: false,
                searchable:false,
                items: destinosViewData.map((e) =>
                    MultiSelectItem<String?>(e, e.toString())
                ).toList(),
                onTap: (values) {
                  Property.data.destinosAlquiler = values;
                },
              ),
            ),
          ],
        ),
      ),
      SizedBox(height: 16),
      Container(
          child: Column(
              children: [
                Text('Condición: '+(_condicion[_condicionIndex.toInt()])),
                SizedBox(height: 4),
                SmoothStarRating(
                  rating: _condicionIndex,
                  isReadOnly: false,
                  size: 35,
                  filledIconData: Icons.star,
                  defaultIconData: Icons.star_border,
                  color: Colors.yellow[700],
                  borderColor: Colors.yellow[700],
                  starCount: 6,
                  allowHalfRating: false,
                  spacing: 1,
                  onRated: (value) {
                    setState(() {
                      _condicionIndex = value;
                      Property.data.condicionInmueble = _condicion[_condicionIndex.toInt()];
                    });
                  },
                ),
              ]
          )
      ),
      SizedBox(height: 16),
      Container(
        child:Column(
          children: [
            Text('Cantidad de Areas Comunes'),
            SizedBox(height: 4),
            SpinBox(
              min: 0,
              value: Property.data.areasComunes.toDouble(),
              onChanged: (value) => {
                Property.data.areasComunes=value.toInt()
              },
            )
          ]
        ),
      ),
      SizedBox(height: 16),
      Container(
        child: Column(
          children: [
            Text('Descripción de Areas Comunes'),
            SizedBox(height: 4),
            Container(
              // color: Colors.grey,
              decoration: BoxDecoration(
                border: Border.all(color: SOFT_GREY, width: 0),
                borderRadius: BorderRadius.circular(8),
              ),
              // padding: EdgeInsets.all(7.0),
              padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: 100,
                  maxHeight: 100,
                ),
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: TextField(
                    onChanged: (value){
                      Property.data.areasComunesDescripcion = value;
                    },
                    controller: _controllerDescripcionAreasComunes,
                    keyboardType: TextInputType.multiline,
                    minLines: 4,
                    maxLines: null, //grow automatically
                    decoration: InputDecoration.collapsed(
                      hintText: 'Descripción de areas comunes',
                      hintStyle: TextStyle(
                        color: SOFT_GREY,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      SizedBox(height: 16),
      Container(
        child: Column(
          children: [
            Text('Ambientes'),
            SizedBox(height: 4),
            ButtonTheme(
              alignedDropdown: true,
              child:DropdownButtonFormField<String?>(
                isExpanded: true,
                style: GoogleFonts.nunito(
                  color: Colors.black54,
                ),
                hint: Text("Seleccione..."),
                value: Property.data.ambientes,
                items: ["Monoambiente","1 Dormitorio","2 Dormitorios","3 Dormitorios"].map((e) =>
                  new DropdownMenuItem<String?>(
                    value: e,
                    child: Text(e.toString(),
                      style:GoogleFonts.nunito(
                        color: Colors.black54,
                      ),
                    ),
                  )
                ).toList(),
                onChanged: (_v) {
                  setState(() {
                    Property.data.ambientes = _v;
                  });
                },
              ),
            ),
          ]
        )
      ),
      SizedBox(height: 16),
      Container(
        child: Column(
          children: [
            Text('Año de construcción'),
            SizedBox(height: 4),
            ButtonTheme(
              alignedDropdown: true,
              child:DropdownButtonFormField<int>(
                isExpanded: true,
                style: GoogleFonts.nunito(
                  color: Colors.black54,
                ),
                hint: Text("Seleccione..."),
                value: Property.data.anoConstruccion,
                items: List.generate(52, (i) => (i+DateTime.now().year-51) + 1).map((int z) {
                  return DropdownMenuItem<int>(
                    value: z,
                    child: Text(z.toString(), style:
                    GoogleFonts.nunito(
                      color: Colors.black54,
                    ),
                    ),
                  );
                }).toList(),
                onChanged: (_v) {
                  setState(() {
                    Property.data.anoConstruccion = _v;
                  });
                },
              ),
            ),
          ]
        )
      ),
      SizedBox(height: 16),
      Flex(
        direction: Axis.horizontal,
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: Column(
              children: [
                Text('Cant. de Pisos'),
                SizedBox(height: 4),
                SpinBox(
                  min: 0,
                  value: Property.data.cantPisos.toDouble(),
                  onChanged: (value) => {
                    Property.data.cantPisos=value.toInt()
                  },
                ),
              ],
            )
          ),
          SizedBox(width: 5),
          Expanded(
            child: Column(
              children: [
                Text('Cant. de Dptos.'),
                SizedBox(height: 4),
                SpinBox(
                  min: 0,
                  value: Property.data.cantDpto.toDouble(),
                  onChanged: (value) => {
                    Property.data.cantDpto=value.toInt()
                  },
                ),
              ],
            ),
          ),
        ],
      ),
      SizedBox(height: 16),
      Flex(
        direction: Axis.horizontal,
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: Column(
              children: [
                Text('Cochera'),
                SizedBox(height: 4),
                Switch(
                  value: Property.data.cochera,
                  onChanged: (value) {
                    setState(() {
                      Property.data.cochera = value;
                    });
                  },
                ),
              ],
            )
          ),
          SizedBox(width: 5),
          Expanded(
            child: Column(
              children: [
                Text('Cocheras'),
                SizedBox(height: 4),
                SpinBox(
                  key: UniqueKey(),
                  enabled: Property.data.cochera,
                  min: 0,
                  value: Property.data.cocheras.toDouble(),
                  onChanged: (value) => {
                    Property.data.cocheras=value.toInt()
                  },
                ),
              ],
            ),
          ),
        ],
      ),
      SizedBox(height: 16),
      Flex(
        direction: Axis.horizontal,
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
              child: Column(
                children: [
                  Text('Baulera'),
                  SizedBox(height: 4),
                  Switch(
                    value: Property.data.baulera,
                    onChanged: (value) {
                      setState(() {
                        Property.data.baulera = value;
                      });
                    },
                  ),
                ],
              )
          ),
          SizedBox(width: 5),
          Expanded(
            child: Column(
              children: [
                Text('Bauleras'),
                SizedBox(height: 4),
                SpinBox(
                  key: UniqueKey(),
                  enabled: Property.data.baulera,
                  min: 0,
                  value: Property.data.bauleras.toDouble(),
                  onChanged: (value) => {
                    Property.data.bauleras=value.toInt()
                  },
                ),
              ],
            ),
          ),
        ],
      ),
      SizedBox(height: 16),
      Flex(
        direction: Axis.horizontal,
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
              child: Column( children: [
                Text('Dormitorios en Suite'),
                SizedBox(height: 4),
                SpinBox(
                  min: 0,
                  value: Property.data.dormitoriosSuite.toDouble(),
                  onChanged: (value) => {
                    Property.data.dormitoriosSuite=value.toInt()
                  },
                ),
              ],
              )
          ),
          SizedBox(width: 5),
          Expanded(
            child: Column(
              children: [
                Text('Dormitorios Normales'),
                SizedBox(height: 4),
                SpinBox(
                  min: 0,
                  value: Property.data.dormitoriosNormales.toDouble(),
                  onChanged: (value) => {
                    Property.data.dormitoriosNormales=value.toInt()
                  },
                ),
              ],
            ),
          ),
        ],
      ),
      SizedBox(height: 16),
      Flex(
        direction: Axis.horizontal,
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
              child: Column( children: [
                Text('Dormitorios en Planta Baja'),
                SizedBox(height: 4),
                SpinBox(
                  min: 0,
                  value: Property.data.dormitoriosPlantaBaja.toDouble(),
                  onChanged: (value) => {
                  Property.data.dormitoriosPlantaBaja=value.toInt()
                  },
                ),
              ],
              )
          ),
        ],
      ),
      SizedBox(height: 16),
      Flex(
        direction: Axis.horizontal,
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            flex: 1,
              child: Column(
                children: [
                  Text('Generador'),
                  SizedBox(height: 4,),
                  Switch(
                    value: Property.data.generador,
                    onChanged: (value){
                      setState(() {
                        Property.data.generador=value;
                        Property.data.generadorDescripcion = null;
                      });
                    },
                  ),
                ],
              )
          ),
          Expanded(
            flex: 1,
            child: Column(
              children: [
                Text('Descripción Generador'),
                // SizedBox(height: 4,),
                ButtonTheme(
                  alignedDropdown: true,
                  child: DropdownButtonFormField<String?>(
                    hint: Text('Seleccione...'),
                    disabledHint: Text(''),
                    value: Property.data.generadorDescripcion,
                    items: ['En Edificio', 'Compartido', 'Exclusivo'].map((e) {
                      return DropdownMenuItem<String?>(
                        value: e,
                        child: Text(
                          e.toString(),
                          style: GoogleFonts.nunito(
                            color: Colors.black54,
                          ),
                        ),
                      );
                    }).toList(),
                    onChanged: Property.data.generador? (_v){
                      setState(() {
                        Property.data.generadorDescripcion = _v;
                      });
                    }:null,
                  )
                ),
              ],
            ),
          ),
        ],
      ),
      SizedBox(height: 16),
      Flex(
        direction: Axis.horizontal,
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
              child: Column( children: [
                Text('Inventario'),
                SizedBox(height: 4),
                Switch(
                  value: Property.data.inventario,
                  onChanged: (value) {
                    setState(() {
                      Property.data.inventario = value;
                    });
                  },
                ),
              ],
              )
          ),
          SizedBox(width: 5),
          Expanded(
            child: Column(
              children: [
                Text('Titulo de Propiedad'),
                SizedBox(height: 4),
                Switch(
                  value: Property.data.tituloPropiedad,
                  onChanged: (value) {
                    setState(() {
                      Property.data.tituloPropiedad = value;
                    });
                  },
                ),
              ],
            ),
          ),
        ],
      ),
      SizedBox(height: 16),
      Flex(
        direction: Axis.horizontal,
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: Column( children: [
              Text('Portero'),
              SizedBox(height: 4),
              Switch(
                value: Property.data.portero,
                onChanged: (value) {
                  setState(() {
                    Property.data.portero = value;
                    if(!Property.data.portero){
                      _controllerPortero.text="";
                      Property.data.telefonosPortero = null;
                    }
                  });
                },
              )
              ],
            )
          ),
          SizedBox(width: 5),
          Expanded(
            child: Column(
              children: [
                Text('Nro. del Portero'),
                SizedBox(height: 4),
                TextFormField(
                  enabled: Property.data.portero,
                  controller: _controllerPortero,
                  keyboardType: TextInputType.text,
                  maxLines: 1,
                  decoration: InputDecoration(
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: SOFT_GREY, width: 0),
                      borderRadius: BorderRadius.all(
                        Radius.circular(8),
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: SOFT_GREY, width: 0),
                      borderRadius: BorderRadius.all(
                        Radius.circular(8),
                      ),
                    ),
                    hintText: "Teléfono Portero",
                    hintStyle: TextStyle(
                        color: SOFT_GREY,
                        fontSize: 14
                    ),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12.0),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      SizedBox(height: 16),
      Flex(
        direction: Axis.horizontal,
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: Column(
              children: [
                Text('Teléfono'),
                SizedBox(height: 4),
                Switch(
                  value: Property.data.telefono,
                  onChanged: (value) {
                    setState(() {
                      Property.data.telefono = value;
                      if(!Property.data.telefono){
                        _controllerTelefonos.text="";
                        Property.data.telefonoNro = null;
                      }
                    });
                  },
                ),
              ],
            )
          ),
          SizedBox(width: 5),
          Expanded(
            child: Column(
              children: [
                Text('Nros. de telefonos'),
                SizedBox(height: 4),
                TextFormField(
                  onChanged: (value){
                    Property.data.telefonoNro = value;
                  },
                  enabled: Property.data.telefono,
                  controller: _controllerTelefonos,
                  keyboardType: TextInputType.phone,
                  maxLines: 1,
                  decoration: InputDecoration(
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: SOFT_GREY, width: 0),
                      borderRadius: BorderRadius.all(
                        Radius.circular(8),
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: SOFT_GREY, width: 0),
                      borderRadius: BorderRadius.all(
                        Radius.circular(8),
                      ),
                    ),
                    hintText: "Telefonos",
                    hintStyle: TextStyle(
                        color: SOFT_GREY,
                        fontSize: 14
                    ),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12.0),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
      SizedBox(height: 16),
      Flex(
        direction: Axis.horizontal,
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
              child: Column( children: [
                Text('Parrilla'),
                SizedBox(height: 4),
                Switch(
                  value: Property.data.parrilla,
                  onChanged: (value) {
                    setState(() {
                      Property.data.parrilla = value;
                    });
                  },
                ),
              ],
              )
          ),
          SizedBox(width: 5),
          Expanded(
            child: Column(
              children: [
                Text('Guardia'),
                SizedBox(height: 4),
                Switch(
                  value: Property.data.guardia,
                  onChanged: (value) {
                    setState(() {
                      Property.data.guardia = value;
                    });
                  },
                ),
              ],
            ),
          ),
        ],
      ),
      SizedBox(height: 16),
      Flex(
        direction: Axis.horizontal,
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: Column( children: [
              Text('Jardín'),
              SizedBox(height: 4),
              Switch(
                value: Property.data.jardin,
                onChanged: (value) {
                  setState(() {
                    Property.data.jardin = value;
                  });
                },
              ),
            ],
            )
        ),
        SizedBox(width: 5),
        Expanded(
          child: Column(
            children: [
              Text('Piso de Parquet'),
              SizedBox(height: 4),
              Switch(
                value: Property.data.pisoParquet,
                onChanged: (value) {
                  setState(() {
                    Property.data.pisoParquet = value;
                  });
                },
              ),
            ],
          ),
        ),
      ],
      ),
      SizedBox(height: 16),
      Flex(
        direction: Axis.horizontal,
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
              child: Column( children: [
                Text('Gimnasio'),
                SizedBox(height: 4),
                Switch(
                  value: Property.data.gimnasio,
                  onChanged: (value) {
                    setState(() {
                      Property.data.gimnasio = value;
                    });
                  },
                ),
              ],
              )
          ),
          SizedBox(width: 5),
          Expanded(
            child: Column(
              children: [
                Text('Planos'),
                SizedBox(height: 4),
                Switch(
                  value: Property.data.planoInmuble,
                  onChanged: (value) {
                    setState(() {
                      Property.data.planoInmuble = value;
                    });
                  },
                ),
              ],
            ),
          ),
          SizedBox(height: 16),
        ],
      ),
      SizedBox(height: 16),
      Flex(
        direction: Axis.horizontal,
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: [
          Expanded(
              child: Column(
                children: [
                  Text('Piscina'),
                  SizedBox(height: 4,),
                  Switch(
                    value: Property.data.piscina,
                    onChanged: (value){
                      setState(() {
                        Property.data.piscina = value;
                      });
                    },
                  )
                ],
              )
          ),
          Expanded(
            child: SizedBox(),
          )
        ],
      ),
      SizedBox(height: 16),
      Container(
        child: Column(
          children: [
            Text('Medidas'),
            SizedBox(height: 4),
            TextFormField(
              onChanged: (value){
                Property.data.medidas = value;
              },
              controller: _controllerMedidas,
              keyboardType: TextInputType.text,
              maxLines: null,
              decoration: InputDecoration(
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: SOFT_GREY, width: 0),
                  borderRadius: BorderRadius.all(
                    Radius.circular(8),
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: SOFT_GREY, width: 0),
                  borderRadius: BorderRadius.all(
                    Radius.circular(8),
                  ),
                ),
                hintText: "A x L",
                hintStyle: TextStyle(
                    color: SOFT_GREY,
                    fontSize: 14
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12.0),
              ),
            )
          ]
        ),
      ),
      SizedBox(height: 16),
      Flex(
        direction: Axis.horizontal,
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            flex:1,
            child: Column(
              children: [
                Text('Superficie Total'),
                SizedBox(height: 4),
                TextFormField(
                  onChanged: (value){
                    Property.data.supTotal = value.isNotEmpty?double.parse(value):null;
                  },
                  controller: _controllerSupTotal,
                  keyboardType: TextInputType.number,
                  maxLines: 1,
                  decoration: InputDecoration(
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: SOFT_GREY, width: 0),
                      borderRadius: BorderRadius.all(
                        Radius.circular(8),
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: SOFT_GREY, width: 0),
                      borderRadius: BorderRadius.all(
                        Radius.circular(8),
                      ),
                    ),
                    hintText: "Superficie Total",
                    hintStyle: TextStyle(
                        color: SOFT_GREY,
                        fontSize: 14
                    ),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12.0),
                  ),
                )
              ],
            )
          ),
          SizedBox(width: 15),
          Expanded(
            flex:1,
            child: Column(
              children: [
                Text('Superficie Construida'),
                SizedBox(height: 4),
                TextFormField(
                  onChanged: (value){
                    Property.data.superficieConstruido = value.isNotEmpty?double.parse(value):null;
                  },
                  controller: _controllerSupConstruida,
                  keyboardType: TextInputType.number,
                  maxLines: 1,
                  decoration: InputDecoration(
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: SOFT_GREY, width: 0),
                      borderRadius: BorderRadius.all(
                        Radius.circular(8),
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: SOFT_GREY, width: 0),
                      borderRadius: BorderRadius.all(
                        Radius.circular(8),
                      ),
                    ),
                    hintText: "Superficie Construida",
                    hintStyle: TextStyle(
                        color: SOFT_GREY,
                        fontSize: 14
                    ),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12.0),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
      SizedBox(height: 16),
      Flex(
        direction: Axis.horizontal,
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            flex: 1,
              child: Column(
                children: [
                  Text('¿Tiene Cartel?'),
                  SizedBox(height: 4),
                  Switch(
                    value: Property.data.cartel,
                    onChanged: (value) {
                      setState(() {
                        Property.data.cartel = value;
                        if(!Property.data.cartel){
                          _controllerCartel.text="";
                          Property.data.fechaCartel = null;
                        }
                      });
                    },
                  ),
                ],
              )
          ),
          SizedBox(width: 5),
          Expanded(
            flex: 1,
            child: Column(
              children: [
                Text('Fecha de colocación'),
                SizedBox(height: 4),
                TextFormField(
                  enabled: Property.data.cartel,
                  controller: _controllerCartel,
                  maxLines: 1,
                  readOnly: true,
                  decoration: InputDecoration(
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: SOFT_GREY, width: 0),
                      borderRadius: BorderRadius.all(
                        Radius.circular(8),
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: SOFT_GREY, width: 0),
                      borderRadius: BorderRadius.all(
                        Radius.circular(4),
                      ),
                    ),
                    hintText: 'Seleccione la fecha',
                    hintStyle: TextStyle(
                        color: SOFT_GREY,
                        fontSize: 11
                    ),
                    prefixIcon: IconButton(
                      icon:Icon(Icons.date_range, color: ASSENT_COLOR, size: 14),
                      onPressed: (){
                        _selectDateWithMinMaxDate(context);
                      },
                      padding: EdgeInsets.all(0),
                    ),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      SizedBox(height: 16),
      Container(
        child: Column(
          children: [
            Text('Descripcion del inmueble'),
            SizedBox(height: 4),
            Container(
              // color: Colors.grey,
              decoration: BoxDecoration(
                border: Border.all(color: SOFT_GREY, width: 0),
                borderRadius: BorderRadius.circular(8),
              ),
              // padding: EdgeInsets.all(7.0),
              padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  // minWidth: 100,
                  // maxWidth: 50,
                  minHeight: 100,
                  maxHeight: 100,
                ),
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: TextField(
                    onChanged: (value){
                      Property.data.descrInmueble = value;
                    },
                    controller: _controllerDescInmueble,
                    keyboardType: TextInputType.multiline,
                    minLines: 4,
                    maxLines: null, //grow automatically
                    decoration: InputDecoration.collapsed(
                      hintText: 'Ingrese la descripción del inmueble',
                      hintStyle: TextStyle(
                        color: SOFT_GREY,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ]
        )
      ),
    ];
  }

  Future<Null> _selectDateWithMinMaxDate(BuildContext context) async {
    var firstDate = DateTime(2017, 01, 01);
    var lastDate = DateTime(DateTime.now().year, DateTime.now().month,DateTime.now().day+7);
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: firstDate,
      lastDate: lastDate,
      cancelText: "Cancelar",
      confirmText: "Ok",
      currentDate: DateTime.now(),
    );
    if (picked != null && picked != _selectedDateCartel) {
      setState(() {
        _selectedDateCartel = picked;
        _controllerCartel.text= format.format(_selectedDateCartel);
        Property.data.fechaCartel =  _controllerCartel.text;
      });
    }
  }
}
