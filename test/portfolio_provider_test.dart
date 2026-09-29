import 'package:flutter_test/flutter_test.dart';
import 'package:tanzania_stocks_app/data/sample_stocks.dart';
import 'package:tanzania_stocks_app/providers/portfolio_provider.dart';

void main() {
  group('PortfolioProvider', () {
    test('starts with the demo balance and no holdings', () {
      final portfolio = PortfolioProvider();

      expect(portfolio.balanceMinor, 50000000);
      expect(portfolio.holdings, isEmpty);
    });

    test('updates the balance and holdings after a purchase', () {
      final portfolio = PortfolioProvider();
      final stock = sampleStocks.first;

      final result = portfolio.buyShares(stock, 2);

      expect(result, TradeResult.success);
      expect(portfolio.balanceMinor, 50000000 - (stock.priceMinor * 2));
      expect(portfolio.sharesOwned(stock.symbol), 2);
    });

    test('does not mutate state when funds are insufficient', () {
      final portfolio = PortfolioProvider(initialBalanceMinor: 100);
      final stock = sampleStocks.first;

      final result = portfolio.buyShares(stock, 1);

      expect(result, TradeResult.insufficientFunds);
      expect(portfolio.balanceMinor, 100);
      expect(portfolio.holdings, isEmpty);
    });
  });
}
