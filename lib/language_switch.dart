import 'package:flutter/material.dart';
import '../i18n/strings.g.dart';
import 'package:provider/provider.dart';
import '../data.dart';
import 'design_system.dart';

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

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: Text(t.languageSwitch, style: AppTypography.h2),
      ),
      body: Container(
        decoration: BoxDecoration(gradient: AppDesign.meshGradient(context)),
        child: SafeArea(
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
            itemCount: langList.length,
            itemBuilder: (context, index) {
              final item = langList[index];
              final name = item["name"]!;
              final code = item["code"]!;
              final selected = isSelected(code);

              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: AppDesign.glassMorphism(
                  padding: EdgeInsets.zero,
                  color: selected ? AppColors.electricBlue : Colors.white,
                  opacity: selected ? 0.2 : 0.05,
                  child: ListTile(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
                    title: Text(name, style: AppTypography.body.copyWith(fontWeight: selected ? FontWeight.bold : FontWeight.normal)),
                    trailing: selected ? const Icon(Icons.check_circle, color: AppColors.electricBlue) : null,
                    onTap: () {
                      data.setLangCode(code);
                      if (code == 'auto') {
                        LocaleSettings.useDeviceLocale();
                      } else {
                        LocaleSettings.setLocaleRaw(code);
                      }
                      setState(() {});
                    },
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
