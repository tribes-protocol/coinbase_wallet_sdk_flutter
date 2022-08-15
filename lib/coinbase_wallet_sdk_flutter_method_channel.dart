import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'coinbase_wallet_sdk_flutter_platform_interface.dart';

/// An implementation of [CoinbaseWalletSdkFlutterPlatform] that uses method channels.
class MethodChannelCoinbaseWalletSdkFlutter
    extends CoinbaseWalletSdkFlutterPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('coinbase_wallet_sdk_flutter');

  @override
  Future<dynamic> call(String method, [arguments]) async {
    final result = await methodChannel.invokeMethod<String>(method, arguments);
    return result != null ? jsonDecode(result) : null;
  }

  // @override
  // Future<String?> getPlatformVersion() async {
  //   final version = await methodChannel.invokeMethod<String>(
  //     'getPlatformVersion',
  //   );
  //   return version;
  // }

  // @override
  // Future<String> initiateHandshake() async {
  //   final json = await methodChannel.invokeMethod<String>('initiateHandshake');
  //   return _parsePlatformResultString(json);
  // }

  // @override
  // Future<String> personalSign(String address, String message) async {
  //   final json = await methodChannel.invokeMethod<String>(
  //     'personalSign',
  //     <String, dynamic>{'address': address, 'message': message},
  //   );

  //   return _parsePlatformResultString(json);
  // }

  // String _parsePlatformResultString(String? json) {
  //   if (json == null) {
  //     throw PlatformError(69, 'Missing platform result');
  //   }

  //   final map = jsonDecode(json);
  //   final error = map['error'];
  //   final value = map['value'];

  //   if (error != null) {
  //     throw PlatformError(error['code'], error['message']);
  //   } else if (value is! String) {
  //     throw PlatformError(420, 'Invalid return value: $value');
  //   }

  //   return value;
  // }
}
