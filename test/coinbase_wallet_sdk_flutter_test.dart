import 'package:coinbase_wallet_sdk_flutter/coinbase_wallet_sdk_flutter.dart';
import 'package:coinbase_wallet_sdk_flutter/coinbase_wallet_sdk_flutter_method_channel.dart';
import 'package:coinbase_wallet_sdk_flutter/coinbase_wallet_sdk_flutter_platform_interface.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

const _addy = '0xE69F609C75f8640fA034166c63929f2875C01343';

class MockCoinbaseWalletSdkFlutterPlatform
    with MockPlatformInterfaceMixin
    implements CoinbaseWalletSdkFlutterPlatform {
  @override
  Future<String?> getPlatformVersion() => Future.value('42');

  @override
  Future<String> initiateHandshake() async {
    return _addy;
  }

  @override
  Future<String> personalSign(String address, String message) async {
    if (address == _addy) {
      return '0x0';
    } else {
      throw PlatformError(1, 'Invalid address');
    }
  }
}

void main() {
  final CoinbaseWalletSdkFlutterPlatform initialPlatform =
      CoinbaseWalletSdkFlutterPlatform.instance;

  test('$MethodChannelCoinbaseWalletSdkFlutter is the default instance', () {
    expect(
        initialPlatform, isInstanceOf<MethodChannelCoinbaseWalletSdkFlutter>());
  });

  test('getPlatformVersion', () async {
    CoinbaseWalletSdkFlutter coinbaseWalletSdkFlutterPlugin =
        CoinbaseWalletSdkFlutter();
    MockCoinbaseWalletSdkFlutterPlatform fakePlatform =
        MockCoinbaseWalletSdkFlutterPlatform();
    CoinbaseWalletSdkFlutterPlatform.instance = fakePlatform;

    expect(await coinbaseWalletSdkFlutterPlugin.getPlatformVersion(), '42');
  });
}
