import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

const _kLocaleStorageKey = '__locale_key__';

class MyLocalizations {
  MyLocalizations(this.locale);

  final Locale locale;

  static MyLocalizations of(BuildContext context) =>
      Localizations.of<MyLocalizations>(context, MyLocalizations)!;

  static List<String> languages() => ['en', 'ar', 'fr'];

  static late SharedPreferences _prefs;
  static Future initialize() async =>
      _prefs = await SharedPreferences.getInstance();
  static Future storeLocale(String locale) =>
      _prefs.setString(_kLocaleStorageKey, locale);
  static Locale? getStoredLocale() {
    final locale = _prefs.getString(_kLocaleStorageKey);
    return locale != null && locale.isNotEmpty ? createLocale(locale) : null;
  }

  String get languageCode => locale.toString();
  String? get languageShortCode =>
      _languagesWithShortCode.contains(locale.toString())
          ? '${locale.toString()}_short'
          : null;
  int get languageIndex => languages().contains(languageCode)
      ? languages().indexOf(languageCode)
      : 0;

  String getText(String key) =>
      (kTranslationsMap[key] ?? {})[locale.toString()] ?? '';

  String getVariableText({
    String? enText = '',
    String? arText = '',
    String? frText = '',
  }) =>
      [enText, arText, frText][languageIndex] ?? '';

  static const Set<String> _languagesWithShortCode = {
    'ar',
    'az',
    'ca',
    'cs',
    'da',
    'de',
    'dv',
    'en',
    'es',
    'et',
    'fi',
    'fr',
    'gr',
    'he',
    'hi',
    'hu',
    'it',
    'km',
    'ku',
    'mn',
    'ms',
    'no',
    'pt',
    'ro',
    'ru',
    'rw',
    'sv',
    'th',
    'uk',
    'vi',
  };
}

class MyLocalizationsDelegate extends LocalizationsDelegate<MyLocalizations> {
  const MyLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) {
    final language = locale.toString();
    return MyLocalizations.languages().contains(
      language.endsWith('_')
          ? language.substring(0, language.length - 1)
          : language,
    );
  }

  @override
  Future<MyLocalizations> load(Locale locale) =>
      SynchronousFuture<MyLocalizations>(MyLocalizations(locale));

  @override
  bool shouldReload(MyLocalizationsDelegate old) => false;
}

Locale createLocale(String language) => language.contains('_')
    ? Locale.fromSubtags(
        languageCode: language.split('_').first,
        scriptCode: language.split('_').last,
      )
    : Locale(language);

final kTranslationsMap = <Map<String, Map<String, String>>>[
  // Login Page

  {
    // Sign in
    'A2bX7': {'en': 'Sign in', 'ar': 'تسجيل الدخول'},
    // Forgot Password
    'D9zP6': {'en': 'Forgot Password ?', 'ar': 'هل نسيت كلمة السر ؟'},
    // Skip
    'E5yQ8': {'en': 'Skip', 'ar': 'يتخطى'},
    // Or sign in with
    'F4wR7': {'en': 'Or sign in with', 'ar': 'أو قم بتسجيل الدخول باستخدام'},
    //Sign in with Google
    'G2vS9': {'en': 'Sign in with Google', 'ar': 'الدخول مع جوجل'},
    //Sign in with facebook
    'F2vS9': {
      'en': 'Sign in with Facebook',
      'ar': 'قم بتسجيل الدخول باستخدام الفيسبوك'
    },
    // Sign in with phone
    'P5hN7': {
      'en': 'Sign in with Phone',
      'ar': 'قم بتسجيل الدخول باستخدام الهاتف'
    },
    // I agree to the
    'A9gR1': {'en': 'I agree to the', 'ar': 'أوافق على'},
    //User Agreement
    'U4rA8': {'en': 'User Agreement', 'ar': 'اتفاق المستخدم'},
    // and the
    'A3nD7': {'en': 'and the', 'ar': 'وال'},
    //Privacy Policy
    'P6lI2': {'en': 'Privacy Policy', 'ar': 'سياسة الخصوصية'},
    // Register
    'R7gI4': {'en': 'Register', 'ar': 'تسجيل'},
    //Welcome Back
    'W3lC6': {'en': 'Welcome Back', 'ar': 'مرحبًا مجددًا'},
    // Sign in with
    'S9nI8': {
      'en':
          'Sign in with your email and password or continue with social media',
      'ar':
          'قم بتسجيل الدخول باستخدام بريدك الإلكتروني وكلمة المرور أو استمر مع وسائل التواصل الاجتماعي'
    },
    // login
    'L5gI1': {'en': 'Log In', 'ar': 'تسجيل الدخول'},
    // create account
    'C9rA2': {'en': 'Create Account', 'ar': 'إنشاء حساب'}
  },
  // Complite profile
  {
    // Complete Profile
    'C8pP6': {'en': 'Complete Profile', 'ar': 'اكمل الملف الشخصي'},
    // Complete your details...
    'C5mY7': {
      'en': 'Complete your details or continue with social media',
      'ar': 'اكمل تفاصيلك أو استمر مع وسائل التواصل الاجتماعي'
    },
    // Full Name
    'F5lN8': {'en': 'Full Name', 'ar': 'الاسم الكامل'},
    // enter full name
    'E7rF1': {'en': 'Enter full name', 'ar': 'أدخل الاسم الكامل'},
    // this field is required
    'T6sF4': {'en': 'This field is required', 'ar': 'هذا الحقل مطلوب'},
    // At least 3 characters
    'A9tL2': {'en': 'At least 3 characters', 'ar': 'على الأقل 3 أحرف'},
    //Please select a prefix
    'P5sP9': {'en': 'Please select a prefix', 'ar': 'يرجى اختيار بادئة'},
    //Phone Number
    'P6hN8': {'en': 'Phone Number', 'ar': 'رقم الهاتف'},
    // Number phone
    'N4mP7': {
      'en': 'Number phone etc 12345678...',
      'ar': 'رقم الهاتف وما إلى ذلك 12345678...'
    },
    // Please select a gender
    'P8sG5': {'en': 'Please select a gender', 'ar': 'يرجى اختيار الجنس'},
    // Male
    'M4lE1': {'en': 'Male', 'ar': 'ذكر'},
    //Female
    'F5mL2': {'en': 'Female', 'ar': 'أنثى'},
    //Birthday
    'B7rT3': {'en': 'Birthday', 'ar': 'تاريخ الميلاد'},
    // Enter your birthday
    'E8rY2': {'en': 'Enter your birthday', 'ar': 'أدخل تاريخ ميلادك'},
    // continue
    'C8nE1': {'en': 'Continue', 'ar': 'متابعة'},
    //By continuing ...
    'B4yC7': {
      'en':
          'By continuing, you confirm that you agree with our Terms and Conditions',
      'ar': 'من خلال الاستمرار، تؤكد أنك توافق على شروطنا وأحكامنا'
    }
  },
  // HOme page

  {
    // Home page
    'H4mP1': {'en': 'Home Page', 'ar': 'الصفحة الرئيسية'},
    // Search on blueray
    'S6hB8': {'en': 'Search on Blue Ray', 'ar': 'البحث عن بلو راي'},
    // For Ordering Call
    'F4rO1': {
      'en': 'For Ordering Call +974 50 38 06 40',
      'ar': 'للطلب اتصل برقم +974 50 38 06 40'
    },
    //See More
    'S4eM7': {'en': 'See More', 'ar': 'رؤية المزيد'},
    // Special for you
    'S8lF3': {'en': 'Special for you', 'ar': 'خاص بك'},
    //Products
    'P5sS1': {'en': 'Products', 'ar': 'منتجات'}
  }
].reduce((a, b) => a..addAll(b));
