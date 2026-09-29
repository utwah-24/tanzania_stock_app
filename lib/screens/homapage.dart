import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart' as shadcn;
import 'package:tanzania_stocks_app/data/sample_stocks.dart';
import 'package:tanzania_stocks_app/providers/market_provider.dart';
import 'package:tanzania_stocks_app/providers/portfolio_provider.dart';
import 'package:tanzania_stocks_app/providers/profile_provider.dart';
import 'package:tanzania_stocks_app/screens/market_watch.dart';
import 'package:tanzania_stocks_app/widgets/holdings_balance_card.dart';
import 'package:tanzania_stocks_app/widgets/latest_news_section.dart';
import 'package:tanzania_stocks_app/widgets/market_movers_section.dart';
import 'package:tanzania_stocks_app/widgets/services_section.dart';
import 'package:tanzania_stocks_app/widgets/stock_market_list.dart';

const _portfolioBlue = Color(0xFF193A56);
const _homeWelcomeHeight = 90.0;
const _portfolioHeight = 150.0;
const _portfolioCornerRadius = 15.0;

String _formatBalance(int balanceMinor) {
  return (balanceMinor ~/ 100).toString().replaceAllMapped(
    RegExp(r'\B(?=(\d{3})+(?!\d))'),
    (_) => ',',
  );
}

class _HomeWelcomeRow extends StatelessWidget {
  const _HomeWelcomeRow();

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      key: const ValueKey('home-welcome-bar'),
      color: Colors.black,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.asset(
                'assets/profile/avatar.jpg',
                height: 48,
                width: 48,
                fit: BoxFit.cover,
                semanticLabel: 'Profile picture',
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Welcome back,',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Consumer<ProfileProvider>(
                    builder: (context, profile, child) => Text(
                      profile.userName,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const shadcn.Icon(Icons.notifications, color: Colors.white),
          ],
        ),
      ),
    );
  }
}

class Homepage extends StatelessWidget {
  const Homepage({super.key});

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: Colors.black,
      child: SafeArea(
        top: true,
        bottom: false,
        child: SingleChildScrollView(
          key: const PageStorageKey('home-scroll'),
          primary: false,
          child: Column(
            children: [
              SizedBox(
                height: _homeWelcomeHeight,
                child: const _HomeWelcomeRow(),
              ),
              ColoredBox(
                color: Colors.black,
                child: Column(
                  children: [
                    SizedBox(
                      height: _portfolioHeight,
                      child: ClipRRect(
                        key: const ValueKey('home-portfolio-surface'),
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(_portfolioCornerRadius),
                          topRight: Radius.circular(_portfolioCornerRadius),
                        ),
                        clipBehavior: Clip.antiAlias,
                        child: ColoredBox(
                          color: _portfolioBlue,
                          child: Consumer<PortfolioProvider>(
                            builder: (context, portfolio, child) =>
                                HoldingsBalanceCard(
                                  balanceLabel:
                                      '${_formatBalance(portfolio.balanceMinor)}/=',
                                  backgroundColor: Colors.transparent,
                                  foregroundColor: Colors.white,
                                  mutedForegroundColor: const Color(0xFFB8C9D8),
                                  balanceVisible: portfolio.balanceVisible,
                                  onToggleVisibility:
                                      portfolio.toggleBalanceVisibility,
                                ),
                          ),
                        ),
                      ),
                    ),
                    ColoredBox(
                      color: _portfolioBlue,
                      child: ClipRRect(
                        key: const ValueKey('home-content-surface-clip'),
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(20),
                          topRight: Radius.circular(20),
                        ),
                        clipBehavior: Clip.antiAlias,
                        child: Container(
                          key: const ValueKey('home-content-surface'),
                          decoration: BoxDecoration(
                            color: shadcn.Theme.of(context)
                                .colorScheme
                                .background,
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(20),
                              topRight: Radius.circular(20),
                            ),
                          ),
                          padding: EdgeInsets.fromLTRB(
                            10,
                            10,
                            10,
                            MediaQuery.paddingOf(context).bottom + 24,
                          ),
                          child: Column(
                            children: [
                              const ServicesSection(),
                              const LatestNewsSection(itemLimit: 1),
                              Consumer<MarketProvider>(
                                builder: (context, market, child) =>
                                    MarketMoversSection(
                                      items: market.featuredStocks,
                                      priceFormatter: formatStockPrice,
                                    ),
                              ),
                              const SizedBox(height: 20),
                              Padding(
                                padding: const EdgeInsets.only(
                                  left: 12,
                                  right: 12,
                                  bottom: 10,
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: Text(
                                        'Recent market activity',
                                        style: shadcn.Theme.of(context)
                                            .typography
                                            .small
                                            .copyWith(
                                              color: shadcn.Theme.of(context)
                                                  .colorScheme
                                                  .mutedForeground,
                                            ),
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    shadcn.TextButton(
                                      onPressed: () => Navigator.of(context)
                                          .push(
                                            MaterialPageRoute<void>(
                                              builder: (context) =>
                                                  const MarketWatchPage(),
                                            ),
                                          ),
                                      density: shadcn.ButtonDensity.compact,
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Text(
                                            'Market watch',
                                            style: shadcn.Theme.of(context)
                                                .typography
                                                .sans
                                                .copyWith(
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.w600,
                                                  color: shadcn.Theme.of(
                                                    context,
                                                  ).colorScheme.foreground,
                                                ),
                                          ),
                                          const SizedBox(width: 6),
                                          Icon(
                                            Icons.north_east,
                                            size: 19,
                                            color: shadcn.Theme.of(context)
                                                .colorScheme
                                                .foreground,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Consumer<MarketProvider>(
                                builder: (context, market, child) =>
                                    StockMarketList(
                                      items: market.featuredStocks,
                                      priceFormatter: formatStockPrice,
                                      onItemTap: (item) {
                                        ScaffoldMessenger.of(context)
                                          ..hideCurrentSnackBar()
                                          ..showSnackBar(
                                            SnackBar(
                                              content: Text(
                                                '${item.displayName} • ${formatStockPrice(item)} • Sample price',
                                              ),
                                            ),
                                          );
                                      },
                                    ),
                              ),
                            ],
                          ),
                        ),
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
  }
}
