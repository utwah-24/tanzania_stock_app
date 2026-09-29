import 'package:flutter/foundation.dart';

/// Company identity from the exchange directory, independent of market quotes.
@immutable
class ListedCompany {
  const ListedCompany({
    required this.symbol,
    required this.name,
    this.logoAsset,
  });

  final String symbol;
  final String name;
  final String? logoAsset;
}
