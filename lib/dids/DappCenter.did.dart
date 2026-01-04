import 'package:agent_dart/agent_dart.dart';

final AppId = IDL.Nat;
final Url = IDL.Text;
final CountryCode = IDL.Text;
final DeveloperInfo = IDL.Record({
  'teamName': IDL.Text,
  'githubPage': Url,
  'cCode': CountryCode,
  'other': IDL.Text,
  'email': IDL.Text,
  'website': Url,
});
final DID = IDL.Text;
final Token = IDL.Text;
final IdentityToken = IDL.Record({'did': DID, 'token': Token});
final CanisterId = IDL.Text;
final Status = IDL.Variant({
  'Online': IDL.Null,
  'InPublicBeta': IDL.Null,
  'Offline': IDL.Null,
  'InDevelopment': IDL.Null,
  'Frozen': IDL.Null,
});
final Note = IDL.Text;
final DappCategory = IDL.Variant({
  'DEX': IDL.Null,
  'NFT': IDL.Null,
  'Games': IDL.Null,
  'Base': IDL.Null,
  'DeFi': IDL.Null,
  'News': IDL.Null,
  'Social': IDL.Null,
  'Shopping': IDL.Null,
  'Tools': IDL.Null,
  'Gambling': IDL.Null,
});
final CreateAppinfo = IDL.Record({
  'appType': IDL.Text,
  'logo': Url,
  'name': IDL.Text,
  'description': IDL.Text,
  'keywords': IDL.Vec(IDL.Text),
  'category': IDL.Vec(DappCategory),
});
final Index = IDL.Nat;
final DappVersion = IDL.Float64;
final DAppType = IDL.Variant({
  'web': Url,
  'standaloneApp': IDL.Record({
    'android_apk': Url,
    'android_market': Url,
    'ios_store': Url,
  }),
  'mini': DappVersion,
});
final Category = IDL.Variant({
  'DEX': IDL.Null,
  'NFT': IDL.Null,
  'Games': IDL.Null,
  'Base': IDL.Null,
  'DeFi': IDL.Null,
  'News': IDL.Null,
  'Social': IDL.Null,
  'Shopping': IDL.Null,
  'Tools': IDL.Null,
  'Gambling': IDL.Null,
});
final Timestamp = IDL.Nat;
final AppInfoAllArgs = IDL.Record({
  'id': IDL.Nat,
  'status': Status,
  'teamDids': IDL.Vec(DID),
  'creatorDid': DID,
  'appType': DAppType,
  'logo': Url,
  'name': IDL.Text,
  'uses': IDL.Nat,
  'description': IDL.Text,
  'score': IDL.Record({
    'bad': IDL.Nat,
    'normal': IDL.Nat,
    'good': IDL.Nat,
  }),
  'keywords': IDL.Vec(IDL.Text),
  'users': IDL.Nat,
  'category': IDL.Vec(Category),
  'stateProcess': IDL.Vec(IDL.Tuple([Status, Timestamp, Note])),
});
final Error = IDL.Variant({
  'CanisterError': IDL.Record({'message': IDL.Text}),
  'InvalidCanister': IDL.Null,
});
final Result = IDL.Variant({'Ok': IDL.Text, 'Err': Error});
final AppInfoMoreArgs = IDL.Record({
  'status': Status,
  'teamDids': IDL.Vec(DID),
  'creatorDid': DID,
  'appType': DAppType,
  'description': IDL.Text,
  'keywords': IDL.Vec(IDL.Text),
  'users': IDL.Nat,
  'category': IDL.Vec(Category),
  'stateProcess': IDL.Vec(IDL.Tuple([Status, Timestamp, Note])),
});
final HttpHeader = IDL.Record({'value': IDL.Text, 'name': IDL.Text});
final HttpResponsePayload = IDL.Record({
  'status': IDL.Nat,
  'body': IDL.Vec(IDL.Nat8),
  'headers': IDL.Vec(HttpHeader),
});
final TransformArgs = IDL.Record({
  'context': IDL.Vec(IDL.Nat8),
  'response': HttpResponsePayload,
});
final Evaluation = IDL.Record({
  'did': DID,
  'content': IDL.Text,
  'score': IDL.Variant({
    'bad': IDL.Null,
    'normal': IDL.Null,
    'good': IDL.Null,
  }),
  'timestamp': Timestamp,
});
final OrderBy = IDL.Variant({
  'noSort': IDL.Null,
  'usesDESC': IDL.Null,
  'scoreDESC': IDL.Null,
});
final AppInfoArgs = IDL.Record({
  'id': IDL.Nat,
  'logo': Url,
  'name': IDL.Text,
  'uses': IDL.Nat,
  'score': IDL.Record({
    'bad': IDL.Nat,
    'normal': IDL.Nat,
    'good': IDL.Nat,
  }),
});
final AppInfoUpdate = IDL.Record({
  'logo': Url,
  'name': IDL.Text,
  'description': IDL.Text,
  'keywords': IDL.Vec(IDL.Text),
  'category': IDL.Vec(Category),
});
final Expiration = IDL.Nat;
final SessionId = IDL.Text;
final AppIdentityToken = IDL.Record({
  'expiration': Expiration,
  'dAppIdentToken': IdentityToken,
  'accCanisterId': CanisterId,
});
final AuthAppInfoArgs = IDL.Record({
  'id': IDL.Nat,
  'logo': Url,
  'name': IDL.Text,
  'uses': IDL.Nat,
  'score': IDL.Record({
    'bad': IDL.Nat,
    'normal': IDL.Nat,
    'good': IDL.Nat,
  }),
  'deviceDesc': IDL.Text,
});
final MiniVersionNotes = IDL.Tuple([DappVersion, Timestamp, Note]);
final funcMap = {
    'becomeDeveloper' : IDL.Func(
        [DeveloperInfo, Url, IdentityToken, CanisterId],
        [DeveloperInfo],
        [],
      ),
    'changeStatus' : IDL.Func(
        [IDL.Nat, Status, Note, IdentityToken, CanisterId],
        [IDL.Bool],
        [],
      ),
    'confirmAuthSubAppLogin' : IDL.Func(
        [SessionId, AppId, IdentityToken, CanisterId],
        [IDL.Bool],
        [],
      ),
    'createSubAppAuthSession' : IDL.Func([IDL.Text, AppId], [SessionId], []),
    'init' : IDL.Func([IDL.Vec(IDL.Nat8)], [CanisterId], []),
    'listEvaluation' : IDL.Func(
        [Index, IDL.Nat],
        [IDL.Vec(Evaluation)],
        ['query'],
      ),
    'miniDAppAuthByIdentToken' : IDL.Func(
        [AppId, IDL.Text, IdentityToken, CanisterId],
        [AppIdentityToken],
        [],
      ),
    'postEvaluation' : IDL.Func(
        [Index, Evaluation, IdentityToken, CanisterId],
        [Evaluation],
        [],
      ),
    'querySubAppAuthByApp' : IDL.Func(
        [SessionId],
        [IDL.Opt(AppIdentityToken)],
        ['query'],
      ),
    'querySubAppAuthByMian' : IDL.Func(
        [SessionId],
        [AuthAppInfoArgs],
        ['query'],
      ),

    'selectAppInfo' : IDL.Func(
        [Status, IDL.Opt(Category), IDL.Opt(IDL.Text), OrderBy, IDL.Nat],
        [IDL.Vec(AppInfoArgs)],
        ['composite_query'],
      ),
    'sqliteCanisterid' : IDL.Func([], [IDL.Text], ['query']),
    'updateAppInfo' : IDL.Func(
        [IDL.Nat, AppInfoUpdate, IdentityToken, CanisterId],
        [IDL.Bool],
        [],
      ),
    'updateDSMSAppDid' : IDL.Func([IdentityToken, CanisterId], [IDL.Bool], []),
    'updateDeveloperInfo' : IDL.Func(
        [DeveloperInfo, IdentityToken, CanisterId],
        [IDL.Bool],
        [],
      ),
};
