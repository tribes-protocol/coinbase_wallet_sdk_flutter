package xyz.tribes.coinbase.coinbase_wallet_sdk_flutter

import android.content.Intent
import android.net.Uri
import androidx.annotation.NonNull
import com.coinbase.android.nativesdk.CoinbaseWalletSDK
import com.coinbase.android.nativesdk.message.request.Web3JsonRPC
import com.coinbase.android.nativesdk.message.response.ReturnValue

import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import io.flutter.plugin.common.PluginRegistry

/** CoinbaseWalletSdkFlutterPlugin */
class CoinbaseWalletSdkFlutterPlugin : FlutterPlugin, MethodCallHandler,
    ActivityAware, PluginRegistry.ActivityResultListener {
    /// The MethodChannel that will the communication between Flutter and native Android
    ///
    /// This local reference serves to register the plugin with the Flutter Engine and unregister it
    /// when the Flutter Engine is detached from the Activity
    private lateinit var channel: MethodChannel

    private lateinit var coinbase: CoinbaseWalletSDK

    private var act: android.app.Activity? = null

    override fun onAttachedToEngine(@NonNull flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        coinbase = CoinbaseWalletSDK(
            appContext = flutterPluginBinding.applicationContext,
            domain = Uri.parse("https://www.coinbase.com"),
            openIntent = { intent -> act?.startActivityForResult(intent, 0) }
        );
        channel = MethodChannel(flutterPluginBinding.binaryMessenger, "coinbase_wallet_sdk_flutter")
        channel.setMethodCallHandler(this)
    }

    override fun onMethodCall(@NonNull call: MethodCall, @NonNull result: Result) {
        if (call.method == "getPlatformVersion") {
            result.success("Android ${android.os.Build.VERSION.RELEASE}")
        } else if (call.method == "initiateHandshake") {
            initiateHandshake(result)
        } else {
            result.notImplemented()
        }
    }

    override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
        channel.setMethodCallHandler(null)
    }

    private fun initiateHandshake(@NonNull callback: Result) {
        val requestAccount = Web3JsonRPC.RequestAccounts().action()

        coinbase.initiateHandshake(initialActions = listOf(requestAccount)) { result: kotlin.Result<List<ReturnValue>> ->

            if (result.isFailure) {
                println("hish: error ${result.exceptionOrNull()}")
                return@initiateHandshake
            }
            val returnValues = result.getOrNull() ?: emptyList();
            if (returnValues.isEmpty()) {
                println("hish: missing return values")
                return@initiateHandshake
            }

            when (val requestAccountResult = returnValues[0]) {
                is Result -> {
                    println("hish: address ${requestAccountResult}");
                }
                is Error -> {
                    println("hish: error ${requestAccountResult}")
                }
            }
        }
    }

    override fun onAttachedToActivity(binding: ActivityPluginBinding) {
        act = binding.activity
        binding.addActivityResultListener(this)
    }

    override fun onDetachedFromActivityForConfigChanges() {
        act = null
    }

    override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) {
        // no-op
    }

    override fun onDetachedFromActivity() {
        // no-op
    }

    override fun onActivityResult(requestCode: Int, resultCode: Int, data: Intent?): Boolean {
        val uri = data?.data ?: return false
        return coinbase.handleResponse(uri)
    }
}
