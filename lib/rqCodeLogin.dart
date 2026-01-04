import 'dart:async';
import 'home.dart';
import 'i18n/strings.g.dart';
import 'package:flutter/material.dart';
import 'data.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:flutter/foundation.dart';
import 'package:device_info_plus/device_info_plus.dart';
import '../dids/IC.dart' as ic;
import 'package:permission_handler/permission_handler.dart';
import 'language_switch.dart';
import 'util.dart';

class QqCodeLogin extends StatefulWidget {
  const QqCodeLogin({super.key});

  @override
  State<QqCodeLogin> createState() => QqCodeLoginState();
}

class QqCodeLoginState extends State<QqCodeLogin> {
  late Data data;
  static final DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
  String platformName = "";
  String deviceModel = "";
  int appId = 1;
  String loginSessionId = "null";
  String sessionIdIsInvalidOrExpired = "";
  bool loginSuccessful = false;

  @override
  void initState() {
    data = context.read<Data>();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final mediaSize = MediaQuery.sizeOf(context);
    ColorScheme colorScheme = Theme.of(context).colorScheme;
    BoxShadow boxShadow = const BoxShadow(
      color: Color.fromRGBO(158, 158, 158, 0.5),
      offset: Offset(0.5, 0.5),
      blurRadius: 5,
      spreadRadius: 2,
    );
    return Scaffold(
      appBar: AppBar(
        backgroundColor: colorScheme.inversePrimary,
        title: Text(t.loginWithQRcode),
        actions: [Padding(padding: const EdgeInsets.only(right: 3), child: Text("v${data.packageVersion}"))],
      ),
      body: Column(
        children: [
          Align(
            alignment: Alignment.topRight,
            child: TextButton.icon(
                icon: const Icon(Icons.language), label: Text(t.switchLanguage), onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const LanguageSwitch()))),
          ),
          SizedBox(
            width: mediaSize.width,
            height: mediaSize.height * 0.05,
          ),
          Image.asset("assets/img/logo2.png", width: 120),
          Text("DSMS verifier access terminal", textScaler: const TextScaler.linear(1.2), style: TextStyle(color: colorScheme.primary)),
          const SizedBox(height: 20),
          if (loginSessionId == "null")
            OutlinedButton.icon(
                onPressed: () {
                  createSubAppAuthSession();
                },
                icon: const Icon(Icons.qr_code),
                label: Text(t.loginWithQRcode))
          else if (sessionIdIsInvalidOrExpired != "" || loginSuccessful)
            Stack(
              alignment: Alignment.center,
              children: <Widget>[
                Container(
                  decoration: BoxDecoration(boxShadow: [boxShadow]),
                  child: QrImageView(data: "sessionId Is Invalid Or Expired", version: QrVersions.auto, size: 150.0, padding: const EdgeInsets.all(6), backgroundColor: Colors.white70),
                ),
                Container(
                  color: const Color.fromRGBO(255, 255, 255, 0.9),
                  width: 156,
                  height: 156,
                ),
                Column(
                  children: [
                    if (!loginSuccessful)
                      ElevatedButton(
                          onPressed: () {
                            setState(() {
                              sessionIdIsInvalidOrExpired = "";
                            });
                            createSubAppAuthSession();
                          },
                          child: Text(t.refreshTheQRcode)),
                    Text(
                      loginSuccessful ? t.loginSuccessful : sessionIdIsInvalidOrExpired,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    )
                  ],
                )
              ],
            )
          else ...[
            Container(
              decoration: BoxDecoration(boxShadow: [boxShadow]),
              child: QrImageView(data: "delta://authorize|$loginSessionId", version: QrVersions.auto, size: 150.0, padding: const EdgeInsets.all(6), backgroundColor: Colors.white70),
            ),
            const SizedBox(height: 9),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(padding: const EdgeInsets.only(right: 6), child: Image.asset("assets/img/scanIt.png", width: 40, color: colorScheme.primary)),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [Text(t.useDeltaMobileApp), Text(t.scanQRcodeToLogin)],
                ),
              ],
            ),
          ],
          const Spacer(),
          Text(t.scanQRcodeSupportsDeltaversions, style: TextStyle(color: Colors.red))
        ],
      ),
    );
  }

  createSubAppAuthSession() async {
    if (platformName == "" || deviceModel == "") {
      // platformName = defaultTargetPlatform.toString();
      if (defaultTargetPlatform == TargetPlatform.android) {
        final androidInfo = await deviceInfoPlugin.androidInfo;
        platformName = "Android";
        deviceModel = androidInfo.model;
      } else if (defaultTargetPlatform == TargetPlatform.iOS) {
        IosDeviceInfo iosInfo = await deviceInfoPlugin.iosInfo;
        platformName = "IOS";
        deviceModel = iosInfo.model;
      } else {
        await Util.showAlert("This device type is not supported, only Android and IOS are supported.");
        return;
      }
    }
    final deviceDesc = "$platformName, $deviceModel";
    final sessionId = await ic.DappCenter.exec("createSubAppAuthSession", args: [deviceDesc, appId]);
    if (sessionId != null) {
      setState(() {
        loginSessionId = sessionId;
      });
      pollingLoginSessionId();
    }
  }

  pollingLoginSessionId() {
    bool responded = true;
    if (loginSessionId != "null") {
      Timer.periodic(const Duration(seconds: 5), (timer) async {
        if (responded) {
          responded = false;
          final identityTokenOpt = await ic.DappCenter.exec("querySubAppAuthByApp", args: [loginSessionId]);
          responded = true;
          print(identityTokenOpt);
          if (identityTokenOpt is List) {
            if (identityTokenOpt.isNotEmpty) {
              timer.cancel();
              Map appIdentityToken = identityTokenOpt.first;
              data.setAcctCanisterId(appIdentityToken["accCanisterId"]);
              appIdentityToken["expiration"] = appIdentityToken["expiration"].toInt();
              data.setAppIdentityToken(Map<String, dynamic>.from(appIdentityToken));
              setState(() {
                loginSuccessful = true;
              });
              Future.delayed(const Duration(seconds: 2), () {
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute<void>(
                    builder: (BuildContext context) => const Home(),
                  ),
                );
              });
            }
          } else {
            timer.cancel();
            setState(() {
              sessionIdIsInvalidOrExpired = data.icErrorMsg;
            });
          }
        }
      });
    }
  }
}
