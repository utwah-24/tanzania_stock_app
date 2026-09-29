import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart' as shadcn;
import 'package:tanzania_stocks_app/main.dart';
import 'package:tanzania_stocks_app/data/sample_stocks.dart';
import 'package:tanzania_stocks_app/models/stock_item.dart';
import 'package:tanzania_stocks_app/screens/buy_shares.dart';
import 'package:tanzania_stocks_app/screens/share_profile.dart';
import 'package:tanzania_stocks_app/widgets/stock_market_list.dart';

void main() {
  testWidgets(
    'Every share opens its own profile with matching price and returns',
    (tester) async {
      await tester.binding.setSurfaceSize(const Size(402, 874));
      addTearDown(() => tester.binding.setSurfaceSize(null));
      await tester.pumpWidget(const MyApp());
      await tester.pumpAndSettle();
      await tester.tap(
        find.descendant(
          of: find.byType(shadcn.NavigationBar),
          matching: find.byIcon(shadcn.LucideIcons.trendingUp),
        ),
      );
      await tester.pumpAndSettle();
      final list = tester.widget<StockMarketList>(find.byType(StockMarketList));
      var checkedChartControls = false;
      for (final stock in list.items) {
        final row = find.byKey(ValueKey(stock.symbol));
        await tester.ensureVisible(row);
        await tester.pumpAndSettle();
        await tester.tap(row);
        await tester.pumpAndSettle();
        final page = tester.widget<ShareProfilePage>(
          find.byType(ShareProfilePage),
        );
        expect(page.stock.symbol, stock.symbol);
        expect(find.text(list.priceFormatter(stock)), findsWidgets);
        for (final label in [
          'Opening',
          'High / Low',
          'Volume',
          'Best Bid Price',
          'Best Offer Price',
          'Financial Metrics',
          'EPS',
          'BV',
          'P/E',
          'P/B',
          'ROE',
          'Div Yield',
          'FY 2026',
        ]) {
          expect(find.text(label), findsOneWidget);
        }
        if (!checkedChartControls) {
          expect(find.text('Price movement'), findsOneWidget);
          for (final range in ['1D', '1W', '1M', '1Y', '5Y']) {
            expect(find.byKey(ValueKey('chart-range-$range')), findsOneWidget);
          }
          await tester.tap(find.byKey(const ValueKey('chart-range-1Y')));
          await tester.pumpAndSettle();
          checkedChartControls = true;
        }
        final buy = find.byKey(const ValueKey('buy-share-button'));
        final buyPosition = tester.getTopLeft(buy);
        expect(buy.hitTestable(), findsOneWidget);
        await tester.ensureVisible(find.textContaining('Estimated Dividend:'));
        await tester.pumpAndSettle();
        expect(
          find.textContaining('Estimated Dividend:').hitTestable(),
          findsOneWidget,
        );
        expect(tester.getTopLeft(buy), buyPosition);
        expect(buy.hitTestable(), findsOneWidget);
        await tester.tap(buy);
        await tester.pumpAndSettle();
        expect(find.byType(BuySharesPage), findsOneWidget);
        expect(find.text(stock.companyName), findsWidgets);
        expect(find.text(list.priceFormatter(stock)), findsOneWidget);
        await tester.enterText(
          find.byKey(const ValueKey('share-quantity-field')),
          '3',
        );
        await tester.pumpAndSettle();
        final expectedTotal = StockItem(
          symbol: stock.symbol,
          displayName: stock.displayName,
          companyName: stock.companyName,
          priceMinor: stock.priceMinor * 3,
          changeBasisPoints: stock.changeBasisPoints,
        );
        expect(find.text(list.priceFormatter(expectedTotal)), findsOneWidget);
        await tester.pumpAndSettle();
        expect(tester.takeException(), isNull);
        await tester.pageBack();
        await tester.pumpAndSettle();
        expect(find.byType(ShareProfilePage), findsOneWidget);
        await tester.pageBack();
        await tester.pumpAndSettle();
        expect(find.text('Shares'), findsWidgets);
        expect(row.hitTestable(), findsOneWidget);
      }
    },
  );

  testWidgets('Profile accommodates narrow screens and large text', (
    tester,
  ) async {
    await tester.binding.setSurfaceSize(const Size(320, 700));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    final stock = sampleStocks.first;
    await tester.pumpWidget(
      MaterialApp(
        home: shadcn.Theme(
          data: const shadcn.ThemeData(),
          child: MediaQuery(
            data: const MediaQueryData(
              size: Size(320, 700),
              textScaler: TextScaler.linear(2),
            ),
            child: ShareProfilePage(stock: stock),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
    await tester.ensureVisible(find.textContaining('Estimated Dividend:'));
    await tester.pumpAndSettle();
  });
}
