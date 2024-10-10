import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  Future<Map> _recuperarPreco() async {
    Uri url = Uri.parse("https://blockchain.info/ticker");
    http.Response response = await http.get(url);
    await Future.delayed(Duration(seconds: 10));
    return json.decode(response.body);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.all(32),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Image.asset("assets/images/bitcoin.png"),
              Padding(
                padding: const EdgeInsets.only(top: 30, bottom: 30),
                child: FutureBuilder<Map>(
                  future: _recuperarPreco(),
                  builder: (context, snapshot) {
                    String resultado;
                    switch (snapshot.connectionState) {
                      case ConnectionState.none:
                      case ConnectionState.waiting:
                        print("conexao waiting");
                        resultado = "Carregando...";
                        break;
                      case ConnectionState.active:
                      case ConnectionState.done:
                        print("conexao done");
                        if (snapshot.hasError) {
                          resultado = "Erro ao carregar os dados.";
                        } else {
                          double valor = snapshot.data!["BRL"]["buy"];
                          resultado = "Preço do bitcoin: ${valor.toString()} ";
                        }
                        break;
                    }
                    return Center(
                      child: Text(resultado),
                    );
                  },
                ),
              ),
              MaterialButton(
                color: Colors.orange,
                padding: const EdgeInsets.fromLTRB(30, 15, 30, 15),
                onPressed: _recuperarPreco,
                child: const Text(
                  "Atualizar",
                  style: TextStyle(fontSize: 20, color: Colors.white),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
