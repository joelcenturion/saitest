import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/gestures.dart';
import 'package:devkitflutter/ui/reusable/global_function.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:devkitflutter/bloc/authentication/login/login_bloc2.dart';
import 'package:devkitflutter/ui/integration/api/property_listview.dart';

class Signin2Page extends StatefulWidget {
  @override
  _Signin2PageState createState() => _Signin2PageState();
}

class _Signin2PageState extends State<Signin2Page>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _globalFunction = GlobalFunction();
  TextEditingController _etUsername = TextEditingController();
  TextEditingController _etPassword = TextEditingController();
  late LoginBloc2 _loginBloc;

  bool _obscureText = true;
  IconData _iconVisible = Icons.visibility_off;
  IconData _iconPassword = Icons.lock;
  IconData _iconUser = Icons.perm_identity;

  Color _mainColor = Color(0xff243972);
  Color _underlineColor = Color(0xFFCCCCCC);

  void _toggleObscureText() {
    setState(() {
      _obscureText = !_obscureText;
      if (_obscureText == true) {
        _iconVisible = Icons.visibility_off;
      } else {
        _iconVisible = Icons.visibility;
      }
    });
  }

  @override
  void initState() {
    _loginBloc = BlocProvider.of<LoginBloc2>(context);

    super.initState();
  }

  @override
  void dispose() {
    _etUsername.dispose();
    _etPassword.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark);
    double keyboard = MediaQuery.of(context).viewInsets.bottom;
    return Scaffold(
        backgroundColor: Color(0xFFF1F3F6),
        body: BlocListener<LoginBloc2, LoginState2>(
            listener: (context, state) {
              if (state is LoginError) {
                Navigator.pop(context);
                Fluttertoast.showToast(
                    msg: state.errorMessage,
                    toastLength: Toast.LENGTH_LONG,
                    backgroundColor: Colors.red,
                    textColor: Colors.white,
                    fontSize: 13);
              }
              if (state is LoginWaiting) {
                FocusScope.of(context).unfocus();
                _globalFunction.showProgressDialog(context);
              }
              if (state is LoginSuccess) {
                print('data login');
                print('sessionId : ' + state.loginData.nombreUsuario);
                Navigator.pop(context);
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => PropertyListviewPage()));
              }
            },
            child: Stack(
              fit: StackFit.expand,
              children: <Widget>[
                // set your logo here
                Container(
                    alignment: Alignment.topCenter,
                    child: ListView(
                        physics: NeverScrollableScrollPhysics(),
                        children: <Widget>[
                          SizedBox(
                            height: 20,
                          ),
                          AnimatedSize(
                            curve: Curves.easeInOut,
                            duration: const Duration(milliseconds: 500),
                            vsync: this,
                            child: Image.asset(
                              'assets/images/logo_sai_app.png',
                              height: keyboard == 0 ? 150 : 70,
                            ),
                          ),
                          Center(
                            child: Text(
                              'S.A.I',
                              style: GoogleFonts.nunito(
                                fontSize: keyboard == 0 ? 32 : 20,
                                fontWeight: FontWeight.w900,
                                color: Color(0xff243972),
                                letterSpacing: 2,
                              ),
                            ),
                          ),
                        ])),

                ListView(
                  physics: NeverScrollableScrollPhysics(),
                  children: <Widget>[
                    // create form login
                    Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        elevation: 1,
                        margin: EdgeInsets.fromLTRB(
                            32, keyboard == 0 ? 230 : 140, 32, 0),
                        color: Colors.white,
                        child: Container(
                          margin: EdgeInsets.fromLTRB(24, 0, 24, 20),
                          child: Form(
                              key: _formKey,
                              child: Column(
                                children: <Widget>[
                                  SizedBox(
                                    height: 30,
                                  ),
                                  Center(
                                    child: Text(
                                      'INICIAR SESIÓN',
                                      style: GoogleFonts.nunito(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w800,
                                        color: _mainColor,
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  TextFormField(
                                    keyboardType: TextInputType.name,
                                    controller: _etUsername,
                                    decoration: InputDecoration(
                                        prefixIcon: Icon(_iconUser,
                                            color: Colors.grey[700], size: 20),
                                        focusedBorder: UnderlineInputBorder(
                                            borderSide: BorderSide(
                                                color: Colors.grey[600]!)),
                                        enabledBorder: UnderlineInputBorder(
                                          borderSide: BorderSide(
                                              color: _underlineColor),
                                        ),
                                        labelText: 'Nombre de usuario',
                                        labelStyle:
                                        TextStyle(color: Colors.grey[700])),
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Favor ingrese su nombre de usuario';
                                      }
                                      return null;
                                    },
                                  ),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  TextFormField(
                                    obscureText: _obscureText,
                                    controller: _etPassword,
                                    decoration: InputDecoration(
                                      focusedBorder: UnderlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Colors.grey[600]!)),
                                      enabledBorder: UnderlineInputBorder(
                                        borderSide:
                                        BorderSide(color: _underlineColor),
                                      ),
                                      labelText: 'Contraseña',
                                      labelStyle:
                                      TextStyle(color: Colors.grey[700]),
                                      prefixIcon: Icon(_iconPassword,
                                          color: Colors.grey[700], size: 20),
                                      suffixIcon: IconButton(
                                          icon: Icon(_iconVisible,
                                              color: Colors.grey[700],
                                              size: 20),
                                          onPressed: () {
                                            _toggleObscureText();
                                          }),
                                    ),
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Favor ingrese su contraseña';
                                      }
                                      return null;
                                    },
                                  ),
                                  SizedBox(
                                    height: 7,
                                  ),
                                  Padding(
                                    padding: EdgeInsets.symmetric(vertical: 10),
                                    child: Align(
                                      alignment: Alignment.centerRight,
                                      child: GestureDetector(
                                        onTap: () {
                                          Fluttertoast.showToast(
                                              msg: '¿Olvido su contraseña?',
                                              toastLength: Toast.LENGTH_SHORT);
                                        },
                                        child: Text(
                                          '¿Olvido su contraseña?',
                                          style: TextStyle(fontSize: 13),
                                          maxLines: 1,
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  SizedBox(
                                    width: double.maxFinite,
                                    child: ElevatedButton(
                                        style: ButtonStyle(
                                          backgroundColor: MaterialStateProperty
                                              .resolveWith<Color>(
                                                (Set<MaterialState> states) =>
                                            _mainColor,
                                          ),
                                          shape: MaterialStateProperty.all(
                                              RoundedRectangleBorder(
                                                borderRadius:
                                                BorderRadius.circular(10),
                                              )),
                                        ),
                                        onPressed: () {
                                          //if (_formKey.currentState!.validate()) {
                                          // If the form is valid, display a snackbar. In the real world,
                                          // you'd often call a server or save the information in a database.
                                          // ScaffoldMessenger.of(context)
                                          //    .showSnackBar(SnackBar(content: Text('Bienvenido...')));
                                          _loginBloc.add(Login2(
                                              username: _etUsername.text,
                                              password: _etPassword.text));
                                          // Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => PropertyListviewPage()));
                                          //}
                                        },
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 15),
                                          child: Text(
                                            'INGRESAR',
                                            style: GoogleFonts.nunito(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.white,
                                                letterSpacing: 1),
                                            textAlign: TextAlign.center,
                                          ),
                                        )),
                                  ),
                                ],
                              )),
                        )),
                  ],
                ),
                Container(
                  // padding: EdgeInsets.all(20),
                  // height: MediaQuery.of(context).size.height - 770,
                  padding: EdgeInsets.only(
                      top: MediaQuery.of(context).size.height - 60),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      Expanded(
                        child: Center(
                          child: RichText(
                            text: TextSpan(
                              children: [
                                TextSpan(
                                  text: 'INMOBILIARIA PROPIVER S.A.',
                                  style: GoogleFonts.nunito(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                    color: Color(0xff243972),
                                  ),
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = () async {
                                      final url = 'http://propiver.com';
                                      if (await canLaunch(url)) {
                                        await launch(
                                          url,
                                          forceSafariVC: false,
                                        );
                                      }
                                    },
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              ],
            )));
  }
}
