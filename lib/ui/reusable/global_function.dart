import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:intl/number_symbols.dart';
import 'package:intl/number_symbols_data.dart';
import 'package:flutter_logs/flutter_logs.dart';
import 'package:multi_image_picker/multi_image_picker.dart';

class GlobalFunction{
  bool validateMobileNumber(String value) {
    String patttern = r'(^(?:[+0]9)?[0-9]{10,15}$)';
    RegExp regExp = new RegExp(patttern);
    if (value.length < 8) {
      return false;
    } else if (!regExp.hasMatch(value)) {
      return false;
    } else {
      return true;
    }
  }

  bool validateEmail(String value) {
    String pattern = r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = new RegExp(pattern);
    if (!regex.hasMatch(value)) {
      return false;
    } else {
      return true;
    }
  }

  String removeDecimalZeroFormat(double v) {
    NumberFormat formatter = NumberFormat();
    formatter.minimumFractionDigits = 0;
    formatter.maximumFractionDigits = 2;
    return formatter.format(v);
  }

  String formatNumber(double? number){
    numberFormatSymbols['custom'] = new NumberSymbols(
        NAME: 'custom',
        DECIMAL_SEP: ',',
        GROUP_SEP: '.',
        PERCENT: '%',
        ZERO_DIGIT: '0',
        PLUS_SIGN: '+',
        MINUS_SIGN: '-',
        EXP_SYMBOL: 'e',
        PERMILL: '\u2030',
        INFINITY: '\u221E',
        NAN: 'NaN',
        DECIMAL_PATTERN: '',
        SCIENTIFIC_PATTERN: '#E0',
        PERCENT_PATTERN: '#,##0%',
        CURRENCY_PATTERN: '\u00A4#,##0.00',
        DEF_CURRENCY_CODE: 'Gs.');
    NumberFormat formatter = NumberFormat('#,##0.##','custom');
    number = number??0;
    return formatter.format(number);
  }

  String formatTime(int timeNum) {
    return timeNum < 10 ? "0" + timeNum.toString() : timeNum.toString();
  }

  Future showProgressDialog(BuildContext context) {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return WillPopScope(
            onWillPop: () {
              return Future.value(false);
            },
            child: Center(
              child: CircularProgressIndicator(),
            ),
          );
        });
  }

  //confirmation prompt when back button is pressed
  Future <dynamic> confirmationOnBackPressed(BuildContext context){
    return showDialog(
        context: context,
        builder: (BuildContext context){
          return AlertDialog(
            // title: Text('Descartar'),
            content: Text(
                '¿Desea descartar los cambios realizados?',
                style: GoogleFonts.nunito(
                  fontSize: 16,
                  fontWeight: FontWeight.normal,
                  color: Color(0xff243972),
                )
            ),
            actions: [
              cancelButton(context),
              confirmButton(context, 'Descartar', Colors.redAccent, Colors.white)
            ],
          );
        }
    );
  }

  //confirmation prompt when you want to save a new property
  Future <dynamic> showConfirmationPrompt(BuildContext context){
    return showDialog(
        context: context,
        builder: (BuildContext context){
          return AlertDialog(
            title: Text('Confirmación'),
            content: Text('¿Desea guardar los cambios realizados?'),
            actions: [
              cancelButton(context),
              confirmButton(context, 'Guardar', Colors.white, Color(0xff243972))
            ],
          );
        }
    );
  }

  //Buttons for Prompts
  Widget cancelButton(context){
    return TextButton(
        style: ButtonStyle(
          elevation: MaterialStateProperty.all(10),
          backgroundColor: MaterialStateProperty.resolveWith<Color>(
                (Set<MaterialState> states) => Colors.white,
          ),
          overlayColor: MaterialStateProperty.all(Colors.transparent),
          shape: MaterialStateProperty.all(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25.0),
              )
          ),
        ),
        onPressed: () => Navigator.pop(context, false),
        child: Text(
            'Cancelar',
            style: TextStyle(color: Color(0xff243972))
        )
    );
  }
  Widget confirmButton(context, String text, Color buttonColor, Color textColor){
    return TextButton(
      style: ButtonStyle(
        elevation: MaterialStateProperty.all(10),
        backgroundColor: MaterialStateProperty.resolveWith<Color>(
              (Set<MaterialState> states) => buttonColor,
        ),
        overlayColor: MaterialStateProperty.all(Colors.transparent),
        shape: MaterialStateProperty.all(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(25.0),
            )
        ),
      ),
      onPressed: () => Navigator.pop(context, true),
      child: Text(
        '$text',
        style: TextStyle(color: textColor),
      ),
    );
  }

  showSnackBar(BuildContext context, {required String msg, Color? color, int? duration}){
    ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          duration: Duration(milliseconds: duration??1500),
          content: Text(msg),
          backgroundColor: color?? Colors.green,
          behavior: SnackBarBehavior.floating,
        )
    );
  }

  flutterToast(String msg, Color color){
    Fluttertoast.showToast(
        backgroundColor: color,
        textColor: Colors.white,
        fontSize: 13.0,
        msg: msg,
        toastLength: Toast.LENGTH_LONG
    );
  }

}

Future<List<List<dynamic>>> getBase64List(List<Asset> images) async{
  final  images64 = List.generate(images.length, (i) => [null,'','']);
  ByteData imageByte;
  int i=0;
  for(Asset image in images) {
    imageByte = await image.getByteData(quality: 30);
    images64[i][1] = images[i].name!.split('.').last;
    images64[i][2] = base64Encode(imageByte.buffer.asUint8List());
    // print('images: ${images64}');
    i++;
  }
  // print('compare: ${images64[0][2]!.compareTo((images64[1][2])!)}');
  return images64;
}

Future<String> getBase64(Asset image) async{
  String image64 = '';
  ByteData imageByte;
  imageByte = await image.getByteData(quality: 40);
  image64 = base64Encode(imageByte.buffer.asUint8List());
  return image64;
}

void logToFile(String logMessage) {
  FlutterLogs.logToFile(
      logFileName: 'SaiLog',
      overwrite: false,
      //If set 'true' logger will append instead of overwriting
      logMessage: logMessage,
      appendTimeStamp: true); //Add time stamp at the end of log message
}
