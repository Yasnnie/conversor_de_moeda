import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;

const request = "https://api.hgbrasil.com/finance?format=json&key=2f27080e";

void main() async {
  
  runApp(MaterialApp(
    home: App(),
  ));
}

Future<Map?> getData() async {
  http.Response response = await http.get(Uri.parse(request));
  return json.decode(response.body);
}

class App extends StatefulWidget {
  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<App> {
  final realController = TextEditingController();
  final dolarController = TextEditingController();
  final euroController = TextEditingController();
  final pesoController = TextEditingController();
  final ieneController = TextEditingController();


  double? dolar;
  double? euro;
  double? peso;
  double? iene;


 void _clearAll() {
    realController.text = "";
    dolarController.text = "";
    euroController.text = "";
    pesoController.text = "";
    ieneController.text = "";
  }

  void _realChangged(String text){
      if (text.isEmpty) {
      _clearAll();
      return;
    }
    double real = double.parse(text);
    dolarController.text = (real / dolar!).toStringAsFixed(2);
    euroController.text = (real / euro!).toStringAsFixed(2);
    pesoController.text = (real/ peso!).toStringAsFixed(2);
    ieneController.text = (real/ iene!).toStringAsFixed(2);
  
  }

  void _dolarChangged(String text){
    if (text.isEmpty) {
      _clearAll();
      return;
    }
      double dolar =  double.parse(text);
      realController.text = (dolar * this.dolar!).toStringAsFixed(2);
      euroController.text = (dolar * this.dolar! / euro!).toStringAsFixed(2);
      pesoController.text = (dolar * this.dolar! / peso!).toStringAsFixed(2);
      ieneController.text = (dolar * this.dolar! / iene!).toStringAsFixed(2);
  }

  void _euroChangged(String text){
    if (text.isEmpty) {
      _clearAll();
      return;
    }
        double euro =  double.parse(text);
        realController.text = (euro * this.euro!).toStringAsFixed(2);
        dolarController.text = (euro * this.euro! / dolar!).toStringAsFixed(2);
        pesoController.text = (euro * this.euro! / peso!).toStringAsFixed(2);
        ieneController.text = (euro * this.euro! / iene!).toStringAsFixed(2);
  }

  void _pesoChangged(String text){
    if (text.isEmpty) {
      _clearAll();
      return;
    }
        double peso =  double.parse(text);
        realController.text = (peso * this.peso!).toStringAsFixed(2);
        dolarController.text = (peso * this.peso! / dolar!).toStringAsFixed(2);
        euroController.text = (peso * this.peso! / euro!).toStringAsFixed(2);
        ieneController.text = (peso * this.peso! / iene!).toStringAsFixed(2);
  }

 void _ieneChangged(String text){
    if (text.isEmpty) {
      _clearAll();
      return;
    }
        double iene =  double.parse(text);
        realController.text = (iene * this.iene!).toStringAsFixed(2);
        dolarController.text = (iene * this.iene! / dolar!).toStringAsFixed(2);
        euroController.text = (iene * this.iene! / euro!).toStringAsFixed(2);
        pesoController.text = (iene * this.iene! / peso!).toStringAsFixed(2);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("Conversor de moeda"),
        backgroundColor: Colors.teal,
        centerTitle: true,
      ),
      body: FutureBuilder<Map?>(
        future: getData(),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.none:
            case ConnectionState.waiting:
              return Center(
                child: Text(
                  "Carregando Dados...",
                  style: TextStyle(
                    color: Colors.teal,
                    fontSize: 25,
                  ),
                ),
              );
            default:
              if (snapshot.hasError) {
                return Center(
                    child: Text("Erro ao Dados...",
                        style: TextStyle(
                          color: Colors.teal,
                          fontSize: 25,
                        )));
              } else {
                dolar = snapshot.data!["results"]["currencies"]["USD"]["buy"];
                euro = snapshot.data!["results"]["currencies"]["EUR"]["buy"];
                peso = snapshot.data!["results"]["currencies"]["ARS"]["buy"];
                iene = snapshot.data!["results"]["currencies"]["JPY"]["buy"];

                return SingleChildScrollView(
                  padding: EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      Icon(Icons.monetization_on,
                          size: 100, color: Colors.teal),
                      buildTextField("Reais", "R\$", realController, _realChangged),
                      buildTextField("Dólares", "US\$",dolarController, _dolarChangged),
                      buildTextField("Euros", "€",euroController,_euroChangged),
                      buildTextField("Peso Argentino", "\$", pesoController, _pesoChangged),
                      buildTextField("Iene", "¥", ieneController, _ieneChangged),
                    ],
                  ),
                );
              }
          }
        },
      ),
    );
  }
}

//STYLES
Widget buildTextField(String text, String prefix, TextEditingController control, Function function) {
  return Padding(
      padding: EdgeInsets.only(top: 10, bottom: 10),
      child: TextField(
        keyboardType: TextInputType.number,
        decoration: InputDecoration(
            labelText: text,
            border: OutlineInputBorder(),
            labelStyle: TextStyle(color: Colors.teal),
            prefixText: prefix),
        style: TextStyle(color: Colors.teal),
        controller: control,
        onChanged: function as void Function(String)?,
      ));
}
