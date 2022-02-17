import 'package:devkitflutter/config/apps/ecommerce/constant.dart';
import 'package:devkitflutter/model/integration/historico_estados_model.dart';
import 'package:devkitflutter/network/api_provider.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:devkitflutter/ui/apps/food_delivery/reusable_widget.dart';
import 'package:intl/intl.dart';
import 'edit_property_page.dart';
import 'package:async/async.dart';

class EditEstados extends StatefulWidget {
  const EditEstados({Key? key}) : super(key: key);

  @override
  _EditEstadosState createState() => _EditEstadosState();
}

class _EditEstadosState extends State<EditEstados> with AutomaticKeepAliveClientMixin{
  @override
  bool get wantKeepAlive => true;

  final _reusableWidget = ReusableWidget();
  List exampleItems = [
    {'estado': 'DISPONIBLE', 'fecha': DateTime.now().toString(), 'comentario': 'comentario de ejemplo',},
    {'estado': 'RESERVADO', 'fecha': DateTime.now().toString()},
    {'estado': 'SEÑADO', 'fecha': DateTime.now().toString()},
    {'estado': 'ALQUILADO', 'fecha': DateTime.now().toString()},
    {'estado': 'DISPONIBLE', 'fecha': DateTime.now().toString()},
    {'estado': 'RESERVADO', 'fecha': DateTime.now().toString()},
    {'estado': 'SEÑADO', 'fecha': DateTime.now().toString()},
    {'estado': 'VENDIDO', 'fecha': DateTime.now().toString()},
  ];
  List<String> _estados = ['DISPONIBLE', 'RESERVADO', 'SEÑADO', 'ALQUILADO', 'VENDIDO'];
  DateFormat format = DateFormat("yyyy-MM-dd");
  late DateTime now;
  Color _colorAmarillo = Color(0xfff7c705);
  Color _colorNaranja = Color(0xffff6f00);
  Color _colorRojo = Color(0xffff1900);
  Color _colorAzul = Color(0xff243972);
  final List<bool> _isSelected = [false, false, false, false, false];
  final _controllerFechaActualizacion = TextEditingController();
  final _controllerDuracionAlquiler = TextEditingController();
  final _controllerDiasNotificacion = TextEditingController();
  final _controllerComentario = TextEditingController();
  bool _archivarButton = false;
  bool _editarEstados = false;
  int? _indexSelected;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    now = DateTime.now();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: buildEstadosListView(),
    );
  }


 Widget buildEstadosListView(){
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
              child: Property.data.estados.isNotEmpty?buildHistorico():Center(child: Text('El Inmueble ${Property.data.idinmueble} no tiene estados.'))
            ),
            SizedBox(height: 15,),
            Divider(thickness: 1.5,),
            SizedBox(height: 15,),
            Container(
              margin: EdgeInsets.only(left: 12),
              child: Text(
                'CAMBIAR ESTADO',
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
                      children: _estados.asMap().entries.map(
                          (e){
                            int index = e.key;
                            String value = e.value;
                            return Container(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  _isSelected[index]?Icon(
                                    Icons.check_rounded,
                                    size: 25,
                                  ):SizedBox(),
                                  Text(
                                    ' $value',
                                    style: GoogleFonts.montserrat(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              )
                            );
                          }
                      ).toList(),
                      onPressed: (int index){
                        int previousIndex = _isSelected.indexOf(true);
                        // _isSelected.fillRange(0, _isSelected.length, false);
                        setState((){
                          _isSelected[index] = !_isSelected[index];
                          if(previousIndex >= 0)_isSelected[previousIndex] = false;
                        });
                        if (_isSelected[3] || _isSelected[4]){
                          showArchivarPrompt(context).then((value) {
                            Property.data.archivado = value;
                          });
                        }
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
                _isSelected[3]?'FECHA DE ALQUILER': _isSelected[4]? 'FECHA DE VENTA':'FECHA DE ACTUALIZACIÓN',
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
                  controller: _controllerFechaActualizacion,
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
            _isSelected[3]?Container(
              margin: EdgeInsets.only(left: 12),
              child: Text(
                'DURACIÓN DE ALQUILER',
                style: GoogleFonts.montserrat(
                  color: Colors.grey,
                  fontSize: 13,
                ),
              ),
            ):SizedBox(),
            _isSelected[3]?SizedBox(height: 15,):SizedBox(),
            _isSelected[3]?TextFormField(
              onChanged: (value){
                Property.data.duracionAlq = value;
              },
              keyboardType: TextInputType.number,
              controller: _controllerDuracionAlquiler,
              maxLines: 1,
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
                hintText: 'Ingrese duración del alquiler',
                hintStyle: TextStyle(
                    color: SOFT_GREY,
                    fontSize: 15
                ),
              ),
            ):SizedBox(),
            _isSelected[3]?SizedBox(height: 15,):SizedBox(),
            _isSelected[3]?Container(
              margin: EdgeInsets.only(left: 12),
              child: Text(
                'DIAS PARA NOTIFICACION',
                style: GoogleFonts.montserrat(
                  color: Colors.grey,
                  fontSize: 13,
                ),
              ),
            ):SizedBox(),
            _isSelected[3]?SizedBox(height: 15,):SizedBox(),
            _isSelected[3]?TextFormField(
              onChanged: (value){
                Property.data.diasNotif = value.trim().isNotEmpty?int.parse(value.trim()):null;
              },
              inputFormatters: <TextInputFormatter>[
                FilteringTextInputFormatter.digitsOnly
              ],
              keyboardType: TextInputType.number,
              controller: _controllerDiasNotificacion,
              maxLines: 1,
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
                hintText: 'Ingrese días para notificación',
                hintStyle: TextStyle(
                    color: SOFT_GREY,
                    fontSize: 15
                ),
              ),
            ):SizedBox(),
            _isSelected[3]?SizedBox(height: 15,):SizedBox(),
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
                  // maxWidth: 50,
                  minHeight: 100,
                  maxHeight: 100,
                ),
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  // reverse: true,
                // here's the actual text box
                  child: TextField(
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
            _archivarButton? Container(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: (){
                  showArchivarPrompt(context).then((value) {
                    Property.data.archivado = value;
                  });
                },
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 18),
                  child: Text(
                    'ARCHIVAR ',
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  primary: _colorAzul,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ):SizedBox(),
            SizedBox(height: 15,),
            ElevatedButton(
              onPressed: (){
                _editarEstados? _editarEstado(_indexSelected):_agregarEstado();
              },
              child: Text(_editarEstados?'OK':'Agregar Estado'),
              style: ElevatedButton.styleFrom(
                  primary: _colorAzul
              ),
            ),
            _editarEstados?ElevatedButton(
              onPressed: (){
                setState((){
                  _clearFields();
                  _editarEstados=false;
                });
              },
              child: Text('Cancelar'),
              style: ElevatedButton.styleFrom(
                  primary: _colorAzul
              ),
            ):SizedBox(),
          ],
        ),
      ),
    );
  }


  _editarEstado(int? index){
    if (index==null) return;
    int indexEstado = _isSelected.indexOf(true);
    if (indexEstado<0){showMessage('Seleccione Estado'); return;}
    Property.data.estados[index].estado = _estados[indexEstado];
    Property.data.estados[index].fechaHora = _controllerFechaActualizacion.text;
    Property.data.estados[index].comentario = _controllerComentario.text;
    _clearFields();
    _editarEstados=false;
    setState((){});
  }

  _agregarEstado(){
    if(!_formKey.currentState!.validate())
      return;
    int index = _isSelected.indexOf(true);
    if(index<0) {showMessage('Seleccione Estado'); return;}
    final _estado = HistoricoEstadosModel(estado: _estados[index], fechaHora: _controllerFechaActualizacion.text);
    _estado.comentario = _controllerComentario.text;
    _clearFields();
    setState((){
      Property.data.estados.add(_estado);
    });

  }

  _clearFields(){
    _isSelected.fillRange(0, _isSelected.length, false);
    _controllerFechaActualizacion.clear();
    _controllerComentario.clear();
  }

 Widget buildHistorico(){
    return ListView.builder(
      // separatorBuilder: (context, index) => Divider(color: Colors.grey, height: 2, thickness: 2,),
      itemCount: Property.data.estados.length,
      itemBuilder: (context, index) {
        String item = Property.data.estados[index].estado;
        String date = Property.data.estados[index].fechaHora??'';
        return GestureDetector(
          child: Card(
            elevation: 3,
            child: Container(
              height: 45,
              decoration: BoxDecoration(
                border: Border(
                  left: BorderSide(
                    color: (item.compareTo('DISPONIBLE') == 0? Colors.green
                        : (item.compareTo('RESERVADO') == 0)? _colorAmarillo
                        : (item.compareTo('ALQUILADO') == 0)? _colorRojo
                        : _colorNaranja
                    ),
                    width: 10.0,
                  ),
                ),
                // gradient: LinearGradient(
                //     stops: [0.03, 0.03],
                //     colors: [Colors.red, Colors.white]
                // ),
                // borderRadius: BorderRadius.circular(5),
                // boxShadow: [
                //   BoxShadow(
                //     color: Colors.grey,
                //     offset: Offset(0.0, 1.0), //(x,y)
                //     blurRadius: 5.0,
                //   ),
                // ],

              ),
              child: ListTile(
                dense: true,
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      item.toUpperCase(),
                      style: TextStyle(
                        fontSize: 14,
                      ),
                    ),
                    Text(date),
                  ],
                ),
                // title: Text(item)
              ),
            ),
          ),
          onDoubleTap: (){
            loadItems(Property.data.estados[index]);
            _editarEstados = true;
            _indexSelected = index;
          },
        );
      },
    );
 }

 loadItems(HistoricoEstadosModel _estado){
    int index = _estados.indexOf(_estado.estado.toUpperCase());
    _isSelected.fillRange(0, _isSelected.length, false);
    setState(() {
      _isSelected[index] = true;
      _controllerFechaActualizacion.text = _estado.fechaHora!;
      _controllerComentario.text = _estado.comentario??'';
      if(_isSelected[3] || _isSelected[4]){
        _archivarButton = true;
      }else{
        _archivarButton = false;
      }
    });
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
       _controllerFechaActualizacion.text = format.format(picked);
     });
   }
 }

  Future<dynamic> showArchivarPrompt(BuildContext context){
    return showDialog(
        context: context,
        builder: (BuildContext context){
          return AlertDialog(
            title: Text('Archivar'),
            content: Text('¿Desea Archivar el Inmueble?'),
            actions: [
              TextButton(
                  onPressed: () => Navigator.pop(context,false),
                  child: Text(
                      'NO',
                      style: TextStyle(color: Color(0xff243972))
                  )
              ),
              TextButton(
                onPressed: () => Navigator.pop(context,true),
                child: Text(
                  'SI',
                  style: TextStyle(color: Color(0xff243972)),
                ),
              )
            ],
          );
        }
    );
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
