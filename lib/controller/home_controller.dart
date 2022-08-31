import 'dart:convert';

import 'package:alquran/database/bookmark.dart';
import 'package:alquran/models/juz_model.dart' as detailJuz;
import 'package:alquran/models/surah_model.dart';
import '../models/detail_surah_model.dart' as detailSurah;

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:sqflite/sqflite.dart';

import '../utils/colors.dart';
import '../utils/curdex.dart';

class HomeController with ChangeNotifier {
  static ValueNotifier<DatabaseManager> database =
      ValueNotifier(DatabaseManager.instance);

  static List<detailJuz.DetailJuz> allJuz = [];

  static ValueNotifier<bool> adaDataAllJuz = ValueNotifier(false);

  static List<SurahModel> allSurah = [];
  static Future<List<SurahModel>> getAllSurah() async {
    Uri url =
        Uri.parse('https://quran-rdr76wqee-fadillahnurfaq.vercel.app/surah');
    var res = await http.get(url);
    List? data = (jsonDecode(res.body) as Map<String, dynamic>)['data'];
    if (data == null || data.isEmpty) {
      return [];
    } else {
      allSurah = data.map((e) => SurahModel.fromJson(e)).toList();
      return allSurah;
    }
  }

  static Future<List<detailJuz.DetailJuz>> getAllJuz() async {
    for (int i = 1; i <= 30; i++) {
      Uri url =
          Uri.parse("https://quran-rdr76wqee-fadillahnurfaq.vercel.app/juz/$i");
      var res = await http.get(url);

      Map<String, dynamic> data =
          (json.decode(res.body) as Map<String, dynamic>)['data'];

      detailJuz.DetailJuz juz = detailJuz.DetailJuz.fromJson(data);
      allJuz.add(juz);
    }
    return allJuz;
  }

  static Future<List<Map<String, dynamic>>> getBookMark() async {
    Database db = await database.value.db;
    List<Map<String, dynamic>> allBookmarks = await db.query(
      "bookmark",
      where: "last_read = 0",
      orderBy: "juz, via, surah, ayat",
    );

    return allBookmarks;
  }

  static Future<Map<String, dynamic>?> getLastRead() async {
    Database db = await database.value.db;
    List<Map<String, dynamic>> allDataLastRead =
        await db.query("bookmark", where: "last_read = 1");

    if (allDataLastRead.isEmpty) {
      //* Tidak ada data last read
      return null;
    } else {
      //* ada data -> diambil index ke - (Karena cuma ada 1 data didalam list)

      return allDataLastRead.first;
    }
  }

  static void deleteBookmark(int id) async {
    Database db = await database.value.db;
    await db.delete("bookmark", where: "id = $id");
    database.notifyListeners();
  }
}
