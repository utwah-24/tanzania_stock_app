import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart' as shadcn;
import 'package:tanzania_stocks_app/widgets/holdings_balance_card.dart';

void main() {
  testWidgets('Eye button hides and restores the balance and spoken amounts', (
    tester,
  ) async {
    final semantics = tester.ensureSemantics();
    await tester.pumpWidget(
      shadcn.Theme(
        data: const shadcn.ThemeData(),
        child: MaterialApp(
          home: Scaffold(body: HoldingsBalanceCard(balanceLabel: '\$10,000')),
        ),
      ),
    );

    expect(find.text('\$10,000'), findsOneWidget);
    await tester.tap(find.byTooltip('Hide balance'));
    await tester.pumpAndSettle();
    expect(find.text('\$10,000'), findsNothing);
    expect(find.text('••••••'), findsOneWidget);
    expect(find.bySemanticsLabel('Balance hidden'), findsOneWidget);

    await tester.tap(find.byTooltip('Show balance'));
    await tester.pumpAndSettle();
    expect(find.text('\$10,000'), findsOneWidget);
    expect(find.text('••••••'), findsNothing);
    expect(tester.takeException(), isNull);
    semantics.dispose();
  });

  testWidgets('Holdings card does not render a chart', (tester) async {
    await tester.binding.setSurfaceSize(const Size(320, 800));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    final semantics = tester.ensureSemantics();
    await tester.pumpWidget(
      shadcn.Theme(
        data: const shadcn.ThemeData(),
        child: MaterialApp(
          home: Scaffold(body: HoldingsBalanceCard(balanceLabel: '\$10,000')),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('\$10,000'), findsOneWidget);
    expect(
      find.bySemanticsLabel('Holdings end at 10,000 dollars'),
      findsNothing,
    );
    expect(tester.takeException(), isNull);
    semantics.dispose();
  });
}
