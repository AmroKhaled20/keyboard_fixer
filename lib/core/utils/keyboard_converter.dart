class KeyboardConverter {
  static const Map<String, String> _englishToArabicMap = {
    'q': 'ض',
    'w': 'ص',
    'e': 'ث',
    'r': 'ق',
    't': 'ف',
    'y': 'غ',
    'u': 'ع',
    'i': 'ه',
    'o': 'خ',
    'p': 'ح',
    '[': 'ج',
    ']': 'د',
    '\\': '\\',
    'a': 'ش',
    's': 'س',
    'd': 'ي',
    'f': 'ب',
    'g': 'ل',
    'h': 'ا',
    'j': 'ت',
    'k': 'ن',
    'l': 'م',
    ';': 'ك',
    '\'': 'ط',
    'z': 'ئ',
    'x': 'ء',
    'c': 'ؤ',
    'v': 'ر',
    'b': 'لا',
    'n': 'ى',
    'm': 'ة',
    ',': 'و',
    '.': 'ز',
    '/': 'ظ',
    '`': 'ذ',

    'Q': 'ض',
    'W': 'ص',
    'E': 'ث',
    'R': 'ق',
    'U': 'ع',
    'I': 'ه',
    'O': 'خ',
    'P': 'ح',
    'A': 'ش',
    'S': 'س',
    'D': 'ي',
    'F': 'ب',
    'J': 'ت',
    'K': 'ن',
    'L': 'م',
    'Z': 'ئ',
    'X': 'ء',
    'C': 'ؤ',
    'V': 'ر',
    'M': 'ة',

    'H': 'أ',
    'Y': 'إ',
    'N': 'آ',
    'G': 'لأ',
    'T': 'لإ',
    'B': 'لآ',

    '?': '؟',
    '<': ',',
    '>': '.',
    '{': '<',
    '}': '>',
    '~': 'ّ',
    '"': '"',
    ':': ':',
    '|': '|',
    '(': ')',
    ')': '(',

    '0': '٠',
    '1': '١',
    '2': '٢',
    '3': '٣',
    '4': '٤',
    '5': '٥',
    '6': '٦',
    '7': '٧',
    '8': '٨',
    '9': '٩',
  };

  static final Map<String, String> _arabicToEnglishMap = _initReverseMap();

  static Map<String, String> _initReverseMap() {
    final map = <String, String>{};
    _englishToArabicMap.forEach((en, ar) {
      map.putIfAbsent(ar, () => en);
    });
    return map;
  }

  static String convertToArabic(String input) {
    return _convert(input, _englishToArabicMap);
  }

  static String convertToEnglish(String input) {
    return _convert(input, _arabicToEnglishMap);
  }

  static String _convert(String input, Map<String, String> map) {
    final buffer = StringBuffer();
    int i = 0;

    while (i < input.length) {
      if (i < input.length - 1) {
        final String twoChars = input.substring(i, i + 2);
        if (map.containsKey(twoChars)) {
          buffer.write(map[twoChars]);
          i += 2;
          continue;
        }
      }

      final String char = input[i];
      buffer.write(map[char] ?? char);
      i++;
    }

    return buffer.toString();
  }
}
