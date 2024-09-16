import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../screens/home.dart';

class LoanDetails extends StatefulWidget {
  final String id;
  final String totalAmount;
  final String installmentAmount;

  const LoanDetails(this.id, this.totalAmount, this.installmentAmount,
      {Key? key})
      : super(key: key);

  @override
  State<LoanDetails> createState() => _LoanDetailsState();
}

class _LoanDetailsState extends State<LoanDetails> {
  late DateTime _selectedDate; // late initialization
  late TextEditingController _totalAmountController;
  late TextEditingController _installmentAmountController;
  late TextEditingController _remarksController;

  @override
  void initState() {
    super.initState();
    _selectedDate = DateTime.now(); // initialize _selectedDate
    _totalAmountController = TextEditingController(text: widget.totalAmount);
    _installmentAmountController =
        TextEditingController(text: widget.installmentAmount);
    _remarksController = TextEditingController();
  }

  Future<void> _submitPayment() async {
    const url = 'https://ranroloan.realpos.online/api/loans/pay';

    final response = await http.post(
      Uri.parse(url),
      body: {
        'loanID_': widget.id,
        'installment_': _installmentAmountController.text,
        'date_': _selectedDate.toString(),
        'remarks_': _remarksController.text,
      },
    );
    if (response.statusCode == 200) {
      // Show payment successful dialog
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Payment Successful"),
            actions: <Widget>[
              TextButton(
                child: Text("OK"),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
      _remarksController.text = '';
    } else {
      // Show payment unsuccessful dialog
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Payment Unsuccessful"),
            actions: <Widget>[
              TextButton(
                child: Text("OK"),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(242, 247, 242, 1),
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(142, 85, 114, 1),
        shadowColor: const Color.fromARGB(255, 228, 228, 228),
        title: Text(
          "Pay for ${widget.id}",
          style: const TextStyle(
              color: Color.fromARGB(255, 255, 255, 255),
              fontWeight: FontWeight.w900,
              fontSize: 25),
        ),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => Home()),
              );
            },
            icon: const Icon(Icons.home_filled),
            color: const Color.fromARGB(255, 255, 255, 255),
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextFormField(
                readOnly: true,
                controller: _totalAmountController,
                decoration: const InputDecoration(
                  border: UnderlineInputBorder(),
                  labelText: 'Total Amount (Rs.)',
                  labelStyle: TextStyle(fontSize: 20),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: InkWell(
                onTap: () {
                  showDatePicker(
                    context: context,
                    initialDate: _selectedDate,
                    firstDate: DateTime(1900),
                    lastDate: DateTime.now(),
                  ).then((value) {
                    if (value != null) {
                      setState(() {
                        _selectedDate = value;
                      });
                    }
                  });
                },
                child: InputDecorator(
                  decoration: const InputDecoration(
                    border: UnderlineInputBorder(),
                    labelText: 'Date *',
                    labelStyle: TextStyle(fontSize: 20),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        '${_selectedDate.toLocal()}'.split(' ')[0],
                      ),
                      const Icon(Icons.calendar_today),
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextFormField(
                controller: _installmentAmountController,
                decoration: const InputDecoration(
                  border: UnderlineInputBorder(),
                  labelText: 'Installment Amount (Rs.) *',
                  labelStyle: TextStyle(fontSize: 20),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a value';
                  }
                  final numericValue = int.tryParse(value);
                  if (numericValue == null) {
                    return 'Please enter numbers only';
                  }
                  if (numericValue <= 0) {
                    return 'Please enter a value greater than 0';
                  }
                  if (value.length > 6) {
                    return 'Please enter a value with no more than 6 digits';
                  }
                  return null; // return null if the input is valid
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextFormField(
                maxLines: 2,
                controller: _remarksController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Remarks',
                  labelStyle: TextStyle(fontSize: 20),
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text(
                      'Cancel',
                      style: TextStyle(
                        fontSize: 20.0,
                        color: Colors.black54,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      primary: Color.fromRGBO(230, 230, 234, 1),
                      padding: EdgeInsets.all(16.0),
                      // Set the height of the button to 60.0
                      fixedSize: const Size(150.0, 60.0),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: ElevatedButton(
                    onPressed: () {
                      _submitPayment();
                    },
                    child: const Text(
                      'Pay',
                      style: TextStyle(fontSize: 20.0),
                    ),
                    style: ElevatedButton.styleFrom(
                      primary: Color.fromRGBO(42, 183, 202, 1),
                      padding: EdgeInsets.all(16.0),
                      // Set the height of the button to 60.0
                      fixedSize: const Size(150.0, 60.0),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
