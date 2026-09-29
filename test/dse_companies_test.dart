import 'dart:ui' as ui;

import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tanzania_stocks_app/data/dse_companies.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('Directory has unique symbols and every bundled logo decodes', () async {
    expect(dseCompanies.length, 28);
    expect(dseCompanies.map((company) => company.symbol).toSet().length, 28);
    for (final company in dseCompanies) {
      final asset = company.logoAsset;
      if (asset == null) continue;
      final bytes = await rootBundle.load(asset);
      final codec = await ui.instantiateImageCodec(bytes.buffer.asUint8List());
      final frame = await codec.getNextFrame();
      expect(frame.image.width, greaterThan(0), reason: company.symbol);
      frame.image.dispose();
      codec.dispose();
    }
  });
}
