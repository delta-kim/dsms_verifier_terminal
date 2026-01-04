import 'package:agent_dart/agent_dart.dart';

final CountryCode = IDL.Text;
final DID = IDL.Text;
final Token = IDL.Text;
final IdentityToken = IDL.Record({'did': DID, 'token': Token});
final CanisterId = IDL.Text;
final AppIdentityTokenArgs = IDL.Record({
  'dAppIdentToken': IdentityToken,
  'accCanisterId': CanisterId,
});
final MobileNumber = IDL.Text;
final Expiration = IDL.Nat;
final Timestamp = IDL.Nat;
final AccessNumberRecordAgrs = IDL.Record({
  'status': IDL.Text,
  'reqNum': IDL.Nat,
  'accessNumber': MobileNumber,
  'expiration': Expiration,
  'rewards': IDL.Nat,
  'succNum': IDL.Nat,
  'carrier': IDL.Text,
  'online': Timestamp,
});
final Result = IDL.Variant({
  'ok': AccessNumberRecordAgrs,
  'err': IDL.Text,
});
final CoinCode = IDL.Text;
final CoinName = IDL.Text;
final TransferFee = IDL.Record({
  'max': IDL.Nat,
  'min': IDL.Nat,
  'rate': IDL.Nat,
});
final ChainIdent = IDL.Text;
final ContractConf = IDL.Record({
  'chainIdent': ChainIdent,
  'tokenAddress': IDL.Text,
  'inputDecimals': IDL.Nat,
  'standard': IDL.Text,
});
final CrossChainConf = IDL.Variant({
  'native': IDL.Record({
    'chainIdent': ChainIdent,
    'inputDecimals': IDL.Nat,
  }),
  'contract': ContractConf,
  'Delta': IDL.Null,
});
final LedgerInitArgs = IDL.Record({
  'web': IDL.Text,
  'decimals': IDL.Nat,
  'code': CoinCode,
  'name': CoinName,
  'transferFee': TransferFee,
  'crossChainConfs': IDL.Vec(CrossChainConf),
  'symbol': IDL.Text,
});
final DID__1 = IDL.Text;
final Summary = IDL.Variant({
  'ReleaseToMintDTC': IDL.Nat64,
  'PreMint1DTCInEcosystem': IDL.Nat64,
  'RecommendNewcomers': DID__1,
  'DSMSVerifyReward': DID__1,
  'RegisterFromReferrer': DID__1,
  'Mining': IDL.Text,
  'ICPCrowdfunding': IDL.Nat32,
  'MiningReferralLevel1': IDL.Text,
  'MiningReferralLevel2': IDL.Text,
});
final DTCTHistory64 = IDL.Record({
  'did': DID__1,
  'summary': Summary,
  'timestamp': IDL.Nat64,
  'index': IDL.Nat64,
  'amount': IDL.Int64,
});
final DID__2 = IDL.Text;
final USCTSummary = IDL.Variant({
  'ConvertToUSDT': IDL.Tuple([IDL.Float64, IDL.Nat64]),
  'AdRewards': IDL.Null,
  'AdRewardsReferralLevel1': DID__2,
  'AdRewardsReferralLevel2': DID__2,
});
final USCTHistory64 = IDL.Record({
  'did': DID__2,
  'created': IDL.Nat64,
  'adId': IDL.Text,
  'summary': USCTSummary,
  'checkTime': IDL.Nat64,
  'advertiser': IDL.Text,
  'index': IDL.Nat64,
  'amount': IDL.Int64,
});
final HistoryByType = IDL.Variant({
  'DTCT': IDL.Vec(DTCTHistory64),
  'USCT': IDL.Vec(USCTHistory64),
});
final BasicInfo = IDL.Record({
  'population': IDL.Nat,
  'baseRate': IDL.Nat,
});
final Index = IDL.Nat;
final E164Code = IDL.Text;
final VerificationPack = IDL.Record({
  'verifyText': IDL.Text,
  'encryptKey': IDL.Text,
  'accessNumbers': IDL.Vec(MobileNumber),
});
final CanisterCodeType = IDL.Variant({
  'ICPfunds': IDL.Null,
  'DappCenter': IDL.Null,
  'stats': IDL.Null,
  'Ledgers': CoinCode,
  'account': IDL.Null,
  'PendingUSCT': IDL.Null,
  'xCredits': IDL.Null,
  'MultiChainWallet': IDL.Null,
  'mobile': IDL.Null,
  'RoadMap': IDL.Null,
});
final ActorCanisterId = IDL.Tuple([
  IDL.Text,
  IDL.Variant({'one': CanisterId, 'list': IDL.Vec(CanisterId)})
]);
final MobileAppType = IDL.Variant({'ios': IDL.Null, 'android': IDL.Null});
final MobileApplastVersion = IDL.Variant({
  'ios': IDL.Record({'version': IDL.Text, 'store': IDL.Text}),
  'android': IDL.Record({
    'apk': IDL.Text,
    'version': IDL.Text,
    'store': IDL.Text,
  }),
});
final CreditType = IDL.Variant({'DTCT': IDL.Null, 'USCT': IDL.Null});
final CreditCanisterData = IDL.Record({
  'skip': Index,
  'fulled': IDL.Bool,
  'length': Index,
  'canisterId': CanisterId,
});
final CanisterDate = IDL.Record({
  'end': Index,
  'fulled': IDL.Bool,
  'start': Index,
  'canisterId': CanisterId,
});
final E164Code2 = IDL.Text;
final E164AndISOCode = IDL.Tuple([E164Code, E164Code2, CountryCode]);
final VerifyStatus = IDL.Variant({
  'success': IDL.Null,
  'waiting': IDL.Null,
  'partSuccs': IDL.Null,
});
final Update2Main = IDL.Variant({
  'LedgerArchiveId': IDL.Tuple([CoinCode, CanisterId]),
  'SubMiningCredit': IDL.Nat,
});
final TotalCredit = IDL.Record({
  'fuel': IDL.Nat,
  'mining': IDL.Nat,
  'ecolog': IDL.Nat,
  'consensusDev': IDL.Nat,
});

final funcMap = {
  'activeAccessNumber2online2': IDL.Func(
    [IDL.Text, CountryCode, AppIdentityTokenArgs],
    [Result],
    [],
  ),
  'addAccessNumber': IDL.Func(
    [DID, IDL.Text, IDL.Text, Expiration],
    [IDL.Bool],
    [],
  ),
  'basicInfo': IDL.Func([], [BasicInfo], ['query']),
  'buildAccessNumberActiveCode': IDL.Func(
    [CanisterId, CountryCode, IdentityToken],
    [IDL.Text],
    [],
  ),
  'callbackVerification': IDL.Func(
    [IDL.Text, AppIdentityTokenArgs],
    [IDL.Text],
    [],
  ),
  'checkAccessNumberLimit': IDL.Func(
    [CountryCode],
    [
      IDL.Record({
        'err': IDL.Text,
        'allowedNum': IDL.Nat,
        'acNum': IDL.Nat,
      }),
    ],
    ['composite_query'],
  ),
  'countAccessNumberRecord': IDL.Func(
    [],
    [
      IDL.Vec(IDL.Tuple([CountryCode, IDL.Nat]))
    ],
    ['query'],
  ),
  'countDids': IDL.Func([], [Index], ['query']),
  'createLogin': IDL.Func(
    [IDL.Text, DID, IDL.Text],
    [CanisterId, DID, Token],
    [],
  ),
  'createVerification': IDL.Func(
    [
      IDL.Vec(IDL.Text),
      IDL.Vec(DID),
      IDL.Text,
      E164Code,
      CountryCode,
      IDL.Text,
    ],
    [VerificationPack],
    [],
  ),
  'cyclesBalance': IDL.Func([], [IDL.Nat], ['query']),
  'filterOptionalAccessNumbers': IDL.Func(
    [CountryCode],
    [
      IDL.Vec(IDL.Tuple([DID, AccessNumberRecordAgrs]))
    ],
    ['query'],
  ),
  'getAccessNumberRecord': IDL.Func(
    [CountryCode, DID],
    [IDL.Opt(AccessNumberRecordAgrs)],
    ['query'],
  ),
  'getCanisterId': IDL.Func([CanisterCodeType], [CanisterId], ['query']),
  'getCanisterIdMap': IDL.Func([], [IDL.Vec(ActorCanisterId)], ['query']),
  'getDSMSencryptKey': IDL.Func(
    [MobileNumber, AppIdentityTokenArgs],
    [IDL.Text],
    ['composite_query'],
  ),
  'getMobileApplastVersion': IDL.Func(
    [MobileAppType],
    [MobileApplastVersion],
    ['query'],
  ),
  'getXCreditCanisterData': IDL.Func(
    [CreditType],
    [IDL.Vec(CreditCanisterData)],
    ['query'],
  ),
  'init': IDL.Func(
    [IDL.Vec(IDL.Nat8), IDL.Vec(IDL.Nat8)],
    [IDL.Vec(IDL.Text)],
    [],
  ),
  'isAccountPrincipal': IDL.Func([IDL.Principal], [IDL.Bool], ['query']),
  'isCanAddAccessNumber': IDL.Func(
    [CountryCode, E164Code, MobileNumber],
    [IDL.Bool],
    ['composite_query'],
  ),
  'listAccountCanisterDate': IDL.Func(
    [],
    [IDL.Vec(CanisterDate)],
    ['query'],
  ),
  'listE164map': IDL.Func([], [IDL.Vec(E164AndISOCode)], ['query']),
  'matchAccountCanister': IDL.Func([DID], [IDL.Opt(CanisterId)], ['query']),
  'matchAccountCanisters': IDL.Func(
    [IDL.Vec(DID)],
    [
      IDL.Vec(IDL.Tuple([CanisterId, IDL.Vec(DID)]))
    ],
    ['query'],
  ),
  'parseDID': IDL.Func([DID], [Index], ['query']),
  'pauseAccessNumber': IDL.Func(
    [CountryCode, AppIdentityTokenArgs],
    [AccessNumberRecordAgrs],
    [],
  ),
  'queryVerifyStatus': IDL.Func([IDL.Text], [VerifyStatus], ['query']),
  'receiveUpdates': IDL.Func([Update2Main], [], ['oneway']),
  'reconcileUSCT': IDL.Func(
    [IDL.Text, IDL.Vec(IDL.Text), IDL.Vec(IDL.Nat64), IDL.Nat64],
    [IDL.Bool],
    [],
  ),
  'remainingTotalCredit': IDL.Func([], [TotalCredit], ['query']),
  'renewalAccessNumber': IDL.Func(
    [DID, CountryCode, Expiration],
    [IDL.Bool],
    [],
  ),
  'rts_info': IDL.Func(
    [],
    [
      IDL.Vec(IDL.Tuple([IDL.Text, IDL.Nat]))
    ],
    ['query'],
  ),
  'setGlobalAccessNumber': IDL.Func(
    [IDL.Text, IDL.Text, IDL.Opt(IDL.Text)],
    [IDL.Text],
    [],
  ),
  'updateAccessNumberOnline2': IDL.Func(
    [CountryCode, AppIdentityTokenArgs, IDL.Text],
    [AccessNumberRecordAgrs],
    [],
  ),
  'updateCanisterStatus': IDL.Func([CanisterId], [IDL.Bool], []),
  'updateLedgersArgs': IDL.Func([LedgerInitArgs], [], ['oneway']),
  'updateMobileApplastVersion': IDL.Func(
    [IDL.Vec(MobileApplastVersion)],
    [IDL.Bool],
    [],
  ),
  'upgradeCanister': IDL.Func(
    [CanisterCodeType, IDL.Vec(IDL.Nat8)],
    [IDL.Text],
    [],
  ),
  'upload_wasm_module': IDL.Func(
    [IDL.Vec(IDL.Nat8), IDL.Vec(IDL.Nat8)],
    [IDL.Bool],
    [],
  ),
  'verifyConfirmation': IDL.Func(
    [IDL.Text],
    [VerifyStatus, MobileNumber],
    [],
  ),
};
