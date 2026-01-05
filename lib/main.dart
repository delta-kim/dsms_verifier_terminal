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
import 'design_system.dart';
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
      debugShowCheckedModeBanner: false,
      title: 'DSMS Verifier terminal',
      navigatorKey: NavigatorProvider.navigatorKey,
      // locale: TranslationProvider.of(context).flutterLocale,
      // supportedLocales: AppLocaleUtils.supportedLocales,
      // localizationsDelegates: GlobalMaterialLocalizations.delegates,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.electricBlue,
          brightness: Brightness.dark,
          surface: AppColors.background,
        ),
        scaffoldBackgroundColor: AppColors.background,
        useMaterial3: true,
        fontFamily: 'Roboto',
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
      body: Container(
        decoration: BoxDecoration(
          gradient: AppDesign.meshGradient(context),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AppDesign.glassMorphism(
                padding: const EdgeInsets.all(32),
                child: Hero(
                  tag: 'logo',
                  child: Image.asset(
                    "assets/img/logo2.png",
                    width: 120,
                    height: 120,
                  ),
                ),
              ),
              const SizedBox(height: 32),
              Text(
                "DSMS Verifier Terminal",
                style: AppTypography.h1.copyWith(
                  letterSpacing: 1.2,
                ),
              ),
              const SizedBox(height: 8),
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.electricBlue,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ],
          ),
        ),
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
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: Text(t.usageTips, style: AppTypography.h2),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: AppDesign.meshGradient(context),
        ),
        child: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: ListView(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                  children: [
                    AppDesign.glassMorphism(
                      padding: const EdgeInsets.all(16),
                      color: Colors.orange,
                      opacity: 0.05,
                      child: Text(
                        t.usageTipStart,
                        style: AppTypography.body.copyWith(
                            color: Colors.orangeAccent,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    const SizedBox(height: 16),
                    _glassTipItem(t.usageTip1, Icons.info_outline),
                    _glassTipItem(t.usageTip2, Icons.security),
                    _glassTipItemRich(
                      t.usageTip3(
                        n: const TextSpan(
                            text: "3",
                            style: TextStyle(fontWeight: FontWeight.bold)),
                        noLockScreen: TextSpan(
                            text: t.noLockScreen,
                            style: const TextStyle(
                                color: Colors.orangeAccent,
                                fontWeight: FontWeight.bold)),
                      ),
                      Icons.lock_open,
                    ),
                    _glassTipItem(t.usageTip4, Icons.settings_applications),
                    _glassTipItem(t.usageTip5, Icons.battery_alert),
                    _glassTipItem(t.usageTip6, Icons.notification_important),
                    const SizedBox(height: 16),
                    AppDesign.glassMorphism(
                      padding: const EdgeInsets.all(16),
                      color: Colors.orange,
                      opacity: 0.05,
                      child: Text(
                        t.usageTipEnd,
                        style: AppTypography.body
                            .copyWith(color: Colors.orangeAccent),
                      ),
                    ),
                    if (conflictingApp != null) ...[
                      const SizedBox(height: 24),
                      AppDesign.glassMorphism(
                        padding: const EdgeInsets.all(20),
                        color: Colors.red,
                        child: Column(
                          children: [
                            Text(
                                t.alreadyinstalledConflictingApp(
                                    name: conflictingApp!.name),
                                style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold)),
                            const SizedBox(height: 12),
                            ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: Image.memory(conflictingApp!.icon!,
                                  width: 48, height: 48),
                            ),
                          ],
                        ),
                      ),
                    ],
                    const SizedBox(height: 24),
                    AppDesign.glassMorphism(
                      borderRadius: 20,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 24, vertical: 20),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          InkWell(
                            onTap: () => setState(() => iHaveRead = !iHaveRead),
                            child: Row(
                              children: [
                                Checkbox(
                                  value: iHaveRead,
                                  activeColor: AppColors.electricBlue,
                                  checkColor: Colors.white,
                                  side: BorderSide(
                                    color: Colors.white.withOpacity(0.4),
                                    width: 2,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  onChanged: (value) =>
                                      setState(() => iHaveRead = value!),
                                ),
                                Expanded(
                                  child: Text(t.iHaveReadAndFollowed,
                                      style: AppTypography.body),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 16),
                          SizedBox(
                            width: double.infinity,
                            height: 56,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.electricBlue,
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16)),
                                elevation: 0,
                              ),
                              child: Text(t.nextStep,
                                  style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold)),
                              onPressed: () async {
                                setState(() {
                                  conflictingApp = null;
                                });
                                if (iHaveRead == false) {
                                  Util.showAlert(t.pleaseCheckX(
                                      text: t.iHaveReadAndFollowed));
                                  return;
                                }
                                for (String packageName
                                    in conflictingPackageNames) {
                                  try {
                                    bool? installed =
                                        await InstalledApps.isAppInstalled(
                                            packageName);
                                    if (installed == true) {
                                      conflictingApp =
                                          await InstalledApps.getAppInfo(
                                              packageName, BuiltWith.flutter);
                                      if (conflictingApp != null) {
                                        setState(() {});
                                        return;
                                      }
                                    }
                                  } catch (e) {
                                    debugPrint(
                                        "Error checking app $packageName: $e");
                                  }
                                }

                                if (!mounted) return;
                                Navigator.of(context).pushReplacement(
                                  MaterialPageRoute<void>(
                                    builder: (BuildContext context) =>
                                        const QqCodeLogin(),
                                  ),
                                );
                              },
                            ),
                          ),
                          const SizedBox(height: 12),
                          Text("v${widget.data.packageVersion}",
                              style: AppTypography.caption),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _glassTipItem(String text, IconData icon) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: AppDesign.glassMorphism(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Icon(icon, color: AppColors.electricBlue, size: 24),
            const SizedBox(width: 16),
            Expanded(child: Text(text, style: AppTypography.body)),
          ],
        ),
      ),
    );
  }

  Widget _glassTipItemRich(InlineSpan span, IconData icon) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: AppDesign.glassMorphism(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Icon(icon, color: AppColors.electricBlue, size: 24),
            const SizedBox(width: 16),
            Expanded(child: Text.rich(span, style: AppTypography.body)),
          ],
        ),
      ),
    );
  }
}
