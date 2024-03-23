import 'dart:convert';

Currency currencyFromJson(String str) => Currency.fromJson(json.decode(str));

String currencyToJson(Currency data) => json.encode(data.toJson());

class Currency {
  String timestamp;
  String microtimestamp;
  List<List<String>> bids;
  List<List<String>> asks;

  Currency({
    required this.timestamp,
    required this.microtimestamp,
    required this.bids,
    required this.asks,
  });

  factory Currency.fromJson(Map<String, dynamic> json) => Currency(
    timestamp: json["timestamp"],
    microtimestamp: json["microtimestamp"],
    bids: List<List<String>>.from(json["bids"].map((x) => List<String>.from(x.map((x) => x)))),
    asks: List<List<String>>.from(json["asks"].map((x) => List<String>.from(x.map((x) => x)))),
  );

  Map<String, dynamic> toJson() => {
    "timestamp": timestamp,
    "microtimestamp": microtimestamp,
    "bids": List<dynamic>.from(bids.map((x) => List<dynamic>.from(x.map((x) => x)))),
    "asks": List<dynamic>.from(asks.map((x) => List<dynamic>.from(x.map((x) => x)))),
  };
}