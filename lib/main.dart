import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class DataModel {
  final String value;

  DataModel({required this.value});

  factory DataModel.fromJson(Map<String, dynamic> json) {
    return DataModel(value: json['value']);
  }
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Future<DataModel> fetchData() async {
    final response = await http.get(Uri.parse(
        'https://api.coindesk.com/v1/bpi/currentprice.json')); // API URL

    if (response.statusCode == 200) {
      // Nếu kết quả trả về thành công
      final jsonBody = jsonDecode(response.body);
      return DataModel.fromJson(jsonBody);
    } else {
      throw Exception('Failed to load data');
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('API Demo'),
        ),
        body: Center(
          child: FutureBuilder<DataModel>(
            future: fetchData(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return Text(snapshot.data!.value);
              } else if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              }
              return CircularProgressIndicator();
            },
          ),
        ),
      ),
    );
  }
}

void main() {
  runApp(MyApp());
}
