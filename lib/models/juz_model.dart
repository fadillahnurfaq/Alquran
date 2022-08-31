// To parse this JSON data, do
//
//     final detailJuz = detailJuzFromJson(jsonString);

import 'dart:convert';

DetailJuz detailJuzFromJson(String str) => DetailJuz.fromJson(json.decode(str));

String detailJuzToJson(DetailJuz data) => json.encode(data.toJson());

class DetailJuz {
  DetailJuz({
    this.juz,
    this.juzStartSurahNumber,
    this.juzEndSurahNumber,
    this.juzStartInfo,
    this.juzEndInfo,
    this.totalVerses,
    this.verses,
  });

  int? juz;
  int? juzStartSurahNumber;
  dynamic? juzEndSurahNumber;
  String? juzStartInfo;
  String? juzEndInfo;
  int? totalVerses;
  List<Verse>? verses;

  factory DetailJuz.fromJson(Map<String, dynamic> json) => DetailJuz(
        juz: json["juz"],
        juzStartSurahNumber: json["juzStartSurahNumber"],
        juzEndSurahNumber: json["juzEndSurahNumber"],
        juzStartInfo: json["juzStartInfo"],
        juzEndInfo: json["juzEndInfo"],
        totalVerses: json["totalVerses"],
        verses: json["verses"] == null
            ? []
            : List<Verse>.from(json["verses"].map((x) => Verse.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "juz": juz,
        "juzStartSurahNumber": juzStartSurahNumber,
        "juzEndSurahNumber": juzEndSurahNumber,
        "juzStartInfo": juzStartInfo,
        "juzEndInfo": juzEndInfo,
        "totalVerses": totalVerses,
        "verses": verses == null
            ? {}
            : List<dynamic>.from(verses!.map((x) => x.toJson())),
      };
}

class Verse {
  Verse({
    this.number,
    this.meta,
    this.text,
    this.translation,
    this.audio,
    this.tafsir,
    this.kondisiAudio = 'stop',
  });

  String kondisiAudio;
  Number? number;
  Meta? meta;
  Text? text;
  Translation? translation;
  Audio? audio;
  Tafsir? tafsir;

  factory Verse.fromJson(Map<String, dynamic> json) => Verse(
        number: Number.fromJson(json["number"]),
        meta: Meta.fromJson(json["meta"]),
        text: Text.fromJson(json["text"]),
        translation: Translation.fromJson(json["translation"]),
        audio: Audio.fromJson(json["audio"]),
        tafsir: Tafsir.fromJson(json["tafsir"]),
      );

  Map<String, dynamic> toJson() => {
        "number": number?.toJson(),
        "meta": meta?.toJson(),
        "text": text?.toJson(),
        "translation": translation?.toJson(),
        "audio": audio?.toJson(),
        "tafsir": tafsir?.toJson(),
        "kondisiAudio": kondisiAudio,
      };
}

class Audio {
  Audio({
    this.primary,
    this.secondary,
  });

  String? primary;
  List<String>? secondary;

  factory Audio.fromJson(Map<String, dynamic> json) => Audio(
        primary: json["primary"],
        secondary: List<String>.from(json["secondary"].map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "primary": primary,
        "secondary": secondary == null
            ? {}
            : List<dynamic>.from(secondary!.map((x) => x)),
      };
}

class Meta {
  Meta({
    this.juz,
    this.page,
    this.manzil,
    this.ruku,
    this.hizbQuarter,
    this.sajda,
  });

  int? juz;
  int? page;
  int? manzil;
  int? ruku;
  int? hizbQuarter;
  Sajda? sajda;

  factory Meta.fromJson(Map<String, dynamic> json) => Meta(
        juz: json["juz"],
        page: json["page"],
        manzil: json["manzil"],
        ruku: json["ruku"],
        hizbQuarter: json["hizbQuarter"],
        sajda: Sajda.fromJson(json["sajda"]),
      );

  Map<String, dynamic> toJson() => {
        "juz": juz,
        "page": page,
        "manzil": manzil,
        "ruku": ruku,
        "hizbQuarter": hizbQuarter,
        "sajda": sajda?.toJson(),
      };
}

class Sajda {
  Sajda({
    this.recommended,
    this.obligatory,
  });

  bool? recommended;
  bool? obligatory;

  factory Sajda.fromJson(Map<String, dynamic> json) => Sajda(
        recommended: json["recommended"],
        obligatory: json["obligatory"],
      );

  Map<String, dynamic> toJson() => {
        "recommended": recommended,
        "obligatory": obligatory,
      };
}

class Number {
  Number({
    this.inQuran,
    this.inSurah,
  });

  int? inQuran;
  int? inSurah;

  factory Number.fromJson(Map<String, dynamic> json) => Number(
        inQuran: json["inQuran"],
        inSurah: json["inSurah"],
      );

  Map<String, dynamic> toJson() => {
        "inQuran": inQuran,
        "inSurah": inSurah,
      };
}

class Tafsir {
  Tafsir({
    this.id,
  });

  Id? id;

  factory Tafsir.fromJson(Map<String, dynamic> json) => Tafsir(
        id: Id.fromJson(json["id"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id?.toJson(),
      };
}

class Id {
  Id({
    this.short,
    this.long,
  });

  String? short;
  String? long;

  factory Id.fromJson(Map<String, dynamic> json) => Id(
        short: json["short"],
        long: json["long"],
      );

  Map<String, dynamic> toJson() => {
        "short": short,
        "long": long,
      };
}

class Text {
  Text({
    this.arab,
    this.transliteration,
  });

  String? arab;
  Transliteration? transliteration;

  factory Text.fromJson(Map<String, dynamic> json) => Text(
        arab: json["arab"],
        transliteration: Transliteration.fromJson(json["transliteration"]),
      );

  Map<String, dynamic> toJson() => {
        "arab": arab,
        "transliteration": transliteration?.toJson(),
      };
}

class Transliteration {
  Transliteration({
    this.en,
  });

  String? en;

  factory Transliteration.fromJson(Map<String, dynamic> json) =>
      Transliteration(
        en: json["en"],
      );

  Map<String, dynamic> toJson() => {
        "en": en,
      };
}

class Translation {
  Translation({
    this.en,
    this.id,
  });

  String? en;
  String? id;

  factory Translation.fromJson(Map<String, dynamic> json) => Translation(
        en: json["en"],
        id: json["id"],
      );

  Map<String, dynamic> toJson() => {
        "en": en,
        "id": id,
      };
}
