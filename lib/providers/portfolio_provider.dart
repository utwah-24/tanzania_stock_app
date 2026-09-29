import 'dart:collection';

import 'package:flutter/foundation.dart';
import 'package:tanzania_stocks_app/models/stock_item.dart';

enum TradeResult {
  success,
  invalidQuantity,
  unavailableQuote,
  insufficientFunds,
  insufficientShares,
}

class PortfolioProvider extends ChangeNotifier {
  PortfolioProvider({int initialBalanceMinor = 50000000})
    : _balanceMinor = initialBalanceMinor;

  int _balanceMinor;
  bool _balanceVisible = true;
  final Map<String, int> _holdings = {};

  int get balanceMinor => _balanceMinor;
  bool get balanceVisible => _balanceVisible;
  UnmodifiableMapView<String, int> get holdings =>
      UnmodifiableMapView(_holdings);

  int sharesOwned(String symbol) => _holdings[symbol] ?? 0;

  void toggleBalanceVisibility() {
    _balanceVisible = !_balanceVisible;
    notifyListeners();
  }

  TradeResult buyShares(StockItem stock, int quantity) {
    if (quantity <= 0) {
      return TradeResult.invalidQuantity;
    }
    if (!stock.hasQuote) {
      return TradeResult.unavailableQuote;
    }

    final costMinor = stock.priceMinor * quantity;
    if (costMinor > _balanceMinor) {
      return TradeResult.insufficientFunds;
    }

    _balanceMinor -= costMinor;
    _holdings[stock.symbol] = sharesOwned(stock.symbol) + quantity;
    notifyListeners();
    return TradeResult.success;
  }

  TradeResult sellShares(StockItem stock, int quantity) {
    if (quantity <= 0) {
      return TradeResult.invalidQuantity;
    }
    if (!stock.hasQuote) {
      return TradeResult.unavailableQuote;
    }

    final currentQuantity = sharesOwned(stock.symbol);
    if (quantity > currentQuantity) {
      return TradeResult.insufficientShares;
    }

    _balanceMinor += stock.priceMinor * quantity;
    final remainingQuantity = currentQuantity - quantity;
    if (remainingQuantity == 0) {
      _holdings.remove(stock.symbol);
    } else {
      _holdings[stock.symbol] = remainingQuantity;
    }
    notifyListeners();
    return TradeResult.success;
  }
}
