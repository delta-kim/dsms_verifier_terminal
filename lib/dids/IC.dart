import 'package:agent_dart/agent_dart.dart';
export 'package:agent_dart/agent_dart.dart';
import '../data.dart';
import 'package:provider/provider.dart';
import '../NavigatorProvider.dart';
import '../util.dart';
import './delta.did.dart' as d;
import './account.did.dart' as a;
import './DappCenter.did.dart' as dc;
import 'package:flutter/material.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

const String host = "icp0.io";

// A future method because we need debug mode works for local developement

CanisterActor createActor(String canisterId, ServiceClass serviceClass) {
  final agent = HttpAgent(defaultPort: 443, defaultHost: host);
  // if (!host.contains("ic0")) {
  //   agent.fetchRootKey();
  // }
  return Actor.createActor(serviceClass, ActorConfig(agent: agent, canisterId: Principal.fromText(canisterId)));
}

class Delta {
  static String canisterId = "ojpsk-siaaa-aaaam-adtea-cai";

  static CanisterActor actor = createActor(canisterId, IDL.Service(d.funcMap));
  static List<Map<dynamic, dynamic>> accountCanisterList = [];

  static Future<dynamic> exec(String funcName, {List<dynamic>? args, bool hush = false}) async {
    String? annotation;
    if (d.funcMap[funcName]!.annotations.isNotEmpty) {
      annotation = d.funcMap[funcName]!.annotations[0];
    }
    if (!hush) Util.showLoadingDialog(annotation);
    try {
      var res = await actor.getFunc(funcName)?.call(args);
      if (!hush) Util.closeAlertDialog();
      return res;
    } catch (e) {
      if (!hush) Util.closeAlertDialog();
      final map = parseError(e);
      print(map);
      await Util.showErrorAlert(map["errorMsg"]!, title: "$funcName:${map["errorStatus"]!}", hush: hush);
      return null;
    }
  }

  static Future<Map<String, List<String>>> matchAccountCanisters(List<String> addressIds) async {
    Map<String, List<String>> result = {};
    for (var addressId in addressIds) {
      String? canisterId = await matchAccountCanister(addressId);
      if (result[canisterId] != null) {
        result[canisterId]!.add(addressId);
      } else {
        result[canisterId] = [addressId];
      }
    }
    return result;
  }

  static Future<String> matchAccountCanister(String addressId) async {
    if (accountCanisterList.isEmpty) {
      accountCanisterList = await exec("listAccountCanisterDate", hush: true);
    }
    int index = Util.parseDID(addressId);
    for (Map<dynamic, dynamic> map in accountCanisterList) {
      if (index >= map["start"].toInt() && index <= map["end"].toInt()) {
        String canisterId = map["canisterId"].toString();
        return canisterId;
      }
    }
    accountCanisterList = await exec("listAccountCanisterDate", hush: true);
    for (Map<dynamic, dynamic> map in accountCanisterList) {
      if (index >= map["start"].toInt() && index <= map["end"].toInt()) {
        String canisterId = map["canisterId"].toString();
        return canisterId;
      }
    }
    return accountCanisterList.last["canisterId"].toString();
  }
}

Map<String, String> parseError(e) {
  Map<String, String> map = {};
  if (e is QueryResponseRejected) {
    map["errorMsg"] = e.rejectMessage!; //!.replaceAll(canisterIdReg, ":");
    map["errorStatus"] = e.status;
  } else if (e is PollingResponseRejectedException) {
    map["errorMsg"] = e.rejectMessage;
    map["errorStatus"] = e.status.name;
  } else {
    map["errorMsg"] = e.toString();
    map["errorStatus"] = "error";
    print("other errors");
    print(e.runtimeType);
  }
  return map;
}

class Account {
  late String canisterId;
  static Map<String, CanisterActor> actorMap = {};
  Account() {
    canisterId = NavigatorProvider.navigatorContext!.read<Data>().acctCanisterId;
    if (canisterId == "") {
      throw ("acctCanisterId  does not exist");
    }
    actorMap[canisterId] = actorMap[canisterId] ?? createActor(canisterId, IDL.Service(a.funcMap));
  }

  Account.form(String _canisterId) {
    canisterId = _canisterId;
    actorMap[canisterId] = actorMap[canisterId] ?? createActor(canisterId, IDL.Service(a.funcMap));
  }
  CanisterActor get actor {
    return actorMap[canisterId]!;
  }

  Future<dynamic> exec(String funcName, {List<dynamic>? args, bool hush = false}) async {
    String? annotation;
    if (a.funcMap[funcName]!.annotations.isNotEmpty) {
      annotation = a.funcMap[funcName]!.annotations[0];
    }
    if (!hush) Util.showLoadingDialog(annotation);
    try {
      CanisterActor actor = actorMap[canisterId]!;
      var res = await actor.getFunc(funcName)?.call(args);
      if (!hush) Util.closeAlertDialog();
      if (res != null) {
        return res;
      }
      if (!hush) Util.closeAlertDialog();
    } catch (e) {
      if (!hush) Util.closeAlertDialog();
      final map = parseError(e);
      print(funcName);
      print(map);
      await Util.showErrorAlert(map["errorMsg"]!, title: "$funcName:${map["errorStatus"]!}", hush: hush);
      return null;
    }
    //  finally {
    //   if (!hush) Util.closeAlertDialog();
    // }
  }

  static Future<Map<String, dynamic>?> testAccountStatus(String addressId) async {
    var canisterId = await Delta.exec("matchAccountCanister", args: [addressId]);
    if (canisterId is List) {
      var accountStatus = await Account.form(canisterId[0]).exec("getAccountStatus", args: [addressId]);
      return {"canisterId": canisterId[0], "accountStatus": accountStatus};
    }
    return null;
  }
}

class DappCenter {
  static String canisterId = "";
  static CanisterActor? actor;

  static Future<dynamic> exec(String funcName, {List<dynamic>? args, bool hush = false}) async {
    if (canisterId.isEmpty) {
      Map<String, dynamic> canisterType = {"DappCenter": null};
      canisterId = await Delta.exec("getCanisterId", args: [canisterType], hush: true);
      actor = createActor(canisterId, IDL.Service(dc.funcMap));
    }
    String? annotation;
    if (dc.funcMap[funcName]!.annotations.isNotEmpty) {
      annotation = dc.funcMap[funcName]!.annotations[0];
    }
    if (!hush) Util.showLoadingDialog(annotation);
    try {
      var res = await actor?.getFunc(funcName)?.call(args);

      if (!hush) Util.closeAlertDialog();
      if (res != null) {
        return res;
      }
      if (!hush) Util.closeAlertDialog();
    } catch (e) {
      if (!hush) Util.closeAlertDialog();
      final map = parseError(e);
      print(e);
      await Util.showErrorAlert(map["errorMsg"]!, title: "$funcName:${map["errorStatus"]!}", hush: hush);
      return null;
    }
  }
}
