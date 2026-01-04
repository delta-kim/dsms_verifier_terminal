import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../i18n/strings.g.dart';
import './NavigatorProvider.dart';
import 'dart:math' as math;
import '../../data.dart';
import 'package:fluttertoast/fluttertoast.dart';

//import 'body/pages/punksBAYCdata.dart';
const List<String> chars32 = ["0", "1", "2", "3", "4", "5", "6", "7", "8", "9", "A", "B", "C", "D", "E", "F", "G", "H", "J", "K", "L", "M", "N", "P", "Q", "R", "T", "U", "V", "W", "X", "Y"];

class Util {
  static Future<void> showErrorAlert(String content, {required String title, bool hush = false}) {
    String newContent = content;
    if (!content.contains(" ")) {
      if (content.contains("|")) {
        List<String> langKeys = content.split("|");
        String langKey = langKeys.first;
        dynamic func = t[langKey];
        if (func != null) {
          switch (langKeys.length - 1) {
            case 1:
              newContent = func(x: langKeys.last);
              break;
            case 2:
              newContent = func(x: langKeys[1], y: langKey[2]);
              break;
            case 3:
              newContent = func(x: langKeys[1], y: langKey[2], z: langKey[3]);
              break;
            default:
            //newContent = content;
            //break;
          }
        }
      } else {
        newContent = t[content];
      }
    }

    final context = NavigatorProvider.navigatorContext;
    Data data = context!.read<Data>();
    data.icErrorMsg = newContent;
    data.icErrorLanglabel = content;
    if (hush == false) {
      final titles = title.split(":");
      String newTitle = title;
      if (t[titles.last] != null) {
        newTitle = "${titles.first}:${t[titles.last]}";
      }
      return showAlert(newContent, title: newTitle);
    }
    return Future.value();
  }

  static Future<void> showAlert(String content, {String? title}) {
    final context = NavigatorProvider.navigatorContext;
    return showDialog<void>(
      context: context!,
      builder: (context) {
        return AlertDialog(
          title: Text("${title ?? t.tip}:"),
          content: Text(content),
          actions: <Widget>[
            TextButton(
              child: const Text("OK"),
              onPressed: () => Navigator.of(context).pop(), // close dialog
            ),
          ],
        );
      },
    );
  }

  static Future<bool?> showConfirm<bool>(String content, {String? title}) {
    final context = NavigatorProvider.navigatorContext;
    return showDialog<bool>(
      context: context!,
      builder: (context) {
        return AlertDialog(
          title: Text("${title ?? t.tip}:"),
          content: Text(content),
          actions: <Widget>[
            TextButton(
              child: Text(t.cancel),
              onPressed: () => Navigator.of(context).pop(false),
            ),
            TextButton(
              child: Text(t.confirm),
              onPressed: () => Navigator.of(context).pop(true),
            ),
          ],
        );
      },
    );
  }

  static Future<void> showLoadingDialog(String? symbol, {String showText = ""}) {
    final context = NavigatorProvider.navigatorContext;

    var icon = Icons.manage_search_outlined;
    //String showText = "Querying...";
    if (showText.isEmpty) {
      showText = t.querying;
    }
    if (symbol == null) {
      icon = Icons.save_as_outlined;
      showText = t.writingToOnChain_pleaseWait;
    }
    return showDialog<void>(
      context: context!,
      barrierDismissible: false, //点击遮罩不关闭对话框
      builder: (context) {
        return UnconstrainedBox(
            constrainedAxis: Axis.vertical,
            child: SizedBox(
              width: 300,
              child: AlertDialog(
                icon: Icon(icon),
                iconColor: Colors.yellow[800],
                backgroundColor: const Color.fromRGBO(255, 255, 255, 0.7),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    const CircularProgressIndicator(),
                    Padding(
                      padding: const EdgeInsets.only(top: 26.0),
                      child: Text(showText),
                    )
                  ],
                ),
              ),
            ));
      },
    );
  }

  static void closeAlertDialog() {
    final context = NavigatorProvider.navigatorContext;
    Navigator.of(context!).pop();
  }

  static void toast(String msg) {
    Fluttertoast.showToast(msg: msg, gravity: ToastGravity.CENTER, backgroundColor: Colors.black54);
  }

  static Future<bool?> showConfirmYes<bool>(BuildContext context, String tip) {
    final formKey = GlobalKey<FormState>();
    return showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(tip),
          content: Form(
            key: formKey,
            child: TextFormField(
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                contentPadding: EdgeInsets.fromLTRB(10, 0, 10, 0),
              ),
              maxLength: 3,
              validator: (value) {
                if (value != "yes") {
                  return tip;
                }
                return null;
              },
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text(t.cancel),
              onPressed: () => Navigator.of(context).pop(false),
            ),
            TextButton(
              child: Text(t.confirm),
              onPressed: () {
                if ((formKey.currentState as FormState).validate()) {
                  Navigator.of(context).pop(true);
                }
              },
            ),
          ],
        );
      },
    );
  }

  static Widget avatar(String avatarStr, String name, {void Function()? onTap, double textScaler = 0.6}) {
    final avatarArr = avatarStr.toString().split("#");
    return Stack(alignment: AlignmentDirectional.center, children: [
      ClipRRect(
        //borderRadius: BorderRadius.circular(10),
        borderRadius: BorderRadius.vertical(top: Radius.circular(26)),
        child: InkWell(
          onTap: onTap,
          child: Util.avatarImage(avatarStr),
        ),
      ),
      Positioned(
        bottom: 0,
        child: Text(
          name,
          textScaler: TextScaler.linear(textScaler),
          style: const TextStyle(color: Color.fromRGBO(255, 255, 225, 0.8), shadows: <Shadow>[
            Shadow(
              offset: Offset(1.0, 1.0),
              blurRadius: 2.0,
              color: Colors.black45,
            ),
            Shadow(
              offset: Offset(-1.0, -1.0),
              blurRadius: 2.0,
              color: Colors.black45,
            ),
          ]),
        ),
      )
    ]);
  }

  static Widget avatarImage(String avatarStr) {
    if (avatarStr != "") {
      final avatarArr = avatarStr.toString().split("#");
      return CachedNetworkImage(
        imageUrl: Util.avatarSrc(avatarArr[0], int.parse(avatarArr[1])),
        placeholder: (context, url) => Image.asset("assets/img/avatar.placeholder.jpg"),
        errorWidget: (context, url, error) => const Icon(Icons.error),
        fit: BoxFit.cover,
      );
      //return Image.network(Util.avatarSrc(avatarArr[0], int.parse(avatarArr[1])), fit: BoxFit.cover);
    } else {
      return Image.asset("assets/img/avatar.placeholder.jpg");
    }
  }

  static String avatarSrc(String name, int index) {
    if (name == "ICPunks") {
      return "https://punks.oss-ap-southeast-1.aliyuncs.com/icpunks/$index.jpg?x-oss-process=image/resize,w_192,limit_0";
    } else if (name == "BAYC") {
      return "https://punks.oss-ap-southeast-1.aliyuncs.com/BAYC/${index.toString().padLeft(4, '0')}.png?x-oss-process=image/resize,w_192,limit_0";
      // return "https://api.sandbox.game/avatars/presets/${BAYC_Map[index]['id']}/thumbnail.png";
    }
    // name == "CryptoPunks"
    return "https://punks.oss-ap-southeast-1.aliyuncs.com/cryptopunks/${index.toString().padLeft(4, '0')}.png?x-oss-process=image/resize,w_192,limit_0";
  }

  static toDecimal(dynamic amount, {num exponent = 6}) {
    return (amount.toInt() / math.pow(10, exponent)).toStringAsFixed(4);
  }

  static int get now {
    return DateTime.now().millisecondsSinceEpoch ~/ 1000;
  }

  static int _base32ToNat(String base32Str) {
    // Algorithm example 1F1F =(1*16^3)+(15*16^2)+(1*16^1)+(F*16^0) = 4096+3840+16+15 = 7967
    const int carry = 32;
    var i = base32Str.length;
    int nat = 0;
    for (var char in base32Str.characters) {
      i -= 1;
      int locate = chars32.indexOf(char);
      // nat += locate * ( carry**i );
      nat += locate * math.pow(carry, i).toInt();
    }
    return nat;
  }

  static String toBase32(int n) {
    var numb = n;
    String res = "";
    int carry = 32;
    while (numb >= carry) {
      res = chars32[(numb % carry)] + res;
      numb = numb ~/ carry;
    }
    return chars32[numb] + res;
  }

  static int parseDID(String addressId) {
    if (addressId.length != 13) {
      throw ("addressId length is incorrect");
    }

    var sumMaskLast = addressId.substring(0, 1);
    var id32 = addressId.substring(1);

    int id = _base32ToNat(id32);
    int _id = id;
    int sum = 0;
    while (_id > 0) {
      sum += _id % 10;
      _id = _id ~/ 10;
    }
    var sumMask = toBase32(sum);

    if (!sumMask.endsWith(sumMaskLast)) {
      throw ("2.addressId format is invalid");
    }

    String idStr = id.toString(); // textPadStart  For the case where id is 0

    var indexStr = idStr.substring(0, 13);
    var len = int.parse(idStr.substring(13, 15));

    int index = int.parse(indexStr);

    return index ~/ math.pow(10, len);
  }

  static String? checkDID(String did) {
    if (did.length != 13) {
      return "did length is incorrect";
    }

    var sumMaskLast = did.substring(0, 1);
    var id32 = did.substring(1);

    int id = _base32ToNat(id32);
    int _id = id;
    int sum = 0;
    while (_id > 0) {
      sum += _id % 10;
      _id = _id ~/ 10;
    }
    var sumMask = toBase32(sum);

    if (!sumMask.endsWith(sumMaskLast)) {
      return "2.did format is invalid";
    }
    return null;
  }

  static String? checkWalletAddress(String walletAddress) {
    if (walletAddress.length != 18 && walletAddress.length != 19) {
      return "wallet address length is incorrect";
    }
    return null;
  }

  static String formatTimePeriod(int period) {
    String hour = (period ~/ 3600).toString().padLeft(2, "0");
    int remainder = period % 3600;
    String minute = (remainder ~/ 60).toString().padLeft(2, "0");
    String second = (remainder % 60).toString().padLeft(2, "0");
    return "$hour:$minute:$second";
  }

  static DateFormat dateFormat = DateFormat('yyyy-MM-dd HH:mm:ss'); //
  static String formatDate(dynamic timestamp) {
    return dateFormat.format(DateTime.fromMillisecondsSinceEpoch(timestamp.toInt() * 1000));
  }

  static String shortDisplayAddress(String addr, {int showLength = 20}) {
    if (addr.length > showLength) {
      int length = (showLength - 2) ~/ 2;
      return "${addr.substring(0, length)}...${addr.substring(addr.length - length)}";
    }
    return addr;
  }

  static double transferFee(Map map, double amount, int decimals) {
    double fee = amount / map['rate'].toInt();
    final times = math.pow(10, decimals);
    double min = map['min'].toInt() / times;
    if (fee < min) {
      return min;
    }
    double max = map['max'].toInt() / times;
    if (fee > max) {
      return max;
    }
    return fee;
  }

  static bool isDarkMode() {
    final context = NavigatorProvider.navigatorContext;
    var brightness = MediaQuery.of(context!).platformBrightness;
    return brightness == Brightness.dark;
  }
}

listTile(String title, {String subtitle = "", Widget? SubTitle, Widget? trailing}) {
  return ListTile(
    title: Text(
      textScaler: const TextScaler.linear(0.9),
      title,
      style: const TextStyle(color: Colors.black54),
    ),
    subtitle: SubTitle ??
        SelectableText(
          subtitle,
          textScaler: const TextScaler.linear(1.2),
          style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
    trailing: trailing,
  );
}
