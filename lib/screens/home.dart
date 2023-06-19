import 'package:flutter/material.dart';
import 'package:ranro_mob/screens/qr_scanner.dart';

import 'loans_list.dart';

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        /* dark theme settings */
      ),
      themeMode: ThemeMode.dark,
      debugShowCheckedModeBanner: false,
      title: 'Ranro Loan',
      home: Scaffold(
        
        
        appBar: AppBar(
          backgroundColor: Color.fromARGB(255, 9, 73, 183),
          title: const Text(
            'Ranro Loan',
            style: TextStyle(
                color: Color.fromARGB(255, 255, 255, 255),
                fontSize: 24.0,
                fontWeight: FontWeight.bold),
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.home),
              onPressed: () {
                // Navigate to home screen
              },
            ),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 60.0),
              ElevatedButton.icon(
                
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => const QRViewExample(),
                  ));
                },
                
                label: const Text(
                  'Scan',
                  style: TextStyle(fontSize: 30.0),
                ),
                style: ElevatedButton.styleFrom(
                  primary: Color.fromRGBO(25, 26, 25, 1),
                  padding: const EdgeInsets.all(16.0),
                  // Set the height of the button to 60.0
                  fixedSize: const Size(double.infinity, 100.0),
                ), icon: Icon(Icons.search),
              ),
              const SizedBox(height: 40.0),
              ElevatedButton.icon(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const LoansList(),
                    ),
                  );
                },
                label: const Text(
                  'Loans List',
                  style: TextStyle(fontSize: 30.0),
                ),
                style: ElevatedButton.styleFrom(
                  primary: Color.fromRGBO(25, 26, 25, 1),
                  padding: EdgeInsets.all(16.0),
                  // Set the height of the button to 60.0
                  fixedSize: const Size(double.infinity, 100.0),
                ), icon: Icon(Icons.library_books_sharp),
              ),
              const SizedBox(height: 40.0),
              ElevatedButton.icon(
                icon: Icon(Icons.safety_check),
                onPressed: () {},
                label: const Text(
                  'New Loan',
                  style: TextStyle(fontSize: 30.0),
                ),
                style: ElevatedButton.styleFrom(
                  primary: Color.fromARGB(255, 23, 23, 23),
                  padding: EdgeInsets.all(16.0),
                  // Set the height of the button to 60.0
                  fixedSize: const Size(double.infinity, 100.0),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
