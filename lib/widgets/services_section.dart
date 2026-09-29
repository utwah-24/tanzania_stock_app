import 'package:flutter/material.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart' as shadcn;

class ServicesSection extends StatelessWidget {
  const ServicesSection({super.key});

  static const _services = [
    (label: 'Guide', image: 'assets/services/guide.png'),
    (label: 'Minor a/c', image: 'assets/services/people.png'),
    (label: 'Statement', image: 'assets/services/statement.png'),
    (label: 'Bonds', image: 'assets/services/bonds.png'),
  ];

  @override
  Widget build(BuildContext context) {
    final theme = shadcn.Theme.of(context);
    return ConstrainedBox(
      constraints: const BoxConstraints(minHeight: 150),
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Services',
              style: theme.typography.sans.copyWith(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: theme.colorScheme.foreground,
              ),
            ),
            const SizedBox(height: 12),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  for (var index = 0; index < _services.length; index++) ...[
                    if (index > 0) const SizedBox(width: 10),
                    shadcn.Card(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 14,
                      ),
                      borderRadius: BorderRadius.circular(10),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Image.asset(
                            _services[index].image,
                            width: 36,
                            height: 36,
                            fit: BoxFit.contain,
                            excludeFromSemantics: true,
                          ),
                          const SizedBox(width: 10),
                          Text(
                            _services[index].label,
                            style: theme.typography.sans.copyWith(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: theme.colorScheme.cardForeground,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
