import 'package:devkitflutter/config/constant.dart';
import 'package:devkitflutter/library/smooth_star_rating/smooth_star_rating.dart';
import 'package:devkitflutter/network/api_provider.dart';
import 'package:devkitflutter/ui/integration/api/add_details.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinbox/flutter_spinbox.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';

class CaracteristicasTabPage extends StatefulWidget {

  const CaracteristicasTabPage({Key? key, this.formKey}) : super(key: key);
  final GlobalKey<FormState>? formKey;

  @override
  _CaracteristicasTabPageState createState() => _CaracteristicasTabPageState(formKey!);
}

class _CaracteristicasTabPageState extends State<CaracteristicasTabPage> with AutomaticKeepAliveClientMixin {

  _CaracteristicasTabPageState(this._formKeyCaracteristicas):super();
  GlobalKey<FormState> _formKeyCaracteristicas;

  @override
  bool get wantKeepAlive => true;
  // initialize global widget
  final DateFormat format=DateFormat("yyyy-MM-dd");
  double _condicionIndex = 6;
  final _controllerTelefonos = TextEditingController();
  final  _condicion = ["Malo", "Regular", "Bueno", "Muy Bueno", "Excelente","A Estrenar", "En Pozo"];
  final CancelToken apiToken = CancelToken();
  List<String?> destinosViewData = [];
  List<String?> destinosViewDataSelected = [];
  final _controllerMedidas = TextEditingController(); //
  final _controllerSupTotal = TextEditingController();
  final _controllerSupConstruida = TextEditingController();
  final _controllerNroPortero = TextEditingController();
  DateTime _selectedDateCartel=DateTime.now();
  final _controllerCartel = TextEditingController();
  final _controllerDescripcionAreasComunes= TextEditingController();
  final _controllerDescInmueble = TextEditingController();

  @override
  void initState() {
    _getDestinosFromApi();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(20),
      child:Form(
        key: _formKeyCaracteristicas,
        child: ListView(
          children: _items(),
        ),
      ),
    );
  }

  Future  _getDestinosFromApi() async {
    if(destinosViewDataSelected.isEmpty){
      ApiProvider _apiProvider = ApiProvider();
      _apiProvider.getDestinosState(apiToken).then((response) {
        setState(() {
          destinosViewData.addAll(response);
        });
      });
    }
    print('destinos: ${Inmueble.data.destinosAlquiler}');
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
            Text('Destino'),
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
                  destinosViewDataSelected = values;
                  Inmueble.data.destinosAlquiler = values;
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
                      Inmueble.data.condicionInmueble = _condicion[_condicionIndex.toInt()];
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
              value: Inmueble.data.areasComunes.toDouble(),
              min: 0,
              onChanged: (value) => {
                Inmueble.data.areasComunes=(value.toInt())
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
                      Inmueble.data.areasComunesDescripcion = value;
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
                value: Inmueble.data.ambientes,
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
                    Inmueble.data.ambientes = _v;
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
                value: Inmueble.data.anoConstruccion,
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
                    Inmueble.data.anoConstruccion = _v;
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
          // Expanded(
          //   child: Column(
          //     children: [
          //       Text('Cant. de Pisos'),
          //       SizedBox(height: 4),
          //       SpinBox(
          //         min: 0,
          //         value: Inmueble.data.cantPisos.toDouble(),
          //         onChanged: (value) => {
          //           Inmueble.data.cantPisos=value.toInt()
          //         },
          //       ),
          //     ],
          //   )
          // ),

          Expanded(
            child: Column(
              children: [
                Text('Cant. de Dptos.'),
                SizedBox(height: 4),
                SpinBox(
                  min: 0,
                  value: Inmueble.data.cantDpto.toDouble(),
                  onChanged: (value) => {
                    Inmueble.data.cantDpto=value.toInt()
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
                  value: Inmueble.data.cochera,
                  onChanged: (value) {
                    setState(() {
                      Inmueble.data.cochera = value;
                      Inmueble.data.cocheras = 0;
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
                  enabled: Inmueble.data.cochera,
                  min: 0,
                  value: Inmueble.data.cocheras.toDouble(),
                  onChanged: (value) => {
                    Inmueble.data.cocheras=value.toInt()
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
                    value: Inmueble.data.baulera,
                    onChanged: (value) {
                      setState(() {
                        Inmueble.data.baulera = value;
                        Inmueble.data.bauleras=0;
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
                  enabled: Inmueble.data.baulera,
                  min: 0,
                  value: Inmueble.data.bauleras.toDouble(),
                  onChanged: (value) => {
                    Inmueble.data.bauleras=value.toInt()
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
                Text('Dormitorios Suite'),
                SizedBox(height: 4),
                SpinBox(
                  min: 0,
                  value: Inmueble.data.dormitoriosSuite.toDouble(),
                  onChanged: (value) => {
                    Inmueble.data.dormitoriosSuite=value.toInt()
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
                  value: Inmueble.data.dormitoriosNormales.toDouble(),
                  onChanged: (value) => {
                    Inmueble.data.dormitoriosNormales=value.toInt()
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
                  value: Inmueble.data.dormitoriosPlantaBaja.toDouble(),
                  onChanged: (value) => {
                    Inmueble.data.dormitoriosPlantaBaja=value.toInt()
                  },
                ),
              ],
              )
          ),

          // Expanded(
          //   child: SizedBox(),
          // ),
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
                    value: Inmueble.data.generador,
                    onChanged: (value){
                      setState(() {
                        Inmueble.data.generador=value;
                        Inmueble.data.generadorDescripcion=null;
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
                      value: Inmueble.data.generadorDescripcion,
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
                      onChanged: Inmueble.data.generador? (_v){
                        setState(() {
                          Inmueble.data.generadorDescripcion = _v;
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
                  value: Inmueble.data.inventario,
                  onChanged: (value) {
                    setState(() {
                      Inmueble.data.inventario = value;
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
                  value: Inmueble.data.tituloPropiedad,
                  onChanged: (value) {
                    setState(() {
                      Inmueble.data.tituloPropiedad = value;
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
                value: Inmueble.data.portero,
                onChanged: (value) {
                  setState(() {
                    Inmueble.data.portero = value;
                    if(!Inmueble.data.portero){
                      Inmueble.data.telefonosPortero=null;
                      _controllerNroPortero.text = '';
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
                  onChanged: (value){
                    Inmueble.data.telefonosPortero = value;
                    print('a: ${Inmueble.data.telefonosPortero}');
                  },
                  validator: (value){
                    if(value == null || value.isEmpty && Inmueble.data.portero){
                      return 'Ingrese Nro. del Portero';
                    }else{
                      return null;
                    }
                  },
                  enabled: Inmueble.data.portero,
                  controller: _controllerNroPortero,
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
                  value: Inmueble.data.telefono,
                  onChanged: (value) {
                    setState(() {
                      Inmueble.data.telefono = value;
                      if(!Inmueble.data.telefono){
                        _controllerTelefonos.text="";
                        Inmueble.data.telefonoNro=null;

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
                Text('Nro. de telefono'),
                SizedBox(height: 4),
                TextFormField(
                  onChanged: (value){
                    Inmueble.data.telefonoNro=value;
                  },
                  validator: (value){
                    if(value == null || value.isEmpty && Inmueble.data.telefono){
                      return 'Ingrese Nro. de teléfono';
                    }else{
                      return null;
                    }
                  },
                  enabled: Inmueble.data.telefono,
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
                  value: Inmueble.data.parrilla,
                  onChanged: (value) {
                    setState(() {
                      Inmueble.data.parrilla = value;
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
                  value: Inmueble.data.guardia,
                  onChanged: (value) {
                    setState(() {
                      Inmueble.data.guardia = value;
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
                value: Inmueble.data.jardin,
                onChanged: (value) {
                  setState(() {
                    Inmueble.data.jardin = value;
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
                value: Inmueble.data.pisoParquet,
                onChanged: (value) {
                  setState(() {
                    Inmueble.data.pisoParquet = value;
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
                  value: Inmueble.data.gimnasio,
                  onChanged: (value) {
                    setState(() {
                      Inmueble.data.gimnasio = value;
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
                  value: Inmueble.data.planoInmuble,
                  onChanged: (value) {
                    setState(() {
                      Inmueble.data.planoInmuble = value;
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
                    value: Inmueble.data.piscina,
                    onChanged: (value){
                      setState(() {
                        Inmueble.data.piscina = value;
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
                Inmueble.data.medidas = value;
              },
              controller: _controllerMedidas,
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
                    Inmueble.data.supTotal = value.isNotEmpty? double.parse(value):null;
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
                    Inmueble.data.superficieConstruido = value.isNotEmpty?double.parse(value):null;
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
                    value: Inmueble.data.cartel,
                    onChanged: (value) {
                      setState(() {
                        Inmueble.data.cartel = value;
                        if(!Inmueble.data.cartel){
                          _controllerCartel.text="";
                          Inmueble.data.fechaCartel = null;
                        }else{
                          _selectedDateCartel=DateTime.now();
                          _controllerCartel.text=format.format(_selectedDateCartel);
                          Inmueble.data.fechaCartel = _controllerCartel.text;
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
                  enabled: Inmueble.data.cartel,
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
                      Inmueble.data.descrInmueble = value;
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
      });
    }
  }


}


