import 'package:flutter/foundation.dart';
import 'package:provider/provider.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'dart:convert';
export 'package:provider/provider.dart';
import 'package:get_storage/get_storage.dart';
export 'package:get_storage/get_storage.dart';

final GetStorage storage = GetStorage();
const sstorage = FlutterSecureStorage();

class Data with ChangeNotifier, DiagnosticableTreeMixin {
  String _langCode = "";
  Map<String, dynamic> _appIdentityToken = {};
  String _acctCanisterId = "";
  Map<String, dynamic> _acctInfo = {};
  String icErrorMsg = "";
  String icErrorLanglabel = "";
  String packageVersion = "0.0.0";

  Future<String> getLangCode() async {
    if (_langCode == '') {
      String? temp = await sstorage.read(key: "langCode");
      if (temp != null) {
        _langCode = temp;
      }
    }
    return _langCode;
  }

  String get langCode {
    return _langCode;
  }

  Map<String, dynamic> get appIdentityToken => _appIdentityToken;
  Map<String, dynamic> get acctInfo => _acctInfo;

  Future<void> get loadAppIdentityToken async {
    final tmp = await sstorage.read(key: "identityToken");
    if (tmp != null) {
      _appIdentityToken = json.decode(tmp);
      //_appIdentityToken = tem_.map((key, value) => MapEntry(key, value.toString()));
    }
  }

  String get acctCanisterId {
    return _acctCanisterId;
  }

  void setAcctInfo(Map<String, dynamic> acctInfo) {
    _acctInfo = acctInfo;
    notifyListeners();
  }

  Future<String> loadAcctCanisterId() async {
    if (_acctCanisterId != "") {
      return _acctCanisterId;
    }
    final temp = await sstorage.read(key: "acctCanisterId");
    if (temp != null) {
      _acctCanisterId = temp;
    }
    return _acctCanisterId;
  }

  void setLangCode(String langCode) {
    sstorage.write(key: "langCode", value: langCode);
    _langCode = langCode;
    notifyListeners();
  }

  void setAppIdentityToken(Map<String, dynamic> appIdentityToken) {
    _appIdentityToken = appIdentityToken;
    sstorage.write(key: "identityToken", value: json.encode(appIdentityToken));
    notifyListeners();
  }

  void setAcctCanisterId(String acctCanisterId) {
    _acctCanisterId = acctCanisterId;
    sstorage.write(key: "acctCanisterId", value: acctCanisterId);
    notifyListeners();
  }

  void notify() {
    notifyListeners();
  }

  void removeAcctCanisterId() {
    _acctCanisterId = "";
    sstorage.delete(key: "acctCanisterId");
  }

  /// Makes `Data` readable inside the devtools by listing all of its properties
  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(StringProperty('langCode', _langCode));
    properties.add(ObjectFlagProperty<Map<String, dynamic>>('appIdentityToke', _appIdentityToken));
    properties.add(StringProperty('acctCanisterId', _acctCanisterId));
  }
}
