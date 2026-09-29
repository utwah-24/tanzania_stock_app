import 'package:tanzania_stocks_app/models/stock_item.dart';

// Illustrative UI values, not current or historical market quotes.
// Always identify these as sample data wherever they are displayed.
const sampleStocks = [
  StockItem(
    symbol: 'CRDB',
    displayName: 'CRDB',
    companyName: 'CRDB Bank',
    priceMinor: 185000,
    changeBasisPoints: 125,
  ),
  StockItem(
    symbol: 'VODA',
    displayName: 'VODACOM',
    companyName: 'Vodacom Tanzania',
    priceMinor: 85000,
    changeBasisPoints: -58,
  ),
  StockItem(
    symbol: 'NMB',
    displayName: 'NMB',
    companyName: 'NMB Bank',
    priceMinor: 720000,
    changeBasisPoints: 210,
  ),
  StockItem(
    symbol: 'AFRIPRISE',
    displayName: 'AFRI',
    companyName: 'Afriprise',
    priceMinor: 45000,
    changeBasisPoints: 0,
  ),
  StockItem(
    symbol: 'TCC',
    displayName: 'TCC',
    companyName: 'Tanzania Cigarette Company',
    priceMinor: 1250000,
    changeBasisPoints: -80,
  ),
  StockItem(
    symbol: 'TBL',
    displayName: 'TBL',
    companyName: 'Tanzania Breweries',
    priceMinor: 850000,
    changeBasisPoints: 60,
  ),
];

String formatStockPrice(StockItem item) {
  if (!item.hasQuote) return '—';
  final minor = item.priceMinor.abs();
  final whole = (minor ~/ 100).toString().replaceAllMapped(
    RegExp(r'\B(?=(\d{3})+(?!\d))'),
    (_) => ',',
  );
  final fraction = (minor % 100).toString().padLeft(2, '0');
  return 'TZS ${item.priceMinor < 0 ? '-' : ''}$whole.$fraction';
}
