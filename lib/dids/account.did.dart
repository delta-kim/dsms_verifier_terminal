import 'package:agent_dart/agent_dart.dart';

const Index = IDL.Nat;
const Uid = IDL.Nat;
const CanisterId = IDL.Text;
final CanisterDate = IDL.Record({
  'end': Index,
  'fulled': IDL.Bool,
  'start': Index,
  'canisterId': CanisterId,
});
const CoinName = IDL.Text;
final CanisterMapArgs = IDL.Record({
  'mobileCanisterId': CanisterId,
  'statsCanisterId': CanisterId,
  'hangUSCTCanisterId': CanisterId,
  'accountCanisters': IDL.Vec(CanisterDate),
  'mcWalletCanisterId': CanisterId,
  'ICPfundsCanisterId': CanisterId,
  'Ledgers': IDL.Vec(IDL.Tuple([CoinName, CanisterId])),
  'dappCenterCanisterId': CanisterId,
});
const DID = IDL.Text;
const Timestamp = IDL.Nat;
const TxIndex = IDL.Nat;
final USCTSummary__1 = IDL.Variant({
  'ConvertToUSDT': IDL.Tuple([IDL.Float64, TxIndex]),
  'AdRewards': IDL.Null,
  'AdRewardsReferralLevel1': DID,
  'AdRewardsReferralLevel2': DID,
});
const Balance = IDL.Nat;
final HangUpUSCTHistoryArgs = IDL.Record({
  'did': DID,
  'created': Timestamp,
  'adId': IDL.Text,
  'summary': USCTSummary__1,
  'adInfo': IDL.Text,
  'advertiser': IDL.Text,
  'amount': Balance,
});
const MoneyAddress = IDL.Text;
const CoinCode = IDL.Text;
const Token = IDL.Text;
final IdentityToken = IDL.Record({'did': DID, 'token': Token});
final ResultErr = IDL.Record({'msg': IDL.Text, 'code': IDL.Nat16});
final Result = IDL.Variant({'ok': IDL.Text, 'err': ResultErr});
const AppId = IDL.Nat;
const OutsideAdderss = IDL.Text;
final DepositAddressArgs = IDL.Record({
  'now': Timestamp,
  'expiryTime': Timestamp,
  'address': OutsideAdderss,
});
const MobileNumber = IDL.Text;
final ADLevel = IDL.Variant({
  'level0': IDL.Null,
  'level1': IDL.Null,
  'level2': IDL.Null,
});
const Expiration = IDL.Nat;
final AppIdentityToken = IDL.Record({
  'expiration': Expiration,
  'dAppIdentToken': IdentityToken,
  'accCanisterId': CanisterId,
});
const CountryCode = IDL.Text;
final Result__1 = IDL.Variant({'ok': IDL.Bool, 'err': ResultErr});
final SafetyCircle = IDL.Record({'did': DID, 'appellation': IDL.Text});
final Result_1 = IDL.Variant({'ok': IDL.Null, 'err': ResultErr});
const TxHash = IDL.Text;
const ChainIdent = IDL.Text;
const Note = IDL.Text;
final ExportTokenResult = IDL.Variant({
  'ok': IDL.Record({
    'chainCoinCode': CoinCode,
    'chainFee': Balance,
    'txHash': TxHash,
    'amount': Balance,
  }),
  'err': Note,
  'pending': TxHash,
  'execution': IDL.Null,
});
final Value = IDL.Variant({
  'Int': IDL.Int,
  'Nat': IDL.Nat,
  'Blob': IDL.Vec(IDL.Nat8),
  'Text': IDL.Text,
  'ArrayText': IDL.Vec(IDL.Text),
  'ArrayNat': IDL.Vec(IDL.Nat),
});
const Nickname = IDL.Text;
final Role = IDL.Variant({
  'miner': IDL.Null,
  'verifier': IDL.Null,
  'core': IDL.Null,
  'ambassador': IDL.Null,
  'developer': IDL.Null,
});
final MiningStatus = IDL.Variant({
  'mining': IDL.Null,
  'inactive': IDL.Null,
});
final MiningDetailArgs = IDL.Record({
  'status': MiningStatus,
  'clickTime': IDL.Vec(Timestamp),
  'days': IDL.Nat,
});
final AccountBasic = IDL.Record({
  'created': Timestamp,
  'credits': IDL.Record({
    'IncDTCT': IDL.Nat,
    'IncUSCT': IDL.Nat,
    'DTCT': IDL.Int,
    'USCT': IDL.Int,
    'USCTdecimals': IDL.Nat8,
    'DTCTdecimals': IDL.Nat8,
  }),
  'referees': IDL.Vec(DID),
  'referrer': DID,
  'nickname': Nickname,
  'cCode': CountryCode,
  'safetyCirclesLength': IDL.Nat,
  'index': Index,
  'mobile': MobileNumber,
  'roles': IDL.Vec(IDL.Tuple([Role, Timestamp])),
  'miningDetail': MiningDetailArgs,
  'avatar': IDL.Text,
});
final AccountStatus = IDL.Variant({
  'logOut': IDL.Null,
  'unregistered': IDL.Null,
  'logIn': IDL.Null,
});
final DAppAcctInfo = IDL.Record({
  'uid': Uid,
  'nickname': Nickname,
  'cCode': CountryCode,
  'roles': IDL.Vec(IDL.Tuple([Role, Timestamp])),
  'avatar': IDL.Text,
});
final ExportTokenError = IDL.Opt(IDL.Tuple([ChainIdent, Timestamp, Note]));
const DID__1 = IDL.Text;
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
final DTCTHistory = IDL.Record({
  'did': DID__1,
  'summary': Summary,
  'timestamp': IDL.Nat,
  'index': IDL.Nat,
  'amount': IDL.Int,
});
final DepositAddress = IDL.Record({
  'expiryTime': Timestamp,
  'address': OutsideAdderss,
});
final USCTSummary = IDL.Variant({
  'ConvertToUSDT': IDL.Tuple([IDL.Float64, IDL.Nat64]),
  'AdRewards': IDL.Null,
  'AdRewardsReferralLevel1': DID__1,
  'AdRewardsReferralLevel2': DID__1,
});
final USCTHistory = IDL.Record({
  'did': DID__1,
  'created': IDL.Nat,
  'adId': IDL.Text,
  'summary': USCTSummary,
  'adInfo': IDL.Text,
  'checkTime': IDL.Nat,
  'advertiser': IDL.Text,
  'index': IDL.Nat,
  'amount': IDL.Int,
});
const Advertiser = IDL.Text;
final CanisterTypeData = IDL.Variant({
  'Null': IDL.Null,
  'Ledgers': IDL.Tuple([CoinCode, CanisterId]),
  'account': CanisterDate,
});
final HistoryArgs = IDL.Record({
  'did': DID__1,
  'created': IDL.Nat64,
  'adId': IDL.Text,
  'summary': USCTSummary,
  'adInfo': IDL.Text,
  'advertiser': IDL.Text,
  'amount': IDL.Nat64,
});

final funcMap = {
  'addendDSMSVerifyReward': IDL.Func(
    [DID, IDL.Nat, IDL.Opt(DID)],
    [],
    ['oneway'],
  ),
  'allowChangeMobile': IDL.Func(
    [IdentityToken, IDL.Text, IDL.Text],
    [IDL.Bool],
    [],
  ),
  'appTokenStatus': IDL.Func([AppId, IdentityToken], [IDL.Text], ['query']),
  'appendReferee': IDL.Func([DID, DID, IDL.Nat], [], []),
  'applyAndRenewDepositAddress': IDL.Func(
    [MoneyAddress, CoinCode, IDL.Text, IdentityToken],
    [DepositAddressArgs],
    [],
  ),
  'applyDSMSVerifierIdentity': IDL.Func(
    [IDL.Text, IDL.Text, IdentityToken],
    [IDL.Bool],
    [],
  ),
  'changeMobileHistory': IDL.Func(
    [IdentityToken],
    [
      IDL.Vec(IDL.Tuple([MobileNumber, Timestamp]))
    ],
    ['query'],
  ),
  'changeMobileNumber': IDL.Func(
    [IdentityToken, MobileNumber, IDL.Text],
    [IDL.Bool],
    [],
  ),
  'checkExist': IDL.Func([DID], [IDL.Bool], ['query']),
  'childRewardTimeAndReferees': IDL.Func(
    [IDL.Vec(DID), DID, ADLevel, IDL.Nat],
    [IDL.Nat, IDL.Nat, IDL.Vec(DID)],
    ['query'],
  ),
  'clearWalletExportError': IDL.Func(
    [MoneyAddress, CoinCode, IdentityToken],
    [IDL.Bool],
    [],
  ),
  'convertUSCT2USDT': IDL.Func(
    [IDL.Nat, MoneyAddress, IdentityToken],
    [IDL.Bool],
    [],
  ),
  'createDappToken': IDL.Func(
    [AppId, IdentityToken],
    [AppIdentityToken],
    [],
  ),
  'createOne': IDL.Func(
    [DID, Index, MobileNumber, CountryCode, DID, IDL.Text, Token, IDL.Nat],
    [IDL.Bool],
    [],
  ),
  'crowdfundingICP': IDL.Func(
    [IDL.Nat, MoneyAddress, IdentityToken],
    [Balance],
    [],
  ),
  'dailyMining': IDL.Func([IdentityToken], [IDL.Bool], []),
  'delSafetyCircle': IDL.Func([IdentityToken, SafetyCircle], [IDL.Bool], []),
  'depositCallBack': IDL.Func(
    [Balance, TxHash, OutsideAdderss, MoneyAddress, CoinCode, ChainIdent],
    [],
    ['oneway'],
  ),
  'dsmsAccessStatus': IDL.Func(
    [IdentityToken],
    [
      IDL.Opt(IDL.Tuple([Timestamp, Timestamp]))
    ],
    ['query'],
  ),
  'exportToken': IDL.Func(
    [MoneyAddress, CoinCode, IDL.Nat, IDL.Text, ChainIdent, IdentityToken],
    [Balance],
    [],
  ),
  'exportTokenCallBack': IDL.Func(
    [ExportTokenResult, OutsideAdderss, MoneyAddress, CoinCode, ChainIdent],
    [IDL.Bool],
    [],
  ),
  'forceLogin': IDL.Func([DID, IDL.Text, IDL.Text], [DID, Token], []),
  'generate3virtualAddr': IDL.Func([], [Index], []),
  'generateSafetyCode': IDL.Func([DID], [IDL.Opt(SafetyCircle)], []),
  'getAccountExtras': IDL.Func(
    [IdentityToken, IDL.Text],
    [IDL.Opt(Value)],
    ['query'],
  ),
  'getAccountInfo': IDL.Func([IdentityToken], [AccountBasic], ['query']),
  'getAccountStatus': IDL.Func([DID], [AccountStatus], ['query']),
  'getDAppAcctInfo': IDL.Func(
    [IdentityToken, AppId],
    [DAppAcctInfo],
    ['query'],
  ),
  'getDepositAddress': IDL.Func(
    [MoneyAddress, CoinCode, IDL.Text, IdentityToken],
    [DepositAddressArgs],
    ['query'],
  ),
  'getWalletBalance': IDL.Func(
    [MoneyAddress, CoinCode, IdentityToken],
    [Balance, ExportTokenError],
    ['query'],
  ),
  'listAvatarNickname': IDL.Func(
    [IDL.Vec(DID)],
    [
      IDL.Vec(IDL.Tuple([DID, Nickname, IDL.Text]))
    ],
    ['query'],
  ),
  'listDTCTBuffer': IDL.Func(
    [IdentityToken],
    [IDL.Vec(DTCTHistory)],
    ['query'],
  ),
  'listSecondReferees': IDL.Func(
    [IDL.Vec(DID), IDL.Bool, IdentityToken],
    [
      IDL.Vec(IDL.Tuple([DID, Nickname, MiningStatus, IDL.Text, IDL.Vec(DID)])),
    ],
    ['query'],
  ),
  'listTempDepositAddress': IDL.Func(
    [IdentityToken],
    [
      IDL.Vec(IDL.Tuple([IDL.Text, DepositAddress]))
    ],
    ['query'],
  ),
  'listUSCTBuffer': IDL.Func(
    [IdentityToken],
    [IDL.Vec(USCTHistory)],
    ['query'],
  ),
  'listWalletBalance': IDL.Func(
    [MoneyAddress, IDL.Vec(CoinCode), IdentityToken],
    [
      IDL.Vec(IDL.Record({'balance': Balance, 'coinCode': CoinCode}))
    ],
    ['query'],
  ),
  'logOut': IDL.Func([IdentityToken], [IDL.Bool], []),
  'miningUSCT': IDL.Func(
    [IdentityToken, Advertiser, IDL.Nat64, IDL.Text, IDL.Text],
    [IDL.Bool],
    [],
  ),
  'overViewWallet': IDL.Func(
    [IDL.Vec(CoinCode), IdentityToken],
    [
      IDL.Record({
        'total': IDL.Vec(IDL.Record({'balance': Balance, 'coinCode': CoinCode})),
        'list': IDL.Vec(IDL.Tuple([MoneyAddress, Note])),
        'defaultAddress': MoneyAddress,
      }),
    ],
    ['query'],
  ),
  'payDSMSverifyFee': IDL.Func(
    [DID, IDL.Vec(DID)],
    [
      IDL.Vec(IDL.Tuple([DID, Balance]))
    ],
    [],
  ),
  'pendingUSCTBuffer': IDL.Func(
    [IdentityToken],
    [IDL.Vec(HistoryArgs)],
    ['query'],
  ),
  'queryProvideSafety': IDL.Func([IdentityToken], [IDL.Vec(DID)], ['query']),
  'querySafetyCircles': IDL.Func(
    [IdentityToken],
    [IDL.Vec(SafetyCircle)],
    ['query'],
  ),
  'readSafetyCode': IDL.Func(
    [IdentityToken, DID],
    [IDL.Opt(IDL.Text)],
    ['query'],
  ),
  'receiveBroadcast': IDL.Func(
    [IDL.Opt(Index), CanisterTypeData],
    [],
    ['oneway'],
  ),
  'renewalDSMSVerifierIdentity': IDL.Func([IdentityToken], [IDL.Bool], []),
  'rts_info': IDL.Func(
    [],
    [
      IDL.Vec(IDL.Tuple([IDL.Text, IDL.Nat]))
    ],
    ['query'],
  ),
  'setAccount': IDL.Func(
    [IDL.Text, IDL.Text, IdentityToken],
    [IDL.Bool],
    [],
  ),
  'setLogin': IDL.Func([DID, Token], [], ['oneway']),
  'setSafetyCircle': IDL.Func([IdentityToken, SafetyCircle], [IDL.Text], []),
  'setWallet': IDL.Func(
    [
      IDL.Variant({
        'new': IDL.Null,
        'note': IDL.Vec(IDL.Text),
        'default': MoneyAddress,
      }),
      IdentityToken,
    ],
    [
      IDL.Record({
        'list': IDL.Vec(IDL.Tuple([MoneyAddress, Note])),
        'defaultAddress': MoneyAddress,
      }),
    ],
    [],
  ),
  'unconfirmedUSCT': IDL.Func(
    [IdentityToken],
    [IDL.Nat64, IDL.Nat64],
    ['query'],
  ),
  'testQualificatin': IDL.Func(
    [IDL.Text, IdentityToken],
    [IDL.Bool],
    ['query'],
  ),
  'transferToken': IDL.Func(
    [
      MoneyAddress,
      CoinCode,
      IDL.Nat,
      MoneyAddress,
      IDL.Text,
      IdentityToken,
    ],
    [Balance],
    [],
  ),
  'unbindDepositAddress': IDL.Func(
    [MoneyAddress, CoinCode, IDL.Text, IdentityToken],
    [IDL.Bool],
    [],
  ),
  'usctMiningTimestamp': IDL.Func(
    [IdentityToken],
    [
      IDL.Vec(IDL.Tuple([Advertiser, Timestamp]))
    ],
    ['query'],
  ),
  'walletAddressList': IDL.Func(
    [IdentityToken],
    [
      IDL.Record({
        'list': IDL.Vec(IDL.Tuple([MoneyAddress, Note])),
        'defaultAddress': MoneyAddress,
      }),
    ],
    ['query'],
  ),
};
