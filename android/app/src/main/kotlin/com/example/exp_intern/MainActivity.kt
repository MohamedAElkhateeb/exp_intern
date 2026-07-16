package com.example.exp_intern

import android.content.ComponentName
import android.content.Intent
import android.net.Uri
import android.os.Handler
import android.os.Looper
import androidx.activity.result.ActivityResultLauncher
import androidx.annotation.NonNull
import com.example.exp_intern.com.example.exp_intern.CheckoutBroadcastReceiver
import io.flutter.embedding.android.FlutterFragmentActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import com.oppwa.mobile.connect.checkout.meta.CheckoutActivityResult
import com.oppwa.mobile.connect.checkout.meta.CheckoutActivityResultContract
import com.oppwa.mobile.connect.checkout.meta.CheckoutSettings
import com.oppwa.mobile.connect.checkout.meta.CheckoutStorePaymentDetailsMode
import com.oppwa.mobile.connect.exception.PaymentError
import com.oppwa.mobile.connect.payment.BrandsValidation
import com.oppwa.mobile.connect.payment.CheckoutInfo
import com.oppwa.mobile.connect.payment.ImagesRequest
import com.oppwa.mobile.connect.provider.Connect
import com.oppwa.mobile.connect.provider.ITransactionListener
import com.oppwa.mobile.connect.provider.Transaction
import com.oppwa.mobile.connect.provider.TransactionType
import java.util.LinkedHashSet

class MainActivity : FlutterFragmentActivity(), ITransactionListener, MethodChannel.Result {

    private var checkoutId = ""
    private var resultChannel: MethodChannel.Result? = null
    private var type = ""
    private var mode = ""
    private var brands = ""
    private var lang = ""
    private var shopperResultUrl = ""
    private var setStorePaymentDetailsMode = ""

    private val handler = Handler(Looper.getMainLooper())

    private val checkoutLauncher: ActivityResultLauncher<CheckoutSettings> =
        registerForActivityResult(CheckoutActivityResultContract()) { result ->
            handleCheckoutResult(result)
        }

    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        val channel = "Hyperpay.demo.fultter/channel"
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, channel)
            .setMethodCallHandler { call, result ->
                resultChannel = result

                if (call.method == "gethyperpayresponse") {
                    type = call.argument<String>("type") ?: ""
                    mode = call.argument<String>("mode") ?: ""
                    checkoutId = call.argument<String>("checkoutid") ?: ""
                    lang = call.argument<String>("lang") ?: ""
                    shopperResultUrl = call.argument<String>("ShopperResultUrl") ?: ""
                    brands = call.argument<String>("brand") ?: ""
                    setStorePaymentDetailsMode = call.argument<String>("setStorePaymentDetailsMode") ?: ""

                    when (type) {
                        "ReadyUI" -> openCheckoutUI(checkoutId)
                        "StoredCards", "CustomUI" -> notImplemented()
                        else -> error("1", "THIS TYPE NO IMPLEMENT IN ANDROID", "")
                    }
                } else {
                    error("1", "METHOD NAME IS NOT FOUND", "")
                }
            }
    }

    private fun openCheckoutUI(checkoutId: String) {
        val paymentBrands: MutableSet<String> = LinkedHashSet()

        when (brands) {
            "MADA" -> paymentBrands.add("MADA")
            "STC_PAY" -> paymentBrands.add("STC_PAY")
            "VISA" -> paymentBrands.add("VISA")
            "MASTER" -> paymentBrands.add("MASTER")
            "TAMARA" -> paymentBrands.add("TAMARA")
            else -> {
                paymentBrands.add("MASTER")
                paymentBrands.add("VISA")
            }
        }

        val checkoutSettings: CheckoutSettings = if (mode == "LIVE") {
            CheckoutSettings(checkoutId, paymentBrands, Connect.ProviderMode.LIVE)
        } else {
            CheckoutSettings(checkoutId, paymentBrands, Connect.ProviderMode.TEST)
        }

        checkoutSettings.locale = lang
        checkoutSettings.isCardScanningEnabled = false
        checkoutSettings.isTotalAmountRequired = true

        if ("true" == setStorePaymentDetailsMode) {
            checkoutSettings.storePaymentDetailsMode = CheckoutStorePaymentDetailsMode.PROMPT
        }

        checkoutSettings.themeResId = R.style.NewCheckoutTheme

        val componentName = ComponentName(
            packageName,
            CheckoutBroadcastReceiver::class.java.name
        )
        checkoutSettings.componentName = componentName

        checkoutLauncher.launch(checkoutSettings)
    }

    private fun handleCheckoutResult(result: CheckoutActivityResult) {
        if (result.isCanceled) {
            error("2", "Canceled", "")
            return
        }
        if (result.isErrored) {
            error("3", "Checkout Result Error", "")
            return
        }
        val transaction = result.transaction
        if (transaction != null && transaction.transactionType == TransactionType.SYNC) {
            success("SYNC")
        }
    }

    override fun success(result: Any?) {
        handler.post { resultChannel?.success(result) }
    }

    override fun error(@NonNull errorCode: String, errorMessage: String?, errorDetails: Any?) {
        handler.post { resultChannel?.error(errorCode, errorMessage, errorDetails) }
    }

    override fun notImplemented() {
        handler.post { resultChannel?.notImplemented() }
    }

    override fun onNewIntent(@NonNull intent: Intent) {
        super.onNewIntent(intent)
        if (intent.scheme != null && intent.scheme == shopperResultUrl) {
            success("success")
        }
    }

    override fun transactionCompleted(@NonNull transaction: Transaction) {
        if (transaction.transactionType == TransactionType.SYNC) {
            success("SYNC")
        } else {
            val uri = Uri.parse(transaction.redirectUrl)
            startActivity(Intent(Intent.ACTION_VIEW, uri))
        }
    }

    override fun transactionFailed(@NonNull transaction: Transaction, @NonNull paymentError: PaymentError) {
        error("transactionFailed", paymentError.errorMessage, "transactionFailed")
    }

    override fun brandsValidationRequestSucceeded(@NonNull brandsValidation: BrandsValidation) {}

    override fun brandsValidationRequestFailed(@NonNull paymentError: PaymentError) {}

    override fun imagesRequestSucceeded(@NonNull imagesRequest: ImagesRequest) {}

    override fun imagesRequestFailed() {}

    override fun paymentConfigRequestSucceeded(@NonNull checkoutInfo: CheckoutInfo) {}

    override fun paymentConfigRequestFailed(@NonNull paymentError: PaymentError) {}
}