class LanguagePhrase {
  const LanguagePhrase({
    required this.korean,
    required this.romanization,
    required this.meaning,
    required this.note,
  });

  final String korean;
  final String romanization;
  final String meaning;
  final String note;
}

const koreanStarterPhrases = <LanguagePhrase>[
  LanguagePhrase(
    korean: '안녕하세요',
    romanization: 'annyeonghaseyo',
    meaning: 'Сәлеметсіз бе',
    note: 'Күнделікті жағдайда қолданылатын сыпайы амандасу үлгісі.',
  ),
  LanguagePhrase(
    korean: '감사합니다',
    romanization: 'gamsahamnida',
    meaning: 'Рақмет',
    note: 'Алғыс білдірудің сыпайы формасы.',
  ),
  LanguagePhrase(
    korean: '네',
    romanization: 'ne',
    meaning: 'Иә',
    note: 'Сыпайы келісу не оң жауап беру үшін айтылады.',
  ),
  LanguagePhrase(
    korean: '아니요',
    romanization: 'aniyo',
    meaning: 'Жоқ',
    note: 'Сыпайы түрде теріс жауап беру үлгісі.',
  ),
  LanguagePhrase(
    korean: '죄송합니다',
    romanization: 'joesonghamnida',
    meaning: 'Кешіріңіз',
    note: 'Кешірім сұрауға немесе сыпайы түрде назар аудартуға болады.',
  ),
  LanguagePhrase(
    korean: '이름이 뭐예요?',
    romanization: 'ireumi mwoyeyo?',
    meaning: 'Есіміңіз кім?',
    note: 'Сыпайы күнделікті сұрақ. Жақын не ресми емес ортада қолданылады.',
  ),
];
