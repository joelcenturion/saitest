import 'package:devkitflutter/config/constant.dart';
import 'package:flutter/material.dart';

import '../edit_property_page.dart';

class EditAdicionalesTabPage extends StatefulWidget {
  @override
  _EditAdicionalesTabPageState createState() => _EditAdicionalesTabPageState();
}

class _EditAdicionalesTabPageState extends State<EditAdicionalesTabPage> with AutomaticKeepAliveClientMixin {

  @override
  bool get wantKeepAlive => true;


  var _controllerExpensas = TextEditingController();
  final _controllerPreciom2 = TextEditingController();
  final _controllerPrecioha = TextEditingController();
  final _controllerCocheraAdicional = TextEditingController();
  final _controllerBauleraAdicional = TextEditingController();
  final _controllerMueblesAdicional = TextEditingController();


  @override
  void initState() {
    super.initState();
    _initializeForm();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _initializeForm(){
    _controllerExpensas.text = Property.data.precioExpensas==0.0?'':Property.data.precioExpensas.toString();
    _controllerCocheraAdicional.text = Property.data.precioCocheraAdicional == 0.0?'':Property.data.precioCocheraAdicional.toString();
    _controllerBauleraAdicional.text = Property.data.precioBauleraAdicional == 0.0?'': Property.data.precioBauleraAdicional.toString();
    _controllerMueblesAdicional.text = Property.data.precioMueblesAdicional == 0.0?'':Property.data.precioMueblesAdicional.toString();
    _controllerPreciom2.text = Property.data.precioM2 == 0.0?'':Property.data.precioM2.toString();
    _controllerPrecioha.text = Property.data.precioHa == 0.0?'':Property.data.precioHa.toString();
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
      SizedBox(height: 16),
      Flex(
        direction: Axis.horizontal,
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: Column(
              children: [
                Text('Contrato'),
                SizedBox(height: 4),
                Switch(
                  value: Property.data.contrato,
                  onChanged: (value) {
                    setState(() {
                      Property.data.contrato = value;
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
                Text('Exclusividad'),
                SizedBox(height: 4),
                Switch(
                  value: Property.data.exclusividad,
                  onChanged: (value) {
                    setState(() {
                      Property.data.exclusividad = value;
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
            child: Column(
              children: [
                Text('Directo'),
                SizedBox(height: 4),
                Switch(
                  value: Property.data.directo,
                  onChanged: (value) {
                    setState(() {
                      Property.data.directo = value;
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
                Text('Incluye I.V.A.'),
                SizedBox(height: 4),
                Switch(
                  value: Property.data.iva,
                  onChanged: (value) {
                    setState(() {
                      Property.data.iva = value;
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
              child: Column(
                children: [
                  Text('Incluye Expensas'),
                  SizedBox(height: 4),
                  Switch(
                    value: Property.data.expensas,
                    onChanged: (value) {
                      setState(() {
                        Property.data.expensas = value;
                        _controllerExpensas.text='';
                        Property.data.precioExpensas = 0.0;
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
                Text('Precio de expensas'),
                SizedBox(height: 4),
                TextFormField(
                  onChanged: (value){
                    Property.data.precioExpensas = value.isNotEmpty? double.parse(value):0.0;
                  },
                  enabled: Property.data.expensas,
                  controller: _controllerExpensas,
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
                    hintText: "Precio de la expensa",
                    hintStyle: TextStyle(
                        color: SOFT_GREY,
                        fontSize: 14
                    ),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12.0),
                  ),
                  validator:  (value) {
                    if ((value == null || value.isEmpty)) {
                      return 'Favor ingrese un precio mayor a cero';
                    }else if(int.parse(value)<=0){
                      return 'Favor ingrese un precio mayor a cero';
                    }
                    return null;
                  },
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
                  Text('Adicional por Cochera'),
                  SizedBox(height: 4),
                  Switch(
                    value: Property.data.cocheraAdicional,
                    onChanged: (value) {
                      setState(() {
                        Property.data.cocheraAdicional = value;
                        _controllerCocheraAdicional.text='';
                        Property.data.precioCocheraAdicional = 0.0;
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
                Text('Precio de cochera adicional'),
                SizedBox(height: 4),
                TextFormField(
                  onChanged: (value){
                    Property.data.precioCocheraAdicional = value.isNotEmpty? double.parse(value):0.0;
                  },
                  enabled: Property.data.cocheraAdicional,
                  controller: _controllerCocheraAdicional,
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
                    hintText: "Precio de cochera adicional",
                    hintStyle: TextStyle(
                        color: SOFT_GREY,
                        fontSize: 14
                    ),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12.0),
                  ),
                  validator:  (value) {
                    if ((value == null || value.isEmpty)) {
                      return 'Favor ingrese un precio mayor a cero';
                    }else if(int.parse(value)<=0){
                      return 'Favor ingrese un precio mayor a cero';
                    }
                    return null;
                  },
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
                  Text('Adicional por baulera'),
                  SizedBox(height: 4),
                  Switch(
                    value: Property.data.bauleraAdicional,
                    onChanged: (value) {
                      setState(() {
                        Property.data.bauleraAdicional = value;
                        _controllerBauleraAdicional.text='';
                        Property.data.precioBauleraAdicional = 0.0;
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
                Text('Precio de baulera adicional'),
                SizedBox(height: 4),
                TextFormField(
                  onChanged: (value){
                    Property.data.precioBauleraAdicional = value.isNotEmpty? double.parse(value):0.0;
                  },
                  enabled: Property.data.bauleraAdicional,
                  controller: _controllerBauleraAdicional,
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
                    hintText: "Precio de baulera adicional",
                    hintStyle: TextStyle(
                        color: SOFT_GREY,
                        fontSize: 14
                    ),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12.0),
                  ),
                  validator:  (value) {
                    if ((value == null || value.isEmpty)) {
                      return 'Favor ingrese un precio mayor a cero';
                    }else if(int.parse(value)<=0){
                      return 'Favor ingrese un precio mayor a cero';
                    }
                    return null;
                  },
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
                Text('Muebles'),
                SizedBox(height: 4),
                Switch(
                  value: Property.data.muebles,
                  onChanged: (value) {
                    setState(() {
                      Property.data.muebles = value;
                      _controllerMueblesAdicional.text = '';
                      Property.data.precioMueblesAdicional = 0.0;
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
                Text('Adicional con muebles'),
                SizedBox(height: 4),
                TextFormField(
                  enabled: Property.data.muebles,
                  controller: _controllerMueblesAdicional,
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
                    hintText: "Precio adicional con muebles",
                    hintStyle: TextStyle(
                        color: SOFT_GREY,
                        fontSize: 14
                    ),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12.0),
                  ),
                  validator:  (value) {
                    if ((value == null || value.isEmpty)) {
                      return 'Favor ingrese un precio mayor a cero';
                    }else if(int.parse(value)<=0){
                      return 'Favor ingrese un precio mayor a cero';
                    }
                    return null;
                  },
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
                Text('Precio por m2'),
                SizedBox(height: 4),
                TextFormField(
                  onChanged: (value){
                    Property.data.precioM2 = value.isNotEmpty? double.parse(value):0.0;
                  },
                  controller: _controllerPreciom2,
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
                    hintText: "Precio de la expensa",
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
            child: Column(
              children: [
                Text('Precio por Ha.'),
                SizedBox(height: 4),
                TextFormField(
                  onChanged: (value){
                    Property.data.precioHa = value.isNotEmpty? double.parse(value):0.0;
                  },
                  controller: _controllerPrecioha,
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
                    hintText: "Precio por Ha.",
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
    ];
  }
}
