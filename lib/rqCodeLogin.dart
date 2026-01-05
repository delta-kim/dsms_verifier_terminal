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
import 'design_system.dart';

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
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: Text(t.loginWithQRcode, style: AppTypography.h2),
        actions:[
            TextButton.icon(
                  icon: const Icon(Icons.language, color: AppColors.electricBlue),
                  label: Text(t.switchLanguage, style: AppTypography.body.copyWith(color: AppColors.electricBlue)),
                  onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const LanguageSwitch())),
                ),
            
        ],
      ),
      body: Container(
        width: double.infinity,
        decoration: BoxDecoration(gradient: AppDesign.meshGradient(context)),
        child: Center(
        child: SafeArea(
          child: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            children: [
              // Center(
              //   child: AppDesign.glassMorphism(
              //     padding: const EdgeInsets.all(24),
              //     child: Hero(
              //       tag: 'logo',
              //       child: Image.asset("assets/img/logo2.png", width: 80),
              //     ),
              //   ),
              // ),
              const SizedBox(height: 50),
              Text(
                "Verifier Terminal",
                textAlign: TextAlign.center,
                style: AppTypography.h1,
              ),
              const SizedBox(height: 20),
              if (loginSessionId == "null")
                _buildLoginPrompt()
              else if (sessionIdIsInvalidOrExpired != "" || loginSuccessful)
                _buildStatusView()
              else
                _buildQRView(),
              const SizedBox(height: 40),
              Padding(
                padding: const EdgeInsets.all(24),
                child: Text(
                  t.scanQRcodeSupportsDeltaversions,
                  textAlign: TextAlign.center,
                  style: AppTypography.caption.copyWith(color: AppColors.vibrantRed.withOpacity(0.8)),
                ),
              ),
            ],
          ),
        ),
      ),
      ),
    );
  }

  Widget _buildLoginPrompt() {
    return AppDesign.glassMorphism(
      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 32),
      child: Column(
        children: [
          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.electricBlue,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            onPressed: createSubAppAuthSession,
            icon: const Icon(Icons.qr_code_scanner),
            label: Text(t.loginWithQRcode, style: const TextStyle(fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  Widget _buildQRView() {
    return Column(
      children: [
        AppDesign.glassMorphism(
          padding: const EdgeInsets.all(12),
          color: Colors.white,
          opacity: 0.9,
          child: QrImageView(
            data: "delta://authorize|$loginSessionId",
            version: QrVersions.auto,
            size: 200.0,
            padding: const EdgeInsets.all(10),
          ),
        ),
        const SizedBox(height: 32),
        AppDesign.glassMorphism(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset("assets/img/scanIt.png", width: 40, color: AppColors.electricBlue),
              const SizedBox(width: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(t.useDeltaMobileApp, style: AppTypography.body.copyWith(fontWeight: FontWeight.bold)),
                  Text(t.scanQRcodeToLogin, style: AppTypography.caption),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildStatusView() {
    return AppDesign.glassMorphism(
      padding: const EdgeInsets.all(32),
      color: loginSuccessful ? AppColors.neonGreen : AppColors.vibrantRed,
      opacity: 0.1,
      child: Column(
        children: [
          Icon(
            loginSuccessful ? Icons.check_circle_outline : Icons.error_outline,
            size: 64,
            color: loginSuccessful ? AppColors.neonGreen : AppColors.vibrantRed,
          ),
          const SizedBox(height: 24),
          Text(
            loginSuccessful ? t.loginSuccessful : sessionIdIsInvalidOrExpired,
            style: AppTypography.h2,
            textAlign: TextAlign.center,
          ),
          if (!loginSuccessful) ...[
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                setState(() => sessionIdIsInvalidOrExpired = "");
                createSubAppAuthSession();
              },
              child: Text(t.refreshTheQRcode),
            ),
          ],
        ],
      ),
    );
  }

  createSubAppAuthSession() async {
    if (platformName == "" || deviceModel == "") {
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
