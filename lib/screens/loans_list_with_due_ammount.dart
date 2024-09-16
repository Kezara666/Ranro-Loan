import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:ranro_mob/models/Loans_with__when_using_qr_due_amount.dart';
import '../models/Loan.dart';
import 'loan_show.dart';
import 'loan_show_with_qr.dart';

class LoandList_due extends StatefulWidget {
  const LoandList_due({Key? key}) : super(key: key);

  @override
  State<LoandList_due> createState() => _LoandList_dueState();
}

class _LoandList_dueState extends State<LoandList_due> {
  List<Loan_QR> allLoans = [];
  List<Loan_QR> filteredLoans = [];

  TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    getLoans();
  }

  Future<void> getLoans() async {
    var url = Uri.parse('https://ranroloan.realpos.online/api/loans');
    late http.Response response;

    try {
      response = await http.get(url);
      if (response.statusCode == 200) {
        List<dynamic> loans = jsonDecode(response.body);

        for (var item in loans) {
          var id = item['id'].toString();
          var fullname = item['fullname'].toString();
          var contactNumber = item['contactNumber'].toString();
          var installmentAmount = item['installment_amount'].toString();
          var totalAmount = item['total_amount'].toString();
          var due_amount = item['due_amount'].toString();

          Loan_QR loan = Loan_QR(
            id,
            fullname,
            contactNumber,
            installmentAmount,
            totalAmount,
            due_amount,
          );

          allLoans.add(loan);
        }

        filteredLoans = allLoans;
      } else {
        throw Exception("Error Occurred, ${response.statusCode}");
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  void filterLoans(String searchQuery) {
    setState(() {
      if (searchQuery.isEmpty) {
        filteredLoans = allLoans;
      } else {
        filteredLoans = allLoans
            .where((loan) =>
                loan.fullname.toLowerCase().startsWith(searchQuery.toLowerCase()))
            .toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(242, 247, 242, 1),
      floatingActionButton: IconButton(
        icon: Icon(Icons.search),
        onPressed: () {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text('Search by Name'),
                content: TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: 'Enter a name',
                  ),
                ),
                actions: [
                  TextButton(
                    onPressed: () {
                      filterLoans(_searchController.text);
                      Navigator.pop(context);
                    },
                    child: Text('Search'),
                  ),
                ],
              );
            },
          );
        },
      ),
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(142, 85, 114, 1),
        shadowColor: const Color.fromARGB(255, 228, 228, 228),
        title: const Text(
          "Loans List",
          style: TextStyle(
            color: Color.fromARGB(255, 255, 255, 255),
            fontWeight: FontWeight.w900,
            fontSize: 25,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.home_filled),
            color: const Color.fromARGB(255, 255, 255, 255),
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: filteredLoans.length,
        itemBuilder: (BuildContext context, int index) {
          return Container(
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  width: 0.2,
                  color: Color.fromARGB(103, 78, 0, 0),
                ),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(5.0),
              child: ListTile(
                title: Row(
                  children: [
                    Icon(Icons.file_copy_outlined, size: 15),
                    SizedBox(width: 8),
                    Text(
                      filteredLoans[index].id,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                  ],
                ),
                subtitle: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Flexible(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 4),
                          Text(
                            filteredLoans[index].fullname,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                            ),
                          ),
                          Text(
                            filteredLoans[index].contactNumber,
                            style: TextStyle(
                              color: Color.fromRGBO(51, 55, 69, 1),
                              fontSize: 15,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            'Due Amount: Rs.${filteredLoans[index].due_amount}.00',
                            style: TextStyle(
                              color: Color.fromRGBO(51, 55, 69, 1),
                              fontSize: 15,
                            ),
                          ),
                          Text(
                            'Installment: Rs.${filteredLoans[index].installmentAmount}.00',
                            style: TextStyle(
                              color: Color.fromRGBO(51, 55, 69, 1),
                              fontSize: 15,
                            ),
                          ),
                          Text(
                            'Total: Rs.${filteredLoans[index].totalAmount}.00',
                            style: TextStyle(
                              color: Color.fromRGBO(51, 55, 69, 1),
                              fontSize: 15,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => LoanDetailsQR(
                        filteredLoans[index].id,
                        filteredLoans[index].totalAmount,
                        filteredLoans[index].installmentAmount,
                        filteredLoans[index].due_amount,
                      ),
                    ),
                  );
                },
              ),
            ),
          );
        },
      ),
    );
  }
}
