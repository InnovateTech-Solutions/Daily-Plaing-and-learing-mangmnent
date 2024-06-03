import 'dart:convert';

import 'package:demogp/test/email_test.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Stocks App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: ReminderForm(),
    );
  }
}

class StockPage extends StatefulWidget {
  @override
  _StockPageState createState() => _StockPageState();
}

class _StockPageState extends State<StockPage> {
  String stocksData = "";

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    final response = await http
        .get(Uri.parse('http://127.0.0.1:5000/ask?query=what is python'));
    if (response.statusCode == 200) {
      setState(() {
        stocksData = json.decode(response.body)['response'];
      });
    } else {
      throw Exception('Failed to load data');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Stocks'),
        ),
        body: Text(stocksData));
  }
}