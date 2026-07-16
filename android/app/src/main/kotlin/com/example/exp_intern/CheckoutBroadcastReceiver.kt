package com.example.exp_intern.com.example.exp_intern

import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import com.oppwa.mobile.connect.checkout.dialog.CheckoutActivity

/**
 * Broadcast receiver to listen to intents from CheckoutActivity.
 */
class CheckoutBroadcastReceiver : BroadcastReceiver() {

    override fun onReceive(context: Context, intent: Intent) {
        var mutableIntent = intent
        val action = mutableIntent.action

        if (CheckoutActivity.ACTION_ON_BEFORE_SUBMIT == action) {
            val paymentBrand = mutableIntent.getStringExtra(CheckoutActivity.EXTRA_PAYMENT_BRAND)
            val checkoutId = mutableIntent.getStringExtra(CheckoutActivity.EXTRA_CHECKOUT_ID)

            /* This callback can be used to request a new checkout ID if selected payment brand requires
               some specific parameters or just send back the same checkout id to continue checkout process */
            mutableIntent = Intent(context, CheckoutActivity::class.java).apply {
                this.action = CheckoutActivity.ACTION_ON_BEFORE_SUBMIT
                addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
                putExtra(CheckoutActivity.EXTRA_CHECKOUT_ID, checkoutId)
                /* Also it can be used to cancel the checkout process by sending
                   the CheckoutActivity.EXTRA_CANCEL_CHECKOUT */
                putExtra(CheckoutActivity.EXTRA_TRANSACTION_ABORTED, false)
            }

            context.startActivity(mutableIntent)
        }
    }
}