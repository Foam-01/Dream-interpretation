import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'data/repository.dart';
import 'models.dart';
import 'screens/content_screens.dart';
import 'screens/dream_screens.dart';
import 'screens/home_screen.dart';
import 'screens/number_screens.dart';
import 'theme.dart';

void main() => runApp(const MahaDreamApp());

class MahaDreamApp extends StatelessWidget {
  const MahaDreamApp({super.key});

  @override
  Widget build(BuildContext context) {
    final repo = DreamRepository.instance;
    return MaterialApp(
      title: 'มหาทำนายฝัน',
      debugShowCheckedModeBanner: false,
      theme: buildTheme(),
      locale: const Locale('th'),
      supportedLocales: const [Locale('th'), Locale('en')],
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      routes: {
        '/': (_) => const HomeScreen(),
        '/search': (_) => const DreamSearchScreen(),
        '/categories': (_) => const CategoriesScreen(),
        '/lucky': (_) => const LuckyNumbersScreen(),
        '/digits': (_) => const DigitMeaningsScreen(),
        '/locked': (_) => const DailyLockedNumbersScreen(),
        '/formula-draw': (_) => FormulaScreen(title: 'สูตรวันหวยออก', compute: repo.drawDateFormula),
        '/formula-astro': (_) => FormulaScreen(title: 'สูตรเลขดาราศาสตร์', compute: repo.astronomicalFormula),
        '/running': (_) => const RunningNumbersScreen(),
        '/remedies': (_) => ContentListScreen(
            title: 'วิธีแก้ฝันร้าย',
            intro: 'เคล็ดลับแก้ลางร้ายจากความฝันตามความเชื่อโบราณ',
            load: repo.badDreamRemedies),
        '/luck': (_) => ContentListScreen(title: 'ขอโชค', load: repo.luckSeeking),
        '/prayers': (_) => ContentListScreen(
            title: 'บทสวดขอฝัน', intro: 'สวดก่อนนอนด้วยจิตที่สงบ', load: repo.dreamPrayers),
        '/animals': (_) => NumberIndexScreen(title: 'ตัวเลขประจำสัตว์', load: repo.animalIndex),
        '/paekong': (_) => NumberIndexScreen(title: 'ดัชนีแปะกง', load: repo.paeKongIndex),
        '/rules': (_) => ContentListScreen(
            title: 'ตำราฝันโบราณ', intro: 'หลักการตีความฝันตามเวลาและประเภทของฝัน', load: repo.traditionalRules),
      },
      onGenerateRoute: (settings) {
        final arg = settings.arguments;
        if (settings.name == '/dream' && arg is Dream) {
          return MaterialPageRoute(builder: (_) => DreamDetailScreen(dream: arg));
        }
        if (settings.name == '/category' && arg is DreamCategory) {
          return MaterialPageRoute(builder: (_) => CategoryDreamsScreen(category: arg));
        }
        return null;
      },
    );
  }
}
