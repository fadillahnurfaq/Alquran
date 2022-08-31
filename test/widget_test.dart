// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'dart:convert';

import 'package:alquran/models/juz_model.dart';

import 'package:http/http.dart' as http;

void main() async {
  // Uri url = Uri.parse('https://equran.id/api/surat');
  // var res = await http.get(url);

  //* Mendapatkan List Surah
  // List data = jsonDecode(res.body);

  //* surah ada 114 -> index 0 adalah alfatihah
  // print(data[0]);

  //* Mendapatkan nomor surah
  // print(data[0]['nomor']);

  //* Untuk mengambil data surah
  // Surah surahAnnas = Surah.fromJson(data[113]);
  // print(surahAnnas.nama);
  // print(surahAnnas.deskripsi);
  // print(surahAnnas.nomor);
  // print(surahAnnas.arti);

  //* Print semua tojson
  // print(surahAnnas.toJson());

  //* Untuk detail surah
  // Uri urlAnnas = Uri.parse('https://equran.id/api/surat/${surahAnnas.nomor}');
  // var resAnnas = await http.get(urlAnnas);
  // print('=========');
  // print(resAnnas.body);

  //* Untuk detail annas yang sudah menjadi object
  // Map<String, dynamic> detailAnnas =
  //     (jsonDecode(resAnnas.body) as Map<String, dynamic>);
  // DetailSurah annas = DetailSurah.fromJson(detailAnnas);
  // print(annas.deskripsi);

  //* Untuk mengambil detailAyatAnnas
  // List dataAyatAnnas =
  //     (jsonDecode(resAnnas.body) as Map<String, dynamic>)['ayat'];

  // print(ayatAnnas.ar);
  // Ayat detailAyatAnnas = Ayat.fromJson(dataAyatAnnas[113]);
  // print(detailAyatAnnas);
  // Ayat detailAyatAnnas = Ayat.fromJson(dataAyatAnnas[0]);
  // print(detailAyatAnnas.id);

  // print('=========');
  // print(dataAyatAnnas);
  // Uri urlAlfatihah = Uri.parse('https://quran-api-id.vercel.app/surahs/1');
  // var resAlfatihah = await http.get(urlAlfatihah);
  // List dataAyatAlfatihah =
  //     (jsonDecode(resAlfatihah.body) as Map<String, dynamic>)['ayahs'];
  // Ayahs detailAyatAlfatihah = Ayahs.fromJson(dataAyatAlfatihah[0]);
  // print(detailAyatAlfatihah.meta?.juz);

  // Uri url = Uri.parse('https://quran-api-id.vercel.app/surahs');
  // var res = await http.get(url);
  // List data = jsonDecode(res.body);
  // print(data);
  /* Uri url = Uri.parse('https://api.alquran.cloud/v1/juz/1');
  var res = await http.get(url);
  Map<String, dynamic> dataNumber =
      (json.decode(res.body) as Map<String, dynamic>)['data'];
  print(Juz.fromJson(dataNumber));

  List data = (jsonDecode(res.body) as Map<String, dynamic>)['data']['ayahs'];

  print(data.map((e) => AyahsJuz.fromJson(e)).toList()); */
}
