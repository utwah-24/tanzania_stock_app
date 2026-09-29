import 'package:flutter/material.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart' as shadcn;

/// A balance card styled with the existing shadcn theme.
class HoldingsBalanceCard extends StatefulWidget {
  const HoldingsBalanceCard({
    super.key,
    required this.balanceLabel,
    this.backgroundColor,
    this.foregroundColor,
    this.mutedForegroundColor,
    this.balanceVisible,
    this.onToggleVisibility,
  });

  final String balanceLabel;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final Color? mutedForegroundColor;
  final bool? balanceVisible;
  final VoidCallback? onToggleVisibility;

  @override
  State<HoldingsBalanceCard> createState() => _HoldingsBalanceCardState();
}

class _HoldingsBalanceCardState extends State<HoldingsBalanceCard> {
  bool _balanceVisible = true;
  static const _topCornerRadius = 15.0;

  @override
  Widget build(BuildContext context) {
    final theme = shadcn.Theme.of(context);
    final colors = theme.colorScheme;
    final foregroundColor = widget.foregroundColor ?? colors.foreground;
    final mutedForegroundColor =
        widget.mutedForegroundColor ?? colors.mutedForeground;
    final baseStyle = theme.typography.sans.copyWith(color: foregroundColor);
    final balanceVisible = widget.balanceVisible ?? _balanceVisible;

    return Container(
      constraints: const BoxConstraints(minHeight: 150),
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: widget.backgroundColor ?? colors.background,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(_topCornerRadius),
          topRight: Radius.circular(_topCornerRadius),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Total Portfolio',
                style: baseStyle.copyWith(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(width: 4),
              Tooltip(
                message: balanceVisible ? 'Hide balance' : 'Show balance',
                child: SizedBox(
                  width: 44,
                  height: 44,
                  child: shadcn.IconButton.ghost(
                    onPressed:
                        widget.onToggleVisibility ??
                        () =>
                            setState(() => _balanceVisible = !_balanceVisible),
                    icon: Icon(
                      balanceVisible
                          ? Icons.visibility_outlined
                          : Icons.visibility_off_outlined,
                      size: 19,
                      color: mutedForegroundColor,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            balanceVisible ? widget.balanceLabel : '••••••',
            semanticsLabel: balanceVisible
                ? widget.balanceLabel
                : 'Balance hidden',
            style: baseStyle.copyWith(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              height: 1.15,
              letterSpacing: -1,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'Active CDS 12345',
            style: baseStyle.copyWith(
              fontSize: 12,
              color: mutedForegroundColor,
            ),
          ),
        ],
      ),
    );
  }
}
