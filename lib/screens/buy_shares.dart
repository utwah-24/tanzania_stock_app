import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart' as shadcn;
import 'package:tanzania_stocks_app/models/stock_item.dart';
import 'package:tanzania_stocks_app/providers/portfolio_provider.dart';
import 'package:tanzania_stocks_app/widgets/company_logo.dart';

String _number(num value, {int decimals = 0}) {
  final parts = value.toStringAsFixed(decimals).split('.');
  final whole = parts.first.replaceAllMapped(
    RegExp(r'\B(?=(\d{3})+(?!\d))'),
    (_) => ',',
  );
  return parts.length == 1 ? whole : '$whole.${parts.last}';
}

String _price(int minor) => 'TZS ${_number(minor / 100, decimals: 2)}';

class BuySharesPage extends StatefulWidget {
  const BuySharesPage({super.key, required this.stock});

  final StockItem stock;

  @override
  State<BuySharesPage> createState() => _BuySharesPageState();
}

class _BuySharesPageState extends State<BuySharesPage> {
  late final TextEditingController _sharesController;

  int get _quantity => int.tryParse(_sharesController.text) ?? 0;
  int get _totalMinor => _quantity * widget.stock.priceMinor;

  @override
  void initState() {
    super.initState();
    _sharesController = TextEditingController();
    _sharesController.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _sharesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = shadcn.Theme.of(context);
    final colors = theme.colorScheme;

    return Scaffold(
      backgroundColor: colors.background,
      appBar: AppBar(
        backgroundColor: colors.background,
        foregroundColor: colors.foreground,
        surfaceTintColor: Colors.transparent,
        centerTitle: true,
        title: Text(
          'Buy shares',
          style: theme.typography.sans.copyWith(
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      bottomNavigationBar: DecoratedBox(
        decoration: BoxDecoration(
          color: colors.background,
          border: Border(top: BorderSide(color: colors.border, width: 0.5)),
        ),
        child: SafeArea(
          top: false,
          minimum: const EdgeInsets.fromLTRB(18, 12, 18, 12),
          child: ConstrainedBox(
            constraints: const BoxConstraints(minHeight: 52),
            child: shadcn.PrimaryButton(
              key: const ValueKey('submit-buy-order-button'),
              alignment: Alignment.center,
              onPressed: _quantity <= 0
                  ? null
                  : () {
                      final result = context
                          .read<PortfolioProvider>()
                          .buyShares(widget.stock, _quantity);
                      final message = switch (result) {
                        TradeResult.success =>
                          'Bought $_quantity ${widget.stock.symbol} shares for ${_price(_totalMinor)}',
                        TradeResult.insufficientFunds =>
                          'Your portfolio balance is too low for this order.',
                        TradeResult.unavailableQuote =>
                          'This share does not have an available price.',
                        TradeResult.invalidQuantity =>
                          'Enter a valid number of shares.',
                        TradeResult.insufficientShares =>
                          'You do not own enough shares.',
                      };
                      ScaffoldMessenger.of(context)
                        ..hideCurrentSnackBar()
                        ..showSnackBar(SnackBar(content: Text(message)));
                    },
              child: const Text('Continue'),
            ),
          ),
        ),
      ),
      body: SafeArea(
        top: false,
        child: DefaultTextStyle(
          style: theme.typography.sans.copyWith(
            color: colors.foreground,
            fontSize: 14,
          ),
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(18, 8, 18, 28),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                shadcn.Card(
                  padding: const EdgeInsets.all(18),
                  borderRadius: BorderRadius.circular(18),
                  child: Column(
                    children: [
                      Container(
                        width: 78,
                        height: 78,
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: widget.stock.logoAsset == null
                              ? colors.muted
                              : Colors.white,
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: colors.border.withValues(alpha: 0.55),
                          ),
                        ),
                        child: CompanyLogo(
                          stock: widget.stock,
                          size: 54,
                          fontSize: 18,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        widget.stock.companyName,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        widget.stock.symbol,
                        textAlign: TextAlign.center,
                        style: TextStyle(color: colors.mutedForeground),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                shadcn.Card(
                  padding: const EdgeInsets.all(18),
                  borderRadius: BorderRadius.circular(18),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      _SummaryRow(
                        label: 'Price per share',
                        value: _price(widget.stock.priceMinor),
                      ),
                      const SizedBox(height: 18),
                      Text(
                        'Number of shares',
                        style: TextStyle(
                          color: colors.mutedForeground,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 10),
                      shadcn.TextField(
                        key: const ValueKey('share-quantity-field'),
                        controller: _sharesController,
                        keyboardType: TextInputType.number,
                        textInputAction: TextInputAction.done,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                        ],
                        placeholder: const Text('Enter shares'),
                      ),
                      const SizedBox(height: 18),
                      Divider(color: colors.border),
                      const SizedBox(height: 18),
                      _SummaryRow(
                        label: 'Total cost',
                        value: _price(_totalMinor),
                        emphasize: true,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _SummaryRow extends StatelessWidget {
  const _SummaryRow({
    required this.label,
    required this.value,
    this.emphasize = false,
  });

  final String label;
  final String value;
  final bool emphasize;

  @override
  Widget build(BuildContext context) {
    final colors = shadcn.Theme.of(context).colorScheme;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Text(
            label,
            style: TextStyle(color: colors.mutedForeground, height: 1.4),
          ),
        ),
        const SizedBox(width: 12),
        Flexible(
          child: Text(
            value,
            textAlign: TextAlign.right,
            style: TextStyle(
              fontSize: emphasize ? 20 : 15,
              fontWeight: emphasize ? FontWeight.w700 : FontWeight.w600,
              height: 1.35,
            ),
          ),
        ),
      ],
    );
  }
}
