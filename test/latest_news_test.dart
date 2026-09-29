import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart' as shadcn;
import 'package:tanzania_stocks_app/main.dart';
import 'package:tanzania_stocks_app/data/latest_news.dart';
import 'package:tanzania_stocks_app/screens/news_detail.dart';
import 'package:tanzania_stocks_app/widgets/latest_news_section.dart';

void main() {
  testWidgets('News sits between services and stocks and View all opens news', (
    tester,
  ) async {
    await tester.binding.setSurfaceSize(const Size(402, 874));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    await tester.pumpWidget(const MyApp());
    await tester.pumpAndSettle();
    expect(find.text(latestNews.first.title), findsOneWidget);
    expect(find.text(latestNews.last.title), findsNothing);
    expect(
      tester.getTopLeft(find.text('Services')).dy,
      lessThan(tester.getTopLeft(find.text('Latest News')).dy),
    );
    expect(
      tester.getTopLeft(find.text('Latest News')).dy,
      lessThan(tester.getTopLeft(find.text('Recent market activity')).dy),
    );
    await tester.ensureVisible(find.text('View all'));
    await tester.tap(find.text('View all'));
    await tester.pumpAndSettle();
    expect(find.byType(LatestNewsPage), findsOneWidget);
    expect(find.text(latestNews.first.title), findsOneWidget);
    expect(find.text(latestNews.last.title), findsOneWidget);
    expect(find.text('Sep 10, 2026 • The Citizen'), findsOneWidget);
    await tester.tap(find.byKey(ValueKey(latestNews.last.url)));
    await tester.pumpAndSettle();
    expect(find.byType(NewsDetailPage), findsOneWidget);
    await tester.tap(find.byKey(const ValueKey('news-detail-back')));
    await tester.pumpAndSettle();
    expect(find.byType(LatestNewsPage), findsOneWidget);
    await tester.pageBack();
    await tester.pumpAndSettle();
    expect(find.text('Recent market activity'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets(
    'News opens in-app, image collapses and expands, Read more opens source',
    (tester) async {
      await tester.binding.setSurfaceSize(const Size(402, 874));
      addTearDown(() => tester.binding.setSurfaceSize(null));
      const channel = MethodChannel('plugins.flutter.io/url_launcher');
      final calls = <MethodCall>[];
      tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(channel, (
        call,
      ) async {
        calls.add(call);
        return true;
      });
      addTearDown(
        () => tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(
          channel,
          null,
        ),
      );
      await tester.pumpWidget(const MyApp());
      await tester.pumpAndSettle();
      await tester.ensureVisible(find.byKey(ValueKey(latestNews.first.url)));
      await tester.tap(find.byKey(ValueKey(latestNews.first.url)));
      await tester.pumpAndSettle();
      expect(find.byType(NewsDetailPage), findsOneWidget);
      expect(calls, isEmpty);
      expect(find.text('By ${latestNews.first.author}'), findsOneWidget);

      final header = find.descendant(
        of: find.byKey(const ValueKey('news-image-header')),
        matching: find.byType(AppBar),
      );
      final scroll = find.byKey(const ValueKey('news-detail-scroll'));
      final expandedHeight = tester.getSize(header).height;
      await tester.drag(scroll, const Offset(0, -420));
      await tester.pumpAndSettle();
      expect(tester.getSize(header).height, lessThan(expandedHeight));
      expect(tester.getSize(header).height, closeTo(kToolbarHeight, 1));
      await tester.drag(scroll, const Offset(0, 700));
      await tester.pumpAndSettle();
      expect(tester.getSize(header).height, closeTo(expandedHeight, 1));

      await tester.scrollUntilVisible(
        find.byKey(const ValueKey('news-read-more')),
        300,
        scrollable: find.descendant(
          of: scroll,
          matching: find.byType(Scrollable),
        ),
      );
      await tester.pumpAndSettle();
      await tester.ensureVisible(find.byKey(const ValueKey('news-read-more')));
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(const ValueKey('news-read-more')));
      await tester.pumpAndSettle();
      expect(calls.single.arguments['url'], latestNews.first.url);
      expect(calls.single.arguments['useSafariVC'], isFalse);
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets('News detail fits narrow screens and reports browser failures', (
    tester,
  ) async {
    await tester.binding.setSurfaceSize(const Size(320, 700));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    const channel = MethodChannel('plugins.flutter.io/url_launcher');
    tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(
      channel,
      (_) async => false,
    );
    addTearDown(
      () => tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(
        channel,
        null,
      ),
    );
    await tester.pumpWidget(
      shadcn.Theme(
        data: const shadcn.ThemeData(),
        child: MaterialApp(
          builder: (context, child) => MediaQuery(
            data: MediaQuery.of(context)
                .copyWith(textScaler: TextScaler.linear(2)),
            child: child!,
          ),
          home: NewsDetailPage(article: latestNews.first),
        ),
      ),
    );
    await tester.pumpAndSettle();
    await tester.scrollUntilVisible(
      find.byKey(const ValueKey('news-read-more')),
      400,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.pumpAndSettle();
    await tester.ensureVisible(find.byKey(const ValueKey('news-read-more')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const ValueKey('news-read-more')));
    await tester.pumpAndSettle();
    expect(
      find.text('Could not open the article. Please try again.'),
      findsOneWidget,
    );
    expect(tester.takeException(), isNull);
  });

  testWidgets('News card fits a narrow screen with large text', (tester) async {
    await tester.binding.setSurfaceSize(const Size(320, 700));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    await tester.pumpWidget(
      MaterialApp(
        home: shadcn.Theme(
          data: const shadcn.ThemeData(),
          child: const MediaQuery(
            data: MediaQueryData(textScaler: TextScaler.linear(2)),
            child: LatestNewsPage(),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.text(latestNews.first.title), findsOneWidget);
    expect(find.text(latestNews.last.title), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
