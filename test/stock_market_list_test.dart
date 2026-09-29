import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart' as shadcn;
import 'package:tanzania_stocks_app/data/sample_stocks.dart';
import 'package:tanzania_stocks_app/models/stock_item.dart';
import 'package:tanzania_stocks_app/widgets/stock_market_list.dart';

Widget harness({
  List<StockItem>? items,
  double scale = 1,
  bool dark = false,
  ValueChanged<StockItem>? onTap,
}) => shadcn.Theme(
  data: shadcn.ThemeData(
    colorScheme: dark
        ? shadcn.ColorSchemes.darkSlate
        : shadcn.ColorSchemes.lightSlate,
  ),
  child: MaterialApp(
    home: Scaffold(
      body: Builder(
        builder: (context) => MediaQuery(
          data: MediaQuery.of(context)
              .copyWith(textScaler: TextScaler.linear(scale)),
          child: SingleChildScrollView(
            child: StockMarketList(
              items: items ?? sampleStocks,
              priceFormatter: formatStockPrice,
              onItemTap: onTap,
            ),
          ),
        ),
      ),
    ),
  ),
);

void main() {
  testWidgets('Long names remain accessible at 320px and double text size', (
    tester,
  ) async {
    await tester.binding.setSurfaceSize(const Size(320, 700));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    final semantics = tester.ensureSemantics();
    const longItem = StockItem(
      symbol: 'LONG',
      displayName:
          'An exceptionally long company name that cannot fit on one line',
      companyName: 'A company with a long registered business name',
      priceMinor: 124000,
      changeBasisPoints: -125,
    );
    for (final dark in [false, true]) {
      await tester.pumpWidget(harness(items: [longItem], dark: dark));
      await tester.pumpAndSettle();
      final normalHeight = tester.getSize(find.byType(StockMarketList)).height;
      await tester.pumpWidget(harness(items: [longItem], scale: 2, dark: dark));
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
      expect(
        tester.getSize(find.byType(StockMarketList)).height,
        greaterThan(normalHeight),
      );
      final node = tester.getSemantics(
        find.bySemanticsLabel(
          '${longItem.displayName}, ${longItem.companyName}, TZS 1,240.00, −1.25% versus previous close',
        ),
      );
      expect(node.getSemanticsData().hasAction(SemanticsAction.tap), isFalse);
    }
    semantics.dispose();
  });

  testWidgets('Interactive rows activate by pointer and keyboard', (
    tester,
  ) async {
    final selected = <String>[];
    await tester.pumpWidget(
      harness(
        items: [sampleStocks.first],
        onTap: (item) => selected.add(item.symbol),
      ),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.text('CRDB'));
    await tester.pumpAndSettle();
    expect(selected, ['CRDB']);
    FocusManager.instance.primaryFocus?.unfocus();
    await tester.pump();
    await tester.sendKeyEvent(LogicalKeyboardKey.tab);
    await tester.pumpAndSettle();
    await tester.sendKeyEvent(LogicalKeyboardKey.enter);
    await tester.pumpAndSettle();
    expect(selected, ['CRDB', 'CRDB']);
    expect(tester.takeException(), isNull);
  });

  testWidgets('Empty data presents the empty state', (tester) async {
    await tester.pumpWidget(harness(items: []));
    expect(find.text('No stocks to display'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
