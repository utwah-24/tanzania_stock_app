import 'dart:math' as math;

import 'package:tanzania_stocks_app/models/stock_item.dart';

/// Deterministic, invented demo fundamentals; never a live market snapshot.
class ShareProfileData {
  ShareProfileData(this.stock);

  final StockItem stock;
  int get _seed => stock.symbol.codeUnits.fold(0, (sum, unit) => sum + unit);
  int get openingMinor =>
      (stock.priceMinor / (1 + stock.changeBasisPoints / 10000)).round();
  int get changeMinor => stock.priceMinor - openingMinor;
  int get highMinor =>
      (math.max(openingMinor, stock.priceMinor) * 1.015).round();
  int get lowMinor =>
      (math.min(openingMinor, stock.priceMinor) * 0.985).round();
  int get volume => 150000 + _seed * 7919;
  int get bidPriceMinor => (stock.priceMinor * 0.995).round();
  int get offerPriceMinor => (stock.priceMinor * 1.005).round();
  int get bidQuantity => 1200 + _seed * 73;
  int get offerQuantity => 1800 + _seed * 91;
  double get priceEarnings => 8 + (_seed % 120) / 10;
  double get priceBook => 1.2 + (_seed % 30) / 10;
  double get earningsPerShare => stock.priceMinor / 100 / priceEarnings;
  double get bookValue => stock.priceMinor / 100 / priceBook;
  double get returnOnEquity => earningsPerShare / bookValue * 100;
  double get dividendYield => 2 + (_seed % 35) / 10;
  double get dividendPerShare => stock.priceMinor / 100 * dividendYield / 100;
  int get fiscalYear => 2026;
}
