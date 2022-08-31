import 'package:alquran/controller/detail_surah_controller.dart';

import 'package:alquran/models/detail_surah_model.dart' as detailSurah;

import 'package:alquran/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:scroll_to_index/scroll_to_index.dart';

import '../../database/bookmark.dart';

class DetailSurahView extends StatefulWidget {
  const DetailSurahView({Key? key}) : super(key: key);

  @override
  State<DetailSurahView> createState() => _DetailSurahViewState();
}

class _DetailSurahViewState extends State<DetailSurahView> {
  @override
  void dispose() {
    DetailSurahController.player.value.stop();
    DetailSurahController.player.value.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    DetailSurahController.player.value = AudioPlayer();
  }

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as Map;
    final name = args["name"];
    final number = args["number"];
    Map<String, dynamic>? bookmark;

    // SurahModel surah = ModalRoute.of(context)!.settings.arguments as SurahModel;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'SURAH ${name ?? 'Tidak ada data'}',
        ),
        centerTitle: true,
      ),
      body: FutureBuilder<detailSurah.DetailSurah>(
        future: DetailSurahController.getDetailSurah(number.toString()),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (!snapshot.hasData) {
            return const Center(
              child: Text("Tidak ada data."),
            );
          }

          detailSurah.DetailSurah surah = snapshot.data!;
          if (args["bookmark"] != null) {
            bookmark = args["bookmark"];
            if (bookmark!["index_ayat"] > 1) {
              DetailSurahController.scrollC.scrollToIndex(
                bookmark!["index_ayat"] + 2,
                preferPosition: AutoScrollPosition.begin,
              );
            }
          }
          print(bookmark);

          List<Widget> allAyat = List.generate(
            snapshot.data?.verses?.length ?? 0,
            (index) {
              detailSurah.Verse? ayat = snapshot.data?.verses?[index];
              return AutoScrollTag(
                key: ValueKey(index + 2),
                index: index + 2,
                controller: DetailSurahController.scrollC,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Container(
                      margin: const EdgeInsets.only(top: 10),
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
                            Container(
                              height: 40,
                              width: 40,
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
                                child: Text("${index + 1}"),
                              ),
                            ),
                            ValueListenableBuilder<AudioPlayer>(
                              valueListenable: DetailSurahController.player,
                              builder: (_, value, __) {
                                return Row(
                                  children: [
                                    ValueListenableBuilder<DatabaseManager>(
                                      valueListenable:
                                          DetailSurahController.database,
                                      builder: (_, value, __) {
                                        return IconButton(
                                          onPressed: () {
                                            showDialog(
                                              context: context,
                                              builder: (context) {
                                                return AlertDialog(
                                                  backgroundColor:
                                                      Theme.of(context)
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
                                                  content: const Text(
                                                    "Pilih jenis bookmark ",
                                                    textAlign: TextAlign.center,
                                                  ),
                                                  actions: [
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: [
                                                        ElevatedButton(
                                                          onPressed: () {
                                                            DetailSurahController
                                                                .addBookmark(
                                                                    true,
                                                                    snapshot
                                                                        .data!,
                                                                    ayat!,
                                                                    index);
                                                          },
                                                          style: ElevatedButton
                                                              .styleFrom(
                                                                  primary:
                                                                      appPurple),
                                                          child: const Text(
                                                              "Last Read"),
                                                        ),
                                                        const SizedBox(
                                                            width: 10),
                                                        ElevatedButton(
                                                          onPressed: () {
                                                            DetailSurahController
                                                                .addBookmark(
                                                                    false,
                                                                    snapshot
                                                                        .data!,
                                                                    ayat!,
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
                                          icon: const Icon(
                                              Icons.bookmark_outline),
                                        );
                                      },
                                    ),
                                    (ayat?.kondisiAudio == "stop")
                                        ? IconButton(
                                            onPressed: () {
                                              DetailSurahController.playAudio(
                                                  ayat);
                                            },
                                            icon: const Icon(Icons.play_arrow),
                                          )
                                        : Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              (ayat?.kondisiAudio == "playing")
                                                  ? IconButton(
                                                      onPressed: () {
                                                        DetailSurahController
                                                            .pauseAudio(ayat!);
                                                      },
                                                      icon: const Icon(
                                                          Icons.pause),
                                                    )
                                                  : IconButton(
                                                      onPressed: () {
                                                        DetailSurahController
                                                            .resumeAudio(ayat!);
                                                      },
                                                      icon: const Icon(
                                                          Icons.play_arrow),
                                                    ),
                                              IconButton(
                                                onPressed: () {
                                                  DetailSurahController
                                                      .stopAudio(ayat!);
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
                      '${ayat?.text?.arab}',
                      style: const TextStyle(
                        fontSize: 34,
                      ),
                      textAlign: TextAlign.end,
                    ),
                    const SizedBox(height: 20),
                    Text(
                      '${ayat?.text?.transliteration?.en}',
                      style: const TextStyle(
                        fontSize: 34,
                      ),
                      textAlign: TextAlign.end,
                    ),
                    const SizedBox(height: 20),
                    Text(
                      '${ayat?.translation?.id}',
                      style: const TextStyle(
                        fontSize: 20,
                      ),
                      textAlign: TextAlign.start,
                    ),
                    const SizedBox(height: 50),
                  ],
                ),
              );
            },
          );

          return ListView(
            padding: const EdgeInsets.all(20),
            controller: DetailSurahController.scrollC,
            children: [
              AutoScrollTag(
                key: const ValueKey(0),
                index: 0,
                controller: DetailSurahController.scrollC,
                child: GestureDetector(
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
                                  "Tafsir ${surah.name?.transliteration?.id ?? "Tidak ada data"}")),
                          content: Text(
                            surah.tafsir?.id ??
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
                            surah.name?.transliteration?.id?.toUpperCase() ??
                                'Tidak ada data..',
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          Text(
                            '( ${surah.name?.translation?.id?.toUpperCase() ?? 'Tidak ada data..'} )',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            '${surah.numberOfVerses ?? 'Tidak ada data..'} Ayat | ${surah.revelation?.id}',
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
              ),
              AutoScrollTag(
                key: const ValueKey(1),
                index: 1,
                controller: DetailSurahController.scrollC,
                child: const SizedBox(height: 20),
              ),
              ...allAyat,
            ],
          );
        },
      ),
    );
  }
}
