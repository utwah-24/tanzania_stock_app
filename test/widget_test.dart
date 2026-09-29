import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart' as shadcn;

import 'package:tanzania_stocks_app/main.dart';

void main() {
  testWidgets('Shares tab opens and Home preserves the hidden balance', (
    tester,
  ) async {
    await tester.binding.setSurfaceSize(const Size(402, 874));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    await tester.pumpWidget(const MyApp());
    await tester.pumpAndSettle();
    await tester.tap(find.byTooltip('Hide balance'));
    await tester.pumpAndSettle();

    await tester.tap(
      find.descendant(
        of: find.byType(shadcn.NavigationBar),
        matching: find.byIcon(shadcn.LucideIcons.trendingUp),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.text('Recent market activity'), findsNothing);
    expect(find.text('Demo prices • TZS'), findsOneWidget);
    expect(find.text('—'), findsNothing);
    expect(find.textContaining('TZS ').evaluate().length, 28);
    expect(
      tester
          .widget<shadcn.NavigationBar>(find.byType(shadcn.NavigationBar))
          .selectedKey,
      const ValueKey(1),
    );
    for (final name in ['CRDB', 'VODACOM', 'NMB', 'AFRI', 'TCC', 'TBL']) {
      expect(find.text(name), findsWidgets);
    }

    await tester.ensureVisible(find.text('YETU'));
    await tester.pumpAndSettle();
    expect(find.text('YETU').hitTestable(), findsOneWidget);
    expect(
      tester.getBottomRight(find.text('YETU')).dy,
      lessThan(tester.getTopLeft(find.byType(shadcn.NavigationBar)).dy),
    );

    await tester.binding.setSurfaceSize(const Size(320, 700));
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
    await tester.binding.setSurfaceSize(const Size(402, 874));
    await tester.pumpAndSettle();
    await tester.tap(find.byIcon(Icons.home_filled));
    await tester.pumpAndSettle();
    expect(find.text('Recent market activity'), findsOneWidget);
    expect(find.text('••••••'), findsOneWidget);
    expect(find.byTooltip('Show balance'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('Home scrolls to the final stock and handles taps', (
    tester,
  ) async {
    await tester.binding.setSurfaceSize(const Size(402, 874));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    await tester.pumpWidget(const MyApp());
    await tester.pumpAndSettle();
    expect(find.text('Total Portfolio'), findsOneWidget);
    // The scroll viewport extends to the screen edge behind the floating bar.
    expect(
      tester.getBottomRight(find.byKey(const PageStorageKey('home-scroll'))).dy,
      closeTo(874, 1),
    );
    expect(find.text('Recent market activity'), findsOneWidget);
    for (final name in ['CRDB', 'VODACOM', 'NMB', 'AFRI', 'TCC', 'TBL']) {
      expect(find.text(name), findsWidgets);
    }
    await tester.ensureVisible(find.text('TBL'));
    await tester.pumpAndSettle();
    expect(
      tester.getBottomRight(find.text('TBL')).dy,
      lessThan(tester.getTopLeft(find.byType(shadcn.NavigationBar)).dy),
    );
    await tester.tap(find.text('TBL'));
    await tester.pumpAndSettle();
    expect(find.text('TBL • TZS 8,500.00 • Sample price'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('Home uses a simple single child scroll view', (tester) async {
    await tester.binding.setSurfaceSize(const Size(402, 874));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    await tester.pumpWidget(const MyApp());
    await tester.pumpAndSettle();

    expect(
      tester.widget<SingleChildScrollView>(
        find.byKey(const PageStorageKey('home-scroll')),
      ),
      isA<SingleChildScrollView>(),
    );
    expect(find.byType(SliverPersistentHeader), findsNothing);
    final contentSurface = tester.widget<Container>(
      find.byKey(const ValueKey('home-content-surface')),
    );
    final contentClip = tester.widget<ClipRRect>(
      find.byKey(const ValueKey('home-content-surface-clip')),
    );
    expect(
      contentClip.borderRadius,
      const BorderRadius.only(
        topLeft: Radius.circular(20),
        topRight: Radius.circular(20),
      ),
    );
    expect(contentClip.clipBehavior, Clip.antiAlias);
    final decoration = contentSurface.decoration! as BoxDecoration;
    expect(
      decoration.borderRadius,
      const BorderRadius.only(
        topLeft: Radius.circular(20),
        topRight: Radius.circular(20),
      ),
    );
    final portfolioSurface = tester.widget<ClipRRect>(
      find.byKey(const ValueKey('home-portfolio-surface')),
    );
    expect(
      portfolioSurface.borderRadius,
      const BorderRadius.only(
        topLeft: Radius.circular(15),
        topRight: Radius.circular(15),
      ),
    );
    expect(portfolioSurface.clipBehavior, Clip.antiAlias);
    expect(find.text('Welcome back,').hitTestable(), findsOneWidget);
    expect(find.text('Total Portfolio').hitTestable(), findsOneWidget);

    await tester.drag(
      find.byKey(const PageStorageKey('home-scroll')),
      const Offset(0, -150),
    );
    await tester.pumpAndSettle();

    expect(find.text('Welcome back,').hitTestable(), findsNothing);
    expect(find.text('Total Portfolio').hitTestable(), findsNothing);
    expect(find.text('Services').hitTestable(), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('Market watch opens all stocks and returns to the home page', (
    tester,
  ) async {
    await tester.binding.setSurfaceSize(const Size(402, 874));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    await tester.pumpWidget(const MyApp());
    await tester.pumpAndSettle();
    await tester.ensureVisible(find.text('Market watch'));
    await tester.tap(find.text('Market watch'));
    await tester.pumpAndSettle();

    expect(find.text('Sample market data • Prices in TZS'), findsOneWidget);
    for (final name in ['CRDB', 'VODA', 'NMB', 'AFRIPRISE', 'TCC', 'TBL']) {
      expect(find.text(name), findsOneWidget);
    }
    expect(find.text('Recent market activity'), findsNothing);
    final tableFinder = find.byKey(const ValueKey('market-quotes-table'));
    final table = tester.widget<shadcn.Table>(tableFinder);
    expect(
      table.horizontalController!.position.maxScrollExtent,
      greaterThan(0),
    );
    await tester.drag(tableFinder, const Offset(-280, 0));
    await tester.pumpAndSettle();
    expect(table.horizontalController!.offset, greaterThan(0));
    table.horizontalController!.jumpTo(
      table.horizontalController!.position.maxScrollExtent,
    );
    await tester.pumpAndSettle();
    expect(find.text('M-cap (B)').hitTestable(), findsOneWidget);
    expect(find.text('CRDB').hitTestable(), findsOneWidget);
    expect(tester.takeException(), isNull);
    await tester.pageBack();
    await tester.pumpAndSettle();
    expect(find.text('Recent market activity'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
