# coinbase_wallet_sdk_flutter

A flutter wrapper for CoinbaseWallet mobile SDK

Note: This wrapper only supports iOS and Android.

## Getting Started

### iOS
When your application receives a response from Coinbase Wallet via a Universal Link, this URL needs to be handed off to the SDK via the handleResponse function.
```swift
func application(_ app: UIApplication, open url: URL ...) -> Bool {
    if (try? CoinbaseWalletSDK.shared.handleResponse(url)) == true {
        return true
    }
    // handle other types of deep links
    return false
}

func application(
    _ application: UIApplication, 
    continue userActivity: NSUserActivity, 
    restorationHandler: @escaping ([UIUserActivityRestoring]?) -> Void
) -> Bool {
    if let url = userActivity.webpageURL,
       (try? CoinbaseWalletSDK.shared.handleResponse(url)) == true {
        return true
    }
    // handle other types of deep links
    return false
}
```

### Android
To configure usage with the Coinbase Wallet app, you will need to provide this entry in your application’s manifest.  This will allow your application to open and interact with the Coinbase Wallet app.  
```xml
<queries>
   <package android:name="org.toshi" />
</queries>
```

## Usage

```dart 
  import 'package:coinbase_wallet_sdk_flutter/coinbase_wallet_sdk.dart';
  
  
  // Configure SDK for each platform
  await CoinbaseWalletSDK.shared.configure(
    Configuration(
      ios: IOSConfiguration(
        host: Uri.parse('cbwallet://wsegue'),
        callback: Uri.parse('tribesxyz://mycallback'),
      ),
      android: AndroidConfiguration(
        domain: Uri.parse('https://www.coinbase.com'),
      ),
    ),
  );
    
  // To call web3's eth_requestAccounts
  final response = await CoinbaseWalletSDK.shared.initiateHandshake([
    const RequestAccounts(),
  ]);
  
  final walletAddress = response[0].value;

  // to call web3's personalSign
  final response = await CoinbaseWalletSDK.shared.makeRequest(
    Request(
      actions: [
        PersonalSign(address: address.value, message: message),
      ],
    ),
  );
  
  final signature = response[0].value;
```


