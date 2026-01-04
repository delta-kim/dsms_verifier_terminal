import 'dart:typed_data';

import 'package:characters/characters.dart';

import 'wordsEn.dart';
import 'wordsZhs.dart';
import 'wordsZht.dart';
import 'wordsKo.dart';

enum EncodeLang {
  en('en', enList),
  zhs('zhs', zhsList),
  zht('zht', zhtList),
  ko('ko', koList);

  final String label;
  final List<String> _list;
  const EncodeLang(this.label, this._list);
}

const List<String> singleCharacterEn = [
  "a",
  "b",
  "c",
  "d",
  "e",
  "f",
  "g",
  "h",
  "i",
  "j",
  "k",
  "l",
  "m",
  "n",
  "o",
  "p",
  "q",
  "r",
  "s",
  "t",
  "u",
  "v",
  "w",
  "x",
  "y",
  "z",
  "A",
  "B",
  "C",
  "D",
  "E",
  "F",
  "G",
  "H",
  "I",
  "J",
  "K",
  "L",
  "M",
  "N",
  "O",
  "P",
  "Q",
  "R",
  "S",
  "T",
  "U",
  "V",
  "W",
  "X",
  "Y",
  "Z",
  "!",
  "^",
  "#",
  "\$",
  "@",
  "&",
  "'",
  "(",
  ")",
  "*",
  "+",
  ",",
  "-",
  ".",
  ":",
  ";",
  "<",
  "=",
  ">",
  "?",
  "~",
  "_",
  "[",
  "]",
  "`",
  "7",
  "8",
  "9",
];

class DSMSwords {
  static String fromBytes(Uint8List bytes, EncodeLang encode) {
    return bytes.map((i) => encode._list[i]).toList().join("");
  }

  static Uint8List toBytes(String words, EncodeLang encode) {
    List<int> bytes = [];
    if (encode.label == "en") {
      while (words.isNotEmpty) {
        if (singleCharacterEn.contains(words[0])) {
          bytes.add(encode._list.indexOf(words[0]));
          words = words.substring(1);
        } else {
          bytes.add(encode._list.indexOf(words.substring(0, 2)));
          words = words.substring(2);
        }
      }
      return Uint8List.fromList(bytes);
    }
    for (String char in words.characters) {
      bytes.add(encode._list.indexOf(char));
    }
    return Uint8List.fromList(bytes);
  }
}
