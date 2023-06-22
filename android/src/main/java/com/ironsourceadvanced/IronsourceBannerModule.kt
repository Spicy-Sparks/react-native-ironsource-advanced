package com.ironsourceadvanced

import android.content.Intent
import com.facebook.react.bridge.*
import com.facebook.react.module.annotations.ReactModule
import com.facebook.react.modules.core.DeviceEventManagerModule
import com.ironsource.mediationsdk.ISBannerSize
import com.ironsource.mediationsdk.IronSource
import com.ironsource.mediationsdk.IronSourceBannerLayout
import com.ironsource.mediationsdk.adunit.adapter.utility.AdInfo
import com.ironsource.mediationsdk.logger.IronSourceError
import com.ironsource.mediationsdk.sdk.LevelPlayBannerListener

@ReactModule(name = IronsourceBannerModule.NAME)
class IronsourceBannerModule(reactContext: ReactApplicationContext?) :
  ReactContextBaseJavaModule(reactContext),
  LevelPlayBannerListener {

  companion object {
    const val NAME = "IronsourceBanner"
    var bannerView: IronSourceBannerLayout? = null
    var isAdLoaded = false
  }

  override fun getName(): String {
    return NAME
  }

  private fun sendEvent(reactContext: ReactContext, eventName: String, params: WritableMap?) {
    reactContext
      .getJSModule(DeviceEventManagerModule.RCTDeviceEventEmitter::class.java)
      .emit(eventName, params)
  }

  @ReactMethod
  fun addEventsDelegate() {
    currentActivity?.apply {
      val bannerView = IronSource.createBanner(currentActivity, ISBannerSize.BANNER)
      bannerView.levelPlayBannerListener = this@IronsourceBannerModule
      IronsourceBannerModule.bannerView = bannerView
    }
  }

  @ReactMethod
  fun addListener(eventName: String?) {}

  @ReactMethod
  fun removeListeners(count: Int?) {}

  override fun onAdLoaded(adInfo: AdInfo?) {
    sendEvent(reactApplicationContext, "BANNER_LOADED", null)
    val intent = Intent("com.esound.banner_loaded")
    currentActivity?.applicationContext?.sendBroadcast(intent)
    isAdLoaded = true
  }

  override fun onAdLoadFailed(error: IronSourceError?) {
    val args = Arguments.createMap()
    if(error != null) {
      args.putInt("errorCode", error.errorCode)
      args.putString("message", error.errorMessage)
    }
    sendEvent(reactApplicationContext, "BANNER_FAILED_TO_LOAD", args)
    isAdLoaded = false
  }

  override fun onAdClicked(adInfo: AdInfo?) {
    sendEvent(reactApplicationContext, "BANNER_LOADED", null)
  }

  override fun onAdLeftApplication(adInfo: AdInfo?) {
    sendEvent(reactApplicationContext, "BANNER_LEFT", null)
    isAdLoaded = false
  }

  override fun onAdScreenPresented(adInfo: AdInfo?) {
    sendEvent(reactApplicationContext, "BANNER_PRESENTED", null)
  }

  override fun onAdScreenDismissed(adInfo: AdInfo?) {
    sendEvent(reactApplicationContext, "BANNER_DISMISSED", null)
    isAdLoaded = false
  }
}
