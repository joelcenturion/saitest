import 'package:devkitflutter/config/constant.dart';
import 'package:extended_masked_text/extended_masked_text.dart';
import 'package:flutter/material.dart';
import 'package:devkitflutter/ui/integration/api/add_details.dart';

class AdicionalesTabPage extends StatefulWidget {
  AdicionalesTabPage({Key? key, this.formKey}) : super(key: key);
  final GlobalKey<FormState>? formKey;
  @override
  _AdicionalesTabPageState createState() => _AdicionalesTabPageState(formKey!);
}

class _AdicionalesTabPageState extends State<AdicionalesTabPage> with AutomaticKeepAliveClientMixin {

  _AdicionalesTabPageState(this._formKeyAdicionales):super();
  GlobalKey<FormState> _formKeyAdicionales;
  @override
  bool get wantKeepAlive => true;
  // initialize global widget
  final _controllerExpensas = TextEditingController();
  final _controllerPreciom2 = TextEditingController();
  final _controllerPrecioha = TextEditingController();
  final _controllerCocheraAdicional = TextEditingController();
  final _controllerBauleraAdicional = TextEditingController();
  final _controllerMueblesAdicional = TextEditingController();

  @override
  void initState() {
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
        key: _formKeyAdicionales,
        child: ListView(
          children: _items(),
        ),
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
                  value: Inmueble.data.contrato,
                  onChanged: (value) {
                    setState(() {
                      Inmueble.data.contrato = value;
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
                  value: Inmueble.data.exclusividad,
                  onChanged: (value) {
                    setState(() {
                      Inmueble.data.exclusividad = value;
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
                  value: Inmueble.data.directo,
                  onChanged: (value) {
                    setState(() {
                      Inmueble.data.directo = value;
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
                  value: Inmueble.data.iva,
                  onChanged: (value) {
                    setState(() {
                      Inmueble.data.iva = value;
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
                    value: Inmueble.data.expensas,
                    onChanged: (value) {
                      print('expensas ${Inmueble.data.precioExpensas}');
                      setState(() {
                        Inmueble.data.expensas = value;
                        _controllerExpensas.text='';
                        Inmueble.data.precioExpensas=0.0;
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
                    Inmueble.data.precioExpensas = value.isNotEmpty? double.parse(value):0.0;
                    print('${Inmueble.data.precioExpensas}');
                  },
                  enabled: Inmueble.data.expensas,
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
                    if(Inmueble.data.expensas){
                      if ((value == null || value.isEmpty)) {
                        return 'Favor ingrese un precio mayor a cero';
                      }else if(int.parse(value)<=0){
                        return 'Favor ingrese un precio mayor a cero';
                      }
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
                    value: Inmueble.data.cocheraAdicional,
                    onChanged: (value) {
                      setState(() {
                        Inmueble.data.cocheraAdicional = value;
                        _controllerCocheraAdicional.text='';
                        Inmueble.data.precioCocheraAdicional = 0.0;
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
                    Inmueble.data.precioCocheraAdicional = value.isNotEmpty? double.parse(value):0.0;
                  },
                  enabled: Inmueble.data.cocheraAdicional,
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
                    if(Inmueble.data.cocheraAdicional){
                      if ((value == null || value.isEmpty)) {
                        return 'Favor ingrese un precio mayor a cero';
                      }else if(int.parse(value)<=0){
                        return 'Favor ingrese un precio mayor a cero';
                      }
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
                    value: Inmueble.data.bauleraAdicional,
                    onChanged: (value) {
                      setState(() {
                        Inmueble.data.bauleraAdicional = value;
                        _controllerBauleraAdicional.text='';
                        Inmueble.data.precioBauleraAdicional = 0.0;
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
                    Inmueble.data.precioBauleraAdicional = value.isNotEmpty? double.parse(value):0.0;
                  },
                  enabled: Inmueble.data.bauleraAdicional,
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
                    if(Inmueble.data.bauleraAdicional){
                      if ((value == null || value.isEmpty)) {
                        return 'Favor ingrese un precio mayor a cero';
                      }else if(int.parse(value)<=0){
                        return 'Favor ingrese un precio mayor a cero';
                      }
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
                  value: Inmueble.data.muebles,
                  onChanged: (value) {
                    setState(() {
                      Inmueble.data.muebles = value;
                      _controllerMueblesAdicional.text = '';
                      Inmueble.data.precioMueblesAdicional = 0.0;
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
                  onChanged: (value){
                    Inmueble.data.precioMueblesAdicional = value.isNotEmpty? double.parse(value):0.0;
                  },
                  enabled: Inmueble.data.muebles,
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
                    if(Inmueble.data.muebles){
                      if ((value == null || value.isEmpty)) {
                        return 'Favor ingrese un precio mayor a cero';
                      }else if(int.parse(value)<=0){
                        return 'Favor ingrese un precio mayor a cero';
                      }
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
                      Inmueble.data.precioM2 = value.isNotEmpty? double.parse(value):0.0;
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
                    Inmueble.data.precioHa = value.isNotEmpty? double.parse(value):0.0;
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
