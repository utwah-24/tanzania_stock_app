import 'package:flutter/material.dart';
import 'package:tanzania_stocks_app/models/stock_item.dart';

class CompanyLogo extends StatelessWidget {
  const CompanyLogo({
    super.key,
    required this.stock,
    this.size = 44,
    this.fontSize = 18,
  });

  final StockItem stock;
  final double size;
  final double fontSize;

  @override
  Widget build(BuildContext context) {
    final fallback = Center(
      child: Text(
        stock.symbol.characters.first.toUpperCase(),
        maxLines: 1,
        overflow: TextOverflow.fade,
        softWrap: false,
        style: TextStyle(fontSize: fontSize, fontWeight: FontWeight.w600),
      ),
    );

    final asset = stock.logoAsset;
    if (asset == null) {
      return SizedBox.square(dimension: size, child: fallback);
    }

    return Image.asset(
      asset,
      width: size,
      height: size,
      fit: BoxFit.contain,
      excludeFromSemantics: true,
      errorBuilder: (context, error, stackTrace) => fallback,
    );
  }
}
