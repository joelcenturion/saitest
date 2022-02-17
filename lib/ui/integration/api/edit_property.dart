

import 'package:devkitflutter/config/constant.dart';
import 'package:devkitflutter/model/integration/property_model.dart';
import 'package:devkitflutter/model/integration/property_type_listview_model.dart';
import 'package:devkitflutter/network/api_provider.dart';
import 'package:devkitflutter/ui/apps/food_delivery/reusable_widget.dart';
import 'package:devkitflutter/ui/integration/api/edit_property_page.dart';
import 'package:devkitflutter/ui/integration/api/location_gps.dart';
import 'package:devkitflutter/ui/integration/api/tab/edit_tab_direccion.dart';
import 'package:devkitflutter/ui/reusable/global_function.dart';
import 'package:dio/dio.dart';
import 'package:extended_masked_text/extended_masked_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:search_choices/search_choices.dart';

class EditProperty extends StatefulWidget {

  const EditProperty({Key? key,  this.formKey}) : super(key: key);
  final GlobalKey<FormState>? formKey;

  @override
  _EditPropertyState createState() => _EditPropertyState(formKey!);
}

class _EditPropertyState extends State<EditProperty> with AutomaticKeepAliveClientMixin{

  _EditPropertyState(this._formKey):super();
  GlobalKey<FormState> _formKey;

  @override
  bool get wantKeepAlive => true;

  DateFormat format=DateFormat("yyyy-MM-dd");
  var _controllerVenta = MoneyMaskedTextController(precision: 0, thousandSeparator: '.', decimalSeparator: '');
  var _controllerAlquiler = MoneyMaskedTextController(precision: 0, thousandSeparator: '.', decimalSeparator: '');
  final _controllerDireccion = TextEditingController();
  var _controllerTitulo = TextEditingController();
  final _controllerFechaIngreso = TextEditingController();
  final _controllerComisionVenta = TextEditingController();
  final _controllerComisionAlquiler = TextEditingController();
  final _controllerDescripcion = TextEditingController();
  final _controllerCiudad = TextEditingController();
  LatLng? _position;
  late PropertyModel _propertyModel;
  final _reusableWidget = ReusableWidget();
  final CancelToken apiToken = CancelToken(); // used to cancel fetch data from API
  // final _formKey = GlobalKey<FormState>();
  PropertyTypeListviewModel? _selectedTipoInmueble;
  List<PropertyTypeListviewModel> _tiposInmuebles=List<PropertyTypeListviewModel>.empty();
  List<Asset> images=List.empty();
  Asset? coverImage;
  int coverIndex=0;
  final List<bool> isSelected=[false, true];
  late String _monedaAlquiler;
  late String _monedaVenta;
  late DateTime _selectedDate;
  bool _comisionVenta = false;
  final ApiProvider _apiProvider=ApiProvider();
  final _globalFunction = GlobalFunction();
  NumberFormat nf= NumberFormat('#,###.##', 'es_PY');
  String? _ciudad;
  late String _departamento;
  String? _zona;
  List<String?> zonasListData=[];
  final _controllerZona = TextEditingController();

  @override
  void initState() {
    _selectedDate=DateTime.now();
    images=List.empty();
    _monedaAlquiler = 'Gs.';
    _monedaVenta = '\$';
    _initializeForm();
    super.initState();
  }

  @override
  void dispose() {
    _controllerDireccion.dispose();
    _controllerAlquiler.dispose();
    _controllerVenta.dispose();
    super.dispose();
  }

   Future<void> _getTipoInmuebles()async {
     List<PropertyTypeListviewModel> res = await _apiProvider.getTiposInmueblesViewState("0", "20","", apiToken);
     setState(() {
       _tiposInmuebles = res;
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
    _controllerTitulo.text = Property.data.titulo;
    //fecha ingreso
    _controllerFechaIngreso.text = Property.data.fechaIngreso;
    _controllerDescripcion.text = Property.data.descripcion??'';
    //latitud, longitud
    if(Property.data.latitud != null && Property.data.longitud != null) _position = LatLng(Property.data.latitud as double, Property.data.longitud as double);
    //direccion
    _controllerDireccion.text = Property.data.direccion;
    isSelected[0] = Property.data.tipoInmueble.venta;
    isSelected[1] = Property.data.tipoInmueble.alquiler;
    _comisionVenta = Property.data.comisionVenta;
    _controllerComisionAlquiler.text = Property.data.porcentajeComisionAlquiler == 0?'':Property.data.porcentajeComisionAlquiler.toString();
    _controllerComisionVenta.text = Property.data.porcentajeComisionVenta==0.0?'':Property.data.porcentajeComisionVenta.toString();
    if(isSelected[0]) {
      if (Property.data.precioVenta!=0.0) _controllerVenta.updateValue(Property.data.precioVenta);
      _monedaVenta = Property.data.monedaVenta!;
    }
    if(isSelected[1]) {
      if (Property.data.precioAlquiler!=0.0) _controllerAlquiler.updateValue(Property.data.precioAlquiler);
      _monedaAlquiler = Property.data.monedaAlquiler!;
    }
    await _getTipoInmuebles();
    for (final tipo in _tiposInmuebles){
      if(tipo.nombre.toUpperCase() == Property.data.tipoInmueble.nombre.toUpperCase()){
        _selectedTipoInmueble = tipo; break;
      }
    }
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: _buildForm(),
    );
  }

  Widget? _buildForm(){
    return Form(
      key: _formKey,
      child: ListView(
        children: [
          Container(
            margin: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Fecha de Ingreso'),
                SizedBox(height: 4),
                GestureDetector(
                  onTap: (){
                    _selectDateWithMinMaxDate(context);
                  },
                  child: AbsorbPointer(
                    child: TextFormField(
                      controller: _controllerFechaIngreso,
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
                            Radius.circular(8),
                          ),
                        ),
                        hintText: 'Seleccione la fecha',
                        hintStyle: TextStyle(
                            color: SOFT_GREY,
                            fontSize: 14
                        ),
                        prefixIcon: IconButton(
                          icon:Icon(Icons.date_range, color: ASSENT_COLOR, size: 20),
                          onPressed: (){
                            _selectDateWithMinMaxDate(context);
                          },
                          padding: EdgeInsets.all(0),
                        ),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12.0),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 16),
                Text('Tipo de propiedad'),
                SizedBox(height: 4),
                ButtonTheme(
                  alignedDropdown: true,
                  child:
                  DropdownButtonFormField<PropertyTypeListviewModel>(
                    isExpanded: true,
                    validator: (value) {
                      if (value == null) {
                        return 'Favor seleccione el tipo de propiedad';
                      }
                      return null;
                    },
                    style: GoogleFonts.nunito(
                      color: Colors.black54,
                    ),
                    hint: Text("Seleccione el tipo de propiedad"),
                    value: _selectedTipoInmueble,
                    items: _tiposInmuebles.map((PropertyTypeListviewModel z) {
                      return DropdownMenuItem<PropertyTypeListviewModel>(
                        value: z,
                        child: Text(z.nombre, style:
                        GoogleFonts.nunito(
                          color: Colors.black54,
                        ),
                        ),
                      );
                    }).toList(),
                    onChanged: (_v) {
                      setState(() {
                        _selectedTipoInmueble = _v;
                        Property.data.tipoInmueble.nombre = _selectedTipoInmueble!.nombre;
                      });
                    },
                  ),
                ),
                SizedBox(height: 16),
                Text('Operación'),
                SizedBox(height: 4),
                ToggleButtons(
                  borderRadius: BorderRadius.circular(8),
                  selectedColor: Colors.white,
                  selectedBorderColor: SOFT_GREY,
                  borderColor: Color(0xff243972),
                  color: Color(0xff243972),
                  fillColor: Color(0xff243972),
                  children: <Widget>[
                    Container(
                        width: (MediaQuery.of(context).size.width - 36)/2,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text("VENTA", style:
                            GoogleFonts.nunito(),
                            )
                          ],
                        )
                    ),
                    Container(
                        width: (MediaQuery.of(context).size.width - 36)/2,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text("ALQUILER", style:
                            GoogleFonts.nunito(),)
                          ],
                        )
                    )
                  ],
                  onPressed: (int index) {
                    int count = 0;
                    isSelected.forEach((bool val) {
                      if (val) count++;
                    });
                    if (isSelected[index] && count < 2)
                      return;
                    setState(() {
                      isSelected[index] = !isSelected[index];
                    });
                    Property.data.tipoInmueble.venta = isSelected[0];
                    Property.data.tipoInmueble.alquiler = isSelected[1];
                  },
                  isSelected: isSelected,
                ),
                SizedBox(height: 16),
                Text('Titulo'),
                SizedBox(height: 4),
                TextFormField(
                  onChanged: (value){
                    Property.data.titulo = value;
                  },
                  controller: _controllerTitulo,
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
                    hintText: 'Ingrese el titulo de la propiedad',
                    hintStyle: TextStyle(
                        color: SOFT_GREY,
                        fontSize: 14
                    ),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12.0),
                  ),
                  validator:  (value) {
                    if (value == null || value.isEmpty) {
                      return 'Favor ingrese un titulo para la propiedad';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16),
                Text('Dirección'),
                SizedBox(height: 4),
                TextFormField(
                  controller: _controllerDireccion,
                  readOnly: false,
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
                    hintText: 'Seleccione desde el mapa',
                    hintStyle: TextStyle(
                        color: SOFT_GREY,
                        fontSize: 14
                    ),
                    prefixIcon: IconButton(
                      icon:Icon(Icons.place, color: ASSENT_COLOR, size: 20),
                      onPressed: (){
                        _navigateAndRetrieveSelection(context);
                      },
                      padding: EdgeInsets.all(0),
                    ),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12.0),
                  ),
                  validator:  (value) {
                    if (value == null || value.isEmpty) {
                      return 'Favor seleccione la direccion';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16),
                _ciudad!=null? Text('Ciudad'):SizedBox(),
                SizedBox(height: 4),
                _ciudad!=null?TextFormField(
                  controller: _controllerCiudad,
                  onChanged: (value){
                    Property.data.ciudad = value.trim().toUpperCase();
                  },
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
                    hintText: 'Ingrese el titulo de la propiedad',
                    hintStyle: TextStyle(
                        color: SOFT_GREY,
                        fontSize: 14
                    ),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12.0),
                  ),
                ):SizedBox(),
                SizedBox(height: 16),
                zonasListData.isNotEmpty?Container(
                  // decoration: BoxDecoration(border: Border.all(color: Colors.black)),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text('Zona'),
                          SizedBox(width: 5),
                          // IconButton(
                          //     padding: EdgeInsets.zero,
                          //     constraints: BoxConstraints(),
                          //     hoverColor: Colors.greenAccent,
                          //     highlightColor: Colors.greenAccent,
                          //     color: Colors.green,
                          //     onPressed: (){
                          //       showInputDialog(context, _controllerZona).then((zona){
                          //         if (zona!=null && zona.toString().trim().isNotEmpty){
                          //           setState(() {
                          //             zonasListData.add(zona);
                          //             _zona = zona;
                          //             Property.data.zona = _zona;
                          //             _controllerZona.clear();
                          //           });
                          //         }
                          //       });
                          //     },
                          //     icon: Icon(Icons.add_circle_outline_outlined)
                          // )
                        ],
                      ),
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
                              Property.data.zona = _zona;
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                ):SizedBox(),
                SizedBox(height: 16),
                Text('Descripción'),
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
                      minHeight: 150,
                      maxHeight: 150,
                    ),
                    child: SingleChildScrollView(
                      scrollDirection: Axis.vertical,
                      // reverse: true,
                      // here's the actual text box
                      child: TextField(
                        onChanged: (value){
                          Property.data.descripcion = value;
                        },
                        controller: _controllerDescripcion,
                        keyboardType: TextInputType.multiline,
                        minLines: 4,
                        maxLines: null, //grow automatically
                        decoration: InputDecoration.collapsed(
                          hintText: 'Ingrese la descripción del inmueble',
                          hintStyle: TextStyle(
                            color: SOFT_GREY,
                            fontSize: 15,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 16),
                isSelected[0]? Row(
                  children: [
                    Expanded(
                      flex: 0,
                      child:
                      Column(
                        children: [
                          Text('Comisión por Venta'),
                          SizedBox(height: 4),
                          Switch(
                            value: _comisionVenta,
                            onChanged: (value) {
                              setState(() {
                                _comisionVenta = value;
                              });
                              if(_comisionVenta){
                                Property.data.porcentajeComisionVenta = 5.0;
                                _controllerComisionVenta.text=Property.data.porcentajeComisionVenta.toString();
                              }else {
                                _controllerComisionVenta.clear();
                                Property.data.porcentajeComisionVenta = 0.0;
                                Property.data.comisionVenta = _comisionVenta;
                              }
                              print(Property.data.porcentajeComisionVenta);
                            },
                          ),
                        ],
                      ),
                    ),
                    _comisionVenta?
                    Expanded(
                      flex: 1,
                      child:
                      Column(
                        children: [
                          Text('% de Comisión'),
                          SizedBox(height: 4),
                          Container(
                            width: 100,
                            child:TextFormField(
                              inputFormatters: [
                                FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}'))
                              ],
                              onChanged: (value){
                                Property.data.porcentajeComisionVenta = value.isNotEmpty? double.parse(value):0.0;
                              },
                              controller: _controllerComisionVenta,
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
                                hintText: "Porcentaje de la comisión",
                                hintStyle: TextStyle(
                                    color: SOFT_GREY,
                                    fontSize: 14
                                ),
                                contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12.0),
                              ),
                              validator:  (value) {
                                if ((value == null || value.isEmpty)) {
                                  return 'Favor ingrese % mayor a cero';
                                }else if(int.parse(value)<=0){
                                  return 'Favor ingrese % mayor a cero';
                                }
                                return null;
                              },
                            ),
                          ),
                        ],
                      ),
                    ): Expanded(child: Center()),
                  ],
                ) : Center(),
                SizedBox(height: 16),
                isSelected[1] ? SizedBox(height: 16): Center(),
                isSelected[1] ? Text('Precio Alquiler') : Center(),
                isSelected[1] ? SizedBox(height: 4) : Center(),
                isSelected[1] ? TextFormField(
                  enabled: false,
                  // onChanged: (value){
                  //   Property.data.precioAlquiler = _controllerAlquiler.numberValue;
                  // },
                  controller: _controllerAlquiler,
                  keyboardType: TextInputType.number,
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
                    hintText: "Ingrese el monto del alquiler",
                    hintStyle: TextStyle(
                        color: SOFT_GREY,
                        fontSize: 14
                    ),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12.0),
                    prefix:DropdownButton<String>(
                      isExpanded: false,
                      underline: SizedBox(),
                      // alignment: Alignment.centerLeft,
                      isDense: true,
                      style: GoogleFonts.nunito(
                          color: ASSENT_COLOR, fontSize: 16
                      ),
                      value: _monedaAlquiler,
                      items: <String>["Gs.","\$"].map((String z) {
                        return DropdownMenuItem<String>(
                          value: z,
                          child: Text(z, style:
                          GoogleFonts.nunito(
                              color: ASSENT_COLOR, fontSize: 16
                          ),
                          ),
                        );
                      }).toList(),
                      onChanged: (_v) {
                        setState(() {
                          _monedaAlquiler=_v!;
                        });
                      },
                    ),
                  ),
                  validator:  (value) {
                    if (isSelected[1] && (value == null || value.isEmpty)) {
                      return 'Favor ingrese el precio de alquiler';
                    }
                    return null;
                  },
                ) : Center(),
                SizedBox(height: 16),
                isSelected[0] ? Text('Precio Venta') : Center(),
                isSelected[0] ? SizedBox(height: 4) : Center(),
                isSelected[0] ?
                TextFormField(
                  enabled: false,
                  // onChanged: (value){
                  //   Property.data.precioVenta = _controllerVenta.numberValue;
                  // },
                  keyboardType: TextInputType.number,
                  controller: _controllerVenta,
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
                    hintText: "Ingrese el monto de venta",
                    hintStyle: TextStyle(
                        color: SOFT_GREY,
                        fontSize: 14
                    ),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12.0),
                    prefix: SizedBox(
                      width: 50.0,
                      child: DropdownButtonFormField<String>(
                        isExpanded: false,
                        decoration: InputDecoration.collapsed(hintText: null),
                        // alignment: Alignment.centerLeft,
                        isDense: true,
                        style: GoogleFonts.nunito(
                            color: ASSENT_COLOR, fontSize: 16
                        ),
                        value: _monedaVenta,
                        items: <String>["Gs.","\$"].map((String z) {
                          return DropdownMenuItem<String>(
                            value: z,
                            child: Text(z, style:
                            GoogleFonts.nunito(
                                color: ASSENT_COLOR, fontSize: 16
                            ),
                            ),
                          );
                        }).toList(),
                        onChanged: (_v) {
                          setState(() {
                            _monedaVenta=_v!;
                          });
                        },
                      ),
                    ),
                  ),
                  validator:  (value) {
                    if (isSelected[0] && (value == null || value.isEmpty) ) {
                      return 'Favor ingrese el precio de venta';
                    }
                    return null;
                  },
                ): Center(),
                SizedBox(height: 32),

              ],
            ),
          ),
        ],
      ),
    );
  }

  void _navigateAndRetrieveSelection(BuildContext context) async {
    // Navigator.push returns a Future that completes after calling
    // Navigator.pop on the Selection Screen.

    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => MyLocation(currentLocation: _position)),
    );
    var target = List<dynamic>.from(result);
    _controllerDireccion.text=(target.last.toString());
    Property.data.direccion = _controllerDireccion.text;
    _position=target.first;
    Property.data.gps = _position!;
    _departamento = target[2];
    Property.data.departamento = _departamento;
    _ciudad = target[1];
    _controllerCiudad.text = _ciudad??'';
    Property.data.ciudad = _ciudad;
    _zona=null;
    _getZonasList();
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
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
        _controllerFechaIngreso.text= format.format(_selectedDate);
        Property.data.fechaIngreso = _controllerFechaIngreso.text;
      });
    }
  }

}
