package com.ironsourceadvanced

import android.content.Context
import android.widget.LinearLayout
import com.facebook.react.bridge.UiThreadUtil.runOnUiThread
import com.ironsource.mediationsdk.IronSource

class IronsourceBannerView(context: Context) : LinearLayout(context) {

  init {
    runOnUiThread {
      synchronized(this) {
        try {
          IronSource.loadBanner(IronsourceBannerModule.bannerView)
          attachBanner()
        } catch (err: Exception) {
        }
      }
    }
  }

  fun attachBanner () {
    addView(IronsourceBannerModule.bannerView)
  }
}
