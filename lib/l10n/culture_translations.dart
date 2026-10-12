import '../models/culture_entry.dart';

class CultureCopy {
  const CultureCopy({
    required this.title,
    required this.summary,
    required this.paragraphs,
    this.period,
    this.ingredients = const <String>[],
  });

  final String title;
  final String summary;
  final List<String> paragraphs;
  final String? period;
  final List<String> ingredients;
}

const _translations = <String, Map<String, CultureCopy>>{
  'history-gojoseon': {
    'ru': CultureCopy(
      title: 'Древняя Корея',
      period: '2333 год до н. э. · традиционная легендарная дата',
      summary: 'Первые государства Корейского полуострова и их наследие.',
      paragraphs: [
        'В ранней истории Корейского полуострова возникли различные политические союзы и государства. Сведения о Кочосоне частично дошли до нас в более поздних письменных источниках.',
        'История о Тангунe рассказывает о легендарном происхождении Кореи. Эту дату следует воспринимать как традиционную легенду, а не как точно доказанное историческое событие.',
      ],
    ),
    'en': CultureCopy(
      title: 'Early Korea',
      period: '2333 BCE · traditional legendary date',
      summary: 'Early states on the Korean Peninsula and their legacy.',
      paragraphs: [
        'Several political communities and states emerged in the early history of the Korean Peninsula. Some accounts of Gojoseon survive through later written sources.',
        'The story of Dangun is a foundation legend about Korea’s origins. Its traditional date should not be treated as a precisely verified historical event.',
      ],
    ),
    'ko': CultureCopy(
      title: '고대 한국',
      period: '기원전 2333년 · 전승에 따른 전설상의 연도',
      summary: '한반도의 초기 국가와 그 유산을 살펴봅니다.',
      paragraphs: [
        '한반도의 초기 역사에는 여러 정치 공동체와 국가가 등장했습니다. 고조선에 관한 기록 가운데 일부는 후대의 문헌을 통해 전해집니다.',
        '단군 이야기는 한국의 기원을 설명하는 건국 신화입니다. 전승상의 연도를 정확히 입증된 역사적 사건의 날짜로 보아서는 안 됩니다.',
      ],
    ),
  },
  'history-three-kingdoms': {
    'ru': CultureCopy(
      title: 'Три королевства',
      period: 'I век до н. э. – 668 год',
      summary: 'Когурё, Пэкче и Силла повлияли на историю полуострова.',
      paragraphs: [
        'Три крупных древних государства — Когурё, Пэкче и Силла — создали собственные системы управления и культурные традиции. На развитие региона также повлияли их отношения с соседями.',
        'В 668 году Силла в союзе с династией Тан победила Пэкче и Когурё. Позднее на севере полуострова существовало государство Пархэ, поэтому историю этого периода нельзя сводить к одному государству.',
      ],
    ),
    'en': CultureCopy(
      title: 'The Three Kingdoms',
      period: '1st century BCE–668 CE',
      summary: 'Goguryeo, Baekje, and Silla shaped the peninsula’s history.',
      paragraphs: [
        'The three major ancient states—Goguryeo, Baekje, and Silla—developed their own systems of government and cultural traditions. Their relationships with neighboring states also influenced the region.',
        'In 668, Silla allied with Tang China and defeated Baekje and Goguryeo. Balhae later existed in the north, so the history of this period cannot be reduced to a single state.',
      ],
    ),
    'ko': CultureCopy(
      title: '삼국 시대',
      period: '기원전 1세기–서기 668년',
      summary: '고구려, 백제, 신라가 한반도의 역사에 영향을 주었습니다.',
      paragraphs: [
        '고구려, 백제, 신라 세 나라는 각자의 통치 체계와 문화 전통을 발전시켰습니다. 주변 국가와의 관계도 이 지역의 역사에 영향을 주었습니다.',
        '668년 신라는 당과 연합해 백제와 고구려를 무너뜨렸습니다. 이후 한반도 북쪽에는 발해가 세워졌으므로 이 시기의 역사를 한 나라만으로 설명할 수는 없습니다.',
      ],
    ),
  },
  'history-goryeo': {
    'ru': CultureCopy(
      title: 'Корё',
      period: '918–1392',
      summary: 'Династия Корё объединила государство и развивала искусство и образование.',
      paragraphs: [
        'Государство Корё было основано в 918 году и существовало до 1392 года. Международное название «Корея» связано с названием этой династии.',
        'В этот период развивались буддийская культура, печать металлическими литерами и селадоновая керамика. Общество Корё также переживало политические и внешние перемены.',
      ],
    ),
    'en': CultureCopy(
      title: 'Goryeo',
      period: '918–1392',
      summary: 'Goryeo reunified the state and supported art and learning.',
      paragraphs: [
        'The Goryeo state was founded in 918 and lasted until 1392. The international name “Korea” is connected to the name of this dynasty.',
        'Buddhist culture, metal movable-type printing, and celadon ceramics developed during this period. Goryeo society also experienced political and external change.',
      ],
    ),
    'ko': CultureCopy(
      title: '고려',
      period: '918–1392년',
      summary: '고려는 나라를 다시 통합하고 예술과 학문을 발전시켰습니다.',
      paragraphs: [
        '고려는 918년에 세워져 1392년까지 이어졌습니다. 영어권에서 쓰이는 “Korea”라는 이름은 고려의 국명에서 비롯되었습니다.',
        '이 시기에는 불교문화, 금속활자 인쇄, 청자 제작이 발전했습니다. 고려 사회는 정치적 변화와 대외 관계의 변화도 겪었습니다.',
      ],
    ),
  },
  'history-joseon': {
    'ru': CultureCopy(
      title: 'Чосон',
      period: '1392–1897',
      summary: 'В эпоху Чосон появился хангыль и укрепилась государственная система.',
      paragraphs: [
        'Династия Чосон была основана в 1392 году. Конфуцианские принципы управления влияли на государственную жизнь, а образование и экзамены занимали важное место.',
        'В XV веке при короле Седжоне был создан алфавит хангыль. В 1897 году государство стало Корейской империей, и период Чосон завершился.',
      ],
    ),
    'en': CultureCopy(
      title: 'Joseon',
      period: '1392–1897',
      summary:
          'Hangul was created and state institutions developed under Joseon.',
      paragraphs: [
        'The Joseon dynasty was founded in 1392. Confucian principles shaped government, while education and civil service examinations held an important place.',
        'The Hangul alphabet was created in the 15th century under King Sejong. In 1897, the state became the Korean Empire, bringing the Joseon period to an end.',
      ],
    ),
    'ko': CultureCopy(
      title: '조선',
      period: '1392–1897년',
      summary: '조선 시대에는 한글이 만들어지고 국가 제도가 자리 잡았습니다.',
      paragraphs: [
        '조선은 1392년에 세워졌습니다. 유교적 통치 원리가 국가 운영에 영향을 주었고, 교육과 과거 시험이 중요한 역할을 했습니다.',
        '15세기 세종대왕 때 한글이 만들어졌습니다. 1897년 대한제국이 선포되면서 조선 시대가 끝났습니다.',
      ],
    ),
  },
  'history-modern': {
    'ru': CultureCopy(
      title: 'Современная Южная Корея',
      period: 'С 1945 года',
      summary:
          'После войны была создана Республика Корея, и общество изменилось.',
      paragraphs: [
        'После окончания Второй мировой войны в 1945 году Корейский полуостров оказался разделён на две зоны управления. В 1948 году на юге была создана Республика Корея.',
        'После войны экономика и города страны быстро менялись. Современная Южная Корея сохраняет традиционное наследие и известна технологиями, кино, музыкой и дизайном.',
      ],
    ),
    'en': CultureCopy(
      title: 'Modern South Korea',
      period: '1945 to the present',
      summary: 'The Republic of Korea was founded after the war, and society changed.',
      paragraphs: [
        'After World War II ended in 1945, the Korean Peninsula was divided into two administrative zones. The Republic of Korea was established in the south in 1948.',
        'The country’s economy and cities changed rapidly after the war. Modern South Korea preserves its heritage and is also known for technology, film, music, and design.',
      ],
    ),
    'ko': CultureCopy(
      title: '현대 대한민국',
      period: '1945년부터 현재까지',
      summary: '전쟁 이후 대한민국이 세워지고 사회가 변화했습니다.',
      paragraphs: [
        '1945년 제2차 세계대전이 끝난 뒤 한반도는 두 개의 군정 구역으로 나뉘었습니다. 1948년 남쪽에 대한민국이 수립되었습니다.',
        '전쟁 이후 경제와 도시가 빠르게 변했습니다. 오늘날의 대한민국은 전통 유산을 지키는 동시에 기술, 영화, 음악, 디자인 분야에서도 널리 알려져 있습니다.',
      ],
    ),
  },
  'tradition-hanbok': {
    'ru': CultureCopy(
      title: 'Ханбок',
      summary: 'Форма традиционной одежды и случаи, когда её надевают.',
      paragraphs: [
        'Основные части ханбока — верхняя одежда чогори, а также чхима для женщин или паджи для мужчин. В качестве верхней одежды могут носить турумаги.',
        'Сегодня ханбок надевают на праздники, свадьбы, первый день рождения ребёнка и обряды почитания предков. Фасон и ткань менялись в зависимости от региона, эпохи и повода.',
      ],
    ),
    'en': CultureCopy(
      title: 'Hanbok',
      summary: 'The shape of traditional Korean clothing and when it is worn.',
      paragraphs: [
        'Key parts of hanbok include the jeogori jacket, and either a chima skirt for women or baji trousers for men. A durumagi coat may be worn as an outer layer.',
        'Today, people may wear hanbok for holidays, weddings, a child’s first birthday, and ancestral rites. Its cut and fabric have varied by region, period, and occasion.',
      ],
    ),
    'ko': CultureCopy(
      title: '한복',
      summary: '전통 의복의 형태와 한복을 입는 경우를 알아봅니다.',
      paragraphs: [
        '한복의 주요 부분에는 저고리가 있으며, 여성은 치마를 입고 남성은 바지를 입습니다. 겉옷으로 두루마기를 걸칠 수도 있습니다.',
        '오늘날에는 명절, 결혼식, 아기의 첫돌, 조상을 기리는 의례에 한복을 입기도 합니다. 모양과 소재는 지역과 시대, 입는 목적에 따라 달라져 왔습니다.',
      ],
    ),
  },
  'tradition-seollal': {
    'ru': CultureCopy(
      title: 'Соллаль',
      summary: 'Встреча лунного Нового года в кругу семьи.',
      paragraphs: [
        'Соллаль — первый день нового года по лунному календарю. Многие навещают родные места и проводят время вместе с семьёй.',
        'Некоторые семьи проводят обряд чхаре, кланяются старшим в обряде сэбэ и едят суп ттоккук. Обычаи различаются в зависимости от семьи и региона.',
      ],
    ),
    'en': CultureCopy(
      title: 'Seollal',
      summary: 'A lunar New Year holiday often spent with family.',
      paragraphs: [
        'Seollal is the first day of the lunar calendar’s new year. Many people travel to their hometowns and spend time with family.',
        'Some families hold a charye ceremony, bow to elders in a sebae greeting, and eat tteokguk soup. Customs vary between families and regions.',
      ],
    ),
    'ko': CultureCopy(
      title: '설날',
      summary: '가족과 함께 음력 새해를 맞이하는 명절입니다.',
      paragraphs: [
        '설날은 음력 새해의 첫날입니다. 많은 사람이 고향을 찾아 가족과 함께 시간을 보냅니다.',
        '일부 가정에서는 차례를 지내고, 세배로 어른께 인사하며, 떡국을 먹습니다. 풍습은 가족과 지역에 따라 다를 수 있습니다.',
      ],
    ),
  },
  'tradition-chuseok': {
    'ru': CultureCopy(
      title: 'Чхусок',
      summary: 'Осенний праздник урожая и семейных встреч.',
      paragraphs: [
        'Чхусок отмечают в пятнадцатый день восьмого месяца лунного календаря; праздник связан с осенним урожаем. В эти дни многие семьи собираются вместе.',
        'Некоторые семьи проводят чхаре, посещают могилы предков и готовят рисовые пирожки сонпхён. Традиции различаются между семьями и регионами.',
      ],
    ),
    'en': CultureCopy(
      title: 'Chuseok',
      summary: 'An autumn harvest holiday and time for family gatherings.',
      paragraphs: [
        'Chuseok falls on the fifteenth day of the eighth lunar month and is associated with the autumn harvest. Many families gather during the holiday.',
        'Some families hold charye, visit ancestral graves, and prepare songpyeon rice cakes. Specific customs vary by family and region.',
      ],
    ),
    'ko': CultureCopy(
      title: '추석',
      summary: '가을 수확과 가족 모임을 기념하는 명절입니다.',
      paragraphs: [
        '추석은 음력 8월 15일로, 가을 수확과 관련된 명절입니다. 이 시기에는 많은 가족이 한자리에 모입니다.',
        '일부 가정에서는 차례를 지내고 성묘를 하며 송편을 빚습니다. 구체적인 풍습은 가족과 지역에 따라 다릅니다.',
      ],
    ),
  },
  'tradition-greeting': {
    'ru': CultureCopy(
      title: 'Приветствие и уважение',
      summary: 'Слова, интонация и жесты зависят от ситуации.',
      paragraphs: [
        'В корейском языке важны уровни вежливости. С незнакомцами, старшими или в официальной ситуации обычно выбирают вежливые формы речи.',
        'При приветствии часто слегка кланяются; глубина поклона зависит от ситуации. Уважение к старшим широко распространено, но привычки людей нельзя обобщать.',
      ],
    ),
    'en': CultureCopy(
      title: 'Greetings and respect',
      summary: 'Words, tone, and gestures change with the situation.',
      paragraphs: [
        'Levels of politeness matter in Korean. Polite forms are generally appropriate with strangers, older people, or in formal situations.',
        'A slight bow is often used when greeting someone, and its depth depends on the context. Respect for elders is a common cultural value, but individual habits vary.',
      ],
    ),
    'ko': CultureCopy(
      title: '인사와 예절',
      summary: '말과 말투, 몸짓은 상황에 따라 달라집니다.',
      paragraphs: [
        '한국어에서는 높임말과 말투가 중요합니다. 낯선 사람이나 어른, 공식적인 자리에서는 정중한 표현을 주로 사용합니다.',
        '인사할 때 가볍게 고개를 숙이기도 하며, 인사의 정도는 상황에 따라 달라집니다. 어른을 공경하는 문화가 널리 알려져 있지만 사람마다 습관은 다를 수 있습니다.',
      ],
    ),
  },
  'tradition-wedding': {
    'ru': CultureCopy(
      title: 'Свадебные обычаи',
      summary: 'Традиционные обряды могут быть частью современной свадьбы.',
      paragraphs: [
        'Некоторые корейские пары проводят пхебэк после современной свадебной церемонии или включают его в праздник. Во время обряда супруги выражают уважение родителям.',
        'В пхебэк могут входить символические действия, например бросание орехов и фиников. Этот обряд проводят не все пары; формат свадьбы зависит от семьи и личного выбора.',
      ],
    ),
    'en': CultureCopy(
      title: 'Wedding customs',
      summary: 'Traditional rites may be included in a modern wedding.',
      paragraphs: [
        'Some Korean couples hold a pyebaek ceremony after or as part of a modern wedding. During the ceremony, the couple show respect to their parents.',
        'Pyebaek may include symbolic gestures such as tossing chestnuts and jujubes. Not every couple holds the ceremony; wedding customs depend on family and personal choice.',
      ],
    ),
    'ko': CultureCopy(
      title: '혼례 풍습',
      summary: '현대 결혼식에 전통 의례를 더하기도 합니다.',
      paragraphs: [
        '일부 한국인 부부는 현대식 결혼식 뒤에 또는 결혼식의 일부로 폐백을 합니다. 이 의식에서 부부는 부모님께 인사를 드리고 존경을 표합니다.',
        '폐백에는 밤과 대추를 던지는 등의 상징적인 행동이 포함되기도 합니다. 모든 부부가 폐백을 하는 것은 아니며, 결혼식 방식은 가족과 개인의 선택에 따라 달라집니다.',
      ],
    ),
  },
  'food-kimchi': {
    'ru': CultureCopy(
      title: 'Кимчхи',
      summary: 'Общее название ферментированных овощных блюд.',
      paragraphs: [
        'Кимчхи обычно готовят из пекинской капусты или редьки. В приправы могут входить чеснок, красный перец, имбирь, а в некоторых рецептах — ферментированные морепродукты.',
        'Существуют сотни региональных и сезонных видов кимчхи. Кимджан — традиция совместно готовить и делиться кимчхи на зиму; в 2013 году она была включена ЮНЕСКО в список нематериального культурного наследия.',
      ],
      ingredients: ['Овощи', 'Соль', 'Приправы'],
    ),
    'en': CultureCopy(
      title: 'Kimchi',
      summary: 'A broad name for fermented vegetable dishes.',
      paragraphs: [
        'Kimchi is often made with napa cabbage or radish. Seasonings may include garlic, red pepper, and ginger; some recipes also use fermented seafood.',
        'There are hundreds of regional and seasonal varieties. Kimjang is the tradition of preparing and sharing kimchi for winter; UNESCO added it to its intangible cultural heritage list in 2013.',
      ],
      ingredients: ['Vegetables', 'Salt', 'Seasonings'],
    ),
    'ko': CultureCopy(
      title: '김치',
      summary: '절인 채소를 발효해 만드는 음식의 여러 종류를 가리킵니다.',
      paragraphs: [
        '김치는 주로 배추나 무로 만듭니다. 양념에는 마늘, 고춧가루, 생강이 들어갈 수 있으며, 일부 조리법에는 젓갈을 넣기도 합니다.',
        '김치에는 지역과 계절에 따른 다양한 종류가 있습니다. 김장은 겨울을 앞두고 김치를 담가 나누는 풍습이며, 2013년 유네스코 인류무형문화유산에 등재되었습니다.',
      ],
      ingredients: ['채소', '소금', '양념'],
    ),
  },
  'food-bibimbap': {
    'ru': CultureCopy(
      title: 'Пибимпап',
      summary:
          'Рис с овощами и другими добавками, которые перемешивают перед едой.',
      paragraphs: [
        'Основа пибимпапа — рис. Сверху выкладывают овощные гарниры, яйцо и, по желанию, мясо; часто подают соус кочхуджан.',
        'Состав зависит от рецепта. Перед едой ингредиенты в миске перемешивают.',
      ],
      ingredients: ['Рис', 'Овощи', 'Яйцо', 'Кочхуджан'],
    ),
    'en': CultureCopy(
      title: 'Bibimbap',
      summary: 'Rice topped with vegetables and other ingredients, mixed before eating.',
      paragraphs: [
        'Rice is the base of bibimbap. It is topped with vegetable side dishes, egg, and optionally meat; gochujang sauce is often served with it.',
        'The toppings vary by recipe. The ingredients are mixed together in the bowl before eating.',
      ],
      ingredients: ['Rice', 'Vegetables', 'Egg', 'Gochujang'],
    ),
    'ko': CultureCopy(
      title: '비빔밥',
      summary: '밥 위에 채소와 여러 재료를 올려 먹기 전에 비벼 먹는 음식입니다.',
      paragraphs: [
        '비빔밥의 기본은 밥입니다. 그 위에 나물과 달걀을 올리고, 취향에 따라 고기를 더합니다. 고추장을 곁들이는 경우가 많습니다.',
        '재료는 조리법에 따라 달라집니다. 먹기 전에 그릇 안의 재료를 함께 비빕니다.',
      ],
      ingredients: ['밥', '채소', '달걀', '고추장'],
    ),
  },
  'food-tteokbokki': {
    'ru': CultureCopy(
      title: 'Ттокпокки',
      summary: 'Рисовые клецки, тушённые в соусе.',
      paragraphs: [
        'Главный ингредиент ттокпокки — цилиндрические рисовые клецки тток. В популярном красном соусе есть кочхуджан; в некоторые варианты добавляют бульон, рыбные пирожки и зелёный лук.',
        'Острота и добавки различаются по рецепту. В современных кафе также встречаются неострые варианты и версии с сыром.',
      ],
      ingredients: ['Рисовые клецки', 'Соус кочхуджан', 'Зелёный лук'],
    ),
    'en': CultureCopy(
      title: 'Tteokbokki',
      summary: 'Rice cakes simmered in a seasoned sauce.',
      paragraphs: [
        'The main ingredient in tteokbokki is cylindrical rice cake called tteok. A popular red sauce contains gochujang; some versions add broth, fish cake, and green onion.',
        'The spice level and additions vary by recipe. Modern eateries also offer mild versions and variations with cheese.',
      ],
      ingredients: ['Rice cakes', 'Gochujang sauce', 'Green onion'],
    ),
    'ko': CultureCopy(
      title: '떡볶이',
      summary: '양념과 함께 졸여 만드는 떡 요리입니다.',
      paragraphs: [
        '떡볶이의 주재료는 원통형 떡입니다. 널리 알려진 빨간 양념에는 고추장이 들어가며, 국물이나 어묵, 파를 더하는 종류도 있습니다.',
        '매운 정도와 부재료는 조리법에 따라 다릅니다. 요즘에는 맵지 않은 떡볶이나 치즈를 넣은 종류도 볼 수 있습니다.',
      ],
      ingredients: ['떡', '고추장 양념', '파'],
    ),
  },
  'food-bulgogi': {
    'ru': CultureCopy(
      title: 'Пулькоги',
      summary: 'Тонко нарезанное мясо маринуют и жарят или готовят на гриле.',
      paragraphs: [
        'Пулькоги чаще всего готовят из тонко нарезанной говядины. В маринад могут входить соевый соус, кунжутное масло, сахар и чеснок; иногда добавляют грушу.',
        'Мясо готовят на сковороде или гриле. Гарниры и состав маринада зависят от семейного или ресторанного рецепта.',
      ],
      ingredients: ['Говядина', 'Соевый соус', 'Чеснок', 'Кунжутное масло'],
    ),
    'en': CultureCopy(
      title: 'Bulgogi',
      summary: 'Thinly sliced meat is marinated, then pan-fried or grilled.',
      paragraphs: [
        'Bulgogi is often made with thinly sliced beef. The marinade may include soy sauce, sesame oil, sugar, and garlic; some recipes also add pear.',
        'The meat is cooked in a pan or on a grill. Side dishes and the marinade vary by family and restaurant recipe.',
      ],
      ingredients: ['Beef', 'Soy sauce', 'Garlic', 'Sesame oil'],
    ),
    'ko': CultureCopy(
      title: '불고기',
      summary: '얇게 썬 고기를 양념해 볶거나 구워 먹습니다.',
      paragraphs: [
        '불고기는 얇게 썬 소고기로 만드는 경우가 많습니다. 양념에는 간장, 참기름, 설탕, 마늘이 들어갈 수 있고 배를 넣는 조리법도 있습니다.',
        '고기는 팬이나 석쇠에서 익힙니다. 곁들이는 음식과 양념은 가정이나 식당의 조리법에 따라 달라집니다.',
      ],
      ingredients: ['소고기', '간장', '마늘', '참기름'],
    ),
  },
  'food-gimbap': {
    'ru': CultureCopy(
      title: 'Кимбап',
      summary: 'Рис и начинку заворачивают в ким и нарезают ломтиками.',
      paragraphs: [
        'В кимбапе варёный рис и подготовленную начинку заворачивают в лист сушёных водорослей ким. В начинку могут входить яйцо, овощи, мясо или рыбные продукты.',
        'Кимбап часто готовят для пикника или берут с собой в дорогу. Состав и приправы различаются в разных рецептах.',
      ],
      ingredients: ['Рис', 'Ким (морские водоросли)', 'Овощи и начинка'],
    ),
    'en': CultureCopy(
      title: 'Gimbap',
      summary: 'Rice and fillings are rolled in gim seaweed and sliced.',
      paragraphs: [
        'Cooked rice and prepared fillings are rolled in sheets of dried gim seaweed. Fillings may include egg, vegetables, meat, or fish products.',
        'Gimbap is often prepared for picnics or as a portable meal. Ingredients and seasonings vary between recipes.',
      ],
      ingredients: ['Rice', 'Gim seaweed', 'Vegetables and fillings'],
    ),
    'ko': CultureCopy(
      title: '김밥',
      summary: '밥과 여러 속재료를 김에 말아 썰어 먹습니다.',
      paragraphs: [
        '김밥은 지은 밥과 준비한 속재료를 마른 김에 말아 만듭니다. 속에는 달걀, 채소, 고기 또는 생선 가공품이 들어갈 수 있습니다.',
        '김밥은 소풍이나 이동할 때 먹기 편하도록 자주 준비합니다. 재료와 양념은 조리법에 따라 달라집니다.',
      ],
      ingredients: ['밥', '김', '채소와 속재료'],
    ),
  },
  'food-samgyeopsal': {
    'ru': CultureCopy(
      title: 'Самгёпсаль',
      summary:
          'Свиная грудинка с гриля, которую часто едят с листьями и гарнирами.',
      paragraphs: [
        'Самгёпсаль — ломтики свиной грудинки. Мясо часто жарят на настольном гриле и заворачивают в листья салата.',
        'К нему могут подавать чеснок, соусы, овощи и разные гарниры. Подача зависит от ресторана и региона.',
      ],
      ingredients: ['Свиная грудинка', 'Листья салата', 'Чеснок', 'Гарниры'],
    ),
    'en': CultureCopy(
      title: 'Samgyeopsal',
      summary:
          'Grilled pork belly, often served with leafy wraps and side dishes.',
      paragraphs: [
        'Samgyeopsal consists of slices of pork belly. The meat is often cooked on a grill at the table and wrapped in lettuce leaves.',
        'It may be served with garlic, sauces, vegetables, and side dishes. Serving styles vary by restaurant and region.',
      ],
      ingredients: ['Pork belly', 'Lettuce leaves', 'Garlic', 'Side dishes'],
    ),
    'ko': CultureCopy(
      title: '삼겹살',
      summary: '구운 돼지고기를 잎채소와 반찬에 곁들여 먹는 음식입니다.',
      paragraphs: [
        '삼겹살은 돼지의 배 부위에서 자른 고기입니다. 식탁 위 불판에 구워 상추에 싸 먹는 경우가 많습니다.',
        '마늘과 소스, 채소, 여러 반찬을 곁들일 수 있습니다. 내는 방식은 식당과 지역에 따라 다릅니다.',
      ],
      ingredients: ['돼지고기 삼겹살', '상추', '마늘', '곁들임 반찬'],
    ),
  },
};

CultureCopy localizedCultureCopy(CultureEntry entry, String languageCode) {
  if (languageCode == 'kk') {
    return CultureCopy(
      title: entry.title,
      summary: entry.summary,
      paragraphs: entry.paragraphs,
      period: entry.period,
      ingredients: entry.ingredients,
    );
  }
  return _translations[entry.id]?[languageCode] ??
      CultureCopy(
        title: entry.title,
        summary: entry.summary,
        paragraphs: entry.paragraphs,
        period: entry.period,
        ingredients: entry.ingredients,
      );
}

class PhraseCopy {
  const PhraseCopy(this.meaning, this.note);

  final String meaning;
  final String note;
}

const _phraseTranslations = <String, Map<String, PhraseCopy>>{
  '안녕하세요': {
    'ru': PhraseCopy(
      'Здравствуйте',
      'Вежливое приветствие для повседневных ситуаций.',
    ),
    'en': PhraseCopy('Hello', 'A polite greeting for everyday situations.'),
    'ko': PhraseCopy('안녕하세요', '일상에서 두루 쓰는 정중한 인사말입니다.'),
  },
  '감사합니다': {
    'ru': PhraseCopy('Спасибо', 'Вежливая форма выражения благодарности.'),
    'en': PhraseCopy('Thank you', 'A polite way to express gratitude.'),
    'ko': PhraseCopy('감사합니다', '고마운 마음을 전하는 정중한 표현입니다.'),
  },
  '네': {
    'ru': PhraseCopy('Да', 'Вежливое согласие или положительный ответ.'),
    'en': PhraseCopy('Yes', 'A polite agreement or affirmative answer.'),
    'ko': PhraseCopy('네', '정중하게 동의하거나 긍정할 때 씁니다.'),
  },
  '아니요': {
    'ru': PhraseCopy('Нет', 'Вежливая отрицательная форма ответа.'),
    'en': PhraseCopy('No', 'A polite negative answer.'),
    'ko': PhraseCopy('아니요', '정중하게 부정할 때 쓰는 대답입니다.'),
  },
  '죄송합니다': {
    'ru': PhraseCopy(
      'Извините',
      'Можно использовать, чтобы извиниться или вежливо привлечь внимание.',
    ),
    'en': PhraseCopy(
      'I’m sorry / Excuse me',
      'Use it to apologize or politely get someone’s attention.',
    ),
    'ko': PhraseCopy('죄송합니다', '사과하거나 정중하게 상대의 주의를 끌 때 쓸 수 있습니다.'),
  },
  '이름이 뭐예요?': {
    'ru': PhraseCopy(
      'Как вас зовут?',
      'Вежливый повседневный вопрос; уместен в непринуждённой обстановке.',
    ),
    'en': PhraseCopy(
      'What is your name?',
      'A polite everyday question, suitable for an informal setting.',
    ),
    'ko': PhraseCopy('이름이 뭐예요?', '일상적인 정중한 질문으로, 격식이 덜한 상황에서 씁니다.'),
  },
};

PhraseCopy localizedPhraseCopy(String korean, String languageCode) =>
    _phraseTranslations[korean]?[languageCode] ??
    PhraseCopy(
      koreanStarterPhraseMeaning(korean),
      koreanStarterPhraseNote(korean),
    );

String koreanStarterPhraseMeaning(String korean) => switch (korean) {
  '안녕하세요' => 'Сәлеметсіз бе',
  '감사합니다' => 'Рақмет',
  '네' => 'Иә',
  '아니요' => 'Жоқ',
  '죄송합니다' => 'Кешіріңіз',
  _ => 'Есіміңіз кім?',
};

String koreanStarterPhraseNote(String korean) => switch (korean) {
  '안녕하세요' => 'Күнделікті жағдайда қолданылатын сыпайы амандасу үлгісі.',
  '감사합니다' => 'Алғыс білдірудің сыпайы формасы.',
  '네' => 'Сыпайы келісу не оң жауап беру үшін айтылады.',
  '아니요' => 'Сыпайы түрде теріс жауап беру үлгісі.',
  '죄송합니다' => 'Кешірім сұрауға немесе сыпайы түрде назар аудартуға болады.',
  _ => 'Сыпайы күнделікті сұрақ. Жақын не ресми емес ортада қолданылады.',
};
