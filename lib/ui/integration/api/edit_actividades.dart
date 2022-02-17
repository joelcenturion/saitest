import 'package:devkitflutter/config/apps/ecommerce/constant.dart';
import 'package:devkitflutter/model/integration/historico_actividades_model.dart';
import 'package:devkitflutter/network/api_provider.dart';
import 'package:devkitflutter/ui/reusable/global_function.dart';
import 'package:dio/dio.dart';
import 'package:extended_masked_text/extended_masked_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:devkitflutter/ui/apps/food_delivery/reusable_widget.dart';
import 'package:intl/intl.dart';
import 'edit_property_page.dart';

class EditActividades extends StatefulWidget {
  const EditActividades({Key? key}) : super(key: key);

  @override
  _EditActividadesState createState() => _EditActividadesState();
}

class _EditActividadesState extends State<EditActividades> with AutomaticKeepAliveClientMixin{
  @override
  bool get wantKeepAlive => true;

  // List<String> _actividades = ['LLAMADA', 'EMAIL', 'VISITA', 'OFRECIMIENTO'];
  List<String> _actividades = ['VISITA', 'OFRECIMIENTO'];
  DateFormat format = DateFormat("yyyy-MM-dd");
  late DateTime now;
  Color _colorAzul = Color(0xff243972);
  // final List<bool> _isSelected = [false, false, false, false];
  final List<bool> _isSelected = [false, false];
  final _controllerFechaActividad = TextEditingController();
  final _controllerComentario = TextEditingController();
  final _controllerPrecioVenta = MoneyMaskedTextController(precision: 0, thousandSeparator: '.', decimalSeparator: '');
  final _controllerPrecioAlquiler  = MoneyMaskedTextController(precision: 0, thousandSeparator: '.', decimalSeparator: '');
  bool _isVenta = false;
  bool _isAlquiler = false;
  final CancelToken apiToken = CancelToken();
  bool _editarActividades = false;
  NumberFormat nf = NumberFormat('#,###.##','es_PY');
  final _formKey = GlobalKey<FormState>();
  int? _indexSelected;

  @override
  void initState() {
    super.initState();
    now = DateTime.now();
    initializeForm();
  }

  void initializeForm(){
    _isVenta = Property.data.tipoInmueble.venta;
    _isAlquiler = Property.data.tipoInmueble.alquiler;
    // if(_isVenta) {
    //   _precioVenta = Property.data.precioVenta;
    //   _monedaVenta = Property.data.monedaVenta;
    // }
    // if(_isAlquiler) {
    //   _precioAlquiler = Property.data.precioAlquiler;
    //   _monedaAlquiler = Property.data.monedaAlquiler;
    // }

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: buildActividadesListView(),
    );
  }

  Widget buildActividadesListView(){
    final screenSize = MediaQuery.of(context).size;
    return Form(
      key: _formKey,
      child: Container(
        padding: EdgeInsets.all(15),
        child: ListView(
          children: [
            Container(
              margin: EdgeInsets.only(left: 12),
              child: Text(
                'HISTÓRICO',
                style: GoogleFonts.montserrat(
                  color: Colors.grey,
                  fontSize: 13,
                  // fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(height: 15,),
            Container(
                padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                height: 255,
                decoration: BoxDecoration(
                    border: Border.all(color: _colorAzul),
                    borderRadius: BorderRadius.circular(8)
                ),
                child: Property.data.actividades.isNotEmpty? buildHistorico():Center(child: Text('No se encontraron actividades.'))
            ),
            SizedBox(height: 15,),
            Divider(thickness: 1.5,),
            SizedBox(height: 15,),
            Container(
              margin: EdgeInsets.only(left: 12),
              child: Text(
                'ACTIVIDAD REALIZADA',
                style: GoogleFonts.montserrat(
                  color: Colors.grey,
                  fontSize: 13,
                ),
              ),
            ),
            SizedBox(height: 15,),
            Container(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    width: 200,
                    child: ToggleButtons(
                      constraints: BoxConstraints(
                          minHeight: 40,
                          maxHeight: 40
                      ),
                      direction: Axis.vertical,
                      fillColor: _colorAzul,
                      selectedColor: Colors.white,
                      selectedBorderColor: SOFT_GREY,
                      color: _colorAzul,
                      borderColor: _colorAzul,
                      borderRadius: BorderRadius.circular(10.0),
                      children: _actividades.asMap().entries.map(
                              (e){
                            int index = e.key;
                            String value = e.value;
                            return Container(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    _isSelected[index]?Icon(
                                      Icons.check_rounded,
                                      size: 22,
                                    ):SizedBox(),
                                    Text(
                                      ' $value',
                                      style: GoogleFonts.montserrat(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 13,
                                      ),
                                    ),
                                  ],
                                )
                            );
                          }
                      ).toList(),
                      onPressed: (int index){
                        int previousIndex = _isSelected.indexOf(true);
                        setState((){
                          _isSelected[index] = !_isSelected[index];
                          if(previousIndex >= 0)_isSelected[previousIndex] = false;
                        });
                      },
                      isSelected: _isSelected,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 15,),
            Container(
              margin: EdgeInsets.only(left: 12),
              child: Text(
                'FECHA DE ACTIVIDAD',
                style: GoogleFonts.montserrat(
                  color: Colors.grey,
                  fontSize: 13,
                ),
              ),
            ),
            SizedBox(height: 15,),
            GestureDetector(
              onTap: () => _selectDate(context),
              child: AbsorbPointer(
                child: TextFormField(
                  validator: (value){
                    return (value == null || value.isEmpty)? 'Seleccione Fecha': null;
                  },
                  controller: _controllerFechaActividad,
                  maxLines: 1,
                  readOnly: true,
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12.0),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: SOFT_GREY, width: 0),
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: SOFT_GREY, width: 0),
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    hintText: 'Seleccione la fecha',
                    hintStyle: TextStyle(
                        color: SOFT_GREY,
                        fontSize: 15
                    ),
                    prefixIcon: IconButton(
                      icon: Icon(Icons.date_range, color: ASSENT_COLOR, size: 20,),
                      onPressed: () {
                        _selectDate(context);
                      },
                    ),

                  ),
                ),
              ),
            ),
            SizedBox(height: 15,),
            Container(
              margin: EdgeInsets.only(left: 12),
              child: Text(
                'COMENTARIO',
                style: GoogleFonts.montserrat(
                  color: Colors.grey,
                  fontSize: 13,
                ),
              ),
            ),
            SizedBox(height: 15,),
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
                  // maxWidth: screenSize.width-15,
                  minHeight: 100,
                  maxHeight: 100,
                ),
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  // reverse: true,
                  // here's the actual text box
                  child: TextFormField(
                    controller: _controllerComentario,
                    keyboardType: TextInputType.multiline,
                    minLines: 4,
                    maxLines: null, //grow automatically
                    decoration: InputDecoration.collapsed(
                      hintText: 'Escriba un comentario',
                      hintStyle: TextStyle(
                        color: SOFT_GREY,
                        fontSize: 15,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 15,),
            _isVenta?Container(
              margin: EdgeInsets.only(left: 12),
              child: Text(
                'PRECIO DE VENTA',
                style: GoogleFonts.montserrat(
                  color: Colors.grey,
                  fontSize: 13,
                ),
              ),

            ):SizedBox(),
            _isVenta?SizedBox(height: 15,):SizedBox(),
            _isVenta?TextFormField(
              controller: _controllerPrecioVenta,
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
                    value: Property.data.monedaVenta,
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
                        Property.data.monedaVenta=_v!;
                      });

                    },
                  ),
                ),
              ),
            ):SizedBox(),
            _isVenta?SizedBox(height: 15,):SizedBox(),
            _isAlquiler?Container(
              margin: EdgeInsets.only(left: 12),
              child: Text(
                'PRECIO DE ALQUILER',
                style: GoogleFonts.montserrat(
                  color: Colors.grey,
                  fontSize: 13,
                ),
              ),

            ):SizedBox(),
            _isAlquiler?SizedBox(height: 15,):SizedBox(),
            _isAlquiler?TextFormField(
              controller: _controllerPrecioAlquiler,
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
                hintText: "Ingrese el monto de alquiler",
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
                    value: Property.data.monedaAlquiler,
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
                        Property.data.monedaAlquiler=_v!;
                      });
                    },
                  ),
                ),
              ),
            ):SizedBox(),
            SizedBox(height: 15,),
            ElevatedButton(
              onPressed: (){
                _editarActividades? _editarActividad(_indexSelected):_agregarActividad();
              },
              child: Text(_editarActividades?'Ok':'Agregar Actividad'),
              style: ElevatedButton.styleFrom(
                primary: _colorAzul
              ),
            ),
            _editarActividades?ElevatedButton(
              onPressed: (){
                setState((){
                  _clearFields();
                  _editarActividades=false;
                });
              },
              child: Text('Cancelar'),
              style: ElevatedButton.styleFrom(
                  primary: Colors.blueGrey
              ),
            ):SizedBox(),
          ],
        ),
      ),
    );
  }

  Widget buildHistorico(){
    return ListView.builder(
      // separatorBuilder: (context, index) => Divider(color: Colors.grey, height: 2, thickness: 2,),
      itemCount: Property.data.actividades.length,
      itemBuilder: (context, index) {
        String item = Property.data.actividades[index].tipoActividad;
        String date = Property.data.actividades[index].fecha;
        return GestureDetector(
          child: Card(
            elevation: 3,
            child: Container(
              height: 45,
              decoration: BoxDecoration(
                border: Border.all(color: _colorAzul, width: 0),
                borderRadius: BorderRadius.circular(5),
              ),
              child: ListTile(
                dense: true,
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Icon(
                      item.toUpperCase() == 'LLAMADA'? Icons.call
                          : (item.toUpperCase() == 'EMAIL') ? Icons.email_outlined
                          : (item.toUpperCase() == 'VISITA') ? Icons.directions_walk
                          : Icons.local_offer,
                      color: item.toUpperCase() == 'LLAMADA'? Colors.indigo
                          : (item.toUpperCase() == 'EMAIL') ? Colors.red[800]
                          : (item.toUpperCase() == 'VISITA') ? Colors.greenAccent[700]
                          : Colors.orangeAccent[400],
                    ),
                    Expanded(
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: [
                            SizedBox(width: 10),
                            Text(
                              item,
                              style: TextStyle(
                                fontSize: 15,
                              ),
                            ),
                            SizedBox(width: 10),
                            _isVenta?Text(
                              'V: ${Property.data.monedaVenta} ${nf.format(Property.data.precioVenta)}',
                            ):SizedBox(),
                            _isVenta?SizedBox(width: 10):SizedBox(),
                            _isAlquiler?Text(
                              'A: ${Property.data.monedaAlquiler} ${nf.format(Property.data.precioAlquiler)}',
                            ):SizedBox(),
                            // Expanded(child: SizedBox()),
                            SizedBox(width: 10),
                            Text(date)
                          ],
                        ),
                      ),
                    )
                  ],
                ),
                // title: Text(item)
              ),
            ),
          ),
          onDoubleTap: (){
            loadItems(Property.data.actividades[index]);
            _editarActividades=true;
            _indexSelected=index;
          },
        );
      },
    );
  }

  loadItems(HistoricoActividadesModel _actividad){
    int index = _actividades.indexOf(_actividad.tipoActividad.toUpperCase());
    _isSelected.fillRange(0, _isSelected.length, false);
    setState((){
      _isSelected[index] = true;
      _controllerFechaActividad.text = _actividad.fecha;
      _controllerComentario.text = _actividad.obs;
      _controllerPrecioVenta.updateValue(Property.data.precioVenta);
      _controllerPrecioAlquiler.updateValue(Property.data.precioAlquiler);

    });

  }

  _editarActividad(int? index){
    if (index==null) return;
    int indexActividad = _isSelected.indexOf(true);
    if(indexActividad<0) {showMessage('Seleccione Actividad'); return;}
    Property.data.actividades[index].tipoActividad = _actividades[indexActividad];
    Property.data.actividades[index].fecha = _controllerFechaActividad.text;
    Property.data.actividades[index].obs = _controllerComentario.text;

    if (_controllerPrecioAlquiler.text.trim().isNotEmpty)
      Property.data.precioAlquiler = _controllerPrecioAlquiler.numberValue;

    if (_controllerPrecioVenta.text.trim().isNotEmpty)
      Property.data.precioVenta = _controllerPrecioVenta.numberValue;

    _clearFields();
    _editarActividades=false;
    setState((){});
  }

  _agregarActividad(){
    if(!_formKey.currentState!.validate())
      return;

      int index = _isSelected.indexOf(true);
      if(index<0) {showMessage('Seleccione Actividad'); return;}
      final _actividad = HistoricoActividadesModel();
      _actividad.tipoActividad = _actividades[index];
      _actividad.fecha = _controllerFechaActividad.text;
      _actividad.obs = _controllerComentario.text;

      if (_controllerPrecioAlquiler.text.trim().isNotEmpty) {
        Property.data.precioAlquiler = _controllerPrecioAlquiler.numberValue;
      }
      if (_controllerPrecioVenta.text.trim().isNotEmpty)
        Property.data.precioVenta = _controllerPrecioVenta.numberValue;

      _clearFields();
      setState(() {
        Property.data.actividades.add(_actividad);
      });

  }

  _clearFields(){
    _isSelected.fillRange(0, _isSelected.length, false);
    _controllerFechaActividad.clear();
    _controllerComentario.clear();
    _controllerPrecioVenta.clear();
    _controllerPrecioAlquiler.clear();
  }

  Future<Null> _selectDate(BuildContext context) async{
    final firstDate = DateTime(2017,01,01);
    final lastDate = DateTime(DateTime.now().year, DateTime.now().month,DateTime.now().day+7);
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: firstDate,
      lastDate: lastDate,
      cancelText: "Cancelar",
      confirmText: "OK",
      currentDate: DateTime.now(),
    );
    if (picked != null){
      setState(() {
        _controllerFechaActividad.text = format.format(picked);
      });
    }
  }

  showMessage(String msg){
    ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          duration: Duration(milliseconds: 1500),
          content: Text('$msg'),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
        )
    );
  }
}
