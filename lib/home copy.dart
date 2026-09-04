import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';
import 'package:dsms_verifier_terminal/dsms/words.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:characters/characters.dart';
import 'i18n/strings.g.dart';
import 'package:flutter/material.dart';
import 'package:encrypt/encrypt.dart' as encrypt;
import 'data.dart';
import '../dids/IC.dart' as ic;
import 'dart:math' as math;
import 'language_switch.dart';
import 'rqCodeLogin.dart';
import 'util.dart';
import 'package:flutter_sms_inbox/flutter_sms_inbox.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:http/http.dart' as http;
import 'design_system.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => HomeState();
}

class HomeState extends State<Home> {
  List<SmsMessageState> messageList = <SmsMessageState>[];
  static const ivStr = 'HelloDeltaiviviv';
  final iv = encrypt.IV.fromUtf8(ivStr);
  int nextId = 1;
  int success = 0;
  String e164 = "";
  String listenStatus = 'Monitoring sms …';
  int appId = 1;
  Map<String, String> dAppIdentToken = {};
  Map<String, dynamic> appIdentityTokenArgs = {};
  late Data data;
  Map<String, dynamic> myANRecord = {};
  String thisMsg = "null";
  bool active = true;
  String unboundAccessNumberTipStr = "";
  Timer? timer;
  Timer? timer2;
  ColorScheme? colorScheme;
  bool noteTips = true;
  bool showMoreTips = false;
  final SmsQuery smsQuery = SmsQuery();
  @override
  void initState() {
    data = context.read<Data>();
    final nextIdOpt = storage.read<int>("nextId");
    if (nextIdOpt == null) {
      nextId = 1;
      storage.write("nextId", nextId);
    } else {
      nextId = nextIdOpt;
    }

    int? successOpt = storage.read<int>("success");
    if (successOpt != null) success = successOpt;

    dAppIdentToken =
        Map<String, String>.from(data.appIdentityToken["dAppIdentToken"]);
    appIdentityTokenArgs = Map<String, dynamic>.from(data.appIdentityToken);
    appIdentityTokenArgs.remove("expiration");

    for (int i = nextId - 1; i >= 1; i--) {
      final message = storage.read<Map<String, dynamic>>(i.toString());
      if (message == null) break;
      final smsMessageState = SmsMessageState.fromJson(message);
      messageList.add(smsMessageState);
    }

    WidgetsBinding.instance.addPostFrameCallback((d) async {
      beginListening();
      if (data.acctInfo.isEmpty) {
        await getSubAppAuthInfo();
      }
      await getAccessNumberRecord();
      pollingKeepOnline();
    });
    super.initState();
  }

  pollingKeepOnline() {
    timer = Timer.periodic(const Duration(minutes: 3), (timer) async {
      if (myANRecord.isNotEmpty && myANRecord["status"] == "pause" ||
          myANRecord["status"] == "online") {
        updateAccessNumberOnline();
      }
    });
  }

  void beginListening() async {
    var permission = await Permission.sms.status;
    if (permission.isGranted == false) {
      if (await Permission.sms.request().isGranted == false) {
        Util.showAlert(t.noPermissionGrantedReadDeviceSMSmessages);
        return;
      }
    }
    timer2 = Timer.periodic(const Duration(seconds: 3), (Timer timer) async {
      final List<SmsMessage> list = await smsQuery.querySms(start: 0, count: 6);
      //print(list);
      int timestampMs = DateTime.now().millisecondsSinceEpoch;
      for (final SmsMessage message in list.reversed) {
        if (message.date!.millisecondsSinceEpoch + 5000 < timestampMs) continue;

        thisMsg = message.body!;
        String msgBody = message.body!;
        debugPrint("listen");
        debugPrint(msgBody);
        msgBody = msgBody
            .replaceAll('[국제발신]', '')
            .replaceAll(RegExp(r'\r\n?|\n'), ''); // 移除所有换行符
        if (msgBody.contains("%")) msgBody = Uri.decodeComponent(msgBody);
        if (msgBody.contains("%")) {
          msgBody = Uri.decodeComponent(
              msgBody); // A small amount of SMS needs to be parsed twice
        }
        listenStatus = "Captured new sms!";
        if (msgBody.startsWith("active#")) {
          insertSmsMessageAndCall(message, msgBody, activeAccessNumber2online);
        }
        int length = msgBody.characters.length;
        print("length $length");
        if (length > 58 && length < 150 && msgBody.contains(' ') == false) {
          insertSmsMessageAndCall(message, msgBody, callbackVerification);
        }
      }
    });
  }

  insertSmsMessageAndCall(
      SmsMessage message,
      String msgBody,
      Future<dynamic> Function(SmsMessageState msg, String storageId)
          execCall) async {
    for (SmsMessageState row in messageList) {
      if (row.body == msgBody) {
        print("This verification string has been processed: $msgBody");
        return;
      }
    }
    final messageState = SmsMessageState(
        address: message.address!,
        body: msgBody,
        time: Util.dateFormat.format(message.date!),
        status: "wait",
        error: "");
    setState(() {
      messageList.insert(0, messageState);
    });
    nextId = storage.read<int>("nextId")!;
    String storageId = nextId.toString();
    storage.write(storageId, messageState);
    nextId += 1;
    storage.write("nextId", nextId);
    if (nextId > 60) storage.remove((nextId - 60).toString());
    await execCall(messageState, storageId);
    listenStatus = 'Monitoring sms …';
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final mediaSize = MediaQuery.sizeOf(context);
    colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Hero(tag: 'logo', child: Image.asset("assets/img/logo1.png")),
        ),
        actions: [
          TextButton.icon(
            icon: const Icon(Icons.language, color: AppColors.electricBlue),
            label: Text(t.switchLanguage,
                style:
                    AppTypography.body.copyWith(color: AppColors.electricBlue)),
            onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const LanguageSwitch())),
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(gradient: AppDesign.meshGradient(context)),
        child: SafeArea(
          bottom: false,
          child: myANRecord.isEmpty
              ? _buildEmptyState()
              : CustomScrollView(
                  slivers: [
                    SliverToBoxAdapter(child: _buildHeaderCards()),
                    const SliverToBoxAdapter(child: SizedBox(height: 12)),
                    SliverToBoxAdapter(child: _buildMonitoringBar(mediaSize)),
                    if (noteTips)
                      SliverToBoxAdapter(child: _buildGlassTips(mediaSize)),
                    _buildSliverMessageList(),
                  ],
                ),
        ),
      ),
      bottomNavigationBar: myANRecord.isNotEmpty
          ? AppDesign.glassMorphism(
              borderRadius: 0,
              padding: EdgeInsets.only(
                  bottom: MediaQuery.paddingOf(context).bottom + 8, top: 12),
              child: SizedBox(
                width: 30,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Util.avatar(
                      data.acctInfo["avatar"] ?? "",
                      data.acctInfo["nickname"] ?? "",
                      size: 44,
                      onTap: () =>
                          _openModalBottomSheet(mediaSize.height * (11 / 16)),
                    ),
                  ],
                ),
              ),
            )
          : null,
    );
  }

  Widget _buildEmptyState() {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Center(
        child: AppDesign.glassMorphism(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.phonelink_erase,
                  size: 64, color: Colors.orangeAccent),
              const SizedBox(height: 24),
              Text(unboundAccessNumberTipStr,
                  textAlign: TextAlign.center,
                  style:
                      AppTypography.body.copyWith(color: Colors.orangeAccent)),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.electricBlue,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                  ),
                  child: Text(t.refresh),
                  onPressed: () {
                    setState(() => unboundAccessNumberTipStr = "");
                    getAccessNumberRecord(hush: false);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeaderCards() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: _statusCard(
                  t.accessNumber,
                  "+${myANRecord["accessNumber"]}",
                  Icons.phone_android,
                  AppColors.electricBlue,
                  onTap: () => Util.showAlert(
                      t.goToDeltaDSMSVerifierPageOperate,
                      title: t.needToChangeNumber),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _statusCard(
                  t.rewards,
                  "${myANRecord["rewards"]} DTC",
                  Icons.account_balance_wallet_outlined,
                  AppColors.gold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: _statusCard(
                  "Success / Total",
                  "$success / ${nextId - 1}",
                  Icons.check_circle_outline,
                  AppColors.neonGreen,
                  showAction: true,
                  actionText: "Version: ${data.packageVersion}",
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _statusCard(
                  t.status,
                  myANRecord["status"],
                  Icons.wifi_tethering,
                  statusColor(myANRecord["status"]),
                  showAction: true,
                  actionText: _getActionText(),
                  onAction: _handleStatusAction,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _getActionText() {
    String status = myANRecord["status"];
    if (status == "online") return t.pause;
    if (status == "expired") return t.renewal;
    if (status == "unActivate" || status == "offline") return t.activate;
    if (status == "pause") return t.conTinue;
    return "";
  }

  void _handleStatusAction() async {
    String status = myANRecord["status"];
    if (status == "online") {
      bool b = await Util.showConfirm(t.pauseUsedForMaintenanceOfDevices,
          title: t.youConfirmThePause);
      if (b) {
        timer?.cancel();
        pauseAccessNumber();
      }
    } else if (status == "expired") {
      Util.showAlert(t.goToDeltaDSMSVerifierPageOperate, title: t.needToExtend);
    } else if (status == "unActivate" || status == "offline") {
      Util.showAlert(
          "${t.goToDeltaDSMSVerifierPageOperate} \n “${t.sendActivationCommandToTerminal}”");
    } else if (status == "pause") {
      await updateAccessNumberOnline(hush: false);
      pollingKeepOnline();
    }
  }

  Widget _statusCard(String label, String value, IconData icon, Color color,
      {bool showAction = false,
      String? actionText,
      VoidCallback? onAction,
      VoidCallback? onTap}) {
    return AppDesign.glassMorphism(
      padding: const EdgeInsets.all(16),
      child: InkWell(
        onTap: onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, size: 16, color: color),
                const SizedBox(width: 8),
                Flexible(
                    child: Text(label,
                        style: AppTypography.caption,
                        overflow: TextOverflow.ellipsis)),
              ],
            ),
            const SizedBox(height: 8),
            Text(value,
                style: AppTypography.h2.copyWith(fontSize: 14, color: color),
                overflow: TextOverflow.ellipsis),
            if (showAction && actionText != null && actionText.isNotEmpty) ...[
              const SizedBox(height: 8),
              SizedBox(
                width: double.infinity,
                height: 30,
                child: TextButton(
                  style: TextButton.styleFrom(
                    backgroundColor: color.withOpacity(0.1),
                    padding: EdgeInsets.zero,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8)),
                  ),
                  onPressed: onAction,
                  child: Text(actionText,
                      style: TextStyle(
                          color: color,
                          fontSize: 12,
                          fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildMonitoringBar(Size mediaSize) {
    return Container(
      width: double.infinity,
      color: AppColors.electricBlue.withOpacity(0.1),
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Flexible(
            child: Row(
              children: [
                const _PulseCircle(),
                const SizedBox(width: 8),
                Flexible(
                    child: Text(listenStatus,
                        style: AppTypography.caption
                            .copyWith(color: AppColors.neonGreen),
                        overflow: TextOverflow.ellipsis)),
              ],
            ),
          ),
          Expanded(
              child: Text(thisMsg,
                  textAlign: TextAlign.right,
                  style: AppTypography.caption,
                  overflow: TextOverflow.ellipsis)),
        ],
      ),
    );
  }

  Widget _buildGlassTips(Size mediaSize) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: AppDesign.glassMorphism(
        color: Colors.amber,
        opacity: 0.1,
        padding: const EdgeInsets.all(16),
        child: Stack(
          children: [
            SizedBox(
              width: double.infinity,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 8),
                  Text(t.tip1, style: AppTypography.body),
                  const SizedBox(height: 4),
                  if (showMoreTips) ...[
                    Text.rich(
                      t.usageTip3(
                          noLockScreen: TextSpan(
                              text: t.noLockScreen,
                              style:
                                  const TextStyle(color: Colors.orangeAccent)),
                          n: const TextSpan(text: "2")),
                      style: AppTypography.body,
                    ),
                    const SizedBox(height: 4),
                    Text(t.tip3, style: AppTypography.body),
                    const SizedBox(height: 4),
                    Text(t.tip4, style: AppTypography.body),
                  ],
                  GestureDetector(
                    onTap: () {
                      setState(
                        () {
                          showMoreTips = !showMoreTips;
                        },
                      );
                    },
                    child: Text(
                      showMoreTips ? "Show more" : "Show less",
                      style: AppTypography.body.copyWith(
                        color: Colors.blue,
                        decoration: TextDecoration.underline,
                        decorationColor: Colors.blue,
                      ),
                    ),
                  )
                ],
              ),
            ),
            Positioned(
              top: -18,
              right: -18,
              child: IconButton(
                icon: const Icon(Icons.close, size: 18, color: Colors.white54),
                onPressed: () => setState(() => noteTips = false),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSliverMessageList() {
    return SliverPadding(
      padding: const EdgeInsets.only(top: 8, bottom: 20),
      sliver: SliverList(
        delegate: SliverChildBuilderDelegate(
          (context, i) {
            final msg = messageList[i];
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
              child: AppDesign.glassMorphism(
                padding: const EdgeInsets.all(12),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: _getStatusBgColor(msg).withOpacity(0.1),
                        shape: BoxShape.circle,
                      ),
                      child: getStatusIcon(msg),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(msg.address,
                                  style:
                                      AppTypography.h2.copyWith(fontSize: 14)),
                              Text(msg.time, style: AppTypography.caption),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Text(msg.body, style: AppTypography.body),
                          if (msg.error.isNotEmpty) ...[
                            const SizedBox(height: 4),
                            Text(msg.error,
                                style: AppTypography.caption
                                    .copyWith(color: AppColors.vibrantRed)),
                          ],
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
          childCount: messageList.length,
        ),
      ),
    );
  }

  Color _getStatusBgColor(SmsMessageState msg) {
    if (msg.status == "wait") return Colors.orange;
    if (msg.status == "error") return Colors.red;
    if (msg.status == "success") return Colors.green;
    return Colors.grey;
  }

  Color statusColor(String status) {
    if (status == "online") return Colors.green;
    if (status == "offline") return Colors.red;
    if (status == "expired") return Colors.red;
    if (status == "unActivate") return Colors.red;
    if (status == "pause") return Colors.orange;
    return Colors.black38;
  }

  Future<void> _openModalBottomSheet(double height) async {
    getAccessNumberRecord();
    await showModalBottomSheet<void>(
        context: context,
        backgroundColor: Colors.transparent,
        isScrollControlled: true,
        builder: (BuildContext context) {
          return AppDesign.glassMorphism(
            borderRadius: 24,
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                        color: Colors.white24,
                        borderRadius: BorderRadius.circular(2)),
                  ),
                  const SizedBox(height: 20),
                  listTile(t.accessNumber,
                      subtitle: "+${myANRecord["accessNumber"]}"),
                  listTile(t.TELCO, subtitle: myANRecord["carrier"]),
                  listTile(t.score,
                      subtitle:
                          "${myANRecord["succNum"]}/${myANRecord["reqNum"]}"),
                  listTile(t.rewards,
                      subtitle: "${myANRecord["rewards"]} DTC",
                      trailing: const Text("DTCT | DTC",
                          style:
                              TextStyle(color: AppColors.gold, fontSize: 12))),
                  listTile(t.expirationTime,
                      subtitle: Util.formatDate(myANRecord["expiration"])),
                  listTile(t.lastHeartbeat,
                      subtitle: Util.formatDate(myANRecord["online"])),
                ],
              ),
            ),
          );
        });
  }

  Widget listTile(String title, {String? subtitle, Widget? trailing}) {
    return ListTile(
      title: Text(title,
          style: AppTypography.h2.copyWith(fontSize: 14),
          overflow: TextOverflow.ellipsis),
      subtitle: subtitle != null
          ? Text(subtitle,
              style: AppTypography.body.copyWith(fontSize: 13),
              overflow: TextOverflow.ellipsis)
          : null,
      trailing: trailing,
    );
  }

  getSubAppAuthInfo() async {
    final acctInfo_ = await ic.Account()
        .exec("getDAppAcctInfo", args: [dAppIdentToken, appId]);
    if (acctInfo_ == null) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute<void>(
          builder: (BuildContext context) => const QqCodeLogin(),
        ),
      );
      return;
    }
    data.acctInfo.clear();
    data.acctInfo.addAll(Map<String, dynamic>.from(acctInfo_));
    setState(() {});
  }

  getAccessNumberRecord({bool hush = true}) async {
    final recordOpt = await ic.Delta.exec("getAccessNumberRecord",
        args: [data.acctInfo["cCode"], dAppIdentToken["did"]], hush: hush);
    if (recordOpt is List) {
      if (recordOpt.isEmpty) {
        unboundAccessNumberTipStr = t.unboundAccessNumberTip(
            DSMSverifier: t.DSMSverifier, menu: t.menu, refresh: t.refresh);
        myANRecord.clear();
        setState(() {});
        return;
      }
      Map record = recordOpt.first;
      setStateMyANRecord(record);
    }
  }

  updateAccessNumberOnline({bool hush = true}) async {
    final record = await ic.Delta.exec("updateAccessNumberOnline2",
        args: [
          data.acctInfo["cCode"],
          appIdentityTokenArgs,
          data.packageVersion
        ],
        hush: hush);
    if (record is Map) {
      setStateMyANRecord(record);
    }
  }

  Future<dynamic> activeAccessNumber2online(
      SmsMessageState msg, String storageId) async {
    final recordRes = await ic.Delta.exec("activeAccessNumber2online2",
        args: [msg.body, data.acctInfo["cCode"], appIdentityTokenArgs],
        hush: true);
    if (recordRes is Map) {
      if (recordRes.containsKey("ok")) {
        msg.status = "success";
        success += 1;
        storage.write("success", success);
        storage.write(storageId, msg);
        setStateMyANRecord(recordRes["ok"]);
        //pollingKeepOnline();
      } else {
        msg.status = "error";
        msg.error = recordRes["err"];
        storage.write(storageId, msg);
      }
      if (messageList.length > 60) {
        messageList.removeLast();
      }
    }
  }

  pauseAccessNumber() async {
    final record = await ic.Delta.exec("pauseAccessNumber",
        args: [data.acctInfo["cCode"], appIdentityTokenArgs]);
    if (record is Map) {
      setStateMyANRecord(record);
    }
  }

  setStateMyANRecord(Map record) {
    myANRecord["expiration"] = record["expiration"];
    myANRecord["accessNumber"] = record["accessNumber"];
    myANRecord["carrier"] = record["carrier"];
    myANRecord["reqNum"] = record["reqNum"];
    myANRecord["succNum"] = record["succNum"];
    myANRecord["online"] = record["online"];
    myANRecord["status"] = record["status"];
    myANRecord["rewards"] =
        (record["rewards"].toInt() / math.pow(10, 6)).toString();

    if (e164 == "") e164 = myANRecord["accessNumber"].split(" ")[0];

    setState(() {});
  }

  Widget miniButton(String text,
      {void Function()? onTap, Color? bgColor, Color? color}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
      child: InkWell(
        onTap: onTap,
        child: Container(
            decoration: BoxDecoration(
                color: bgColor ?? colorScheme!.primaryContainer, // 背景颜色
                borderRadius: BorderRadius.circular(10)),
            padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 3),
            child: Text(text,
                style: TextStyle(color: color ?? colorScheme!.primary)) // 内边距
            ),
      ),
    );
  }

  Future<dynamic> callbackVerification(
      SmsMessageState msg, String storageId) async {
    debugPrint("SmsMessage");
    debugPrint(msg.address);
    String sender = msg.address;
    if (sender.startsWith("+") == false && sender.startsWith("00") == false) {
      sender = e164 + sender;
    } else if (sender.startsWith("+00")) {
      sender = sender.substring(3);
    } else if (sender.startsWith("+")) {
      sender = sender.substring(1);
    } else if (sender.startsWith("00")) {
      if (e164 == "82" &&
          (sender.startsWith("006") ||
              sender.startsWith("005") ||
              sender.startsWith("005") ||
              sender.startsWith("004") ||
              sender.startsWith("002") ||
              sender.startsWith("001"))) {
        sender = sender.substring(3);
      } else if (e164 == "82" && sender.startsWith("003")) {
        sender = sender.substring(4);
      } else {
        sender = sender.substring(2);
      }
    }
    encrypt.Encrypted encrypted = encrypt.Encrypted(Uint8List.fromList([]));
    String inputMSISDN = "";
    try {
      if (msg.body.contains("|")) {
        if (msg.body.contains("64|")) {
          final dsmsWords = msg.body.split("64|");
          inputMSISDN = dsmsWords.last;
          encrypted = encrypt.Encrypted.fromBase64(dsmsWords[0]);
        } else if (msg.body.contains("en|")) {
          final dsmsWords = msg.body.split("en|");
          inputMSISDN = dsmsWords.last;
          encrypted =
              encrypt.Encrypted(DSMSwords.toBytes(dsmsWords[0], EncodeLang.en));
        } else if (msg.body.contains("zhs|")) {
          final dsmsWords = msg.body.split("zhs|");
          inputMSISDN = dsmsWords.last;
          encrypted = encrypt.Encrypted(
              DSMSwords.toBytes(dsmsWords[0], EncodeLang.zhs));
        } else if (msg.body.contains("zht|")) {
          final dsmsWords = msg.body.split("zht|");
          inputMSISDN = dsmsWords.last;
          encrypted = encrypt.Encrypted(
              DSMSwords.toBytes(dsmsWords[0], EncodeLang.zht));
        } else if (msg.body.contains("ko|")) {
          final dsmsWords = msg.body.split("ko|");
          inputMSISDN = dsmsWords.last;
          encrypted =
              encrypt.Encrypted(DSMSwords.toBytes(dsmsWords[0], EncodeLang.ko));
        }
        print("inputMSISDN,$inputMSISDN");
        print("sender,$sender");
        if (inputMSISDN != sender) {
          dsmsVerifyStatus(
              inputMSISDN, "inputAndActualNumberDoNotMatch|$sender");
          msg.status = "error";
          msg.error = t.differentFromActualNumber;
          storage.write(storageId, msg);
          return;
        }
      } else {
        encrypted =
            encrypt.Encrypted.fromBase64(msg.body); // Decoding for old versions
      }
    } catch (e) {
      msg.status = "error";
      msg.error = e.toString();
      if (inputMSISDN != "") dsmsVerifyStatus(inputMSISDN, msg.error);
      storage.write(storageId, msg);
      return;
    }
    dynamic sencryptKey = await ic.Delta.exec("getDSMSencryptKey",
        args: [sender, appIdentityTokenArgs], hush: true);
    if (sencryptKey == null) {
      msg.status = "error";
      msg.error = data.icErrorMsg;
      if (inputMSISDN != "") {
        dsmsVerifyStatus(inputMSISDN, data.icErrorLanglabel);
      }
      storage.write(storageId, msg);
      return;
    }
    String verifyText = "";

    try {
      final key = encrypt.Key.fromUtf8(sencryptKey);
      final encrypter =
          encrypt.Encrypter(encrypt.AES(key, mode: encrypt.AESMode.cbc));
      verifyText = encrypter.decrypt(encrypted, iv: iv);
    } catch (e) {
      msg.status = "error";
      msg.error = t.decryptionError;
      if (inputMSISDN != "") {
        dsmsVerifyStatus(inputMSISDN, "decryptionError_pleaseTryAgain");
      }
      storage.write(storageId, msg);
      return;
    }
    debugPrint("verifyText");
    debugPrint(verifyText);
    final res = await ic.Delta.exec("callbackVerification",
        args: [verifyText, appIdentityTokenArgs], hush: true);
    if (res == null) {
      msg.status = "error";
      msg.error = data.icErrorMsg;
      if (inputMSISDN != "") {
        dsmsVerifyStatus(inputMSISDN, data.icErrorLanglabel);
      }
      storage.write(storageId, msg);
      return;
    }
    msg.status = res;
    msg.error = "";
    if (msg.status == "success") {
      success += 1;
      storage.write("success", success);
    }
    storage.write(storageId, msg);
    if (messageList.length > 60) {
      messageList.removeLast();
    }
  }

  Widget getStatusIcon(SmsMessageState msg) {
    if (msg.status == "wait") {
      return const Icon(Icons.more_horiz, color: Colors.orange);
    }
    if (msg.status == "error") {
      return const Icon(Icons.cancel, color: Colors.red);
    }
    if (msg.status == "success") {
      return const Icon(Icons.check, color: Colors.green);
    }
    if (msg.status == "invalid") {
      return const Icon(Icons.warning_amber, color: Colors.orange);
    }
    return const Icon(Icons.cancel);
  }

  Future<dynamic> dsmsVerifyStatus(String msisdn, String error) async {
    const String baseUrl = 'https://status.delta.kim/setDsmsVerifyError';
    try {
      final response = await http.post(Uri.parse(baseUrl),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({'msisdn': msisdn, 'error': error}));
      // print("response.body");
      // print(response.statusCode);
      // print(response.body);
      if (response.statusCode == 200) {
        return response.body;
      }
      return null;
    } catch (e) {
      print('Network error: ${e.toString()}');
      return null;
    }
  }
}

class SmsMessageState {
  SmsMessageState(
      {required this.address,
      required this.body,
      required this.time,
      required this.status,
      required this.error});
  String address;
  String body;
  String time;
  String status;
  String error;

  Map<String, dynamic> toJson() => {
        'address': address,
        'body': body,
        'time': time,
        'status': status,
        'error': error
      };
  factory SmsMessageState.fromJson(Map<String, dynamic> json) {
    return SmsMessageState(
      address: json['address'] as String,
      body: json['body'] as String,
      time: json['time'] as String,
      status: json['status'] as String,
      error: json['error'] as String,
    );
  }
}

class _PulseCircle extends StatefulWidget {
  const _PulseCircle();

  @override
  State<_PulseCircle> createState() => _PulseCircleState();
}

class _PulseCircleState extends State<_PulseCircle>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: AppColors.neonGreen.withOpacity(1 - _controller.value),
            boxShadow: [
              BoxShadow(
                color: AppColors.neonGreen
                    .withOpacity(0.5 * (1 - _controller.value)),
                blurRadius: 10 * _controller.value,
                spreadRadius: 5 * _controller.value,
              ),
            ],
          ),
        );
      },
    );
  }
}
