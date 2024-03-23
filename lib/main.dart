import 'package:cryptocurrency_pair/model/currency.dart';
import 'package:cryptocurrency_pair/model/ticker.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'dart:convert';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: MyHomePage(title: 'Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final TextEditingController controller = TextEditingController();
  bool isSuccess = false;
  bool isShow = false;
  String input = " ";
  Ticker? ticker;
  Currency? currency;
  String buttonText = 'VIEW ORDER BOOK';
  String displayText = 'VIEW ORDER BOOK';

  void toggleText() async {
    var url = Uri.parse('https://www.bitstamp.net/api/v2/order_book/$input');
    var response = await http.get(url);
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      currency = Currency.fromJson(data);
      setState(() {
        displayText = displayText == 'VIEW ORDER BOOK'
            ? 'HIDE ORDER BOOK'
            : 'VIEW ORDER BOOK';
        isShow = true;
      });
    } else {
      const Text("Enter a currency pair to load data");
    }
  }

  void fetchData() async {
    input = controller.text;
    var url = Uri.parse('https://www.bitstamp.net/api/v2/ticker/$input');
    var response = await http.get(url);
    if (controller.text.isEmpty) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text("Alert"),
            content: const Text("Please enter Currency pair"),
            actions: <Widget>[
              TextButton(
                child: const Text("OK"),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      ticker = Ticker.fromJson(data);
      setState(() {
        isSuccess = true;
      });
    } else {
      Column(children: [
        const SizedBox(height: 100),
        Icon(Icons.search, size: 150, color: Colors.black.withOpacity(0.3)),
        const Text("Enter a currency pair to load data ")
      ]);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Center(
        child: Column(
          children: <Widget>[
            const SizedBox(height: 50),
            Padding(
                padding: const EdgeInsets.all(10.0),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.grey.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: TextField(
                          controller: controller,
                          decoration: const InputDecoration(
                            hintText: 'Enter currency pair',
                            border: InputBorder.none,
                            contentPadding:
                                EdgeInsets.symmetric(horizontal: 20.0),
                          ),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.search),
                        onPressed: () {
                          fetchData();
                        },
                      ),
                    ],
                  ),
                )),
            isSuccess == true
                ? Column(children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                            padding: const EdgeInsets.all(20),
                            child: Text(
                              input.toUpperCase(),
                              style: const TextStyle(
                                  color: Colors.black, fontSize: 28),
                            )),
                        Padding(
                            padding: const EdgeInsets.all(20),
                            child: Text(
                              "${DateFormat('dd-MMM-yyyy').format(DateTime.fromMillisecondsSinceEpoch(int.parse(ticker!.timestamp) * 1000))},"
                              " ${DateFormat.Hms().format(DateTime.fromMillisecondsSinceEpoch(int.parse(ticker!.timestamp) * 1000))}",
                              style: const TextStyle(
                                  color: Colors.black, fontSize: 12),
                            )),
                      ],
                    ),
                    const Padding(
                        padding: EdgeInsets.fromLTRB(20, 0, 70, 0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("OPEN",
                                style: TextStyle(
                                    color: Colors.black, fontSize: 10),
                                textAlign: TextAlign.start),
                            Text("HIGH",
                                style: TextStyle(
                                    color: Colors.black, fontSize: 10),
                                textAlign: TextAlign.start),
                          ],
                        )),
                    Padding(
                        padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "\$ ${(double.parse(ticker!.open) / 83.59).toStringAsFixed(2)}",
                              textAlign: TextAlign.start,
                              style: const TextStyle(
                                  color: Colors.black, fontSize: 18),
                            ),
                            Text(
                              "\$ ${(double.parse(ticker!.high) / 83.59).toStringAsFixed(2)}",
                              style: const TextStyle(
                                  color: Colors.black, fontSize: 18),
                            ),
                          ],
                        )),
                    const SizedBox(height: 20),
                    const Padding(
                        padding: EdgeInsets.fromLTRB(20, 0, 60, 0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("LOW",
                                style: TextStyle(
                                    color: Colors.black, fontSize: 10),
                                textAlign: TextAlign.start),
                            Text("LAST",
                                style: TextStyle(
                                    color: Colors.black, fontSize: 10),
                                textAlign: TextAlign.start),
                          ],
                        )),
                    Padding(
                        padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "\$ ${(double.parse(ticker!.low) / 83.59).toStringAsFixed(2)}",
                              textAlign: TextAlign.start,
                              style: const TextStyle(
                                  color: Colors.black, fontSize: 18),
                            ),
                            Text(
                              "\$ ${(double.parse(ticker!.last) / 83.59).toStringAsFixed(2)}",
                              style: const TextStyle(
                                  color: Colors.black, fontSize: 18),
                            ),
                          ],
                        )),
                    const SizedBox(height: 20),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Padding(
                            padding: EdgeInsets.fromLTRB(0, 0, 300, 2),
                            child: Text(
                              "VOLUME",
                              style:
                                  TextStyle(color: Colors.black, fontSize: 10),
                            )),
                        Text(
                          ticker!.volume,
                          style: const TextStyle(
                              color: Colors.black, fontSize: 18),
                        )
                      ],
                    ),
                    Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                      Padding(
                          padding: const EdgeInsets.only(right: 20),
                          child: TextButton(
                            onPressed: () {
                              toggleText();
                            },
                            child: Text(
                              displayText,
                              style: const TextStyle(
                                  color: Colors.deepPurpleAccent, fontSize: 15),
                            ),
                          ))
                    ]),
                    isShow && displayText == 'HIDE ORDER BOOK'
                        ? Padding(
                            padding: const EdgeInsets.only(left: 10, right: 10),
                            child: Column(children: [
                              const Padding(
                                  padding:
                                      EdgeInsets.only(right: 220, bottom: 10),
                                  child: Text("ORDER BOOK",
                                      style: TextStyle(
                                          color: Colors.black, fontSize: 18))),
                              Container(
                                width: 550,
                                margin: const EdgeInsets.only(
                                    bottom: 6.0), //Same as `blurRadius` i guess
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5.0),
                                  color: Colors.white,
                                  boxShadow: const [
                                    BoxShadow(
                                      color: Colors.grey,
                                      offset: Offset(0.0, 1.0), //(x,y)
                                      blurRadius: 6.0,
                                    ),
                                  ],
                                ),
                                child: DataTable(
                                  columnSpacing: 15,
                                  dividerThickness: 0,
                                  columns: const [
                                    DataColumn(label: Text('BID\nPRICE')),
                                    DataColumn(label: Text('QTY')),
                                    DataColumn(label: Text('QTY')),
                                    DataColumn(label: Text('ASK\nPRICE')),
                                  ],
                                  rows: [
                                    for (var i = 0; i < 5; i++)
                                      DataRow(cells: [
                                        DataCell(Text((double.parse(
                                                    currency!.bids[i][0]) /
                                                83.59)
                                            .toStringAsFixed(2))),
                                        DataCell(Text(currency!.bids[i][1])),
                                        DataCell(Text(currency!.asks[i][1])),
                                        DataCell(Text((double.parse(
                                                    currency!.asks[i][0]) /
                                                83.59)
                                            .toStringAsFixed(2))),
                                      ]),
                                  ],
                                ),
                              )
                            ]))
                        : const SizedBox()
                  ])
                : Column(children: [
                    const SizedBox(height: 150),
                    Icon(Icons.search,
                        size: 150, color: Colors.black.withOpacity(0.3)),
                    const Text("Enter a currency pair to load data ")
                  ])
          ],
        ),
      ),
      floatingActionButton: isSuccess
          ? FloatingActionButton(
              backgroundColor: Colors.deepPurpleAccent,
              shape: const CircleBorder(),
              onPressed: () {
                fetchData();
              },
              child: const Icon(
                Icons.refresh_outlined,
                color: Colors.white,
              ),
            )
          : const SizedBox(),
    );
  }
}
