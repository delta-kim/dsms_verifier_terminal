/// Generated file. Do not edit.
///
/// Original: lib/i18n
/// To regenerate, run: `dart run slang`
///
/// Locales: 2
/// Strings: 223 (111 per locale)
///
/// Built on 2025-09-26 at 09:22 UTC

// coverage:ignore-file
// ignore_for_file: type=lint

import 'package:flutter/widgets.dart';
import 'package:slang/builder/model/node.dart';
import 'package:slang_flutter/slang_flutter.dart';
export 'package:slang_flutter/slang_flutter.dart';

const AppLocale _baseLocale = AppLocale.en;

/// Supported locales, see extension methods below.
///
/// Usage:
/// - LocaleSettings.setLocale(AppLocale.en) // set locale
/// - Locale locale = AppLocale.en.flutterLocale // get flutter locale from enum
/// - if (LocaleSettings.currentLocale == AppLocale.en) // locale check
enum AppLocale with BaseAppLocale<AppLocale, Translations> {
	en(languageCode: 'en', build: Translations.build),
	zhCn(languageCode: 'zh', countryCode: 'CN', build: _StringsZhCn.build);

	const AppLocale({required this.languageCode, this.scriptCode, this.countryCode, required this.build}); // ignore: unused_element

	@override final String languageCode;
	@override final String? scriptCode;
	@override final String? countryCode;
	@override final TranslationBuilder<AppLocale, Translations> build;

	/// Gets current instance managed by [LocaleSettings].
	Translations get translations => LocaleSettings.instance.translationMap[this]!;
}

/// Method A: Simple
///
/// No rebuild after locale change.
/// Translation happens during initialization of the widget (call of t).
/// Configurable via 'translate_var'.
///
/// Usage:
/// String a = t.someKey.anotherKey;
/// String b = t['someKey.anotherKey']; // Only for edge cases!
Translations get t => LocaleSettings.instance.currentTranslations;

/// Method B: Advanced
///
/// All widgets using this method will trigger a rebuild when locale changes.
/// Use this if you have e.g. a settings page where the user can select the locale during runtime.
///
/// Step 1:
/// wrap your App with
/// TranslationProvider(
/// 	child: MyApp()
/// );
///
/// Step 2:
/// final t = Translations.of(context); // Get t variable.
/// String a = t.someKey.anotherKey; // Use t variable.
/// String b = t['someKey.anotherKey']; // Only for edge cases!
class TranslationProvider extends BaseTranslationProvider<AppLocale, Translations> {
	TranslationProvider({required super.child}) : super(settings: LocaleSettings.instance);

	static InheritedLocaleData<AppLocale, Translations> of(BuildContext context) => InheritedLocaleData.of<AppLocale, Translations>(context);
}

/// Method B shorthand via [BuildContext] extension method.
/// Configurable via 'translate_var'.
///
/// Usage (e.g. in a widget's build method):
/// context.t.someKey.anotherKey
extension BuildContextTranslationsExtension on BuildContext {
	Translations get t => TranslationProvider.of(this).translations;
}

/// Manages all translation instances and the current locale
class LocaleSettings extends BaseFlutterLocaleSettings<AppLocale, Translations> {
	LocaleSettings._() : super(utils: AppLocaleUtils.instance);

	static final instance = LocaleSettings._();

	// static aliases (checkout base methods for documentation)
	static AppLocale get currentLocale => instance.currentLocale;
	static Stream<AppLocale> getLocaleStream() => instance.getLocaleStream();
	static AppLocale setLocale(AppLocale locale, {bool? listenToDeviceLocale = false}) => instance.setLocale(locale, listenToDeviceLocale: listenToDeviceLocale);
	static AppLocale setLocaleRaw(String rawLocale, {bool? listenToDeviceLocale = false}) => instance.setLocaleRaw(rawLocale, listenToDeviceLocale: listenToDeviceLocale);
	static AppLocale useDeviceLocale() => instance.useDeviceLocale();
	@Deprecated('Use [AppLocaleUtils.supportedLocales]') static List<Locale> get supportedLocales => instance.supportedLocales;
	@Deprecated('Use [AppLocaleUtils.supportedLocalesRaw]') static List<String> get supportedLocalesRaw => instance.supportedLocalesRaw;
	static void setPluralResolver({String? language, AppLocale? locale, PluralResolver? cardinalResolver, PluralResolver? ordinalResolver}) => instance.setPluralResolver(
		language: language,
		locale: locale,
		cardinalResolver: cardinalResolver,
		ordinalResolver: ordinalResolver,
	);
}

/// Provides utility functions without any side effects.
class AppLocaleUtils extends BaseAppLocaleUtils<AppLocale, Translations> {
	AppLocaleUtils._() : super(baseLocale: _baseLocale, locales: AppLocale.values);

	static final instance = AppLocaleUtils._();

	// static aliases (checkout base methods for documentation)
	static AppLocale parse(String rawLocale) => instance.parse(rawLocale);
	static AppLocale parseLocaleParts({required String languageCode, String? scriptCode, String? countryCode}) => instance.parseLocaleParts(languageCode: languageCode, scriptCode: scriptCode, countryCode: countryCode);
	static AppLocale findDeviceLocale() => instance.findDeviceLocale();
	static List<Locale> get supportedLocales => instance.supportedLocales;
	static List<String> get supportedLocalesRaw => instance.supportedLocalesRaw;
}

// translations

// Path: <root>
class Translations implements BaseTranslations<AppLocale, Translations> {
	/// Returns the current translations of the given [context].
	///
	/// Usage:
	/// final t = Translations.of(context);
	static Translations of(BuildContext context) => InheritedLocaleData.of<AppLocale, Translations>(context).translations;

	/// You can call this constructor and build your own translation instance of this locale.
	/// Constructing via the enum [AppLocale.build] is preferred.
	Translations.build({Map<String, Node>? overrides, PluralResolver? cardinalResolver, PluralResolver? ordinalResolver})
		: assert(overrides == null, 'Set "translation_overrides: true" in order to enable this feature.'),
		  $meta = TranslationMetadata(
		    locale: AppLocale.en,
		    overrides: overrides ?? {},
		    cardinalResolver: cardinalResolver,
		    ordinalResolver: ordinalResolver,
		  ) {
		$meta.setFlatMapFunction(_flatMapFunction);
	}

	/// Metadata for the translations of <en>.
	@override final TranslationMetadata<AppLocale, Translations> $meta;

	/// Access flat map
	dynamic operator[](String key) => $meta.getTranslation(key);

	late final Translations _root = this; // ignore: unused_field

	// Translations
	String get tip => 'Tip';
	String get cancel => 'Cancel';
	String get close => 'Close';
	String get selected => 'Selected';
	String get edit => 'Edit';
	String get submit => 'submit';
	String get copiedToClipboard => 'Copied to clipboard.';
	String get nickname => 'NickName';
	String get confirm => 'Confirm';
	String get cannotBeEmpty => 'cannot be empty';
	String get deleteSuccessful => 'Delete successful!';
	String get successfullyModified => 'Successfully modified!';
	String get executionSuccessful => 'Execution successful!';
	String get parameterException => 'Parameter exception!';
	String get preview => 'PreView';
	String get change => 'Change';
	String get replace => 'Replace';
	String get view => 'View';
	String get manage => 'Manage';
	String get modify => 'Modify';
	String get replacedSuccessfully => 'Replaced successfully!';
	String get authentication => 'Authentication';
	String get reacquire => 'Reacquire';
	String get tryAgain => 'try Again';
	String get querying => 'Querying …';
	String get writingToOnChain_pleaseWait => 'Writing to the on-chain, please wait …';
	String get loginWithQRcode => 'Login with QR-code';
	String get useDeltaMobileApp => 'Use Delta mobile App';
	String get scanQRcodeToLogin => 'Scan the QR code to login';
	String get followSystem => 'follow System';
	String get switchLanguage => 'switch Language';
	String get languageSwitch => 'Language switch';
	String get refreshTheQRcode => 'Refresh the QR code';
	String get loginSuccessful => 'login successful!';
	String get accessNumber => 'Access Number';
	String get TELCO => 'TELCO';
	String get score => 'Score';
	String get lastHeartbeat => 'Last heartbeat';
	String get expirationTime => 'Expiration time';
	String get rewards => 'rewards';
	String get menu => 'menu';
	String get DSMSverifier => 'DSMS Verifier';
	String get refresh => 'Refresh';
	String unboundAccessNumberTip({required Object DSMSverifier, required Object menu, required Object refresh}) => 'You have not bound the verification access number yet. Please use the Delta application, then select the "${DSMSverifier}" menu on the "${menu}" page and apply for verification terminal permissions. After the application is successfully bound, click the "${refresh}" button below to reload and proceed to the next step.';
	String get received => 'Received';
	String get processing => 'Processing';
	String get replied => 'Replied';
	String get rejected => 'Rejected';
	String get unknown => 'Unknown';
	String get insufficientBalance => 'Insufficient balance!';
	String InsufficientXbalanceToPayCrossChainNetworkFee({required Object x}) => 'Insufficient ${x} balance to pay cross-chain network fee';
	String get aTransactionThatHasNotBeenCompleted_CannotBeTransferredAtMoment => 'There is a transaction that has not been completed and cannot be transferred at the moment.';
	String get thisfunctionNotSupportExternalCalls => 'This function does not support external calls';
	String get noMatchingAddressThatCanBeUsedToPayCrossChainFees_switchOtherChainToTry => 'There is no matching address that can be used to pay cross-chain fees, Please switch to other chain networks to try.';
	String currentMaximumMatchedSingleTransferAmountIsX({required Object x}) => 'The current maximum matched single transfer amount is ${x}';
	String get memoMustNotBeMoreThan64bytes => 'Memo must not be more than 64 bytes';
	String insufficientBalance_theAmountIsX({required Object x}) => 'Insufficient balance, the amount is: ${x}';
	String get boundRreceivingAddressesExceed3Tip => 'The number of bound receiving addresses cannot exceed 3. \nIf you need to bind a new receiving address, \nplease unbind another receiving address first.';
	String parametersA_exception({required Object x}) => 'Parameters: ${x}, exception';
	String get transferAmountMustBeLargerThan0 => 'Transfer amount must be larger than 0';
	String get authorizationHasExpired => 'Authorization has expired';
	String get theAppHasNotBeenAuthorizedByOwner => 'The app has not been authorized by the owner';
	String get authenticationTokenIsInvalid => 'Authentication token is invalid';
	String get verifyInfoIsInvalidOrExpired => 'verify Info is invalid or expired';
	String get verifyStringExpiredOrSenderNumberNotMatch => 'Verification string expired or sender number does not match';
	String get verifyThatNumberOfAccessTerminalsHasExceededLimitOf1in10000 => 'Verify that the number of access terminals has exceeded the limit of one in 10,000';
	String get timeToParticipateInMiningMustBeMoreThan3Days => 'The time to participate in mining must be more than 3 days';
	String get numberOfSafetyCircleCannotBeLessThan3 => 'The number of safety circle members cannot be less than 3 people';
	String get avatarIsNotSet => 'Avatar is not set';
	String get numberOfDirectReferralsCannotBeLessThan3 => 'The number of direct referrals cannot be less than 3 people';
	String get insufficientTimeLimit_mobileNumberOnlyChangedOnceYear => 'Insufficient time limit, mobile number can only be changed once a year.';
	String get mobileNumberAlreadyExistsAndCannotBeRepeated => 'This mobile phone number already exists and cannot be repeated';
	String get securityCodeIsIncorrect => 'Security code is incorrect';
	String get securityCodeMayHaveExpired => 'Security code may have expired';
	String get sessionIdIsInvalidOrExpired => 'The sessionId is invalid or expired';
	String get sessionHasBeenAuthorized => 'The session has been authorized!';
	String canOnlyBeRenewedWithinXdaysBeforeExpiration({required Object x}) => 'Can only be renewed within ${x} days before expiration';
	String get usageTips => 'Usage Tips';
	String get noLockScreen => 'No lock screen';
	String get usageTipStart => 'To ensure the success rate of verification string monitoring and forwarding, please implement the following tips:';
	String get usageTip1 => '1. Be sure to use a dedicated smartphone and a dedicated MSISDN (mobile number).';
	String get usageTip2 => '2. Please place the device in a suitable location to keep the network and communication signals good.';
	TextSpan usageTip3({required InlineSpan n, required InlineSpan noLockScreen}) => TextSpan(children: [
		n,
		const TextSpan(text: '. Please keep the device connected to the charging cable for a long time and turn on the "'),
		noLockScreen,
		const TextSpan(text: '" function. (Due to the differences in device manufacturers, please query the network or consult the device manufacturer for specific operations. Generally, you need to enter the developer mode to set)'),
	]);
	String get usageTip4 => '4. Try not to open other applications on this dedicated device, and do not install applications such as WeChat, WhatsApp, Facebook, Delta, Twitter, etc.';
	String get usageTip5 => '5. When the DSMS verification access terminal App is working, please put the application at the forefront of the screen.';
	String get usageTip6 => '6. When the system pops up SMS monitoring authorization, please click Allow. ';
	String get usageTipEnd => 'If the monitoring and forwarding success rate is too low due to various reasons, the system will cancel or suspend the verifier\'s qualification according to the algorithm rules. ';
	String get iHaveReadAndFollowed => 'I have read and followed the above precautions';
	String get nextStep => 'Next step';
	String pleaseCheckX({required Object text}) => 'Please check "${text}"';
	String alreadyinstalledConflictingApp({required Object name}) => 'It was found that "${name}" is already installed on the device. Please uninstall it and continue.';
	String get status => 'Status';
	String get pause => 'Pause';
	String get renewal => 'Renewal';
	String get activate => 'Activate';
	String get needToChangeNumber => 'Need to change number? ';
	String get goToDeltaDSMSVerifierPageOperate => 'Please go to the "DSMS verifier" page of the menu of the Delta main application to operate.';
	String get sendActivationCommandToTerminal => 'Send activation command to the terminal to activate';
	String get conTinue => 'Continue';
	String get needToExtend => 'Need to extend?';
	String get youConfirmThePause => 'Do you confirm the pause?';
	String get pauseUsedForMaintenanceOfDevices => 'The pause function is generally used for temporary maintenance of mobile devices.';
	String get scanQRcodeSupportsDeltaversions => 'Scan QR code login only supports Delta 1.0.9 and above';
	TextSpan justOnlineReminder({required InlineSpan online}) => TextSpan(children: [
		const TextSpan(text: 'Please don\'t worry. When there are two or more verification terminals in the "'),
		online,
		const TextSpan(text: '" state in your country and you are selected by the user who needs verification, you will receive a verification string.'),
	]);
	String get tip1 => '1. In order to provide good verification services to the community, please keep your SMS and network signals good at all times.';
	String get tip3 => '3. Please keep this app on top of the screen at all times.';
	String get tip4 => '4. Remember to turn off the "harassment blocking" and "stranger blocking" functions in your SMS and Internet-SMS programs.';
	String get tip4help => 'Generally, mobile phones of the same brand support free Internet SMS function. How to turn it off: Generally, you can see the turn-off function by clicking on the upper right corner of the SMS program.';
	String get noPermissionGrantedReadDeviceSMSmessages => 'No permission was granted to read device SMS messages';
	String get differentFromActualNumber => 'Different from the actual number';
	String get decryptionError => 'Decryption error';
}

// Path: <root>
class _StringsZhCn implements Translations {
	/// You can call this constructor and build your own translation instance of this locale.
	/// Constructing via the enum [AppLocale.build] is preferred.
	_StringsZhCn.build({Map<String, Node>? overrides, PluralResolver? cardinalResolver, PluralResolver? ordinalResolver})
		: assert(overrides == null, 'Set "translation_overrides: true" in order to enable this feature.'),
		  $meta = TranslationMetadata(
		    locale: AppLocale.zhCn,
		    overrides: overrides ?? {},
		    cardinalResolver: cardinalResolver,
		    ordinalResolver: ordinalResolver,
		  ) {
		$meta.setFlatMapFunction(_flatMapFunction);
	}

	/// Metadata for the translations of <zh-CN>.
	@override final TranslationMetadata<AppLocale, Translations> $meta;

	/// Access flat map
	@override dynamic operator[](String key) => $meta.getTranslation(key);

	@override late final _StringsZhCn _root = this; // ignore: unused_field

	// Translations
	@override String get home => '首页';
	@override String get loginWithQRcode => '使用二维码登录';
	@override String get useDeltaMobileApp => '使用Delta手机App';
	@override String get scanQRcodeToLogin => '扫描二维码登录';
	@override String get followSystem => '跟随系统';
	@override String get switchLanguage => '切换语言';
	@override String get languageSwitch => '语言切换';
	@override String get tip => '提示';
	@override String get cancel => '取消';
	@override String get close => '关闭';
	@override String get selected => '已选定';
	@override String get edit => '编辑';
	@override String get submit => '提交';
	@override String get copiedToClipboard => '已拷贝到剪切板。';
	@override String get nickname => '昵称';
	@override String get confirm => '确认';
	@override String get cannotBeEmpty => '不能为空';
	@override String get deleteSuccessful => '删除成功！';
	@override String get successfullyModified => '修改成功！';
	@override String get executionSuccessful => '执行成功！';
	@override String get parameterException => '参数异常！';
	@override String get preview => '预览';
	@override String get change => '更改';
	@override String get replace => '更换';
	@override String get view => '查看';
	@override String get manage => '管理';
	@override String get modify => '修改';
	@override String get replacedSuccessfully => '更换成功!';
	@override String get authentication => '鉴权';
	@override String get reacquire => '重新获取';
	@override String get tryAgain => '再试一次';
	@override String get querying => '正在查询 …';
	@override String get writingToOnChain_pleaseWait => '正在写入链上，请稍候 …';
	@override String get refreshTheQRcode => '刷新二维码';
	@override String get loginSuccessful => '登录成功！';
	@override String get accessNumber => '接入号';
	@override String get TELCO => '运营商';
	@override String get score => '得分';
	@override String get lastHeartbeat => '最后心跳';
	@override String get expirationTime => '到期时间';
	@override String get rewards => '奖励';
	@override String get menu => '菜单';
	@override String get DSMSverifier => 'DSMS验证者';
	@override String get refresh => '刷新';
	@override String unboundAccessNumberTip({required Object menu, required Object DSMSverifier, required Object refresh}) => '你还未绑定验证接入号码, 请通过Delta应用，在"${menu}"页面然后选择"${DSMSverifier}"菜单并进行验证终端权限申请，申请绑定成功后点击下面的"${refresh}"按钮重新加载即可进入下一步。';
	@override String get received => '已收到';
	@override String get processing => '处理中';
	@override String get replied => '已应答';
	@override String get rejected => '拒绝';
	@override String get unknown => '未知';
	@override String get insufficientBalance => '余额不足！';
	@override String InsufficientXbalanceToPayCrossChainNetworkFee({required Object x}) => '${x}余额不足以支付跨链网络费';
	@override String get aTransactionThatHasNotBeenCompleted_CannotBeTransferredAtMoment => '有一笔交易尚未完成，暂不能转账';
	@override String get thisfunctionNotSupportExternalCalls => '该函数不支持被外部调用';
	@override String get noMatchingAddressThatCanBeUsedToPayCrossChainFees_switchOtherChainToTry => '没有匹配到可用于支付跨链手续费的地址，请切换到其它链网络尝试。';
	@override String currentMaximumMatchedSingleTransferAmountIsX({required Object x}) => '当前匹配到单笔最大可转账金额为${x}';
	@override String get memoMustNotBeMoreThan64bytes => '备注不得超过 64 字节';
	@override String insufficientBalance_theAmountIsX({required Object x}) => '余额不足，金额为：${x}';
	@override String get boundRreceivingAddressesExceed3Tip => '已绑定收款地址不能超出3个，\n如需绑定新的收款地址，\n请先解绑另外一个收款地址';
	@override String parametersA_exception({required Object x}) => '参数：${x}，异常';
	@override String get transferAmountMustBeLargerThan0 => '转账金额必须大于0';
	@override String get authorizationHasExpired => '授权已过期';
	@override String get theAppHasNotBeenAuthorizedByOwner => '该应用尚未获得所有者授权';
	@override String get authenticationTokenIsInvalid => '身份验证令牌无效';
	@override String get verifyInfoIsInvalidOrExpired => '验证信息无效或过期';
	@override String get verifyStringExpiredOrSenderNumberNotMatch => '验证串过期或发送者号码不匹配';
	@override String get verifyThatNumberOfAccessTerminalsHasExceededLimitOf1in10000 => '验证接入终端数量已经超过万分之一的限制';
	@override String get timeToParticipateInMiningMustBeMoreThan3Days => '参与挖矿的时间必须大于3天';
	@override String get numberOfSafetyCircleCannotBeLessThan3 => '安全圈成员人数不能少于3人';
	@override String get avatarIsNotSet => '头像未设置';
	@override String get numberOfDirectReferralsCannotBeLessThan3 => '直接推荐人数不能小于3人';
	@override String get insufficientTimeLimit_mobileNumberOnlyChangedOnceYear => '时限不足，一年内只能换一次手机号码。';
	@override String get mobileNumberAlreadyExistsAndCannotBeRepeated => '该手机号码已存在，不能重复';
	@override String get securityCodeIsIncorrect => '安全码不正确';
	@override String get securityCodeMayHaveExpired => '安全码可能已过期';
	@override String get sessionIdIsInvalidOrExpired => '会话id无效或过期';
	@override String get sessionHasBeenAuthorized => '该会话已授权完成！';
	@override String canOnlyBeRenewedWithinXdaysBeforeExpiration({required Object x}) => '只能期满前${x}天内续期';
	@override String get usageTips => '使用提示';
	@override String get noLockScreen => '不锁屏';
	@override String get usageTipStart => '为了保证验证字符串监听和转发成功率，请落实以下注意提示：';
	@override String get usageTip1 => '1. 务必使用一台专用的智能手机和一个专用的MSISDN(移动号码)。';
	@override String get usageTip2 => '2. 请将设备放置在合适的位置，从而保持短信和网络信号良好。';
	@override TextSpan usageTip3({required InlineSpan n, required InlineSpan noLockScreen}) => TextSpan(children: [
		n,
		const TextSpan(text: '. 请将设备处于长期充电线连接状态，并开启“'),
		noLockScreen,
		const TextSpan(text: '”功能。（由于设备厂商的不同,具体操作请通过网络查询或咨询设备厂商，一般需要进入开发者模式中设置）'),
	]);
	@override String get usageTip4 => '4. 在该专用设备上尽量不开启其它应用程序，不安装微信、WhatsApp、facebook、Delta、twitter 等应用。';
	@override String get usageTip5 => '5. 在DSMS验证接入终端App工作时，请将该应用置于屏幕最前端显示。';
	@override String get usageTip6 => '6. 系统弹出短信监听授权时，请点击允许。';
	@override String get usageTipEnd => '如果因各种原因导致监听和转发成功率过低，系统将会根据算法规则取消或暂停验证者资格。';
	@override String get iHaveReadAndFollowed => '我已阅读并按以上注意事项执行';
	@override String get nextStep => '下一步';
	@override String pleaseCheckX({required Object text}) => '请勾选“${text}”';
	@override String alreadyinstalledConflictingApp({required Object name}) => '发现该设备中已安装“${name}”， 请卸载后继续。';
	@override String get status => '状态';
	@override String get pause => '暂停';
	@override String get renewal => '续期';
	@override String get activate => '激活';
	@override String get needToChangeNumber => '如需更改号码吗 ?';
	@override String get goToDeltaDSMSVerifierPageOperate => '请到Delta 主应用的菜单的“DSMS验证者”页面中操作。';
	@override String get sendActivationCommandToTerminal => '发送激指令到该终端进行激活';
	@override String get conTinue => '继续';
	@override String get needToExtend => '如需续期？';
	@override String get youConfirmThePause => '确认暂停吗？';
	@override String get pauseUsedForMaintenanceOfDevices => '暂停功能一般用于手机设备临时维护。';
	@override String get scanQRcodeSupportsDeltaversions => '扫码登录仅支持Delta 1.0.9及以上版本';
	@override TextSpan justOnlineReminder({required InlineSpan online}) => TextSpan(children: [
		const TextSpan(text: '请不要着急，当您所在的国家有两个或以上的验证终端处于“'),
		online,
		const TextSpan(text: '”状态的时候，并且当被需要验证的用户选中时，您将会收到验证字符串。'),
	]);
	@override String get tip1 => '1.为了向社区提供良好的验证服务，请随时保持短信和网络信号良好。';
	@override String get tip3 => '3.请将该应用始终置于屏幕最上层显示。';
	@override String get tip4 => '4.注意在短信和网络短信程序中关闭“骚扰拦截”和“陌生人屏蔽”功能。';
	@override String get tip4help => '一般同品牌的手机支持免费网络短信功能。关闭方法：一般在短信程序的右上角点开可见关闭功能。';
	@override String get noPermissionGrantedReadDeviceSMSmessages => '没有获得读取设备SMS的权限';
	@override String get differentFromActualNumber => '与实际号码不相同';
	@override String get decryptionError => '解密出错';
}

/// Flat map(s) containing all translations.
/// Only for edge cases! For simple maps, use the map function of this library.

extension on Translations {
	dynamic _flatMapFunction(String path) {
		switch (path) {
			case 'tip': return 'Tip';
			case 'cancel': return 'Cancel';
			case 'close': return 'Close';
			case 'selected': return 'Selected';
			case 'edit': return 'Edit';
			case 'submit': return 'submit';
			case 'copiedToClipboard': return 'Copied to clipboard.';
			case 'nickname': return 'NickName';
			case 'confirm': return 'Confirm';
			case 'cannotBeEmpty': return 'cannot be empty';
			case 'deleteSuccessful': return 'Delete successful!';
			case 'successfullyModified': return 'Successfully modified!';
			case 'executionSuccessful': return 'Execution successful!';
			case 'parameterException': return 'Parameter exception!';
			case 'preview': return 'PreView';
			case 'change': return 'Change';
			case 'replace': return 'Replace';
			case 'view': return 'View';
			case 'manage': return 'Manage';
			case 'modify': return 'Modify';
			case 'replacedSuccessfully': return 'Replaced successfully!';
			case 'authentication': return 'Authentication';
			case 'reacquire': return 'Reacquire';
			case 'tryAgain': return 'try Again';
			case 'querying': return 'Querying …';
			case 'writingToOnChain_pleaseWait': return 'Writing to the on-chain, please wait …';
			case 'loginWithQRcode': return 'Login with QR-code';
			case 'useDeltaMobileApp': return 'Use Delta mobile App';
			case 'scanQRcodeToLogin': return 'Scan the QR code to login';
			case 'followSystem': return 'follow System';
			case 'switchLanguage': return 'switch Language';
			case 'languageSwitch': return 'Language switch';
			case 'refreshTheQRcode': return 'Refresh the QR code';
			case 'loginSuccessful': return 'login successful!';
			case 'accessNumber': return 'Access Number';
			case 'TELCO': return 'TELCO';
			case 'score': return 'Score';
			case 'lastHeartbeat': return 'Last heartbeat';
			case 'expirationTime': return 'Expiration time';
			case 'rewards': return 'rewards';
			case 'menu': return 'menu';
			case 'DSMSverifier': return 'DSMS Verifier';
			case 'refresh': return 'Refresh';
			case 'unboundAccessNumberTip': return ({required Object DSMSverifier, required Object menu, required Object refresh}) => 'You have not bound the verification access number yet. Please use the Delta application, then select the "${DSMSverifier}" menu on the "${menu}" page and apply for verification terminal permissions. After the application is successfully bound, click the "${refresh}" button below to reload and proceed to the next step.';
			case 'received': return 'Received';
			case 'processing': return 'Processing';
			case 'replied': return 'Replied';
			case 'rejected': return 'Rejected';
			case 'unknown': return 'Unknown';
			case 'insufficientBalance': return 'Insufficient balance!';
			case 'InsufficientXbalanceToPayCrossChainNetworkFee': return ({required Object x}) => 'Insufficient ${x} balance to pay cross-chain network fee';
			case 'aTransactionThatHasNotBeenCompleted_CannotBeTransferredAtMoment': return 'There is a transaction that has not been completed and cannot be transferred at the moment.';
			case 'thisfunctionNotSupportExternalCalls': return 'This function does not support external calls';
			case 'noMatchingAddressThatCanBeUsedToPayCrossChainFees_switchOtherChainToTry': return 'There is no matching address that can be used to pay cross-chain fees, Please switch to other chain networks to try.';
			case 'currentMaximumMatchedSingleTransferAmountIsX': return ({required Object x}) => 'The current maximum matched single transfer amount is ${x}';
			case 'memoMustNotBeMoreThan64bytes': return 'Memo must not be more than 64 bytes';
			case 'insufficientBalance_theAmountIsX': return ({required Object x}) => 'Insufficient balance, the amount is: ${x}';
			case 'boundRreceivingAddressesExceed3Tip': return 'The number of bound receiving addresses cannot exceed 3. \nIf you need to bind a new receiving address, \nplease unbind another receiving address first.';
			case 'parametersA_exception': return ({required Object x}) => 'Parameters: ${x}, exception';
			case 'transferAmountMustBeLargerThan0': return 'Transfer amount must be larger than 0';
			case 'authorizationHasExpired': return 'Authorization has expired';
			case 'theAppHasNotBeenAuthorizedByOwner': return 'The app has not been authorized by the owner';
			case 'authenticationTokenIsInvalid': return 'Authentication token is invalid';
			case 'verifyInfoIsInvalidOrExpired': return 'verify Info is invalid or expired';
			case 'verifyStringExpiredOrSenderNumberNotMatch': return 'Verification string expired or sender number does not match';
			case 'verifyThatNumberOfAccessTerminalsHasExceededLimitOf1in10000': return 'Verify that the number of access terminals has exceeded the limit of one in 10,000';
			case 'timeToParticipateInMiningMustBeMoreThan3Days': return 'The time to participate in mining must be more than 3 days';
			case 'numberOfSafetyCircleCannotBeLessThan3': return 'The number of safety circle members cannot be less than 3 people';
			case 'avatarIsNotSet': return 'Avatar is not set';
			case 'numberOfDirectReferralsCannotBeLessThan3': return 'The number of direct referrals cannot be less than 3 people';
			case 'insufficientTimeLimit_mobileNumberOnlyChangedOnceYear': return 'Insufficient time limit, mobile number can only be changed once a year.';
			case 'mobileNumberAlreadyExistsAndCannotBeRepeated': return 'This mobile phone number already exists and cannot be repeated';
			case 'securityCodeIsIncorrect': return 'Security code is incorrect';
			case 'securityCodeMayHaveExpired': return 'Security code may have expired';
			case 'sessionIdIsInvalidOrExpired': return 'The sessionId is invalid or expired';
			case 'sessionHasBeenAuthorized': return 'The session has been authorized!';
			case 'canOnlyBeRenewedWithinXdaysBeforeExpiration': return ({required Object x}) => 'Can only be renewed within ${x} days before expiration';
			case 'usageTips': return 'Usage Tips';
			case 'noLockScreen': return 'No lock screen';
			case 'usageTipStart': return 'To ensure the success rate of verification string monitoring and forwarding, please implement the following tips:';
			case 'usageTip1': return '1. Be sure to use a dedicated smartphone and a dedicated MSISDN (mobile number).';
			case 'usageTip2': return '2. Please place the device in a suitable location to keep the network and communication signals good.';
			case 'usageTip3': return ({required InlineSpan n, required InlineSpan noLockScreen}) => TextSpan(children: [
				n,
				const TextSpan(text: '. Please keep the device connected to the charging cable for a long time and turn on the "'),
				noLockScreen,
				const TextSpan(text: '" function. (Due to the differences in device manufacturers, please query the network or consult the device manufacturer for specific operations. Generally, you need to enter the developer mode to set)'),
			]);
			case 'usageTip4': return '4. Try not to open other applications on this dedicated device, and do not install applications such as WeChat, WhatsApp, Facebook, Delta, Twitter, etc.';
			case 'usageTip5': return '5. When the DSMS verification access terminal App is working, please put the application at the forefront of the screen.';
			case 'usageTip6': return '6. When the system pops up SMS monitoring authorization, please click Allow. ';
			case 'usageTipEnd': return 'If the monitoring and forwarding success rate is too low due to various reasons, the system will cancel or suspend the verifier\'s qualification according to the algorithm rules. ';
			case 'iHaveReadAndFollowed': return 'I have read and followed the above precautions';
			case 'nextStep': return 'Next step';
			case 'pleaseCheckX': return ({required Object text}) => 'Please check "${text}"';
			case 'alreadyinstalledConflictingApp': return ({required Object name}) => 'It was found that "${name}" is already installed on the device. Please uninstall it and continue.';
			case 'status': return 'Status';
			case 'pause': return 'Pause';
			case 'renewal': return 'Renewal';
			case 'activate': return 'Activate';
			case 'needToChangeNumber': return 'Need to change number? ';
			case 'goToDeltaDSMSVerifierPageOperate': return 'Please go to the "DSMS verifier" page of the menu of the Delta main application to operate.';
			case 'sendActivationCommandToTerminal': return 'Send activation command to the terminal to activate';
			case 'conTinue': return 'Continue';
			case 'needToExtend': return 'Need to extend?';
			case 'youConfirmThePause': return 'Do you confirm the pause?';
			case 'pauseUsedForMaintenanceOfDevices': return 'The pause function is generally used for temporary maintenance of mobile devices.';
			case 'scanQRcodeSupportsDeltaversions': return 'Scan QR code login only supports Delta 1.0.9 and above';
			case 'justOnlineReminder': return ({required InlineSpan online}) => TextSpan(children: [
				const TextSpan(text: 'Please don\'t worry. When there are two or more verification terminals in the "'),
				online,
				const TextSpan(text: '" state in your country and you are selected by the user who needs verification, you will receive a verification string.'),
			]);
			case 'tip1': return '1. In order to provide good verification services to the community, please keep your SMS and network signals good at all times.';
			case 'tip3': return '3. Please keep this app on top of the screen at all times.';
			case 'tip4': return '4. Remember to turn off the "harassment blocking" and "stranger blocking" functions in your SMS and Internet-SMS programs.';
			case 'tip4help': return 'Generally, mobile phones of the same brand support free Internet SMS function. How to turn it off: Generally, you can see the turn-off function by clicking on the upper right corner of the SMS program.';
			case 'noPermissionGrantedReadDeviceSMSmessages': return 'No permission was granted to read device SMS messages';
			case 'differentFromActualNumber': return 'Different from the actual number';
			case 'decryptionError': return 'Decryption error';
			default: return null;
		}
	}
}

extension on _StringsZhCn {
	dynamic _flatMapFunction(String path) {
		switch (path) {
			case 'home': return '首页';
			case 'loginWithQRcode': return '使用二维码登录';
			case 'useDeltaMobileApp': return '使用Delta手机App';
			case 'scanQRcodeToLogin': return '扫描二维码登录';
			case 'followSystem': return '跟随系统';
			case 'switchLanguage': return '切换语言';
			case 'languageSwitch': return '语言切换';
			case 'tip': return '提示';
			case 'cancel': return '取消';
			case 'close': return '关闭';
			case 'selected': return '已选定';
			case 'edit': return '编辑';
			case 'submit': return '提交';
			case 'copiedToClipboard': return '已拷贝到剪切板。';
			case 'nickname': return '昵称';
			case 'confirm': return '确认';
			case 'cannotBeEmpty': return '不能为空';
			case 'deleteSuccessful': return '删除成功！';
			case 'successfullyModified': return '修改成功！';
			case 'executionSuccessful': return '执行成功！';
			case 'parameterException': return '参数异常！';
			case 'preview': return '预览';
			case 'change': return '更改';
			case 'replace': return '更换';
			case 'view': return '查看';
			case 'manage': return '管理';
			case 'modify': return '修改';
			case 'replacedSuccessfully': return '更换成功!';
			case 'authentication': return '鉴权';
			case 'reacquire': return '重新获取';
			case 'tryAgain': return '再试一次';
			case 'querying': return '正在查询 …';
			case 'writingToOnChain_pleaseWait': return '正在写入链上，请稍候 …';
			case 'refreshTheQRcode': return '刷新二维码';
			case 'loginSuccessful': return '登录成功！';
			case 'accessNumber': return '接入号';
			case 'TELCO': return '运营商';
			case 'score': return '得分';
			case 'lastHeartbeat': return '最后心跳';
			case 'expirationTime': return '到期时间';
			case 'rewards': return '奖励';
			case 'menu': return '菜单';
			case 'DSMSverifier': return 'DSMS验证者';
			case 'refresh': return '刷新';
			case 'unboundAccessNumberTip': return ({required Object menu, required Object DSMSverifier, required Object refresh}) => '你还未绑定验证接入号码, 请通过Delta应用，在"${menu}"页面然后选择"${DSMSverifier}"菜单并进行验证终端权限申请，申请绑定成功后点击下面的"${refresh}"按钮重新加载即可进入下一步。';
			case 'received': return '已收到';
			case 'processing': return '处理中';
			case 'replied': return '已应答';
			case 'rejected': return '拒绝';
			case 'unknown': return '未知';
			case 'insufficientBalance': return '余额不足！';
			case 'InsufficientXbalanceToPayCrossChainNetworkFee': return ({required Object x}) => '${x}余额不足以支付跨链网络费';
			case 'aTransactionThatHasNotBeenCompleted_CannotBeTransferredAtMoment': return '有一笔交易尚未完成，暂不能转账';
			case 'thisfunctionNotSupportExternalCalls': return '该函数不支持被外部调用';
			case 'noMatchingAddressThatCanBeUsedToPayCrossChainFees_switchOtherChainToTry': return '没有匹配到可用于支付跨链手续费的地址，请切换到其它链网络尝试。';
			case 'currentMaximumMatchedSingleTransferAmountIsX': return ({required Object x}) => '当前匹配到单笔最大可转账金额为${x}';
			case 'memoMustNotBeMoreThan64bytes': return '备注不得超过 64 字节';
			case 'insufficientBalance_theAmountIsX': return ({required Object x}) => '余额不足，金额为：${x}';
			case 'boundRreceivingAddressesExceed3Tip': return '已绑定收款地址不能超出3个，\n如需绑定新的收款地址，\n请先解绑另外一个收款地址';
			case 'parametersA_exception': return ({required Object x}) => '参数：${x}，异常';
			case 'transferAmountMustBeLargerThan0': return '转账金额必须大于0';
			case 'authorizationHasExpired': return '授权已过期';
			case 'theAppHasNotBeenAuthorizedByOwner': return '该应用尚未获得所有者授权';
			case 'authenticationTokenIsInvalid': return '身份验证令牌无效';
			case 'verifyInfoIsInvalidOrExpired': return '验证信息无效或过期';
			case 'verifyStringExpiredOrSenderNumberNotMatch': return '验证串过期或发送者号码不匹配';
			case 'verifyThatNumberOfAccessTerminalsHasExceededLimitOf1in10000': return '验证接入终端数量已经超过万分之一的限制';
			case 'timeToParticipateInMiningMustBeMoreThan3Days': return '参与挖矿的时间必须大于3天';
			case 'numberOfSafetyCircleCannotBeLessThan3': return '安全圈成员人数不能少于3人';
			case 'avatarIsNotSet': return '头像未设置';
			case 'numberOfDirectReferralsCannotBeLessThan3': return '直接推荐人数不能小于3人';
			case 'insufficientTimeLimit_mobileNumberOnlyChangedOnceYear': return '时限不足，一年内只能换一次手机号码。';
			case 'mobileNumberAlreadyExistsAndCannotBeRepeated': return '该手机号码已存在，不能重复';
			case 'securityCodeIsIncorrect': return '安全码不正确';
			case 'securityCodeMayHaveExpired': return '安全码可能已过期';
			case 'sessionIdIsInvalidOrExpired': return '会话id无效或过期';
			case 'sessionHasBeenAuthorized': return '该会话已授权完成！';
			case 'canOnlyBeRenewedWithinXdaysBeforeExpiration': return ({required Object x}) => '只能期满前${x}天内续期';
			case 'usageTips': return '使用提示';
			case 'noLockScreen': return '不锁屏';
			case 'usageTipStart': return '为了保证验证字符串监听和转发成功率，请落实以下注意提示：';
			case 'usageTip1': return '1. 务必使用一台专用的智能手机和一个专用的MSISDN(移动号码)。';
			case 'usageTip2': return '2. 请将设备放置在合适的位置，从而保持短信和网络信号良好。';
			case 'usageTip3': return ({required InlineSpan n, required InlineSpan noLockScreen}) => TextSpan(children: [
				n,
				const TextSpan(text: '. 请将设备处于长期充电线连接状态，并开启“'),
				noLockScreen,
				const TextSpan(text: '”功能。（由于设备厂商的不同,具体操作请通过网络查询或咨询设备厂商，一般需要进入开发者模式中设置）'),
			]);
			case 'usageTip4': return '4. 在该专用设备上尽量不开启其它应用程序，不安装微信、WhatsApp、facebook、Delta、twitter 等应用。';
			case 'usageTip5': return '5. 在DSMS验证接入终端App工作时，请将该应用置于屏幕最前端显示。';
			case 'usageTip6': return '6. 系统弹出短信监听授权时，请点击允许。';
			case 'usageTipEnd': return '如果因各种原因导致监听和转发成功率过低，系统将会根据算法规则取消或暂停验证者资格。';
			case 'iHaveReadAndFollowed': return '我已阅读并按以上注意事项执行';
			case 'nextStep': return '下一步';
			case 'pleaseCheckX': return ({required Object text}) => '请勾选“${text}”';
			case 'alreadyinstalledConflictingApp': return ({required Object name}) => '发现该设备中已安装“${name}”， 请卸载后继续。';
			case 'status': return '状态';
			case 'pause': return '暂停';
			case 'renewal': return '续期';
			case 'activate': return '激活';
			case 'needToChangeNumber': return '如需更改号码吗 ?';
			case 'goToDeltaDSMSVerifierPageOperate': return '请到Delta 主应用的菜单的“DSMS验证者”页面中操作。';
			case 'sendActivationCommandToTerminal': return '发送激指令到该终端进行激活';
			case 'conTinue': return '继续';
			case 'needToExtend': return '如需续期？';
			case 'youConfirmThePause': return '确认暂停吗？';
			case 'pauseUsedForMaintenanceOfDevices': return '暂停功能一般用于手机设备临时维护。';
			case 'scanQRcodeSupportsDeltaversions': return '扫码登录仅支持Delta 1.0.9及以上版本';
			case 'justOnlineReminder': return ({required InlineSpan online}) => TextSpan(children: [
				const TextSpan(text: '请不要着急，当您所在的国家有两个或以上的验证终端处于“'),
				online,
				const TextSpan(text: '”状态的时候，并且当被需要验证的用户选中时，您将会收到验证字符串。'),
			]);
			case 'tip1': return '1.为了向社区提供良好的验证服务，请随时保持短信和网络信号良好。';
			case 'tip3': return '3.请将该应用始终置于屏幕最上层显示。';
			case 'tip4': return '4.注意在短信和网络短信程序中关闭“骚扰拦截”和“陌生人屏蔽”功能。';
			case 'tip4help': return '一般同品牌的手机支持免费网络短信功能。关闭方法：一般在短信程序的右上角点开可见关闭功能。';
			case 'noPermissionGrantedReadDeviceSMSmessages': return '没有获得读取设备SMS的权限';
			case 'differentFromActualNumber': return '与实际号码不相同';
			case 'decryptionError': return '解密出错';
			default: return null;
		}
	}
}
