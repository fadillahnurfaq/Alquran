import 'package:alquran/controller/theme_controller.dart';
import 'package:alquran/utils/curdex.dart';
import 'package:alquran/views/details/detail_juz_view.dart';

import 'package:alquran/views/details/detail_surah_view.dart';
import 'package:alquran/views/home/home_view.dart';
import 'package:alquran/views/introduction/introduction_view.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  ThemeController.themePref();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
        valueListenable: ThemeController.isDark,
        builder: (_, value, __) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            navigatorKey: curdex,
            title: 'Al-Quran',
            theme: ThemeController.getTheme(),
            initialRoute: '/',
            routes: {
              '/': (context) => const IntroductionView(),
              '/home': (context) => const HomeView(),
              '/detail-surah': (context) => const DetailSurahView(),
              '/detail-juz': (context) => const DetailJuzView(),
            },
          );
        });
  }
}
