import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart' as shadcn;
import 'package:tanzania_stocks_app/models/market_quote.dart';

/// A two-axis market table with a fixed security column and column headings.
class MarketWatchTable extends StatefulWidget {
  const MarketWatchTable({super.key, required this.quotes});

  final List<MarketQuote> quotes;

  @override
  State<MarketWatchTable> createState() => _MarketWatchTableState();
}

class _MarketWatchTableState extends State<MarketWatchTable> {
  final _horizontal = ScrollController();
  final _vertical = ScrollController();

  static const _columns = [
    'Security',
    'Bid Qty',
    'Bid Price',
    'Offer Price',
    'Ask Qty',
    'Last Price',
    'Change',
    'Time',
    'High',
    'Low',
    'Volume',
    'M-cap (B)',
  ];

  @override
  void dispose() {
    _horizontal.dispose();
    _vertical.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = shadcn.Theme.of(context);
    final colors = theme.colorScheme;
    final dark = colors.brightness == Brightness.dark;
    final positive = dark ? const Color(0xFF4ADE80) : const Color(0xFF15803D);
    final negative = dark ? const Color(0xFFF87171) : const Color(0xFFDC2626);
    final scale = MediaQuery.textScalerOf(context).scale(14) / 14;
    final columnScale = math.max(1.0, scale);
    final rowHeight = math.max(64.0, 48 * scale + 16);
    final style = theme.typography.sans.copyWith(
      fontSize: 14,
      color: colors.foreground,
      fontFeatures: const [FontFeature.tabularFigures()],
    );

    shadcn.TableCell cell(
      String value, {
      String? label,
      bool heading = false,
      bool first = false,
      Color? color,
      bool bold = false,
    }) => shadcn.TableCell(
      child: Semantics(
        header: heading,
        label: label,
        excludeSemantics: label != null,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 16),
          child: Align(
            alignment: first ? Alignment.centerLeft : Alignment.centerRight,
            child: Text(
              value,
              maxLines: 1,
              style: style.copyWith(
                color:
                    color ??
                    (heading ? colors.mutedForeground : colors.foreground),
                fontWeight: heading || bold ? FontWeight.w600 : FontWeight.w400,
              ),
            ),
          ),
        ),
      ),
    );

    if (widget.quotes.isEmpty) {
      return const Center(child: Text('No market quotes to display'));
    }

    return Scrollbar(
      controller: _horizontal,
      thumbVisibility: true,
      trackVisibility: true,
      scrollbarOrientation: ScrollbarOrientation.bottom,
      notificationPredicate: (notification) =>
          notification.metrics.axis == Axis.horizontal,
      child: Scrollbar(
        controller: _vertical,
        notificationPredicate: (notification) =>
            notification.metrics.axis == Axis.vertical,
        child: Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: shadcn.Table(
            key: const ValueKey('market-quotes-table'),
            horizontalController: _horizontal,
            verticalController: _vertical,
            frozenCells: const shadcn.FrozenTableData(
              frozenColumns: [shadcn.TableRef(0)],
              frozenRows: [shadcn.TableRef(0)],
            ),
            defaultColumnWidth: shadcn.FixedTableSize(120 * columnScale),
            columnWidths: {
              0: shadcn.FixedTableSize(142 * math.min(columnScale, 1.3)),
              6: shadcn.FixedTableSize(190 * columnScale),
              7: shadcn.FixedTableSize(90 * columnScale),
              11: shadcn.FixedTableSize(150 * columnScale),
            },
            defaultRowHeight: shadcn.FixedTableSize(rowHeight),
            rows: [
              shadcn.TableHeader(
                cells: [
                  for (var i = 0; i < _columns.length; i++)
                    cell(_columns[i], heading: true, first: i == 0),
                ],
              ),
              for (final quote in widget.quotes)
                shadcn.TableRow(
                  cells: [
                    shadcn.TableCell(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 12,
                        ),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Semantics(
                            label:
                                '${quote.stock.symbol}, ${quote.stock.companyName}, equity',
                            excludeSemantics: true,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  quote.stock.symbol,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: style.copyWith(
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                Text(
                                  'EQ',
                                  style: style.copyWith(
                                    fontSize: 10,
                                    color: colors.mutedForeground,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    cell(
                      _quantity(quote.bidQuantity),
                      label:
                          '${quote.stock.symbol}, bid quantity: ${quote.bidQuantity ?? 'unavailable'}',
                    ),
                    cell(
                      _price(quote.bidPriceMinor),
                      color: positive,
                      label:
                          '${quote.stock.symbol}, bid price: ${_price(quote.bidPriceMinor)} TZS',
                    ),
                    cell(
                      _price(quote.offerPriceMinor),
                      color: quote.offerPriceMinor == null
                          ? colors.mutedForeground
                          : negative,
                      label:
                          '${quote.stock.symbol}, offer price: ${quote.offerPriceMinor == null ? 'unavailable' : '${_price(quote.offerPriceMinor)} TZS'}',
                    ),
                    cell(
                      _quantity(quote.askQuantity),
                      label:
                          '${quote.stock.symbol}, ask quantity: ${quote.askQuantity ?? 'unavailable'}',
                    ),
                    cell(
                      _price(quote.stock.priceMinor),
                      bold: true,
                      label:
                          '${quote.stock.symbol}, last price: ${_price(quote.stock.priceMinor)} TZS',
                    ),
                    cell(
                      _change(quote),
                      color: quote.changeMinor > 0
                          ? positive
                          : quote.changeMinor < 0
                          ? negative
                          : colors.mutedForeground,
                      label: '${quote.stock.symbol}, change: ${_change(quote)}',
                    ),
                    cell(
                      quote.time,
                      label: '${quote.stock.symbol}, quote time: ${quote.time}',
                    ),
                    cell(
                      _price(quote.highMinor),
                      label:
                          '${quote.stock.symbol}, high: ${_price(quote.highMinor)} TZS',
                    ),
                    cell(
                      _price(quote.lowMinor),
                      label:
                          '${quote.stock.symbol}, low: ${_price(quote.lowMinor)} TZS',
                    ),
                    cell(
                      _quantity(quote.volume),
                      label: '${quote.stock.symbol}, volume: ${quote.volume}',
                    ),
                    cell(
                      _group(
                        (quote.marketCapTzs / 1000000000).toStringAsFixed(2),
                      ),
                      label:
                          '${quote.stock.symbol}, market capitalization: ${quote.marketCapTzs} TZS',
                    ),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }

  String _price(int? minor) {
    if (minor == null) return '—';
    final whole = _group((minor.abs() ~/ 100).toString());
    final fraction = minor.abs() % 100;
    return '${minor < 0 ? '−' : ''}$whole${fraction == 0 ? '' : '.${fraction.toString().padLeft(2, '0')}'}';
  }

  String _group(String value) {
    final parts = value.split('.');
    parts[0] = parts[0].replaceAllMapped(
      RegExp(r'\B(?=(\d{3})+(?!\d))'),
      (_) => ',',
    );
    return parts.join('.');
  }

  String _quantity(int? quantity) {
    if (quantity == null) return '—';
    if (quantity >= 1000000) {
      return '${(quantity / 1000000).toStringAsFixed(2)}M';
    }
    if (quantity >= 1000) return '${(quantity / 1000).toStringAsFixed(1)}K';
    return quantity.toString();
  }

  String _change(MarketQuote quote) {
    final change = quote.changeMinor;
    final arrow = change > 0
        ? '↑ '
        : change < 0
        ? '↓ '
        : '';
    final percent = quote.previousCloseMinor == 0
        ? '—'
        : '${(change.abs() / quote.previousCloseMinor * 100).toStringAsFixed(2)}%';
    return '$arrow${_price(change.abs())} ($percent)';
  }
}
