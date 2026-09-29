import 'package:flutter/material.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart' as shadcn;
import 'package:tanzania_stocks_app/data/sample_market_quotes.dart';
import 'package:tanzania_stocks_app/widgets/market_watch_table.dart';

class MarketWatchPage extends StatelessWidget {
  const MarketWatchPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = shadcn.Theme.of(context);
    return Scaffold(
      backgroundColor: theme.colorScheme.background,
      appBar: AppBar(
        title: const Text('Market watch'),
        backgroundColor: theme.colorScheme.background,
        foregroundColor: theme.colorScheme.foreground,
        surfaceTintColor: Colors.transparent,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(10, 8, 10, 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(12, 0, 12, 8),
                child: Text(
                  'Sample market data • Prices in TZS',
                  style: theme.typography.sans
                      .merge(theme.typography.small)
                      .copyWith(color: theme.colorScheme.mutedForeground),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(12, 0, 12, 16),
                child: Text(
                  'Swipe sideways for more columns. M-cap is in TZS billions.',
                  style: theme.typography.sans.copyWith(
                    fontSize: 12,
                    color: theme.colorScheme.mutedForeground,
                  ),
                ),
              ),
              Expanded(child: MarketWatchTable(quotes: sampleMarketQuotes)),
            ],
          ),
        ),
      ),
    );
  }
}
