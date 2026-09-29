class StockItem {
  const StockItem({
    required this.symbol,
    required this.displayName,
    required this.companyName,
    required this.priceMinor,
    required this.changeBasisPoints,
    this.logoAsset,
  }) : hasQuote = true;

  const StockItem.unquoted({
    required this.symbol,
    required this.displayName,
    required this.companyName,
    this.logoAsset,
  }) : hasQuote = false,
       priceMinor = 0,
       changeBasisPoints = 0;

  /// False for directory entries without a quote; numeric fields are unused.
  final bool hasQuote;

  /// Exchange symbol, independent of the shorter UI display label.
  final String symbol;
  final String displayName;
  final String companyName;

  /// TZS price in minor units: 100 minor units equal one shilling.
  final int priceMinor;

  /// Percentage change versus the previous close: 125 means +1.25%.
  final int changeBasisPoints;
  final String? logoAsset;
}
