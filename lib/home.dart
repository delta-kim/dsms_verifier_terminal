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

    dAppIdentToken = Map<String, String>.from(data.appIdentityToken["dAppIdentToken"]);
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
    print("pollingKeepOnline");
    timer?.cancel();
    timer = Timer.periodic(const Duration(minutes: 3), (timer) async {
      print("updateAccessNumberOnline: ${DateTime.now()}");
      if (myANRecord.isNotEmpty && myANRecord["status"] == "pause" || myANRecord["status"] == "online") updateAccessNumberOnline();
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
        msgBody = msgBody.replaceAll('[국제발신]', '').replaceAll(RegExp(r'\r\n?|\n'), ''); // 移除所有换行符
        if (msgBody.contains("%")) msgBody = Uri.decodeComponent(msgBody);
        if (msgBody.contains("%")) msgBody = Uri.decodeComponent(msgBody); // A small amount of SMS needs to be parsed twice
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

  insertSmsMessageAndCall(SmsMessage message, String msgBody, Future<dynamic> Function(SmsMessageState msg, String storageId) execCall) async {
    for (SmsMessageState row in messageList) {
      if (row.body == msgBody) {
        print("This verification string has been processed: $msgBody");
        return;
      }
    }
    final messageState = SmsMessageState(address: message.address!, body: msgBody, time: Util.dateFormat.format(message.date!), status: "wait", error: "");
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
      appBar: AppBar(
        backgroundColor: colorScheme!.primary,
        leading: Image.asset("assets/img/logo1.png"),
        title: const Text("DSMS Verifier terminal"),
        actions: [
          InkWell(
              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const LanguageSwitch())),
              child: Padding(padding: const EdgeInsets.only(right: 3), child: Text("v${data.packageVersion}")))
        ],
      ),
      backgroundColor: Colors.black87,
      body: myANRecord.isEmpty
          ? Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(unboundAccessNumberTipStr, style: const TextStyle(color: Colors.orange)),
                  const SizedBox(height: 16, width: double.infinity),
                  ElevatedButton(
                      child: Text(t.refresh),
                      onPressed: () {
                        setState(() {
                          unboundAccessNumberTipStr = "";
                        });
                        getAccessNumberRecord(hush: false);
                      }),
                ],
              ))
          : Column(children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text("Access Number:", style: TextStyle(color: Colors.amber)),
                  Text("+${myANRecord["accessNumber"]}", style: const TextStyle(color: Colors.amber)),
                  miniButton(t.change, onTap: () => Util.showAlert(t.goToDeltaDSMSVerifierPageOperate, title: t.needToChangeNumber), bgColor: Colors.black12)
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("${t.status}: ", style: const TextStyle(color: Colors.amber)),
                  Row(mainAxisSize: MainAxisSize.min, children: [
                    Container(
                        decoration: BoxDecoration(
                            color: statusColor(myANRecord["status"]), // 背景颜色
                            borderRadius: BorderRadius.circular(6.0)),
                        padding: const EdgeInsets.symmetric(horizontal: 6),
                        margin: const EdgeInsets.symmetric(horizontal: 2),
                        child: Text(myANRecord["status"], style: const TextStyle(color: Colors.white)) // 内边距
                        ),
                    InkWell(
                        child: const Icon(Icons.feedback, color: Colors.yellow),
                        onTap: () {
                          setState(() {
                            noteTips = !noteTips;
                          });
                        })
                  ]),
                  if (myANRecord["status"] == "online")
                    miniButton(t.pause, onTap: () async {
                      bool b = await Util.showConfirm(t.pauseUsedForMaintenanceOfDevices, title: t.youConfirmThePause);
                      if (b) {
                        pauseAccessNumber();
                      }
                    }),
                  if (myANRecord["status"] == "expired") miniButton(t.renewal, onTap: () => Util.showAlert(t.goToDeltaDSMSVerifierPageOperate, title: t.needToExtend)),
                  if (myANRecord["status"] == "unActivate" || myANRecord["status"] == "offline")
                    miniButton(t.activate, onTap: () {
                      Util.showAlert("${t.goToDeltaDSMSVerifierPageOperate} \n “${t.sendActivationCommandToTerminal}”");
                    }),
                  if (myANRecord["status"] == "pause")
                    miniButton(t.conTinue, onTap: () async {
                      await updateAccessNumberOnline(hush: false);
                      pollingKeepOnline();
                    }),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text.rich(
                      TextSpan(text: "success / received: ", children: [
                        TextSpan(text: success.toString(), style: const TextStyle(color: Colors.green)),
                        TextSpan(text: " / ${nextId - 1}"),
                      ]),
                      style: const TextStyle(color: Colors.amber)),
                  Text(listenStatus, style: const TextStyle(color: Colors.white))
                ],
              ),
              Container(
                alignment: Alignment.center,
                width: mediaSize.width,
                color: colorScheme!.primary.withAlpha(150),
                child: Text(thisMsg),
              ),
              if (noteTips)
                Container(
                  width: mediaSize.width,
                  color: const Color.fromARGB(255, 114, 103, 1),
                  child: Stack(children: [
                    Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisSize: MainAxisSize.min, children: [
                      Text(t.tip1),
                      Text.rich(t.usageTip3(noLockScreen: TextSpan(text: t.noLockScreen, style: const TextStyle(color: Colors.orange)), n: const TextSpan(text: "2"))),
                      Text(t.tip3),
                      Text(t.tip4),
                    ]),
                    Positioned(
                        bottom: 0,
                        right: 3,
                        child: InkWell(
                            child: const Icon(Icons.close, color: Colors.red),
                            onTap: () {
                              setState(() {
                                noteTips = false;
                              });
                            })),
                  ]),
                ),
              Expanded(
                child: ListView.separated(
                    separatorBuilder: (context, index) => const Divider(color: Colors.grey, indent: 10, height: 2),
                    itemCount: messageList.length,
                    itemBuilder: (BuildContext context, int i) {
                      final msg = messageList[i];
                      return ListTile(
                        dense: true,
                        leading: getStatusIcon(msg),
                        title: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(msg.address, style: const TextStyle(color: Colors.white)),
                            Text(msg.time, textScaler: const TextScaler.linear(0.8), style: const TextStyle(color: Colors.white)),
                          ],
                        ),
                        subtitle: Column(children: [
                          Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                msg.body,
                                style: const TextStyle(color: Colors.white54),
                              )),
                          Align(alignment: Alignment.bottomRight, child: Text(msg.error, textScaler: const TextScaler.linear(0.9), style: const TextStyle(color: Colors.orange))),
                        ]),
                      );
                    }),
              ),
            ]),

      bottomSheet: myANRecord.isNotEmpty
          ? SizedBox(
              height: 60,
              child: Util.avatar(data.acctInfo["avatar"] ?? "", data.acctInfo["nickname"] ?? "", onTap: () => _openModalBottomSheet(mediaSize.height * (11 / 16))),
            )
          : null,
      //bottomNavigationBar: Text("bar"),
    );
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
        isScrollControlled: true,
        constraints: BoxConstraints.expand(height: height),
        builder: (BuildContext context) {
          return SizedBox(
            height: height,
            child: Column(
              children: <Widget>[
                listTile(t.accessNumber, subtitle: "  ${myANRecord["accessNumber"]}"),
                listTile(t.TELCO, subtitle: "  ${myANRecord["carrier"]}"),
                listTile(t.score, subtitle: "  ${myANRecord["succNum"]}/${myANRecord["reqNum"]}"),
                listTile(t.rewards, subtitle: "  ${myANRecord["rewards"]}", trailing: const Text("DTCT | DTC")),
                listTile(t.expirationTime, subtitle: "  ${Util.formatDate(myANRecord["expiration"])}"),
                listTile(t.lastHeartbeat, subtitle: "  ${Util.formatDate(myANRecord["online"])}"),
              ],
            ),
          );
        });

    // debugPrint(option);
  }

  getSubAppAuthInfo() async {
    final acctInfo_ = await ic.Account().exec("getDAppAcctInfo", args: [dAppIdentToken, appId]);
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
    final recordOpt = await ic.Delta.exec("getAccessNumberRecord", args: [data.acctInfo["cCode"], dAppIdentToken["did"]], hush: hush);
    if (recordOpt is List) {
      if (recordOpt.isEmpty) {
        unboundAccessNumberTipStr = t.unboundAccessNumberTip(DSMSverifier: t.DSMSverifier, menu: t.menu, refresh: t.refresh);
        myANRecord.clear();
        setState(() {});
        return;
      }
      Map record = recordOpt.first;
      setStateMyANRecord(record);
    }
  }

  updateAccessNumberOnline({bool hush = true}) async {
    final record = await ic.Delta.exec("updateAccessNumberOnline2", args: [data.acctInfo["cCode"], appIdentityTokenArgs, data.packageVersion], hush: hush);
    if (record is Map) {
      setStateMyANRecord(record);
    }
  }

  Future<dynamic> activeAccessNumber2online(SmsMessageState msg, String storageId) async {
    final recordRes = await ic.Delta.exec("activeAccessNumber2online2", args: [msg.body, data.acctInfo["cCode"], appIdentityTokenArgs], hush: true);
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
    final record = await ic.Delta.exec("pauseAccessNumber", args: [data.acctInfo["cCode"], appIdentityTokenArgs]);
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
    myANRecord["rewards"] = (record["rewards"].toInt() / math.pow(10, 6)).toString();

    if (e164 == "") e164 = myANRecord["accessNumber"].split(" ")[0];

    setState(() {});
  }

  Widget miniButton(String text, {void Function()? onTap, Color? bgColor, Color? color}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
      child: InkWell(
        onTap: onTap,
        child: Container(
            decoration: BoxDecoration(
                color: bgColor ?? colorScheme!.primaryContainer, // 背景颜色
                borderRadius: BorderRadius.circular(10)),
            padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 3),
            child: Text(text, style: TextStyle(color: color ?? colorScheme!.primary)) // 内边距
            ),
      ),
    );
  }

  bool endsWithNumber(String text) {
    RegExp regExp = RegExp(r'\d{6,}$');
    return regExp.hasMatch(text);
  }

  String findAndReplaceMutatedChar(String text) {
    bool isDigit(String char) {
      return char.codeUnitAt(0) >= 48 && char.codeUnitAt(0) <= 57;
    }

    for (int i = text.length - 1; i >= 0; i--) {
      if (!isDigit(text[i])) {
        List<String> chars = text.split('');
        chars[i] = '|';
        return chars.join();
      }
    }
    return text;
  }

  Future<dynamic> callbackVerification(SmsMessageState msg, String storageId) async {
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
      if (e164 == "82" && (sender.startsWith("006") || sender.startsWith("005") || sender.startsWith("005") || sender.startsWith("004") || sender.startsWith("002") || sender.startsWith("001"))) {
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
      if (endsWithNumber(msg.body) && msg.body.contains("|") == false) {
        msg.body = findAndReplaceMutatedChar(msg.body);
      }
      if (msg.body.contains("|")) {
        if (msg.body.contains("64|")) {
          final dsmsWords = msg.body.split("64|");
          inputMSISDN = dsmsWords.last;
          encrypted = encrypt.Encrypted.fromBase64(dsmsWords[0]);
        } else if (msg.body.contains("en|")) {
          final dsmsWords = msg.body.split("en|");
          inputMSISDN = dsmsWords.last;
          encrypted = encrypt.Encrypted(DSMSwords.toBytes(dsmsWords[0], EncodeLang.en));
        } else if (msg.body.contains("zhs|")) {
          final dsmsWords = msg.body.split("zhs|");
          inputMSISDN = dsmsWords.last;
          encrypted = encrypt.Encrypted(DSMSwords.toBytes(dsmsWords[0], EncodeLang.zhs));
        } else if (msg.body.contains("zht|")) {
          final dsmsWords = msg.body.split("zht|");
          inputMSISDN = dsmsWords.last;
          encrypted = encrypt.Encrypted(DSMSwords.toBytes(dsmsWords[0], EncodeLang.zht));
        } else if (msg.body.contains("ko|")) {
          final dsmsWords = msg.body.split("ko|");
          inputMSISDN = dsmsWords.last;
          encrypted = encrypt.Encrypted(DSMSwords.toBytes(dsmsWords[0], EncodeLang.ko));
        }
        print("inputMSISDN,$inputMSISDN");
        print("sender,$sender");
        if (inputMSISDN != sender) {
          dsmsVerifyStatus(inputMSISDN, "inputAndActualNumberDoNotMatch|$sender");
          msg.status = "error";
          msg.error = t.differentFromActualNumber;
          storage.write(storageId, msg);
          return;
        }
      } else {
        encrypted = encrypt.Encrypted.fromBase64(msg.body); // Decoding for old versions
      }
    } catch (e) {
      msg.status = "error";
      msg.error = e.toString();
      if (inputMSISDN != "") dsmsVerifyStatus(inputMSISDN, msg.error);
      storage.write(storageId, msg);
      return;
    }
    dynamic sencryptKey = await ic.Delta.exec("getDSMSencryptKey", args: [sender, appIdentityTokenArgs], hush: true);
    if (sencryptKey == null) {
      msg.status = "error";
      msg.error = data.icErrorMsg;
      if (inputMSISDN != "") dsmsVerifyStatus(inputMSISDN, data.icErrorLanglabel);
      storage.write(storageId, msg);
      return;
    }
    String verifyText = "";

    try {
      final key = encrypt.Key.fromUtf8(sencryptKey);
      final encrypter = encrypt.Encrypter(encrypt.AES(key, mode: encrypt.AESMode.cbc));
      verifyText = encrypter.decrypt(encrypted, iv: iv);
    } catch (e) {
      msg.status = "error";
      msg.error = t.decryptionError;
      if (inputMSISDN != "") dsmsVerifyStatus(inputMSISDN, "decryptionError_pleaseTryAgain");
      storage.write(storageId, msg);
      return;
    }
    debugPrint("verifyText");
    debugPrint(verifyText);
    final res = await ic.Delta.exec("callbackVerification", args: [verifyText, appIdentityTokenArgs], hush: true);
    if (res == null) {
      msg.status = "error";
      msg.error = data.icErrorMsg;
      if (inputMSISDN != "") dsmsVerifyStatus(inputMSISDN, data.icErrorLanglabel);
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
      final response = await http.post(Uri.parse(baseUrl), headers: {'Content-Type': 'application/json'}, body: jsonEncode({'msisdn': msisdn, 'error': error}));
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
  SmsMessageState({required this.address, required this.body, required this.time, required this.status, required this.error});
  String address;
  String body;
  String time;
  String status;
  String error;

  Map<String, dynamic> toJson() => {'address': address, 'body': body, 'time': time, 'status': status, 'error': error};
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
