import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'build.dart';

const request = "https://api.hgbrasil.com/finance?key=8b63d94f";

void main() async {
  runApp(MaterialApp(
      debugShowCheckedModeBanner:false,
      home: const Home(),
    theme: ThemeData(
      hintColor: Colors.amber,
      primaryColor: Colors.white,
      inputDecorationTheme: const InputDecorationTheme(
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.white),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.amberAccent),
        ),
        hintStyle: TextStyle(color: Colors.amberAccent),
      ),
    ),
  ));
}

Future<Map> getData() async {
  http.Response response = await http.get(Uri.parse(request));
  return json.decode(response.body);
}

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final realController = TextEditingController();
  final dolarController = TextEditingController();
  final euroController = TextEditingController();
  double? dolar;
  double? euro;

  void _realChanged(String text) {
    double real = double.parse(text);
    dolarController.text = (real/dolar!).toStringAsFixed(2);
    euroController.text = (real/euro!).toStringAsFixed(2);
    }
  void _dolarChanged(String text) {
    double dolar = double.parse(text);
    realController.text = (dolar *this.dolar!).toStringAsFixed(2);
    euroController.text = (dolar *this.dolar!/ euro!).toStringAsFixed(2);
  }
  void _euroChanged(String text) {
    double euro = double.parse(text);
    realController.text = (euro *this.euro!).toStringAsFixed(2);
    dolarController.text = (euro *this.euro!/dolar!).toStringAsFixed(2);  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        centerTitle: true,
        title: const Text('\$ Conversor \$',style: TextStyle(color: Colors.black87),),
        backgroundColor: Colors.amberAccent,
        actions: [
          IconButton(onPressed: (){
            realController.text = "";
            dolarController.text = "";
            euroController.text = "";
          }, icon: Icon(Icons.refresh),color: Colors.black87,)
        ],
      ),
      body: FutureBuilder<Map>(
        future: getData(),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.none:
            case ConnectionState.waiting:
              return const Center(
                child: Text(
                  'Carregando dados',
                  style: TextStyle(color: Colors.amberAccent, fontSize: 24),
                ),
              );
            default:
              if (snapshot.hasError) {
                return const Center(
                  child: Text(
                    'Erro',
                    style: TextStyle(color: Colors.red, fontSize: 24),
                  ),
                );
              } else {
                dolar = snapshot.data!["results"]["currencies"]["USD"]["buy"];
                euro = snapshot.data!["results"]["currencies"]["EUR"]["buy"];
                return SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 50),
                        child: Icon(
                          Icons.monetization_on,
                          color: Colors.amberAccent,
                          size: 200,
                        ),
                      ),
                      const SizedBox(
                        height: 50,
                      ),
                      BuildTextField(
                        label: 'Reais',
                        prefix: 'R\$ ',
                        controller: realController,
                        onChanged: _realChanged,
                      ),
                      const SizedBox(height: 20),
                      BuildTextField(
                        label: 'Dólar',
                        prefix: 'US\$ ',
                        controller: dolarController,
                        onChanged: _dolarChanged,
                      ),
                      const SizedBox(height: 20),
                      BuildTextField(
                        label: 'Euro',
                        prefix: '£ ',
                        controller: euroController,
                        onChanged: _euroChanged,
                      ),
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
