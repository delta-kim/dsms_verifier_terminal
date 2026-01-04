import 'dart:async';
import 'package:installed_apps/app_info.dart';
import 'package:installed_apps/installed_apps.dart';
import 'package:agent_dart/agent_dart.dart' as agent_dart;
import 'NavigatorProvider.dart';
import 'home.dart';
import 'i18n/strings.g.dart';
import 'package:flutter/material.dart';
import 'data.dart';
import 'rqCodeLogin.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'dart:ui' as ui show PlaceholderAlignment;
import 'package:package_info_plus/package_info_plus.dart';
import 'util.dart';
import 'package:flutter_sms_inbox/flutter_sms_inbox.dart';
//import 'package:workmanager/workmanager.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  agent_dart.AgentDart.init();
  await GetStorage.init();
  runApp(
    TranslationProvider(
      child: MultiProvider(
        providers: [
          ChangeNotifierProvider<Data>(create: (ctx) => Data()),
        ],
        child: const MyApp(),
      ),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'DSMS Verifier terminal',
      navigatorKey: NavigatorProvider.navigatorKey,
      // locale: TranslationProvider.of(context).flutterLocale,
      // supportedLocales: AppLocaleUtils.supportedLocales,
      // localizationsDelegates: GlobalMaterialLocalizations.delegates,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.lightBlue),
        useMaterial3: true,
      ),
      home: const SplashScreen(),
    );
  }
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  late Data data;
  @override
  void initState() {
    data = context.read<Data>();
    super.initState();
    Timer(const Duration(seconds: 3), () {
      delayBranch();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      //   title: Text(widget.title),
      // ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        //crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          SizedBox(width: MediaQuery.sizeOf(context).width),
          Image.asset("assets/img/logo2.png"),
          Text("DSMS verifier terminal", textScaler: const TextScaler.linear(1.5), style: TextStyle(color: Theme.of(context).colorScheme.primary)),
        ],
      ),
    );
  }

  delayBranch() async {
    data.packageVersion = (await PackageInfo.fromPlatform()).data["version"];
    await data.loadAppIdentityToken;
    final langCode = await data.getLangCode();
    final acctCanisterId = await data.loadAcctCanisterId();
    if (langCode == "" || langCode == "auto") {
      LocaleSettings.useDeviceLocale(); // and this
      if (langCode == "") {
        data.setLangCode("auto");
      }
    } else {
      LocaleSettings.setLocaleRaw(langCode);
    }

    if (acctCanisterId != "" && data.appIdentityToken.isNotEmpty) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute<void>(
          builder: (BuildContext context) => const Home(),
        ),
      );
    } else {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute<void>(
          builder: (BuildContext context) => PreHint(data: data),
        ),
      );
    }
  }
}

class PreHint extends StatefulWidget {
  const PreHint({super.key, required this.data});

  final Data data;
  @override
  createState() => _PreHintState();
}

class _PreHintState extends State<PreHint> {
  bool iHaveRead = false;
  AppInfo? conflictingApp;
  final List<String> conflictingPackageNames = [
    "com.twitter.android",
    "com.tencent.mm",
    "com.whatsapp",
    "com.whatsapp.w4b",
    "com.facebook.katana",
    "kim.delta.mobile",
    "com.blockchainvault",
    "pi.browser",
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(t.usageTips),
      ),
      body: ListView(
        // mainAxisAlignment: MainAxisAlignment.center,
        // crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(width: MediaQuery.sizeOf(context).width, height: 20),
          //Image.asset("assets/img/logo2.png"),
          ListTile(subtitle: Text(t.usageTipStart, style: const TextStyle(color: Colors.orange))),
          textItem(t.usageTip1),
          textItem(t.usageTip2),
          Padding(
            padding: const EdgeInsets.fromLTRB(9, 3, 9, 3),
            child: Text.rich(t.usageTip3(n: const TextSpan(text: "3"), noLockScreen: TextSpan(text: t.noLockScreen, style: const TextStyle(color: Colors.orange))),
                style: const TextStyle(color: Colors.black54)),
          ),
          textItem(t.usageTip4),
          textItem(t.usageTip5),
          textItem(t.usageTip6),
          ListTile(subtitle: Text(t.usageTipEnd, style: const TextStyle(color: Colors.orange))),
          if (conflictingApp != null)
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(width: double.infinity, height: 10),
                Text(t.alreadyinstalledConflictingApp(name: conflictingApp!.name), style: const TextStyle(color: Colors.red)),
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.memory(
                    conflictingApp!.icon!,
                    width: 64,
                    height: 64,
                  ),
                ),
                Text(conflictingApp!.name)
              ],
            ),

          Center(
              child: Text.rich(TextSpan(children: [
            WidgetSpan(
              child: Checkbox(
                  value: iHaveRead,
                  onChanged: (value) {
                    if (value != null) {
                      setState(() {
                        iHaveRead = value;
                      });
                    }
                  }),
              alignment: ui.PlaceholderAlignment.middle,
            ),
            TextSpan(text: t.iHaveReadAndFollowed),
          ]))),

          Center(
            child: ElevatedButton(
              child: Text(t.nextStep),
              onPressed: () async {
                setState(() {
                  conflictingApp = null;
                });
                if (iHaveRead == false) {
                  Util.showAlert(t.pleaseCheckX(text: t.iHaveReadAndFollowed));
                  return;
                }
                for (String packageName in conflictingPackageNames) {
                  conflictingApp = await InstalledApps.getAppInfo(packageName, BuiltWith.flutter);
                  if (conflictingApp != null) {
                    setState(() {});
                    return;
                  }
                }

                Navigator.of(context).pushReplacement(
                  MaterialPageRoute<void>(
                    builder: (BuildContext context) => const QqCodeLogin(),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 30),
          Center(child: Text("v${widget.data.packageVersion}"))
        ],
      ),
    );
  }

  textItem(String text) {
    return Padding(padding: const EdgeInsets.fromLTRB(9, 3, 9, 3), child: Text(text, style: const TextStyle(color: Colors.black54)));
  }
}
