import 'package:alquran/controller/detail_juz_controller.dart';
import 'package:alquran/controller/detail_surah_controller.dart';
import 'package:alquran/controller/home_controller.dart';
import 'package:alquran/controller/theme_controller.dart';
import 'package:alquran/models/surah_model.dart';

import 'package:alquran/utils/colors.dart';

import 'package:flutter/material.dart';

import '../../database/bookmark.dart';
import '../../models/juz_model.dart' as detailJuz;

class HomeView extends StatelessWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Al-Quran Apps"),
        centerTitle: true,
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.search),
          ),
        ],
      ),
      body: DefaultTabController(
        length: 3,
        child: Padding(
          padding: const EdgeInsets.only(top: 20, right: 20, left: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Assalamualaikum',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).brightness == Brightness.dark
                      ? appWhite
                      : appPurpleDark,
                ),
              ),
              const SizedBox(height: 10),
              ValueListenableBuilder<HomeController>(
                  valueListenable: DetailSurahController.homeC,
                  builder: (_, value, __) {
                    return ValueListenableBuilder<HomeController>(
                        valueListenable: DetailJuzController.homeC,
                        builder: (_, value, __) {
                          return ValueListenableBuilder<DatabaseManager>(
                            valueListenable: HomeController.database,
                            builder: (_, value, __) {
                              return FutureBuilder<Map<String, dynamic>?>(
                                future: HomeController.getLastRead(),
                                builder: (context, snapshot) {
                                  if (snapshot.connectionState ==
                                      ConnectionState.waiting) {
                                    return Container(
                                      margin: const EdgeInsets.symmetric(
                                          vertical: 20),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(20),
                                        gradient: const LinearGradient(
                                          colors: [
                                            appPurpleLight1,
                                            appPurpleDark,
                                          ],
                                        ),
                                      ),
                                      child: Stack(
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.all(20.0),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Row(
                                                  children: const [
                                                    Icon(
                                                      Icons.menu_book_rounded,
                                                      color: appWhite,
                                                    ),
                                                    SizedBox(width: 10),
                                                    Text(
                                                      "Terakhir dibaca",
                                                      style: TextStyle(
                                                          color: Colors.white),
                                                    ),
                                                  ],
                                                ),
                                                const SizedBox(height: 30),
                                                const Text(
                                                  "Loading...",
                                                  style: TextStyle(
                                                    color: appWhite,
                                                    fontSize: 18,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                                const SizedBox(height: 10),
                                                const Text(
                                                  "",
                                                  style: TextStyle(
                                                    color: appWhite,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Positioned(
                                            bottom: -60,
                                            right: 0,
                                            child: SizedBox(
                                              width: 200,
                                              height: 200,
                                              child: Image.asset(
                                                'assets/image/alquran.png',
                                                fit: BoxFit.contain,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  }
                                  Map<String, dynamic>? lastRead =
                                      snapshot.data;
                                  return Container(
                                    margin: const EdgeInsets.symmetric(
                                        vertical: 20),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20),
                                      gradient: const LinearGradient(
                                        colors: [
                                          appPurpleLight1,
                                          appPurpleDark,
                                        ],
                                      ),
                                    ),
                                    child: Material(
                                      color: Colors.transparent,
                                      borderRadius: BorderRadius.circular(20),
                                      child: InkWell(
                                        onLongPress: () {
                                          if (lastRead != null) {
                                            showDialog(
                                              context: context,
                                              barrierDismissible: false,
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
                                                    child: Text(
                                                        "Menghapus last read"),
                                                  ),
                                                  content: const Text(
                                                    "Apakah kamu yakin ingin menghapus last read bookmark ? ",
                                                  ),
                                                  actions: [
                                                    TextButton(
                                                      onPressed: () =>
                                                          Navigator.pop(
                                                              context),
                                                      child:
                                                          const Text("BATAL"),
                                                    ),
                                                    TextButton(
                                                      onPressed: () {
                                                        HomeController
                                                            .deleteBookmark(
                                                          lastRead['id'],
                                                        );
                                                        Navigator.pop(context);
                                                      },
                                                      child:
                                                          const Text("HAPUS"),
                                                    )
                                                  ],
                                                );
                                              },
                                            );
                                          }
                                        },
                                        onTap: () {
                                          if (lastRead != null) {
                                            switch (lastRead["via"]) {
                                              case "juz":
                                                print("GO TO JUZ");
                                                detailJuz.DetailJuz? juz =
                                                    HomeController.allJuz[
                                                        lastRead["juz"] - 1];
                                                String nameStart = juz
                                                        .juzStartInfo
                                                        ?.split(" - ")
                                                        .first ??
                                                    "";
                                                String nameEnd = juz.juzEndInfo
                                                        ?.split(" - ")
                                                        .first ??
                                                    "";

                                                List<SurahModel>
                                                    rawAllSurahInJuz = [];
                                                List<SurahModel> allSurahInJuz =
                                                    [];

                                                for (SurahModel item
                                                    in HomeController
                                                        .allSurah) {
                                                  rawAllSurahInJuz.add(item);
                                                  if (item
                                                          .name!
                                                          .transliteration!
                                                          .id ==
                                                      nameEnd) {
                                                    break;
                                                  }
                                                }

                                                for (SurahModel item
                                                    in rawAllSurahInJuz.reversed
                                                        .toList()) {
                                                  allSurahInJuz.add(item);
                                                  if (item
                                                          .name!
                                                          .transliteration!
                                                          .id ==
                                                      nameStart) {
                                                    break;
                                                  }
                                                }
                                                Navigator.pushNamed(
                                                  context,
                                                  '/detail-juz',
                                                  arguments: {
                                                    "juz": juz,
                                                    "surah": allSurahInJuz
                                                        .reversed
                                                        .toList(),
                                                    "bookmark": lastRead,
                                                  },
                                                );
                                                break;
                                              default:
                                                Navigator.pushNamed(
                                                  context,
                                                  '/detail-surah',
                                                  arguments: {
                                                    "name": lastRead["surah"]
                                                        .toString()
                                                        .replaceAll("+", "'")
                                                        .toUpperCase(),
                                                    "number": lastRead[
                                                        "number_surah"],
                                                    "bookmark": lastRead,
                                                  },
                                                );
                                            }
                                            print(lastRead);
                                          }
                                        },
                                        child: Stack(
                                          children: [
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(20.0),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Row(
                                                    children: const [
                                                      Icon(
                                                        Icons.menu_book_rounded,
                                                        color: appWhite,
                                                      ),
                                                      SizedBox(width: 10),
                                                      Text(
                                                        "Terakhir dibaca",
                                                        style: TextStyle(
                                                            color:
                                                                Colors.white),
                                                      ),
                                                    ],
                                                  ),
                                                  const SizedBox(height: 30),
                                                  Text(
                                                    lastRead == null
                                                        ? ""
                                                        : "${lastRead['surah'].toString().replaceAll("+", "'")}",
                                                    style: const TextStyle(
                                                      color: appWhite,
                                                      fontSize: 18,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                  const SizedBox(height: 10),
                                                  Text(
                                                    lastRead == null
                                                        ? "Belum ada data"
                                                        : "Juz ${lastRead['juz']} | Ayat ${lastRead['ayat']}",
                                                    style: const TextStyle(
                                                      color: appWhite,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Positioned(
                                              bottom: -60,
                                              right: 0,
                                              child: SizedBox(
                                                width: 200,
                                                height: 200,
                                                child: Image.asset(
                                                  'assets/image/alquran.png',
                                                  fit: BoxFit.contain,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              );
                            },
                          );
                        });
                  }),
              const TabBar(
                tabs: [
                  Tab(
                    child: Text(
                      'Surah',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Tab(
                    child: Text(
                      'Juz',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Tab(
                    child: Text(
                      'Bookmark',
                      style: TextStyle(),
                    ),
                  ),
                ],
              ),
              Expanded(
                child: TabBarView(
                  children: [
                    //* Bagian Detail surah
                    FutureBuilder<List<SurahModel>>(
                      future: HomeController.getAllSurah(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                        if (!snapshot.hasData) {
                          return const Center(
                            child: Text("Tidak ada data."),
                          );
                        }
                        // print(snapshot.data);
                        return ListView.builder(
                          itemCount: snapshot.data?.length ?? 0,
                          itemBuilder: (context, index) {
                            SurahModel surah = snapshot.data![index];
                            return ListTile(
                              onTap: () {
                                Navigator.pushNamed(
                                  context,
                                  '/detail-surah',
                                  arguments: {
                                    "name": surah.name!.transliteration!.id!
                                        .toUpperCase(),
                                    "number": surah.number,
                                  },
                                );
                              },
                              leading: ValueListenableBuilder<bool>(
                                valueListenable: ThemeController.isDark,
                                builder: (_, value, __) {
                                  return Container(
                                    width: 40,
                                    height: 40,
                                    // color: Colors.amber,
                                    decoration: BoxDecoration(
                                      image: DecorationImage(
                                        image: AssetImage(
                                          value
                                              ? "assets/image/octagonal-dark.png"
                                              : "assets/image/octagonal.png",
                                        ),
                                      ),
                                    ),
                                    child: Center(
                                      child: Text(
                                        // "${surah?.nomor ?? '0'}",
                                        "${surah.number ?? '0'}",
                                      ),
                                    ),
                                  );
                                },
                              ),
                              title: Text(
                                // surah?.namaLatin ?? 'Tidak ada data',
                                surah.name?.transliteration?.id ??
                                    'Tidak ada data',
                              ),
                              subtitle: Text(
                                "${surah.numberOfVerses ?? 'Tidak ada data'} Ayat | ${surah.revelation?.id ?? 'Tidak ada data'}",
                              ),
                              trailing:
                                  Text(surah.name?.short ?? "Tidak ada data"),
                            );
                          },
                        );
                      },
                    ),

                    //* Bagian Juz
                    FutureBuilder<List<detailJuz.DetailJuz>>(
                      future: HomeController.getAllJuz(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                        if (!snapshot.hasData) {
                          return const Center(
                            child: Text("Tidak ada data."),
                          );
                        }

                        return ListView.builder(
                          itemCount: snapshot.data?.length ?? 0,
                          itemBuilder: (context, index) {
                            detailJuz.DetailJuz? juz = snapshot.data?[index];

                            //* Mendapatkan start juz sampai endnya di split
                            String nameStart =
                                juz?.juzStartInfo?.split(" - ").first ?? "";
                            String nameEnd =
                                juz?.juzEndInfo?.split(" - ").first ?? "";

                            List<SurahModel> rawAllSurahInJuz = [];
                            List<SurahModel> allSurahInJuz = [];

                            for (SurahModel item in HomeController.allSurah) {
                              rawAllSurahInJuz.add(item);
                              if (item.name!.transliteration!.id == nameEnd) {
                                break;
                              }
                            }

                            for (SurahModel item
                                in rawAllSurahInJuz.reversed.toList()) {
                              allSurahInJuz.add(item);
                              if (item.name!.transliteration!.id == nameStart) {
                                break;
                              }
                            }

                            return ListTile(
                              onTap: () {
                                Navigator.pushNamed(
                                  context,
                                  '/detail-juz',
                                  arguments: {
                                    "juz": juz,
                                    "surah": allSurahInJuz.reversed.toList(),
                                  },
                                );
                              },
                              leading: Container(
                                width: 40,
                                height: 40,
                                // color: Colors.amber,
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                    image: AssetImage(
                                        ThemeController.isDark.value
                                            ? "assets/image/octagonal-dark.png"
                                            : "assets/image/octagonal.png"),
                                  ),
                                ),
                                child: Center(
                                  child: Text(
                                    "${index + 1}",
                                  ),
                                ),
                              ),
                              title: Text(
                                "Juz ${index + 1}",
                              ),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Mulai dari ${juz?.juzStartInfo ?? "Tidak ada data"}",
                                  ),
                                  Text(
                                    "Sampai ${juz?.juzEndInfo ?? "Tidak ada data"}",
                                  ),
                                ],
                              ),
                            );
                          },
                        );
                      },
                    ),

                    //* Bagian Bookmark
                    ValueListenableBuilder<DatabaseManager>(
                      valueListenable: HomeController.database,
                      builder: (_, value, __) {
                        return FutureBuilder<List<Map<String, dynamic>>>(
                          future: HomeController.getBookMark(),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return const Center(
                                child: CircularProgressIndicator(),
                              );
                            }
                            if (snapshot.data!.isEmpty) {
                              return const Center(
                                child: Text("Bookmark tidak tersedia"),
                              );
                            }

                            return ListView.builder(
                              itemCount: snapshot.data!.length,
                              itemBuilder: (context, index) {
                                Map<String, dynamic> data =
                                    snapshot.data![index];
                                return ListTile(
                                  onTap: () {
                                    switch (data["via"]) {
                                      case "juz":
                                        print("GO TO JUZ");
                                        detailJuz.DetailJuz? juz =
                                            HomeController
                                                .allJuz[data["juz"] - 1];
                                        String nameStart = juz.juzStartInfo
                                                ?.split(" - ")
                                                .first ??
                                            "";
                                        String nameEnd = juz.juzEndInfo
                                                ?.split(" - ")
                                                .first ??
                                            "";

                                        List<SurahModel> rawAllSurahInJuz = [];
                                        List<SurahModel> allSurahInJuz = [];

                                        for (SurahModel item
                                            in HomeController.allSurah) {
                                          rawAllSurahInJuz.add(item);
                                          if (item.name!.transliteration!.id ==
                                              nameEnd) {
                                            break;
                                          }
                                        }

                                        for (SurahModel item in rawAllSurahInJuz
                                            .reversed
                                            .toList()) {
                                          allSurahInJuz.add(item);
                                          if (item.name!.transliteration!.id ==
                                              nameStart) {
                                            break;
                                          }
                                        }
                                        Navigator.pushNamed(
                                          context,
                                          '/detail-juz',
                                          arguments: {
                                            "juz": juz,
                                            "surah":
                                                allSurahInJuz.reversed.toList(),
                                            "bookmark": data,
                                          },
                                        );
                                        break;
                                      default:
                                        Navigator.pushNamed(
                                          context,
                                          '/detail-surah',
                                          arguments: {
                                            "name": data["surah"]
                                                .toString()
                                                .replaceAll("+", "'")
                                                .toUpperCase(),
                                            "number": data["number_surah"],
                                            "bookmark": data,
                                          },
                                        );
                                    }
                                  },
                                  leading: Container(
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
                                  title: Text(data['surah']
                                      .toString()
                                      .replaceAll("+", "'")),
                                  subtitle: Text(
                                      "Ayat ${data['ayat']} - Via ${data['via']}"),
                                  trailing: IconButton(
                                    onPressed: () {
                                      HomeController.deleteBookmark(data['id']);
                                    },
                                    icon: const Icon(Icons.delete),
                                  ),
                                );
                              },
                            );
                          },
                        );
                      },
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          ThemeController.setTheme();
        },
        child: ValueListenableBuilder<bool>(
          valueListenable: ThemeController.isDark,
          builder: (_, value, __) {
            return Icon(
              Icons.color_lens,
              color: value ? appPurpleDark : appWhite,
            );
          },
        ),
      ),
    );
  }
}
