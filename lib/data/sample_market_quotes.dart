import 'package:tanzania_stocks_app/data/sample_stocks.dart';
import 'package:tanzania_stocks_app/models/market_quote.dart';

// Illustrative depth data only. Prices reuse the home page's sample stocks.
// Replace these records with complete quotes when a market feed is connected.
const _depth = {
  'CRDB': (bid: 82000, ask: 99400, volume: 627300, cap: 7587312731363),
  'VODA': (bid: 63, ask: 8700, volume: 631300, cap: 2486848333060),
  'NMB': (bid: 32600, ask: 42700, volume: 5730000, cap: 10575300000000),
  'AFRIPRISE': (bid: 1200, ask: 6200, volume: 224700, cap: 88298549796),
  'TCC': (bid: 1300, ask: 0, volume: 115400, cap: 1325211000000),
  'TBL': (bid: 2400, ask: 3600, volume: 86400, cap: 2500000000000),
};

final sampleMarketQuotes = List<MarketQuote>.unmodifiable(
  sampleStocks.map((stock) {
    final depth = _depth[stock.symbol]!;
    final previousClose =
        (stock.priceMinor / (1 + stock.changeBasisPoints / 10000)).round();
    return MarketQuote(
      stock: stock,
      previousCloseMinor: previousClose,
      bidQuantity: depth.bid,
      bidPriceMinor: stock.priceMinor - 1000,
      offerPriceMinor: depth.ask == 0 ? null : stock.priceMinor + 1000,
      askQuantity: depth.ask == 0 ? null : depth.ask,
      time: '09:30',
      highMinor:
          (stock.priceMinor > previousClose
              ? stock.priceMinor
              : previousClose) +
          1000,
      lowMinor:
          (stock.priceMinor < previousClose
              ? stock.priceMinor
              : previousClose) -
          1000,
      volume: depth.volume,
      marketCapTzs: depth.cap,
    );
  }),
);
