import 'package:alquran/controller/detail_juz_controller.dart';
import 'package:alquran/models/juz_model.dart' as detailJuz;
import 'package:alquran/models/surah_model.dart';
import 'package:alquran/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:scroll_to_index/scroll_to_index.dart';

import '../../controller/home_controller.dart';
import '../../database/bookmark.dart';

class DetailJuzView extends StatefulWidget {
  const DetailJuzView({Key? key}) : super(key: key);

  @override
  State<DetailJuzView> createState() => _DetailJuzViewState();
}

class _DetailJuzViewState extends State<DetailJuzView> {
  @override
  void dispose() {
    DetailJuzController.player.value.stop();
    DetailJuzController.player.value.dispose();
    super.dispose();
  }

  @override
  void initState() {
    DetailJuzController.player.value = AudioPlayer();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as Map;

    Map<String, dynamic>? bookmark;

    detailJuz.DetailJuz? juz = args["juz"];

    List<SurahModel> allSurahInThisJuz = args["surah"];

    if (args["bookmark"] != null) {
      bookmark = args["bookmark"];
      if (bookmark!["index_ayat"] > 1) {
        DetailJuzController.scrollC.scrollToIndex(
          bookmark["index_ayat"],
          preferPosition: AutoScrollPosition.begin,
        );
      }
    }

    List<Widget> allAyat = List.generate(
      juz!.verses!.length,
      (index) {
        detailJuz.Verse ayat = juz.verses![index];
        return AutoScrollTag(
          key: ValueKey(index),
          index: index,
          controller: DetailJuzController.scrollC,
          child: Padding(
            padding: const EdgeInsets.only(top: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                if (ayat.number?.inSurah == 1)
                  GestureDetector(
                    onTap: () {
                      showDialog(
                        context: context,
                        barrierDismissible: false,
                        builder: (context) {
                          return AlertDialog(
                            backgroundColor:
                                Theme.of(context).brightness == Brightness.dark
                                    ? appPurpleLight1.withOpacity(0.5)
                                    : Colors.white,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20)),
                            title: Center(
                                child: Text(
                                    "Tafsir ${allSurahInThisJuz[DetailJuzController.index].name?.transliteration?.id}")),
                            content: Text(
                              allSurahInThisJuz[DetailJuzController.index]
                                      .tafsir
                                      ?.id ??
                                  "Tidak ada tafsir pada surah ini..",
                              textAlign: TextAlign.justify,
                            ),
                            actions: [
                              TextButton(
                                  onPressed: () => Navigator.pop(context),
                                  child: const Text("Oke"))
                            ],
                          );
                        },
                      );
                    },
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      margin: const EdgeInsets.only(bottom: 20),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        gradient: const LinearGradient(
                          colors: [
                            appPurpleLight1,
                            appPurpleDark,
                          ],
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Column(
                          children: [
                            Text(
                              allSurahInThisJuz[DetailJuzController.index]
                                      .name
                                      ?.transliteration
                                      ?.id
                                      ?.toUpperCase() ??
                                  'Tidak ada data..',
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            Text(
                              '( ${allSurahInThisJuz[DetailJuzController.index].name?.translation?.id?.toUpperCase() ?? 'Tidak ada data..'} )',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 10),
                            Text(
                              '${allSurahInThisJuz[DetailJuzController.index].numberOfVerses ?? 'Tidak ada data..'} Ayat | ${allSurahInThisJuz[DetailJuzController.index].revelation?.id}',
                              style: const TextStyle(
                                fontSize: 16,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: appPurpleLight2.withOpacity(0.3),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 5,
                      horizontal: 10,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      // crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              height: 40,
                              width: 40,
                              margin: const EdgeInsets.only(right: 10),
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                  image: AssetImage(
                                    Theme.of(context).brightness ==
                                            Brightness.dark
                                        ? "assets/image/octagonal-dark.png"
                                        : "assets/image/octagonal.png",
                                  ),
                                ),
                              ),
                              child: Center(
                                child: Text("${ayat.number?.inSurah}"),
                              ),
                            ),
                            Text(
                              allSurahInThisJuz[DetailJuzController.index]
                                      .name
                                      ?.transliteration
                                      ?.id ??
                                  "",
                              style: const TextStyle(
                                fontStyle: FontStyle.italic,
                                fontSize: 16,
                              ),
                            )
                          ],
                        ),
                        ValueListenableBuilder<AudioPlayer>(
                          valueListenable: DetailJuzController.player,
                          builder: (_, value, __) {
                            return Row(
                              children: [
                                ValueListenableBuilder<DatabaseManager>(
                                  valueListenable: DetailJuzController.database,
                                  builder: (_, value, __) {
                                    return IconButton(
                                      onPressed: () {
                                        showDialog(
                                          context: context,
                                          builder: (context) {
                                            return AlertDialog(
                                              backgroundColor: Theme.of(context)
                                                          .brightness ==
                                                      Brightness.dark
                                                  ? appPurpleLight1
                                                      .withOpacity(0.5)
                                                  : Colors.white,
                                              shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          20)),
                                              title: const Center(
                                                child: Text("BOOKMARK"),
                                              ),
                                              content: Text(
                                                "Pilih jenis bookmark ",
                                                textAlign: TextAlign.center,
                                              ),
                                              actions: [
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    ElevatedButton(
                                                      onPressed: () {
                                                        DetailJuzController
                                                            .addBookmark(
                                                                true,
                                                                allSurahInThisJuz,
                                                                ayat,
                                                                index);
                                                      },
                                                      style: ElevatedButton
                                                          .styleFrom(
                                                              primary:
                                                                  appPurple),
                                                      child: const Text(
                                                          "Last Read"),
                                                    ),
                                                    const SizedBox(width: 10),
                                                    ElevatedButton(
                                                      onPressed: () {
                                                        DetailJuzController
                                                            .addBookmark(
                                                                false,
                                                                allSurahInThisJuz,
                                                                ayat,
                                                                index);
                                                      },
                                                      style: ElevatedButton
                                                          .styleFrom(
                                                        primary: appPurple,
                                                      ),
                                                      child: const Text(
                                                          "BOOKMARK"),
                                                    ),
                                                  ],
                                                )
                                              ],
                                            );
                                          },
                                        );
                                      },
                                      icon: const Icon(Icons.bookmark_outline),
                                    );
                                  },
                                ),
                                (ayat.kondisiAudio == "stop")
                                    ? IconButton(
                                        onPressed: () {
                                          DetailJuzController.playAudio(ayat);
                                        },
                                        icon: const Icon(Icons.play_arrow),
                                      )
                                    : Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          (ayat.kondisiAudio == "playing")
                                              ? IconButton(
                                                  onPressed: () {
                                                    DetailJuzController
                                                        .pauseAudio(ayat);
                                                  },
                                                  icon: const Icon(Icons.pause),
                                                )
                                              : IconButton(
                                                  onPressed: () {
                                                    DetailJuzController
                                                        .resumeAudio(ayat);
                                                  },
                                                  icon: const Icon(
                                                      Icons.play_arrow),
                                                ),
                                          IconButton(
                                            onPressed: () {
                                              DetailJuzController.stopAudio(
                                                  ayat);
                                            },
                                            icon: const Icon(Icons.stop),
                                          ),
                                        ],
                                      )
                              ],
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  '${ayat.text?.arab}',
                  style: const TextStyle(
                    fontSize: 34,
                  ),
                  textAlign: TextAlign.end,
                ),
                const SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.only(left: 20),
                  child: Text(
                    '${ayat.text?.transliteration?.en}',
                    style: const TextStyle(
                        fontSize: 28, fontStyle: FontStyle.italic),
                    textAlign: TextAlign.end,
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  '${ayat.translation?.id}',
                  style: const TextStyle(
                    fontSize: 20,
                  ),
                  textAlign: TextAlign.left,
                ),
                const SizedBox(height: 50),
              ],
            ),
          ),
        );
      },
    );

    return Scaffold(
      appBar: AppBar(
        title: Builder(builder: (context) {
          return Text("Juz ${juz.juz}");
        }),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        controller: DetailJuzController.scrollC,
        children: allAyat,
      ),
    );
  }
}
