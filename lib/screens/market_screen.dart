import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart' as shadcn;
import 'package:tanzania_stocks_app/data/sample_stocks.dart';
import 'package:tanzania_stocks_app/providers/market_provider.dart';
import 'package:tanzania_stocks_app/screens/share_profile.dart';
import 'package:tanzania_stocks_app/widgets/stock_market_list.dart';

/// Shares tab content displayed by [PageViewScreen].
class MarketScreen extends StatelessWidget {
  const MarketScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = shadcn.Theme.of(context);

    return SingleChildScrollView(
      key: const PageStorageKey('shares-scroll'),
      primary: false,
      padding: EdgeInsets.fromLTRB(
        10,
        8,
        10,
        MediaQuery.paddingOf(context).bottom + 24,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 0, 12, 16),
            child: Text(
              'Demo prices • TZS',
              style: theme.typography.sans
                  .merge(theme.typography.small)
                  .copyWith(color: theme.colorScheme.mutedForeground),
            ),
          ),
          Consumer<MarketProvider>(
            builder: (context, market, child) => StockMarketList(
              items: market.stocks,
              priceFormatter: formatStockPrice,
              onItemTap: (item) {
                Navigator.of(context).push(
                  MaterialPageRoute<void>(
                    builder: (context) => ShareProfilePage(stock: item),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
