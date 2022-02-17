import 'package:devkitflutter/config/constant.dart';
import 'package:devkitflutter/network/api_provider.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinbox/flutter_spinbox.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:search_choices/search_choices.dart';
import 'package:devkitflutter/ui/integration/api/tab/edit_tab_direccion.dart';
import 'package:devkitflutter/ui/integration/api/add_details.dart';

class DireccionTabPage extends StatefulWidget {
  DireccionTabPage({Key? key, this.formKey}) : super(key: key);
  final GlobalKey<FormState>? formKey;
  @override
  _DireccionTabPageState createState() => _DireccionTabPageState(formKey!);
}

class _DireccionTabPageState extends State<DireccionTabPage> with AutomaticKeepAliveClientMixin {

  _DireccionTabPageState(this._formKeyDireccion):super();
  GlobalKey<FormState> _formKeyDireccion;
  @override
  bool get wantKeepAlive => true;
  // initialize global widget
  List<String?> ciudadesListData=[];
  List<String?> barrioListData=[];
  List<String?> zonasListData=[];
  List<String?> departamentosListData=[];
  final CancelToken apiToken = CancelToken();
  final _controllerNombreEdificio = TextEditingController();
  final _controllerNombreCondominio = TextEditingController();
  final _controllerNumeracion = TextEditingController();
  final _controllerCalle = TextEditingController();
  final _controllerEntreCalle = TextEditingController();
  final _controllerCasiCalle= TextEditingController();
  final _controllerDistrito= TextEditingController();
  final _controllerFinca= TextEditingController();
  final _controllerCtaCteCatastral= TextEditingController();
  final _controllerZona = TextEditingController();
  late bool _hideZonas;
  String? _departamento;
  String? _ciudad;

  @override
  void initState() {
    _getDepartamentosList();
    _hideZonas = true;
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future _getDepartamentosList() async{
    ApiProvider _apiProvider = ApiProvider();
    _apiProvider.getDepartamentosState(apiToken).then((response) {
      print(response);
      setState(() {
        departamentosListData.clear();
        departamentosListData.addAll(response);
      });
    });
  }

  Future _getCiudadesList() async{
    ApiProvider _apiProvider = ApiProvider();
    print("obteniendo ciudades");
    _apiProvider.getCiudadesState(Inmueble.data.departamento, apiToken).then((response) {
      setState(() {
        ciudadesListData.clear();
        barrioListData.clear();
        zonasListData.clear();
        ciudadesListData.addAll(response);
      });
    });
  }

  Future _getBarriosList() async{
    ApiProvider _apiProvider = ApiProvider();
    _apiProvider.getBarriosState(Inmueble.data.ciudad, apiToken).then((response) {
      setState(() {
        barrioListData.clear();
        barrioListData.addAll(response);
      });
    });
  }

  Future _getZonasList() async{
    ApiProvider _apiProvider = ApiProvider();
    _apiProvider.getZonasState(Inmueble.data.ciudad, apiToken).then((response) {
      setState(() {
        zonasListData.clear();
        zonasListData.addAll(response);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(20),
      child:Form(
        key: _formKeyDireccion,
        child: ListView(
          children: _items(),
        ),
      ),
    );
  }

  List<Widget> _items() {
    return [
      Container(
          child: Column(
              children: [
                Text('Departamento'),
                SizedBox(height: 4),
                departamentosListData.isEmpty?Text("Cargando..."):
                ButtonTheme(
                  alignedDropdown: true,
                  child:DropdownButtonFormField<String?>(
                    isExpanded: true,
                    style: GoogleFonts.nunito(
                      color: Colors.black54,
                    ),
                    hint: Text("Seleccione..."),
                    value: _departamento,
                    items: departamentosListData.map((e) =>
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
                        _departamento = _v;
                        Inmueble.data.departamento = _departamento;
                        _ciudad = null;
                        Inmueble.data.ciudad=null;
                        Inmueble.data.zona = null;
                        if(_v!=null){
                          _getCiudadesList();
                        }
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
            Text('Ciudad o Distrito'),
            SizedBox(height: 4),
            ciudadesListData.isEmpty?Text("Cargando..."):
            ButtonTheme(
              alignedDropdown: true,
              child:DropdownButtonFormField<String?>(
                isExpanded: true,
                style: GoogleFonts.nunito(
                  color: Colors.black54,
                ),
                hint: Text("Seleccione..."),
                value: _ciudad,
                items: ciudadesListData.map((e) =>
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
                    _ciudad = _v;
                    Inmueble.data.ciudad = _ciudad;
                    Inmueble.data.barrio = null;
                    Inmueble.data.zona = null;
                    if(_v!=null){
                      _hideZonas = false;
                      _getBarriosList();
                      _getZonasList();
                    }
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
                  Text('Barrio'),
                  SizedBox(height: 4),
                  (Inmueble.data.ciudad==null || barrioListData.isEmpty)?Text("Cargando..."):
                  ButtonTheme(
                    alignedDropdown: true,
                    child:DropdownButtonFormField<String?>(
                      isExpanded: true,
                      style: GoogleFonts.nunito(
                        color: Colors.black54,
                      ),
                      hint: Text("Seleccione..."),
                      value: Inmueble.data.barrio,
                      items: barrioListData.map((e) =>
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
                          Inmueble.data.barrio = _v;
                        });
                      },
                    ),
                  ),
                ],
              )
          ),
          SizedBox(width: 5),
        ],
      ),
      SizedBox(height: 10),
      Container(
        // decoration: BoxDecoration(border: Border.all(color: Colors.black)),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Zona'),
                SizedBox(width: 5),
                IconButton(
                    padding: EdgeInsets.zero,
                    constraints: BoxConstraints(),
                    hoverColor: Colors.greenAccent,
                    highlightColor: Colors.greenAccent,
                    color: Colors.green,
                    onPressed: (){
                      showInputDialog(context, _controllerZona).then((zona){
                        if (zona!=null && zona.toString().trim().isNotEmpty){
                          setState(() {
                            zonasListData.add(zona);
                            Inmueble.data.zona = zona;
                            _controllerZona.clear();
                          });
                        }
                      });
                    },
                    icon: Icon(Icons.add_circle_outline_outlined)
                )
              ],
            ),
            _hideZonas?Container(child: Text('Cargando...'), margin: EdgeInsets.only(top: 10),):
            Theme(
              data: ThemeData(
                colorScheme: ColorScheme.fromSwatch().copyWith(primary: PRIMARY_COLOR),
              ),
              child: SearchChoices.single(
                padding: 10,
                closeButton: 'Cerrar',
                displayClearIcon: false,
                style: GoogleFonts.nunito(
                  color: Colors.black54,
                ),
                value: Inmueble.data.zona,
                items: zonasListData.map((e) =>
                    DropdownMenuItem<String?>(
                      value: e,
                      child: Padding(
                        padding: EdgeInsets.only(left: 10),
                        child: Text(e.toString(),
                          style:GoogleFonts.nunito(
                            color: Colors.black54,
                          ),
                        ),
                      ),
                    )
                ).toList(),
                hint: Padding(
                    padding: EdgeInsets.only(left: 15, bottom: 5),
                    child: Text('Seleccione...')
                ),
                isExpanded: true,
                underline: Container(
                  // height: 1,
                  decoration: BoxDecoration(
                      border: Border(bottom: BorderSide(color: Colors.black54, width: 0))
                  ) ,
                ),
                onChanged: (value){
                  setState(() {
                    Inmueble.data.zona = value;
                  });
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
            Text('Nombre del edificio'),
            SizedBox(height: 4),
            TextFormField(
              onChanged: (value){
                Inmueble.data.nombreEdificio = value;
              },
              controller: _controllerNombreEdificio,
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
                hintText: "Edificio",
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
      Container(
        child: Column(
          children: [
            Text('Nombre del condominio'),
            SizedBox(height: 4),
            TextFormField(
              onChanged: (value){
                Inmueble.data.nombreCondominio = value;
              },
              controller: _controllerNombreCondominio,
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
                hintText: "Condominio",
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
              child: Column(
                children: [
                  Text('Numeración'),
                  SizedBox(height: 4),
                  TextFormField(
                    onChanged: (value){
                      Inmueble.data.numeracion = value.isNotEmpty?int.parse(value):null;
                    },
                    controller: _controllerNumeracion,
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
                      hintText: "Numeración",
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
          SizedBox(width: 10),
          Expanded(
            child: Column(
              children: [
                Text('Piso'),
                SizedBox(height: 4),
                SpinBox(
                  min: 0,
                  value: (Inmueble.data.piso?.toDouble())??0.0,
                  onChanged: (value) => {
                    Inmueble.data.piso=value.toInt()
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
                  Text('Calle'),
                  SizedBox(height: 4),
                  TextFormField(
                    onChanged: (value){
                      Inmueble.data.nombreCalle = value;
                    },
                    controller: _controllerCalle,
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
                      hintText: "Nombre de la calle",
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
          SizedBox(width: 10),
          Expanded(
            child: Column(
              children: [
                Text('Entre calle'),
                SizedBox(height: 4),
                TextFormField(
                  onChanged: (value){
                    Inmueble.data.entreCalle = value;
                  },
                  controller: _controllerEntreCalle,
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
                    hintText: "Entre calle",
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
            child: Column(
              children: [
                Text('Casi Calle'),
                SizedBox(height: 4),
                TextFormField(
                  onChanged: (value){
                    Inmueble.data.casiCalle = value;
                  },
                  controller: _controllerCasiCalle,
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
                    hintText: "Casi calle",
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
          SizedBox(width: 10),
          Expanded(
            child: Column(
              children: [
                Text('Distrito'),
                SizedBox(height: 4),
                TextFormField(
                  onChanged: (value){
                    Inmueble.data.distrito = value;
                  },
                  controller: _controllerDistrito,
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
                    hintText: "Distrito",
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
              child: Column(
                children: [
                  Text('Cta. Cte. Catastral'),
                  SizedBox(height: 4),
                  TextFormField(
                    onChanged: (value){
                      Inmueble.data.ctaCteCatastral = value;
                    },
                    controller: _controllerCtaCteCatastral,
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
                      hintText: "Casi calle",
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
          SizedBox(width: 10),
          Expanded(
            child: Column(
              children: [
                Text('Finca'),
                SizedBox(height: 4),
                TextFormField(
                  onChanged: (value){
                    Inmueble.data.finca = value.isNotEmpty?int.parse(value):null;
                  },
                  controller: _controllerFinca,
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
                    hintText: "Distrito",
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
      Container(
        child: Column(
          children: [
            Text('Referencias'),
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
                  // reverse: true,
                  // here's the actual text box
                  child: TextField(
                    onChanged: (value){
                      Inmueble.data.referencia = value;
                    },
                    keyboardType: TextInputType.multiline,
                    minLines: 4,
                    maxLines: null, //grow automatically
                    decoration: InputDecoration.collapsed(
                      hintText: 'Referencias de la dirección',
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
}
