import 'package:flutter/material.dart';

import '../models/culture_section.dart';

const cultureSections = <CultureSection>[
  CultureSection(
    'history',
    'Тарих',
    'Ежелгі дәуірден бүгінге дейін',
    Icons.account_balance_rounded,
  ),
  CultureSection(
    'tradition',
    'Дәстүр',
    'Мерекелер мен күнделікті әдеттер',
    Icons.celebration_rounded,
  ),
  CultureSection(
    'food',
    'Тағам',
    'Корея асханасына шолу',
    Icons.ramen_dining_rounded,
  ),
  CultureSection(
    'language',
    'Тіл негіздері',
    'Хангыль және алғашқы тіркестер',
    Icons.translate_rounded,
  ),
];
