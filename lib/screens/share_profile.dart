import 'package:flutter/material.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart' as shadcn;
import 'package:tanzania_stocks_app/models/share_profile_data.dart';
import 'package:tanzania_stocks_app/models/stock_item.dart';
import 'package:tanzania_stocks_app/screens/buy_shares.dart';
import 'package:tanzania_stocks_app/widgets/company_logo.dart';

String _number(num value, {int decimals = 0}) {
  final parts = value.toStringAsFixed(decimals).split('.');
  final whole = parts.first.replaceAllMapped(
    RegExp(r'\B(?=(\d{3})+(?!\d))'),
    (_) => ',',
  );
  return parts.length == 1 ? whole : '$whole.${parts.last}';
}

String _price(int minor) => 'TZS ${_number(minor / 100, decimals: 2)}';

class ShareProfilePage extends StatelessWidget {
  const ShareProfilePage({super.key, required this.stock});

  final StockItem stock;

  @override
  Widget build(BuildContext context) {
    final theme = shadcn.Theme.of(context);
    final colors = theme.colorScheme;
    final data = ShareProfileData(stock);
    final dark = colors.brightness == Brightness.dark;
    final green = dark ? const Color(0xFF4ADE80) : const Color(0xFF15803D);
    final red = dark ? const Color(0xFFF87171) : const Color(0xFFDC2626);
    final sign = stock.changeBasisPoints < 0 ? '−' : '+';
    final metrics = [
      (
        label: 'EPS',
        value: '${_number(data.earningsPerShare, decimals: 2)} TZS',
      ),
      (label: 'BV', value: '${_number(data.bookValue, decimals: 2)} TZS'),
      (label: 'P/E', value: '${data.priceEarnings.toStringAsFixed(2)}×'),
      (label: 'P/B', value: '${data.priceBook.toStringAsFixed(2)}×'),
      (label: 'ROE', value: '${data.returnOnEquity.toStringAsFixed(2)}%'),
      (label: 'Div Yield', value: '${data.dividendYield.toStringAsFixed(2)}%'),
    ];

    return Scaffold(
      backgroundColor: colors.background,
      bottomNavigationBar: DecoratedBox(
        decoration: BoxDecoration(
          color: colors.background,
          border: Border(top: BorderSide(color: colors.border, width: 0.5)),
        ),
        child: SafeArea(
          top: false,
          minimum: const EdgeInsets.fromLTRB(18, 12, 18, 12),
          child: ConstrainedBox(
            constraints: const BoxConstraints(minHeight: 52),
            child: shadcn.PrimaryButton(
              key: const ValueKey('buy-share-button'),
              alignment: Alignment.center,
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => BuySharesPage(stock: stock),
                  ),
                );
              },
              child: const Text('Buy'),
            ),
          ),
        ),
      ),
      appBar: AppBar(
        backgroundColor: colors.background,
        foregroundColor: colors.foreground,
        surfaceTintColor: Colors.transparent,
        centerTitle: true,
        title: Text(
          stock.symbol,
          style: theme.typography.sans.copyWith(
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: SafeArea(
        top: false,
        child: DefaultTextStyle(
          style: theme.typography.sans.copyWith(
            color: colors.foreground,
            fontSize: 14,
          ),
          child: SingleChildScrollView(
            key: const PageStorageKey('share-profile-scroll'),
            padding: const EdgeInsets.fromLTRB(18, 0, 18, 28),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  stock.companyName,
                  textAlign: TextAlign.center,
                  style: TextStyle(color: colors.mutedForeground),
                ),
                const SizedBox(height: 28),
                Center(
                  child: Container(
                    width: 90,
                    height: 90,
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: stock.logoAsset == null
                          ? colors.muted
                          : Colors.white,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: colors.border.withValues(alpha: 0.5),
                      ),
                    ),
                    child: CompanyLogo(stock: stock, size: 62, fontSize: 20),
                  ),
                ),
                const SizedBox(height: 22),
                Text(
                  'Market price per share',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 12, color: colors.mutedForeground),
                ),
                const SizedBox(height: 8),
                Text(
                  _price(stock.priceMinor),
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.w600,
                    letterSpacing: -1,
                  ),
                ),
                const SizedBox(height: 8),
                _PriceMovementBars(
                  stock: stock,
                  data: data,
                  positiveColor: green,
                  negativeColor: red,
                  semanticLabel:
                      '$sign${_number(data.changeMinor.abs() / 100, decimals: 2)} ($sign${(stock.changeBasisPoints.abs() / 100).toStringAsFixed(2)}%)',
                ),
                const SizedBox(height: 12),
                Text(
                  'Demo market data',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 12, color: colors.mutedForeground),
                ),
                const SizedBox(height: 28),
                shadcn.Card(
                  padding: const EdgeInsets.all(18),
                  borderRadius: BorderRadius.circular(18),
                  child: Column(
                    children: [
                      _DetailRow(
                        label: 'Opening',
                        value: _price(data.openingMinor),
                      ),
                      const SizedBox(height: 18),
                      _DetailRow(
                        label: 'High / Low',
                        value:
                            '${_number(data.highMinor / 100, decimals: 2)} / ${_number(data.lowMinor / 100, decimals: 2)} TZS',
                      ),
                      const SizedBox(height: 18),
                      _DetailRow(label: 'Volume', value: _number(data.volume)),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                shadcn.Card(
                  padding: const EdgeInsets.all(18),
                  borderRadius: BorderRadius.circular(18),
                  child: Column(
                    children: [
                      _DetailRow(
                        label: 'Best Bid Price',
                        value: _price(data.bidPriceMinor),
                        subtitle: 'Qty: ${_number(data.bidQuantity)}',
                        valueColor: green,
                      ),
                      const SizedBox(height: 24),
                      _DetailRow(
                        label: 'Best Offer Price',
                        value: _price(data.offerPriceMinor),
                        subtitle: 'Qty: ${_number(data.offerQuantity)}',
                        valueColor: red,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                shadcn.Card(
                  padding: const EdgeInsets.all(18),
                  borderRadius: BorderRadius.circular(18),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Wrap(
                        alignment: WrapAlignment.spaceBetween,
                        crossAxisAlignment: WrapCrossAlignment.center,
                        spacing: 12,
                        runSpacing: 8,
                        children: [
                          const Text(
                            'Financial Metrics',
                            style: TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: colors.muted,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              'FY ${data.fiscalYear}',
                              style: const TextStyle(fontSize: 12),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      LayoutBuilder(
                        builder: (context, constraints) {
                          final scale =
                              MediaQuery.textScalerOf(context).scale(14) / 14;
                          final columns = constraints.maxWidth >= 330 * scale
                              ? 3
                              : constraints.maxWidth >= 220 * scale
                              ? 2
                              : 1;
                          final width =
                              (constraints.maxWidth - (columns - 1) * 10) /
                              columns;
                          return Wrap(
                            spacing: 10,
                            runSpacing: 10,
                            children: [
                              for (final metric in metrics)
                                Container(
                                  width: width,
                                  padding: const EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    color: colors.muted.withValues(alpha: 0.55),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        metric.label,
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: colors.mutedForeground,
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      Text(
                                        metric.value,
                                        style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                            ],
                          );
                        },
                      ),
                      const SizedBox(height: 18),
                      Divider(color: colors.border),
                      const SizedBox(height: 12),
                      Text(
                        'Estimated Dividend: TZS ${_number(data.dividendPerShare, decimals: 2)} per share',
                        style: TextStyle(
                          color: green,
                          fontWeight: FontWeight.w500,
                          height: 1.5,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

enum _ChartRange {
  oneDay('1D', 7),
  oneWeek('1W', 7),
  oneMonth('1M', 10),
  oneYear('1Y', 12),
  fiveYears('5Y', 10);

  const _ChartRange(this.label, this.points);
  final String label;
  final int points;
}

class _ChartPoint {
  const _ChartPoint({required this.label, required this.price});

  final String label;
  final double price;
}

class _PriceMovementBars extends StatefulWidget {
  const _PriceMovementBars({
    required this.stock,
    required this.data,
    required this.positiveColor,
    required this.negativeColor,
    required this.semanticLabel,
  });

  final StockItem stock;
  final ShareProfileData data;
  final Color positiveColor;
  final Color negativeColor;
  final String semanticLabel;

  @override
  State<_PriceMovementBars> createState() => _PriceMovementBarsState();
}

class _PriceMovementBarsState extends State<_PriceMovementBars> {
  _ChartRange _selectedRange = _ChartRange.oneMonth;

  List<_ChartPoint> _pointsFor(_ChartRange range) {
    final seed = widget.stock.symbol.codeUnits.fold<int>(
      0,
      (sum, code) => sum + code,
    );
    final open = widget.data.openingMinor / 100;
    final close = widget.stock.priceMinor / 100;
    final change = close - open;
    final labels = switch (range) {
      _ChartRange.oneDay => ['9:30', '10', '11', '12', '1', '2', '3'],
      _ChartRange.oneWeek => ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'],
      _ChartRange.oneMonth => [
        'W1',
        'W2',
        'W3',
        'W4',
        'W5',
        'W6',
        'W7',
        'W8',
        'W9',
        'Now',
      ],
      _ChartRange.oneYear => [
        'Jan',
        'Feb',
        'Mar',
        'Apr',
        'May',
        'Jun',
        'Jul',
        'Aug',
        'Sep',
        'Oct',
        'Nov',
        'Dec',
      ],
      _ChartRange.fiveYears => [
        '2022',
        '2023',
        '2024',
        '2025',
        '2026',
        'Q1',
        'Q2',
        'Q3',
        'Q4',
        'Now',
      ],
    };
    final amplitude = switch (range) {
      _ChartRange.oneDay => 0.012,
      _ChartRange.oneWeek => 0.018,
      _ChartRange.oneMonth => 0.028,
      _ChartRange.oneYear => 0.055,
      _ChartRange.fiveYears => 0.11,
    };

    return List.generate(range.points, (index) {
      final progress = index / (range.points - 1);
      final wave = ((seed + index * 17) % 11 - 5) * amplitude;
      final rhythm = index.isEven ? amplitude * 0.65 : -amplitude * 0.35;
      final price = open + change * progress + close * (wave + rhythm);
      return _ChartPoint(
        label: labels[index],
        price: index == range.points - 1 ? close : price,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final colors = shadcn.Theme.of(context).colorScheme;
    final points = _pointsFor(_selectedRange);
    final first = points.first.price;
    final last = points.last.price;
    final changeColor = last >= first
        ? widget.positiveColor
        : widget.negativeColor;
    final sign = last >= first ? '+' : '−';
    final change = (last - first).abs();
    final percent = first == 0 ? 0.0 : change / first * 100;

    return Semantics(
      label:
          'Animated price bar chart. Time on the x axis and price on the y axis. ${widget.semanticLabel}',
      child: shadcn.Card(
        padding: const EdgeInsets.fromLTRB(14, 14, 14, 12),
        borderRadius: BorderRadius.circular(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Wrap(
              alignment: WrapAlignment.spaceBetween,
              crossAxisAlignment: WrapCrossAlignment.center,
              spacing: 10,
              runSpacing: 8,
              children: [
                Icon(
                  shadcn.LucideIcons.chartColumnIncreasing,
                  size: 18,
                  color: changeColor,
                ),
                Text(
                  'Price movement',
                  style: TextStyle(
                    color: colors.mutedForeground,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  '$sign${_number(change, decimals: 2)} ($sign${percent.toStringAsFixed(2)}%)',
                  style: TextStyle(
                    color: changeColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            SizedBox(
              height: 184,
              child: TweenAnimationBuilder<double>(
                key: ValueKey(_selectedRange),
                tween: Tween(begin: 0, end: 1),
                duration: const Duration(milliseconds: 850),
                curve: Curves.easeOutCubic,
                builder: (context, progress, child) => CustomPaint(
                  painter: _PriceBarChartPainter(
                    points: points,
                    progress: progress,
                    positiveColor: widget.positiveColor,
                    negativeColor: widget.negativeColor,
                    gridColor: colors.border,
                    mutedColor: colors.mutedForeground,
                    foregroundColor: colors.foreground,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10),
            Wrap(
              alignment: WrapAlignment.spaceBetween,
              spacing: 4,
              runSpacing: 6,
              children: [
                for (final range in _ChartRange.values)
                  shadcn.SelectedButton(
                    key: ValueKey('chart-range-${range.label}'),
                    value: _selectedRange == range,
                    onChanged: (_) => setState(() => _selectedRange = range),
                    style: const shadcn.ButtonStyle.ghost(
                      density: shadcn.ButtonDensity.compact,
                    ),
                    selectedStyle: const shadcn.ButtonStyle.secondary(
                      density: shadcn.ButtonDensity.compact,
                    ),
                    child: Text(range.label),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _PriceBarChartPainter extends CustomPainter {
  const _PriceBarChartPainter({
    required this.points,
    required this.progress,
    required this.positiveColor,
    required this.negativeColor,
    required this.gridColor,
    required this.mutedColor,
    required this.foregroundColor,
  });

  final List<_ChartPoint> points;
  final double progress;
  final Color positiveColor;
  final Color negativeColor;
  final Color gridColor;
  final Color mutedColor;
  final Color foregroundColor;

  @override
  void paint(Canvas canvas, Size size) {
    if (points.isEmpty) return;

    final minPrice = points
        .map((point) => point.price)
        .reduce((a, b) => a < b ? a : b);
    final maxPrice = points
        .map((point) => point.price)
        .reduce((a, b) => a > b ? a : b);
    final range = (maxPrice - minPrice).abs() < 0.01
        ? 1.0
        : maxPrice - minPrice;
    final chart = Rect.fromLTWH(0, 12, size.width - 48, size.height - 44);
    final axis = Paint()
      ..color = gridColor.withValues(alpha: 0.65)
      ..strokeWidth = 1;
    final grid = Paint()
      ..color = gridColor.withValues(alpha: 0.42)
      ..strokeWidth = 1;

    for (var tick = 0; tick < 4; tick++) {
      final y = chart.top + chart.height * tick / 3;
      canvas.drawLine(Offset(chart.left, y), Offset(chart.right, y), grid);
      final value = maxPrice - range * tick / 3;
      _drawText(
        canvas,
        _number(value, decimals: 0),
        Offset(chart.right + 8, y - 7),
        mutedColor,
        10,
        TextAlign.left,
      );
    }
    canvas.drawLine(
      Offset(chart.left, chart.bottom),
      Offset(chart.right, chart.bottom),
      axis,
    );
    canvas.drawLine(
      Offset(chart.left, chart.top),
      Offset(chart.left, chart.bottom),
      axis,
    );

    _drawText(
      canvas,
      'Price',
      Offset(chart.left + 2, 0),
      mutedColor,
      10,
      TextAlign.left,
    );
    _drawText(
      canvas,
      'Time',
      Offset(chart.right - 28, chart.bottom + 24),
      mutedColor,
      10,
      TextAlign.left,
    );

    final slot = chart.width / points.length;
    final barWidth = (slot * 0.54).clamp(8.0, 18.0);
    final baseline = chart.bottom;
    for (var index = 0; index < points.length; index++) {
      final point = points[index];
      final normalized = (point.price - minPrice) / range;
      final barHeight = (chart.height * (0.18 + normalized * 0.82)) * progress;
      final centerX = chart.left + slot * index + slot / 2;
      final rect = RRect.fromRectAndRadius(
        Rect.fromLTWH(
          centerX - barWidth / 2,
          baseline - barHeight,
          barWidth,
          barHeight,
        ),
        const Radius.circular(5),
      );
      final previous = index == 0
          ? points.first.price
          : points[index - 1].price;
      final paint = Paint()
        ..color = point.price >= previous ? positiveColor : negativeColor;
      canvas.drawRRect(rect, paint);

      if (index == 0 ||
          index == points.length ~/ 2 ||
          index == points.length - 1) {
        _drawText(
          canvas,
          point.label,
          Offset(centerX, chart.bottom + 8),
          mutedColor,
          10,
          TextAlign.center,
        );
      }
    }

    final last = points.last;
    final lastNormalized = (last.price - minPrice) / range;
    final lastY =
        baseline - chart.height * (0.18 + lastNormalized * 0.82) * progress;
    canvas.drawLine(
      Offset(chart.left, lastY),
      Offset(chart.right, lastY),
      Paint()
        ..color = foregroundColor.withValues(alpha: 0.25)
        ..strokeWidth = 1,
    );
  }

  void _drawText(
    Canvas canvas,
    String text,
    Offset offset,
    Color color,
    double fontSize,
    TextAlign textAlign,
  ) {
    final span = TextSpan(
      text: text,
      style: TextStyle(color: color, fontSize: fontSize),
    );
    final painter = TextPainter(
      text: span,
      textAlign: textAlign,
      textDirection: TextDirection.ltr,
    )..layout(maxWidth: 58);
    final dx = textAlign == TextAlign.center
        ? offset.dx - painter.width / 2
        : offset.dx;
    painter.paint(canvas, Offset(dx, offset.dy));
  }

  @override
  bool shouldRepaint(covariant _PriceBarChartPainter oldDelegate) {
    return oldDelegate.points != points ||
        oldDelegate.progress != progress ||
        oldDelegate.positiveColor != positiveColor ||
        oldDelegate.negativeColor != negativeColor ||
        oldDelegate.gridColor != gridColor ||
        oldDelegate.mutedColor != mutedColor ||
        oldDelegate.foregroundColor != foregroundColor;
  }
}

class _DetailRow extends StatelessWidget {
  const _DetailRow({
    required this.label,
    required this.value,
    this.subtitle,
    this.valueColor,
  });
  final String label;
  final String value;
  final String? subtitle;
  final Color? valueColor;

  @override
  Widget build(BuildContext context) {
    final colors = shadcn.Theme.of(context).colorScheme;
    final labelWidget = Text(
      label,
      style: TextStyle(color: colors.mutedForeground, height: 1.4),
    );
    Widget values(TextAlign align) => Column(
      crossAxisAlignment: align == TextAlign.right
          ? CrossAxisAlignment.end
          : CrossAxisAlignment.start,
      children: [
        Text(
          value,
          textAlign: align,
          style: TextStyle(
            color: valueColor ?? colors.foreground,
            fontWeight: FontWeight.w600,
            height: 1.4,
          ),
        ),
        if (subtitle != null) ...[
          const SizedBox(height: 4),
          Text(
            subtitle!,
            textAlign: align,
            style: TextStyle(fontSize: 12, color: colors.mutedForeground),
          ),
        ],
      ],
    );
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth < 270 ||
            MediaQuery.textScalerOf(context).scale(14) > 20) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              labelWidget,
              const SizedBox(height: 6),
              values(TextAlign.left),
            ],
          );
        }
        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(flex: 4, child: labelWidget),
            const SizedBox(width: 12),
            Expanded(flex: 6, child: values(TextAlign.right)),
          ],
        );
      },
    );
  }
}
