import 'package:devkitflutter/config/constant.dart';
import 'package:devkitflutter/network/api_provider.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinbox/flutter_spinbox.dart';
import 'package:google_fonts/google_fonts.dart';
import '../edit_property_page.dart';
import 'package:search_choices/search_choices.dart';

class EditDireccionTabPage extends StatefulWidget {
  @override
  _EditDireccionTabPageState createState() => _EditDireccionTabPageState();
}

class _EditDireccionTabPageState extends State<EditDireccionTabPage> with AutomaticKeepAliveClientMixin {

  @override
  bool get wantKeepAlive => true;

  // initialize global widget
  List<String?> ciudadesListData=[];
  List<String?> barrioListData=[];
  List<String?> zonasListData=[];
  List<String?> departamentosListData=[];
  final CancelToken apiToken = CancelToken();
  var _controllerNombreEdificio = TextEditingController();
  var _controllerNombreCondominio = TextEditingController();
  var _controllerNumeracion = TextEditingController();
  var _controllerCalle = TextEditingController();
  var _controllerEntreCalle = TextEditingController();
  var _controllerCasiCalle= TextEditingController();
  var _controllerDistrito= TextEditingController();
  var _controllerFinca= TextEditingController();
  var _controllerCtaCteCatastral= TextEditingController();
  var _controllerReferencias = TextEditingController();
  var _controllerZona = TextEditingController();
  String? _departamento;
  String? _ciudad;
  String? _barrio;
  String? _zona;

  @override
  void initState() {
    _initializeForm();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future _getDepartamentosList() async{
    ApiProvider _apiProvider = ApiProvider();
    _apiProvider.getDepartamentosState(apiToken).then((response) {
      setState(() {
        departamentosListData.addAll(response);
      });
    });
  }

  Future _getCiudadesList() async{
    ApiProvider _apiProvider = ApiProvider();
    _apiProvider.getCiudadesState(_departamento, apiToken).then((response) {
      setState(() {
        ciudadesListData.clear();
        barrioListData.clear();
        zonasListData.clear();
        ciudadesListData.addAll(response);
        _getZonasList();
        _getBarriosList();
      });
    });
    // await Future.delayed(Duration(milliseconds: 500));
  }

  Future _getBarriosList() async{
    ApiProvider _apiProvider = ApiProvider();
    _apiProvider.getBarriosState(_ciudad, apiToken).then((response) {
      setState(() {
        barrioListData.clear();
        barrioListData.addAll(response);
      });
    });
  }

  Future _getZonasList() async{
    ApiProvider _apiProvider = ApiProvider();
    _apiProvider.getZonasState(_ciudad, apiToken).then((response) {
      setState(() {
        zonasListData.clear();
        zonasListData.addAll(response);
      });
    });
  }

  void _initializeForm() async{
    _controllerNombreEdificio.text = Property.data.nombreEdificio??'';
    _controllerNombreCondominio.text = Property.data.nombreCondominio??'';
    if (Property.data.numeracion != 0) _controllerNumeracion.text = Property.data.numeracion.toString();
    _controllerCalle.text = Property.data.nombreCalle??'';
    _controllerCasiCalle.text = Property.data.casiCalle??'';
    _controllerEntreCalle.text = Property.data.entreCalle??'';
    _controllerDistrito.text = Property.data.distrito??'';
    _controllerCtaCteCatastral.text = Property.data.ctaCteCatastral??'';
    _controllerFinca.text = Property.data.finca == 0? '' : Property.data.finca.toString();
    _controllerReferencias.text = Property.data.referencia??'';

    _departamento = Property.data.zonas?.ciudades.departamentos.nombre;
    _ciudad = Property.data.zonas?.ciudades.nombre;
    _zona = Property.data.zonas?.nombre;

    // if(Property.data.zonas != null) {
      await _getDepartamentosList();
      await _getCiudadesList();
    // }

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
                        Property.data.departamento = _v;
                        _departamento = _v;
                        if(_v!=null){
                          Property.data.ciudad = null;
                          _ciudad = null;
                          Property.data.barrio = null;
                          _barrio = null;
                          Property.data.zona = null;
                          _zona = null;
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
                    Property.data.ciudad = _v;
                    _ciudad = _v;
                    if(_v!=null){
                      Property.data.barrio = null;
                      _barrio = null;
                      _getBarriosList();
                      Property.data.zona = null;
                      _zona = null;
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
                  barrioListData.isEmpty?Text("Cargando..."):
                  ButtonTheme(
                    alignedDropdown: true,
                    child:DropdownButtonFormField<String?>(
                      isExpanded: true,
                      style: GoogleFonts.nunito(
                        color: Colors.black54,
                      ),
                      hint: Text("Seleccione..."),
                      value: _barrio,
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
                          Property.data.barrio = _v;
                          _barrio = _v;
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
                            Property.data.zona = zona;
                            _zona = zona;
                            _controllerZona.clear();
                          });
                        }
                      });
                    },
                    icon: Icon(Icons.add_circle_outline_outlined)
                )
              ],
            ),
            zonasListData.isNotEmpty? Theme(
              data: ThemeData(
                colorScheme: ColorScheme.fromSwatch().copyWith(primary: PRIMARY_COLOR),
              ),
              child: SearchChoices.single(
                // icon: Padding(
                //   padding: EdgeInsets.only(bottom: 10),
                //   child: Icon(Icons.arrow_drop_down)),
                // padding: 0,
                closeButton: 'Cerrar',
                displayClearIcon: false,
                style: GoogleFonts.nunito(
                  color: Colors.black54,
                ),
                value: _zona,
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
                    _zona = value;
                    Property.data.zona = value;
                  });
                },
              ),
            ):Container(child: Text('Cargando...'), margin: EdgeInsets.only(top: 10),),
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
                Property.data.nombreEdificio = value;
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
                Property.data.nombreCondominio = value;
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
                      Property.data.numeracion = value.isNotEmpty?int.parse(value):null;
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
                  value: (Property.data.piso?.toDouble())??0.0,
                  onChanged: (value) => {
                    Property.data.cantPisos=value.toInt()
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
                      Property.data.nombreCalle = value;
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
                    Property.data.entreCalle = value;
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
                    Property.data.casiCalle = value;
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
                    Property.data.distrito = value;
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
                      Property.data.ctaCteCatastral = value;
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
                      hintText: "Cta. Cte. Catastral",
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
                    Property.data.finca = value.isNotEmpty?int.parse(value):null;
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
                    hintText: "Finca",
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
                    controller: _controllerReferencias,
                    onChanged: (value){
                      Property.data.referencia = value;
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

Future<dynamic> showInputDialog(BuildContext context, TextEditingController _controllerZona){
  return showDialog(
      context: context,
      builder: (context){
        return AlertDialog(
          title: Text(
            'Ingrese Zona',
            style: GoogleFonts.nunito(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: TextField(
            decoration: InputDecoration(
              labelStyle: GoogleFonts.nunito(
                color: SOFT_GREY,
              ),
              labelText: 'Ingrese Zona',
              contentPadding: EdgeInsets.only(left: 12),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(25.0),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(25.0),
              ),
            ),
            controller: _controllerZona,
          ),
          // contentPadding: EdgeInsets.fromLTRB(24, 15, 24, 5),
          actions: [
            TextButton(
              onPressed: (){
                Navigator.pop(context);
                _controllerZona.clear();
              },
              child: Text(
                'CANCELAR',
                style: GoogleFonts.nunito(
                  color: PRIMARY_COLOR,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            TextButton(
              onPressed: (){
                Navigator.pop(context, _controllerZona.text);
              },
              child: Text(
                'OK',
                style: GoogleFonts.nunito(
                  color: PRIMARY_COLOR,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        );
      }
  );
}
