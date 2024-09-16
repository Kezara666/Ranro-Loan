import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Dropdown Dialog API Example',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Future<List<String>> fetchOptions() async {
    // Perform API call to fetch options
    final response = await http.get(Uri.parse('https://api.example.com/options'));

    if (response.statusCode == 200) {
      // Parse the response body
      final data = jsonDecode(response.body);
      // Extract the options from the data
      final options = List<String>.from(data['options']);
      return options;
    } else {
      throw Exception('Failed to fetch options');
    }
  }

  String ?selectedValue;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Dropdown Dialog API Example'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return Dialog(
                  // Customize your dialog content here
                  child: Container(
                    padding: EdgeInsets.all(16),
                    child: FutureBuilder<List<String>>(
                      future: fetchOptions(),
                      builder: (BuildContext context, AsyncSnapshot<List<String>> snapshot) {
                        if (snapshot.hasData) {
                          return DropdownButton<String>(
                            value: selectedValue,
                            onChanged: (String ?newValue) {
                              setState(() {
                                selectedValue = newValue!;
                              });
                            },
                            items: snapshot.data!.map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                          );
                        } else if (snapshot.hasError) {
                          return Text('Error: ${snapshot.error}');
                        } else {
                          return CircularProgressIndicator();
                        }
                      },
                    ),
                  ),
                );
              },
            );
          },
          child: Text('Show Dialog'),
        ),
      ),
    );
  }
}
