import 'dart:convert';

import 'package:alquran/controller/home_controller.dart';
import 'package:alquran/database/bookmark.dart';
import 'package:alquran/models/detail_surah_model.dart' as detailSurah;
import 'package:alquran/utils/curdex.dart';

import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'package:just_audio/just_audio.dart';
import 'package:scroll_to_index/scroll_to_index.dart';
import 'package:sqflite/sqflite.dart';

import '../utils/colors.dart';

class DetailSurahController with ChangeNotifier {
  // static ValueNotifier<String> kondisiAudio = ValueNotifier("stop");

  static AutoScrollController scrollC = AutoScrollController();

  static ValueNotifier<AudioPlayer> player = ValueNotifier(AudioPlayer());

  static detailSurah.Verse? lastVerse;

  static ValueNotifier<DatabaseManager> database =
      ValueNotifier(DatabaseManager.instance);

  static ValueNotifier<HomeController> homeC = ValueNotifier(HomeController());

  static Future<detailSurah.DetailSurah> getDetailSurah(String id) async {
    Uri url = Uri.parse(
        'https://quran-rdr76wqee-fadillahnurfaq.vercel.app/surah/$id');
    var res = await http.get(url);
    Map<String, dynamic> data =
        (jsonDecode(res.body) as Map<String, dynamic>)['data'];
    return detailSurah.DetailSurah.fromJson(data);
  }

  static void playAudio(detailSurah.Verse? ayat) async {
    if (ayat?.audio?.primary != null) {
      // Catching errors at load time

      try {
        //* Handle penumpukan audio yang berjalan
        if (lastVerse == null) {
          lastVerse = ayat;
        }
        lastVerse!.kondisiAudio = "stop";
        lastVerse = ayat;
        lastVerse!.kondisiAudio = "stop";
        await player.value
            .stop(); //* Mencegah terjadinya penumpukan audio yang sedang berjalan
        await player.value.setUrl(ayat!.audio!.primary!);
        ayat.kondisiAudio = "playing";
        player.notifyListeners();
        await player.value.play();
        ayat.kondisiAudio = "stop";
        player.notifyListeners();
        await player.value.stop();
      } on PlayerException catch (e) {
        // print("Error code: ${e.code}");

        // print("Error message: ${e.message}");
        showDialog(
          context: curdex.currentContext!,
          barrierDismissible: false,
          builder: (context) {
            return AlertDialog(
              backgroundColor: Theme.of(context).brightness == Brightness.dark
                  ? appPurpleLight1.withOpacity(0.5)
                  : Colors.white,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),
              title: const Center(
                child: Text("Terjadi Kesalahan"),
              ),
              content: Text(
                "Error message: ${e.message}",
              ),
              actions: [
                TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text("Oke"))
              ],
            );
          },
        );
      } on PlayerInterruptedException catch (e) {
        // print("Connection aborted: ${e.message}");
        showDialog(
          context: curdex.currentContext!,
          barrierDismissible: false,
          builder: (context) {
            return AlertDialog(
              backgroundColor: Theme.of(context).brightness == Brightness.dark
                  ? appPurpleLight1.withOpacity(0.5)
                  : Colors.white,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),
              title: const Center(
                child: Text("Terjadi Kesalahan"),
              ),
              content: Text(
                "Connection aborted: ${e.message}",
              ),
              actions: [
                TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text("Oke"))
              ],
            );
          },
        );
      } catch (e) {
        // print('An error occured: $e');
        showDialog(
          context: curdex.currentContext!,
          barrierDismissible: false,
          builder: (context) {
            return AlertDialog(
              backgroundColor: Theme.of(context).brightness == Brightness.dark
                  ? appPurpleLight1.withOpacity(0.5)
                  : Colors.white,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),
              title: const Center(
                child: Text("Terjadi Kesalahan"),
              ),
              content: Text(
                "An error occured: ${e.toString()}",
              ),
              actions: [
                TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text("Oke"))
              ],
            );
          },
        );
      }

      player.value.playbackEventStream.listen(
        (event) {},
        onError: (Object e, StackTrace st) {
          if (e is PlayerException) {
            // print('Error code: ${e.code}');
            // print('Error message: ${e.message}');
            showDialog(
              context: curdex.currentContext!,
              barrierDismissible: false,
              builder: (context) {
                return AlertDialog(
                  backgroundColor:
                      Theme.of(context).brightness == Brightness.dark
                          ? appPurpleLight1.withOpacity(0.5)
                          : Colors.white,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20)),
                  title: const Center(
                    child: Text("Terjadi Kesalahan"),
                  ),
                  content: Column(
                    children: [
                      Text(
                        "Error message: ${e.code.toString()}",
                      ),
                      Text(
                        "Error message: ${e.message.toString()}",
                      ),
                    ],
                  ),
                  actions: [
                    TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text("Oke"))
                  ],
                );
              },
            );
          } else {
            // print('An error occurred: $e');
            showDialog(
              context: curdex.currentContext!,
              barrierDismissible: false,
              builder: (context) {
                return AlertDialog(
                  backgroundColor:
                      Theme.of(context).brightness == Brightness.dark
                          ? appPurpleLight1.withOpacity(0.5)
                          : Colors.white,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20)),
                  title: const Center(
                    child: Text("Terjadi Kesalahan"),
                  ),
                  content: Text(
                    "An error occurred: ${e.toString()}",
                  ),
                  actions: [
                    TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text("Oke"))
                  ],
                );
              },
            );
          }
        },
      );
    } else {
      showDialog(
        context: curdex.currentContext!,
        barrierDismissible: false,
        builder: (context) {
          return AlertDialog(
            backgroundColor: Theme.of(context).brightness == Brightness.dark
                ? appPurpleLight1.withOpacity(0.5)
                : Colors.white,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            title: const Center(
              child: Text("Terjadi Kesalahan"),
            ),
            content: const Text(
              "URL Audio tidak ada / tidak dapat diakses.",
            ),
            actions: [
              TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text("Oke"))
            ],
          );
        },
      );
    }
  }

  static void pauseAudio(detailSurah.Verse ayat) async {
    try {
      await player.value.pause();
      ayat.kondisiAudio = "pause";
      player.notifyListeners();
    } on PlayerException catch (e) {
      showDialog(
        context: curdex.currentContext!,
        barrierDismissible: false,
        builder: (context) {
          return AlertDialog(
            backgroundColor: Theme.of(context).brightness == Brightness.dark
                ? appPurpleLight1.withOpacity(0.5)
                : Colors.white,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            title: const Center(
              child: Text("Terjadi Kesalahan"),
            ),
            content: Text(
              "Error message: ${e.message.toString()}",
            ),
            actions: [
              TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text("Oke"))
            ],
          );
        },
      );
    } on PlayerInterruptedException catch (e) {
      // print("Connection aborted: ${e.message}");
      showDialog(
        context: curdex.currentContext!,
        barrierDismissible: false,
        builder: (context) {
          return AlertDialog(
            backgroundColor: Theme.of(context).brightness == Brightness.dark
                ? appPurpleLight1.withOpacity(0.5)
                : Colors.white,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            title: const Center(
              child: Text("Terjadi Kesalahan"),
            ),
            content: Text(
              "Connection aborted: ${e.message}",
            ),
            actions: [
              TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text("Oke"))
            ],
          );
        },
      );
    } catch (e) {
      // print('An error occured: $e');
      showDialog(
        context: curdex.currentContext!,
        barrierDismissible: false,
        builder: (context) {
          return AlertDialog(
            backgroundColor: Theme.of(context).brightness == Brightness.dark
                ? appPurpleLight1.withOpacity(0.5)
                : Colors.white,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            title: const Center(
              child: Text("Terjadi Kesalahan"),
            ),
            content: const Text(
              "Tidak dapat pause audio.",
            ),
            actions: [
              TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text("Oke"))
            ],
          );
        },
      );
    }
  }

  static void resumeAudio(detailSurah.Verse ayat) async {
    try {
      ayat.kondisiAudio = "playing";
      player.notifyListeners();
      await player.value.play();
      ayat.kondisiAudio = "stop";
      player.notifyListeners();
    } on PlayerException catch (e) {
      showDialog(
        context: curdex.currentContext!,
        barrierDismissible: false,
        builder: (context) {
          return AlertDialog(
            backgroundColor: Theme.of(context).brightness == Brightness.dark
                ? appPurpleLight1.withOpacity(0.5)
                : Colors.white,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            title: const Center(
              child: Text("Terjadi Kesalahan"),
            ),
            content: Text(
              "Error message: ${e.message.toString()}",
            ),
            actions: [
              TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text("Oke"))
            ],
          );
        },
      );
    } on PlayerInterruptedException catch (e) {
      // print("Connection aborted: ${e.message}");
      showDialog(
        context: curdex.currentContext!,
        barrierDismissible: false,
        builder: (context) {
          return AlertDialog(
            backgroundColor: Theme.of(context).brightness == Brightness.dark
                ? appPurpleLight1.withOpacity(0.5)
                : Colors.white,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            title: const Center(
              child: Text("Terjadi Kesalahan"),
            ),
            content: Text(
              "Connection aborted: ${e.message}",
            ),
            actions: [
              TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text("Oke"))
            ],
          );
        },
      );
    } catch (e) {
      // print('An error occured: $e');
      showDialog(
        context: curdex.currentContext!,
        barrierDismissible: false,
        builder: (context) {
          return AlertDialog(
            backgroundColor: Theme.of(context).brightness == Brightness.dark
                ? appPurpleLight1.withOpacity(0.5)
                : Colors.white,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            title: const Center(
              child: Text("Terjadi Kesalahan"),
            ),
            content: const Text(
              "Tidak dapat resume audio.",
            ),
            actions: [
              TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text("Oke"))
            ],
          );
        },
      );
    }
  }

  static void stopAudio(detailSurah.Verse ayat) async {
    try {
      await player.value.stop();
      ayat.kondisiAudio = "stop";
      player.notifyListeners();
    } on PlayerException catch (e) {
      showDialog(
        context: curdex.currentContext!,
        barrierDismissible: false,
        builder: (context) {
          return AlertDialog(
            backgroundColor: Theme.of(context).brightness == Brightness.dark
                ? appPurpleLight1.withOpacity(0.5)
                : Colors.white,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            title: const Center(
              child: Text("Terjadi Kesalahan"),
            ),
            content: Text(
              "Error message: ${e.message.toString()}",
            ),
            actions: [
              TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text("Oke"))
            ],
          );
        },
      );
    } on PlayerInterruptedException catch (e) {
      // print("Connection aborted: ${e.message}");
      showDialog(
        context: curdex.currentContext!,
        barrierDismissible: false,
        builder: (context) {
          return AlertDialog(
            backgroundColor: Theme.of(context).brightness == Brightness.dark
                ? appPurpleLight1.withOpacity(0.5)
                : Colors.white,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            title: const Center(
              child: Text("Terjadi Kesalahan"),
            ),
            content: Text(
              "Connection aborted: ${e.message}",
            ),
            actions: [
              TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text("Oke"))
            ],
          );
        },
      );
    } catch (e) {
      // print('An error occured: $e');
      showDialog(
        context: curdex.currentContext!,
        barrierDismissible: false,
        builder: (context) {
          return AlertDialog(
            backgroundColor: Theme.of(context).brightness == Brightness.dark
                ? appPurpleLight1.withOpacity(0.5)
                : Colors.white,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            title: const Center(
              child: Text("Terjadi Kesalahan"),
            ),
            content: const Text(
              "Tidak dapat stop audio.",
            ),
            actions: [
              TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text("Oke"))
            ],
          );
        },
      );
    }
  }

  static void addBookmark(bool lastRead, detailSurah.DetailSurah surah,
      detailSurah.Verse ayat, int indexAyat) async {
    Database db = await database.value.db;

    bool flagExist = false;

    if (lastRead == true) {
      await db.delete("bookmark", where: "last_read = 1");
    } else {
      List checkData = await db.query("bookmark",
          columns: [
            "surah",
            "number_surah",
            "ayat",
            "juz",
            "via",
            "index_ayat",
            "last_read"
          ],
          where:
              "surah = '${surah.name!.transliteration!.id!.replaceAll("'", "+")}' and number_surah = ${surah.number} and ayat = ${ayat.number!.inSurah} and juz = ${ayat.meta!.juz} and via = 'surah' and index_ayat = $indexAyat and last_read = 0");
      if (checkData.isNotEmpty) {
        flagExist = true;
      }
    }

    if (flagExist == false) {
      await db.insert(
        "bookmark",
        {
          "surah": surah.name!.transliteration!.id!.replaceAll("'", "+"),
          "number_surah": surah.number,
          "ayat": ayat.number!.inSurah,
          "juz": ayat.meta!.juz,
          "via": "surah",
          "index_ayat": indexAyat,
          "last_read": lastRead == true ? 1 : 0,
        },
      );
      Navigator.pop(curdex.currentContext!);
      homeC.notifyListeners();
      showDialog(
        context: curdex.currentContext!,
        barrierDismissible: false,
        builder: (context) {
          return AlertDialog(
            backgroundColor: Theme.of(context).brightness == Brightness.dark
                ? appPurpleLight1.withOpacity(0.5)
                : Colors.white,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            title: const Center(
              child: Text("Berhasil"),
            ),
            content: const Text(
              "Berhasil menambahkan bookmark",
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text("Oke"),
              )
            ],
          );
        },
      );
    } else {
      Navigator.pop(curdex.currentContext!);
      showDialog(
        context: curdex.currentContext!,
        barrierDismissible: false,
        builder: (context) {
          return AlertDialog(
            backgroundColor: Theme.of(context).brightness == Brightness.dark
                ? appPurpleLight1.withOpacity(0.5)
                : Colors.white,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            title: const Center(
              child: Text("Terjadi kesalahan"),
            ),
            content: const Text(
              "Bookmark telah tersedia",
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text("Oke"),
              )
            ],
          );
        },
      );
    }

    var data = await db.query("bookmark");
    print(data);
  }
}
