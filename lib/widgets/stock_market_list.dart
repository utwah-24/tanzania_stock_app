import 'package:flutter/material.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart' as shadcn;
import 'package:tanzania_stocks_app/models/stock_item.dart';
import 'package:tanzania_stocks_app/widgets/company_logo.dart';

const _movementColors = {
  1: (light: Color(0xFF15803D), dark: Color(0xFF4ADE80)),
  -1: (light: Color(0xFFDC2626), dark: Color(0xFFF87171)),
};

String _formatChange(int basisPoints) {
  final sign = basisPoints > 0
      ? '+'
      : basisPoints < 0
      ? '−'
      : '';
  return '$sign${(basisPoints.abs() / 100).toStringAsFixed(2)}%';
}

/// A compact, non-scrolling list. The containing page owns scrolling.
///
/// Supply a price formatter; changes are percentages versus the previous close.
class StockMarketList extends StatelessWidget {
  const StockMarketList({
    super.key,
    required this.items,
    required this.priceFormatter,
    this.onItemTap,
  });

  final List<StockItem> items;
  final String Function(StockItem item) priceFormatter;
  final ValueChanged<StockItem>? onItemTap;

  @override
  Widget build(BuildContext context) {
    final theme = shadcn.Theme.of(context);
    return ColoredBox(
      color: theme.colorScheme.background,
      child: items.isEmpty
          ? Padding(
              padding: const EdgeInsets.all(24),
              child: Text(
                'No stocks to display',
                style: theme.typography.sans
                    .merge(theme.typography.small)
                    .copyWith(color: theme.colorScheme.mutedForeground),
              ),
            )
          : Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                for (var index = 0; index < items.length; index++) ...[
                  if (index > 0)
                    Divider(
                      height: 1,
                      thickness: 0.5,
                      color: theme.colorScheme.border,
                    ),
                  _StockRow(
                    key: ValueKey(items[index].symbol),
                    item: items[index],
                    amount: priceFormatter(items[index]),
                    onTap: onItemTap == null
                        ? null
                        : () => onItemTap!(items[index]),
                  ),
                ],
              ],
            ),
    );
  }
}

class _StockRow extends StatelessWidget {
  const _StockRow({
    super.key,
    required this.item,
    required this.amount,
    this.onTap,
  });

  final StockItem item;
  final String amount;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final theme = shadcn.Theme.of(context);
    final colors = theme.colorScheme;
    final movement = item.hasQuote
        ? _movementColors[item.changeBasisPoints.sign]
        : null;
    final change = item.hasQuote ? _formatChange(item.changeBasisPoints) : '—';
    final changeColor = movement == null
        ? colors.mutedForeground
        : colors.brightness == Brightness.dark
        ? movement.dark
        : movement.light;
    final textStyle = theme.typography.sans.copyWith(
      color: colors.foreground,
      height: 1.3,
    );

    Widget row = ConstrainedBox(
      constraints: const BoxConstraints(minHeight: 80),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
        child: LayoutBuilder(
          builder: (context, constraints) => Row(
            children: [
              ExcludeSemantics(
                child: Container(
                  width: 44,
                  height: 44,
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: colors.muted.withValues(alpha: 0.5),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: CompanyLogo(stock: item, size: 28, fontSize: 11),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.displayName,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: textStyle.copyWith(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      item.companyName,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: textStyle.copyWith(
                        fontSize: 13,
                        color: colors.mutedForeground,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              // A bound leaves room for the name at larger text scales.
              // Extreme amounts may wrap within their own trailing column.
              ConstrainedBox(
                constraints: BoxConstraints(
                  maxWidth: constraints.maxWidth * 0.48,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      amount,
                      textAlign: TextAlign.right,
                      style: textStyle.copyWith(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        fontFeatures: const [FontFeature.tabularFigures()],
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      change,
                      textAlign: TextAlign.right,
                      style: textStyle.copyWith(
                        fontSize: 12,
                        color: changeColor,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );

    if (onTap != null) {
      row = shadcn.Clickable(
        onPressed: onTap,
        decoration: WidgetStateProperty.resolveWith(
          (states) => BoxDecoration(
            color: states.contains(WidgetState.pressed)
                ? colors.muted
                : states.contains(WidgetState.hovered) ||
                      states.contains(WidgetState.focused)
                ? colors.muted.withValues(alpha: 0.5)
                : colors.background,
            borderRadius: BorderRadius.zero,
          ),
        ),
        child: row,
      );
    }

    return Semantics(
      container: true,
      excludeSemantics: true,
      button: onTap == null ? null : true,
      onTap: onTap,
      label:
          '${item.displayName}, ${item.companyName}, '
          '${item.hasQuote ? '$amount, $change versus previous close' : 'Price and change unavailable'}',
      child: row,
    );
  }
}
