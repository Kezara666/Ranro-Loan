import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../models/Loan.dart';
import 'loan_show.dart';
import 'loan_show_with_qr.dart';
import 'loans_get_by_qr.dart';

class LoansList extends StatefulWidget {
  const LoansList({Key? key}) : super(key: key);

  @override
  State<LoansList> createState() => _LoansListState();
}

class _LoansListState extends State<LoansList> {
  Future<List<Loan>> getLoans() async {
    var url = Uri.parse('https://ranroloan.realpos.online/api/loans');
    late http.Response response;
    List<Loan> loanss = [];

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

          Loan loan =
              Loan(id, fullname, contactNumber, installmentAmount, totalAmount);

          loanss.add(loan);
        }
      } else {
        return Future.error("Error Occured, ${response.statusCode}");
      }
    } catch (e) {
      return Future.error(e.toString());
    }
    return loanss;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(242, 247, 242, 1),
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(142, 85, 114, 1),
        shadowColor: const Color.fromARGB(255, 228, 228, 228),
        title: const Text(
          "Loans List",
          style: TextStyle(
              color: Color.fromARGB(255, 255, 255, 255),
              fontWeight: FontWeight.w900,
              fontSize: 25),
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.home_filled),
            color: const Color.fromARGB(255, 255, 255, 255),
          )
        ],
      ),
      body: FutureBuilder(
        future: getLoans(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator.adaptive(),
            );
          } else {
            if (snapshot.hasError) {
              return Text(snapshot.error.toString());
            } else {
              return ListView.builder(
                itemCount: snapshot.data.length,
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
                            // add spacing between icon and text
                            Text(
                              snapshot.data[index].id,
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
                                    snapshot.data[index].fullname,
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15,
                                    ),
                                  ),
                                  Text(
                                    snapshot.data[index].contactNumber,
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
                                    'Installment: Rs.${snapshot.data[index].installmentAmount}.00',
                                    style: TextStyle(
                                      color: Color.fromRGBO(51, 55, 69, 1),
                                      fontSize: 15,
                                    ),
                                  ),
                                  Text(
                                    'Total: Rs.${snapshot.data[index].totalAmount}.00',
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
                          int due_amount=int.parse(snapshot.data[index].totalAmount)-int.parse(snapshot.data[index].installmentAmount);
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => LoanDetailsQR(
                                snapshot.data[index].id,
                                snapshot.data[index].totalAmount,
                                snapshot.data[index].installmentAmount,
                                due_amount.toString(),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  );
                },
              );
            }
          }
        },
      ),
    );
  }
}
