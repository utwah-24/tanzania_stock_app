import 'package:flutter/material.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart' as shadcn;
import 'package:tanzania_stocks_app/models/stock_item.dart';
import 'package:tanzania_stocks_app/widgets/company_logo.dart';

class MarketMoversSection extends StatelessWidget {
  const MarketMoversSection({
    super.key,
    required this.items,
    required this.priceFormatter,
  });

  final List<StockItem> items;
  final String Function(StockItem item) priceFormatter;

  @override
  Widget build(BuildContext context) {
    final quoted = items.where((item) => item.hasQuote).toList();
    if (quoted.isEmpty) return const SizedBox.shrink();

    quoted.sort((a, b) => b.changeBasisPoints.compareTo(a.changeBasisPoints));
    final gainers = quoted.take(2).toList();
    final losers = quoted.reversed.take(2).toList();

    return Padding(
      padding: const EdgeInsets.only(top: 12, bottom: 20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: _MoverCard(
              title: 'Top gainers',
              icon: shadcn.LucideIcons.trendingUp,
              items: gainers,
              priceFormatter: priceFormatter,
              accent: const Color(0xFF15803D),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: _MoverCard(
              title: 'Top losers',
              icon: shadcn.LucideIcons.trendingDown,
              items: losers,
              priceFormatter: priceFormatter,
              accent: const Color(0xFFDC2626),
            ),
          ),
        ],
      ),
    );
  }
}

class _MoverCard extends StatelessWidget {
  const _MoverCard({
    required this.title,
    required this.icon,
    required this.items,
    required this.priceFormatter,
    required this.accent,
  });

  final String title;
  final IconData icon;
  final List<StockItem> items;
  final String Function(StockItem item) priceFormatter;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    final theme = shadcn.Theme.of(context);
    final colors = theme.colorScheme;

    return shadcn.Card(
      padding: const EdgeInsets.all(12),
      borderRadius: BorderRadius.circular(8),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              SizedBox(
                width: 28,
                height: 28,
                child: shadcn.Icon(icon, size: 16, color: accent),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: theme.typography.sans.copyWith(
                    color: colors.foreground,
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          for (final (index, item) in items.indexed) ...[
            if (index > 0) const SizedBox(height: 12),
            _MoverRow(item: item, price: priceFormatter(item), accent: accent),
          ],
        ],
      ),
    );
  }
}

class _MoverRow extends StatelessWidget {
  const _MoverRow({
    required this.item,
    required this.price,
    required this.accent,
  });

  final StockItem item;
  final String price;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    final theme = shadcn.Theme.of(context);
    final colors = theme.colorScheme;
    final change = _formatChange(item.changeBasisPoints);

    return Semantics(
      container: true,
      label:
          '${item.displayName}, $price, $change versus previous close, ${item.companyName}',
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          ExcludeSemantics(
            child: Container(
              width: 34,
              height: 34,
              padding: const EdgeInsets.all(7),
              decoration: BoxDecoration(
                color: colors.muted.withValues(alpha: 0.45),
                borderRadius: BorderRadius.circular(7),
              ),
              child: CompanyLogo(stock: item, size: 20, fontSize: 9),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.displayName,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: theme.typography.sans.copyWith(
                    color: colors.foreground,
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  price,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: theme.typography.sans.copyWith(
                    color: colors.mutedForeground,
                    fontSize: 11,
                    fontFeatures: const [FontFeature.tabularFigures()],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 6),
          Text(
            change,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.right,
            style: theme.typography.sans.copyWith(
              color: accent,
              fontSize: 12,
              fontWeight: FontWeight.w700,
              fontFeatures: const [FontFeature.tabularFigures()],
            ),
          ),
        ],
      ),
    );
  }
}

String _formatChange(int basisPoints) {
  final sign = basisPoints > 0
      ? '+'
      : basisPoints < 0
      ? '-'
      : '';
  return '$sign${(basisPoints.abs() / 100).toStringAsFixed(2)}%';
}
