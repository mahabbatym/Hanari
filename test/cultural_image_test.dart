import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hanari/data/culture_content.dart';
import 'package:hanari/widgets/cultural_image.dart';

void main() {
  testWidgets('bundled culture images render at banner width', (tester) async {
    final entries = [...historyEntries, ...traditionEntries, ...foodEntries];

    for (final entry in entries) {
      final assetPath = entry.imageAssetPath;
      expect(assetPath, isNotNull, reason: entry.id);

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CulturalImage(
              assetPath: assetPath,
              imageUrl: entry.imageUrl,
              semanticsLabel: entry.title,
              fallbackIcon: entry.icon,
              width: double.infinity,
              height: 220,
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byType(Image), findsOneWidget, reason: entry.id);
      expect(tester.takeException(), isNull, reason: entry.id);
    }

    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: CulturalImage(
            assetPath: 'assets/culture/language_hangul.png',
            semanticsLabel: 'Hangul, the Korean writing system',
            fallbackIcon: Icons.translate_rounded,
            fit: BoxFit.contain,
            aspectRatio: 2.6,
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.byType(Image), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
