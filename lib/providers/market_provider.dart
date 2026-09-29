import 'dart:collection';

import 'package:flutter/foundation.dart';
import 'package:tanzania_stocks_app/data/dse_companies.dart';
import 'package:tanzania_stocks_app/data/sample_company_quotes.dart';
import 'package:tanzania_stocks_app/data/sample_stocks.dart';
import 'package:tanzania_stocks_app/models/stock_item.dart';

class MarketProvider extends ChangeNotifier {
  MarketProvider() {
    _stocks = _buildStocks();
    _refreshFeaturedStocks();
  }

  late List<StockItem> _stocks;
  late List<StockItem> _featuredStocks;

  UnmodifiableListView<StockItem> get stocks => UnmodifiableListView(_stocks);
  UnmodifiableListView<StockItem> get featuredStocks =>
      UnmodifiableListView(_featuredStocks);

  StockItem? stockForSymbol(String symbol) {
    for (final stock in _stocks) {
      if (stock.symbol == symbol) {
        return stock;
      }
    }
    return null;
  }

  void updateQuote(StockItem updatedStock) {
    final index = _stocks.indexWhere(
      (stock) => stock.symbol == updatedStock.symbol,
    );
    if (index < 0) {
      return;
    }

    _stocks = List.of(_stocks)..[index] = updatedStock;
    _refreshFeaturedStocks();
    notifyListeners();
  }

  void _refreshFeaturedStocks() {
    final bySymbol = {for (final stock in _stocks) stock.symbol: stock};
    _featuredStocks = [
      for (final sample in sampleStocks) ?bySymbol[sample.symbol],
    ];
  }

  static List<StockItem> _buildStocks() {
    final samples = {for (final stock in sampleStocks) stock.symbol: stock};
    final companies = [...dseCompanies]
      ..sort((a, b) {
        final aIndex = sampleStocks.indexWhere(
          (stock) => stock.symbol == a.symbol,
        );
        final bIndex = sampleStocks.indexWhere(
          (stock) => stock.symbol == b.symbol,
        );
        if (aIndex >= 0 || bIndex >= 0) {
          return (aIndex < 0 ? sampleStocks.length : aIndex).compareTo(
            bIndex < 0 ? sampleStocks.length : bIndex,
          );
        }
        return a.symbol.compareTo(b.symbol);
      });

    return companies
        .map((company) {
          final sample = samples[company.symbol];
          if (sample != null) {
            return StockItem(
              symbol: company.symbol,
              displayName: sample.displayName,
              companyName: company.name,
              priceMinor: sample.priceMinor,
              changeBasisPoints: sample.changeBasisPoints,
              logoAsset: company.logoAsset,
            );
          }

          final quote = sampleCompanyQuotes[company.symbol]!;
          return StockItem(
            symbol: company.symbol,
            displayName: company.symbol,
            companyName: company.name,
            priceMinor: quote.priceMinor,
            changeBasisPoints: quote.changeBasisPoints,
            logoAsset: company.logoAsset,
          );
        })
        .toList(growable: false);
  }
}
