import 'package:flutter/material.dart';
import '../i18n/strings.g.dart';
import 'package:provider/provider.dart';
import '../data.dart';

class LanguageSwitch extends StatefulWidget {
  const LanguageSwitch({super.key});

  @override
  LanguageSwitchState createState() {
    return LanguageSwitchState();
  }
}

class LanguageSwitchState extends State<LanguageSwitch> {
  final List<Map<String, String>> langList = [
    {"name": t.followSystem, "code": "auto"},
    {"name": "English", "code": "en"},
    {"name": "简体中文", "code": "zh-Hans"},
    // {"name": "繁體中文", "code": "zh-Hant"},
    // {"name": "日本語", "code": "ja"}
  ];
  late Data data;

  @override
  void initState() {
    super.initState();
    data = context.read<Data>();
  }

  @override
  Widget build(BuildContext context) {
    bool isSelected(String langCode) {
      return data.langCode == langCode;
    }

    List<ListTile> buildListView() {
      final List<ListTile> listTiles = [];
      for (var item in langList) {
        final name = item.values.first;
        final code = item.values.last;
        final selected = isSelected(code); // "code"
        listTiles.add(ListTile(
          title: Text(name),
          trailing: selected ? const Icon(Icons.check) : null,
          selected: selected,
          onTap: () {
            data.setLangCode(code);
            if (code == 'auto') {
              LocaleSettings.useDeviceLocale();
            } else {
              LocaleSettings.setLocaleRaw(code);
            }

            setState(() {});
          },
        ));
      }
      return listTiles;
    }

    return Scaffold(
        appBar: AppBar(
          title: Text(t.languageSwitch),
        ),
        body: Padding(
            padding: const EdgeInsets.only(left: 10, right: 10),
            child: ListView(
              children: buildListView(),
            )));
  }
}
