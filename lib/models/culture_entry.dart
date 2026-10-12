import 'package:flutter/material.dart';

enum CultureEntryKind { history, tradition, food }

class CultureEntry {
  const CultureEntry({
    required this.id,
    required this.kind,
    required this.title,
    required this.summary,
    required this.paragraphs,
    required this.sourceName,
    required this.sourceUrl,
    required this.icon,
    this.period,
    this.ingredients = const [],
    this.imageAssetPath,
    this.imageUrl,
    this.imageSourceName,
    this.imageSourceUrl,
    this.imageLicense,
    this.imageLicenseUrl,
  });

  final String id;
  final CultureEntryKind kind;
  final String title;
  final String summary;
  final List<String> paragraphs;
  final String? period;
  final List<String> ingredients;
  final String sourceName;
  final String sourceUrl;
  final IconData icon;
  final String? imageAssetPath;
  final String? imageUrl;
  final String? imageSourceName;
  final String? imageSourceUrl;
  final String? imageLicense;
  final String? imageLicenseUrl;
}
