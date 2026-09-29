import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart' as shadcn;
import 'package:tanzania_stocks_app/providers/market_provider.dart';
import 'package:tanzania_stocks_app/providers/portfolio_provider.dart';
import 'package:tanzania_stocks_app/providers/profile_provider.dart';
import 'package:tanzania_stocks_app/screens/page_view.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  // Keep the iOS status bar visible while allowing the app surface to extend
  // behind it. Individual screens provide the appropriate icon contrast.
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ProfileProvider()),
        ChangeNotifierProvider(create: (_) => MarketProvider()),
        ChangeNotifierProvider(create: (_) => PortfolioProvider()),
      ],
      child: shadcn.Theme(
        data: const shadcn.ThemeData(),
        child: MaterialApp(
          title: 'Tanzania Stocks',
          debugShowCheckedModeBanner: false,
          localizationsDelegates:
              shadcn.ShadcnLocalizations.localizationsDelegates,
          supportedLocales: shadcn.ShadcnLocalizations.supportedLocales,
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          ),
          home: const PageViewScreen(),
        ),
      ),
    );
  }
}
