
import 'package:devkitflutter/config/constant.dart';
import 'package:devkitflutter/model/integration/historico_estados_model.dart';
import 'package:devkitflutter/model/integration/property_model.dart';
import 'package:devkitflutter/model/integration/property_type_listview_model.dart';
import 'package:devkitflutter/network/api_provider.dart';
import 'package:devkitflutter/ui/apps/food_delivery/reusable_widget.dart';
import 'package:devkitflutter/ui/integration/api/add_gallery_property.dart';
import 'package:devkitflutter/ui/integration/api/location_gps.dart';
import 'package:devkitflutter/ui/integration/api/tab/edit_tab_direccion.dart';
import 'package:dio/dio.dart';
import 'package:extended_masked_text/extended_masked_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:devkitflutter/ui/reusable/global_function.dart';
import 'package:search_choices/search_choices.dart';


class AddPropertyPage extends StatefulWidget {
  final bool fromList;

  const AddPropertyPage({Key? key, this.fromList = false}) : super(key: key);

  @override
  _AddPropertyPageState createState() => _AddPropertyPageState();
}

class _AddPropertyPageState extends State<AddPropertyPage> {
  // initialize reusable widget
  final DateFormat format=DateFormat("yyyy-MM-dd");
  final _controllerVenta = new MoneyMaskedTextController(decimalSeparator: '', thousandSeparator: '.', precision: 0);
  final _controllerAlquiler = new MoneyMaskedTextController(decimalSeparator: '', thousandSeparator: '.', precision: 0);
  final _controllerDireccion = TextEditingController();
  final _controllerTitulo = TextEditingController();
  final _controllerFechaIngreso = TextEditingController();
  final _controllerComisionVenta = TextEditingController();
  final _controllerComisionAlquiler = TextEditingController();
  final _controllerDescripcion = TextEditingController();
  final _controllerCiudad = TextEditingController();
  LatLng? _position;
  String? _ciudad;
  late String _departamento;
  String? _zona;
  List<String?> zonasListData=[];
  late PropertyModel _propertyModel;
  final _reusableWidget = ReusableWidget();
  final CancelToken apiToken = CancelToken(); // used to cancel fetch data from API
  final _formKey = GlobalKey<FormState>();
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
  bool _comisionAlquiler = false;
  final ApiProvider _apiProvider=ApiProvider();
  final _globalFunction = GlobalFunction();
  final _controllerZona = TextEditingController();

  @override
  void initState() {
    _getTipoInmuebles();
    _monedaAlquiler="Gs.";
    _monedaVenta="\$";
    _selectedDate=DateTime.now();
    _controllerFechaIngreso.text=format.format(_selectedDate);
    images=List.empty();
    _controllerComisionVenta.text = '5.0';
    _controllerComisionAlquiler.text = '10.0';
    super.initState();
  }

  @override
  void dispose() {
    _controllerDireccion.dispose();
    _controllerAlquiler.dispose();
    _controllerVenta.dispose();
    super.dispose();
  }
  void _getTipoInmuebles()async {
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

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onBackPressed,
      child: Scaffold(
        appBar: AppBar(
          iconTheme: IconThemeData(
            color: Colors.white,
          ),
          actions: [
            TextButton(
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.resolveWith<Color>(
                      (Set<MaterialState> states) => PRIMARY_COLOR,
                ),
                overlayColor: MaterialStateProperty.all(Colors.transparent),
                shape: MaterialStateProperty.all(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(3.0),
                    )
                ),
              ),
              onPressed: () {
                 _navigateGallery(context);
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 5.0),
                child: Text(
                  'Siguiente',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.amberAccent),
                    textAlign: TextAlign.center,
                ),
              ),
            ),
          ],
          backgroundColor: Color(0xff243972),
          centerTitle: true,
          title: Text('Nueva Propiedad', style: GoogleFonts.nunito(
              fontSize: 20,
              fontWeight: FontWeight.normal,
              color: Colors.white,
            )
          ),
          bottom: _reusableWidget.bottomAppBar(),
        ),
        body: _buildForm(),
      ),
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
                            // _selectDateWithMinMaxDate(context);
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
                  },
                  isSelected: isSelected,
                ),
                SizedBox(height: 16),
                Text('Titulo'),
                SizedBox(height: 4),
                TextFormField(
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
                    _ciudad = value.trim().toUpperCase();
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
                          validator: (value){
                            return (value == null || value.toString().isEmpty)?'Seleccione Zona':null;
                          },
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
                                _controllerComisionVenta.text='5.0';
                              });
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
                                }else if(double.parse(value)<=0){
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
                // isSelected[1]? Row(
                //   children: [
                //     Expanded(
                //       flex: 0,
                //       child:
                //       Column(
                //         children: [
                //           Text('Comisión por Alquiler'),
                //           SizedBox(height: 4),
                //           Switch(
                //             value: _comisionAlquiler,
                //             onChanged: (value) {
                //               setState(() {
                //                 _comisionAlquiler = value;
                //                 _controllerComisionAlquiler.text='10.0';
                //               });
                //             },
                //           ),
                //         ],
                //       ),
                //     ),
                //     _comisionAlquiler?
                //     Expanded(
                //       flex: 1,
                //       child:
                //       Column(
                //         children: [
                //           Text('% de Comisión'),
                //           SizedBox(height: 4),
                //           Container(
                //             width: 100,
                //             child:TextFormField(
                //               inputFormatters: [
                //                 FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}'))
                //               ],
                //               controller: _controllerComisionAlquiler,
                //               keyboardType: TextInputType.number,
                //               maxLines: 1,
                //               decoration: InputDecoration(
                //                 enabledBorder: OutlineInputBorder(
                //                   borderSide: BorderSide(color: SOFT_GREY, width: 0),
                //                   borderRadius: BorderRadius.all(
                //                     Radius.circular(8),
                //                   ),
                //                 ),
                //                 focusedBorder: OutlineInputBorder(
                //                   borderSide: BorderSide(color: SOFT_GREY, width: 0),
                //                   borderRadius: BorderRadius.all(
                //                     Radius.circular(8),
                //                   ),
                //                 ),
                //                 hintText: "Porcentaje de la comisión",
                //                 hintStyle: TextStyle(
                //                     color: SOFT_GREY,
                //                     fontSize: 14
                //                 ),
                //                 contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12.0),
                //               ),
                //               validator:  (value) {
                //                 if ((value == null || value.isEmpty)) {
                //                   return 'Favor ingrese % mayor a cero';
                //                 }else if(double.parse(value)<=0){
                //                   return 'Favor ingrese % mayor a cero';
                //                 }
                //                 return null;
                //               },
                //             ),
                //           ),
                //         ],
                //       ),
                //     ): Expanded(child: Center()),
                //   ],
                // ) : Center(),
                SizedBox(height: 16),
                isSelected[1] ? SizedBox(height: 16): Center(),
                isSelected[1] ? Text('Precio Alquiler') : Center(),
                isSelected[1] ? SizedBox(height: 4) : Center(),
                isSelected[1] ? TextFormField(
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
                    hintText: "Ingrese el monto del venta",
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
                SizedBox(
                  width: double.maxFinite,
                  child: ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.resolveWith<Color>(
                            (Set<MaterialState> states) => Colors.lightBlue,
                      ),
                      overlayColor: MaterialStateProperty.all(Colors.transparent),
                      shape: MaterialStateProperty.all(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(3.0),
                          )
                      ),
                    ),
                    onPressed: () {
                      _navigateGallery(context);
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      child: Text(
                        'SIGUIENTE',
                        style: GoogleFonts.nunito(
                            fontSize:16,
                            fontWeight:FontWeight.bold,
                            color: Colors.white,
                            letterSpacing: 1
                        ),
                        textAlign: TextAlign.center,
                      ),
                    )
                  ),
                ),
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
    print('result: $result');
    var target = List<dynamic>.from(result);
    _controllerDireccion.text=(target.last.toString());
    _position=target.first;
    _departamento = target[2];
    _ciudad = target[1];
    _controllerCiudad.text = _ciudad??'';
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
      });
    }
  }

  void _navigateGallery(BuildContext context) async {
    if(_formKey.currentState!.validate()){
      _propertyModel=PropertyModel(titulo: _controllerTitulo.value.text,
        fechaIngreso: format.format(_selectedDate),
        direccion: _controllerDireccion.value.text, gps: _position!,
        precioAlquiler: _controllerAlquiler.numberValue,
        monedaAlquiler: isSelected[1]?_monedaAlquiler:null,
        precioVenta: _controllerVenta.numberValue,
        monedaVenta: isSelected[0]? _monedaVenta:null,
      );
      _propertyModel.descripcion = _controllerDescripcion.text;
      _propertyModel.estados = [HistoricoEstadosModel(estado: 'DISPONIBLE', fechaHora: format.format(_selectedDate))];
      _propertyModel.comisionVenta = _comisionVenta;
      _propertyModel.porcentajeComisionVenta = _comisionVenta==true?double.parse(_controllerComisionVenta.text):0.0;
      _propertyModel.comisionAlquiler = _comisionAlquiler;
      _propertyModel.porcentajeComisionAlquiler = _comisionAlquiler==true?double.parse(_controllerComisionAlquiler.text):0.0;
      _propertyModel.tipoInmueble = PropertyTypeListviewModel(
          nombre: _selectedTipoInmueble!.nombre, alquiler: isSelected[1] , venta: isSelected[0]
      );
      _propertyModel.departamento = _departamento;
      _propertyModel.ciudad = _ciudad;
      _propertyModel.zona = _zona;
      _propertyModel.images=this.images;
      _propertyModel.coverImage=this.coverImage;
      _propertyModel.coverImageIndex=this.coverIndex;
      Set result = await Navigator.push(context,
          MaterialPageRoute(
              builder: (context) => AddGalleryWidget(propertyModel: _propertyModel,)
          )
      );
      _propertyModel.coverImageIndex=result.last;
      this.coverImage=result.elementAt(1);
      this.images=result.first;
    }else{
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              backgroundColor: Colors.red,
              behavior: SnackBarBehavior.floating,
              content: Text('Faltan campos que completar.'))
      );
    }
  }

  Future<bool> _onBackPressed() async{
    late bool response;
    response = await _globalFunction.confirmationOnBackPressed(context);
    return response;
  }

}
