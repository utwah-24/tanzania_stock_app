import 'package:flutter/foundation.dart';
import 'package:tanzania_stocks_app/models/stock_item.dart';

@immutable
class MarketQuote {
  const MarketQuote({
    required this.stock,
    required this.previousCloseMinor,
    required this.bidQuantity,
    required this.bidPriceMinor,
    required this.offerPriceMinor,
    required this.askQuantity,
    required this.time,
    required this.highMinor,
    required this.lowMinor,
    required this.volume,
    required this.marketCapTzs,
  });

  final StockItem stock;
  final int previousCloseMinor;
  final int? bidQuantity;
  final int? bidPriceMinor;
  final int? offerPriceMinor;
  final int? askQuantity;
  final String time;
  final int highMinor;
  final int lowMinor;
  final int volume;
  final int marketCapTzs;

  int get changeMinor => stock.priceMinor - previousCloseMinor;
}
