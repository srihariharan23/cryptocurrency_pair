import 'dart:convert';

Ticker tickerFromJson(String str) => Ticker.fromJson(json.decode(str));

String tickerToJson(Ticker data) => json.encode(data.toJson());

class Ticker {
  String timestamp;
  String open;
  String high;
  String low;
  String last;
  String volume;
  String vwap;
  String bid;
  String ask;
  String side;
  String open24;
  String percentChange24;

  Ticker({
    required this.timestamp,
    required this.open,
    required this.high,
    required this.low,
    required this.last,
    required this.volume,
    required this.vwap,
    required this.bid,
    required this.ask,
    required this.side,
    required this.open24,
    required this.percentChange24,
  });

  factory Ticker.fromJson(Map<String, dynamic> json) => Ticker(
    timestamp: json["timestamp"],
    open: json["open"],
    high: json["high"],
    low: json["low"],
    last: json["last"],
    volume: json["volume"],
    vwap: json["vwap"],
    bid: json["bid"],
    ask: json["ask"],
    side: json["side"],
    open24: json["open_24"],
    percentChange24: json["percent_change_24"],
  );

  Map<String, dynamic> toJson() => {
    "timestamp": timestamp,
    "open": open,
    "high": high,
    "low": low,
    "last": last,
    "volume": volume,
    "vwap": vwap,
    "bid": bid,
    "ask": ask,
    "side": side,
    "open_24": open24,
    "percent_change_24": percentChange24,
  };
}