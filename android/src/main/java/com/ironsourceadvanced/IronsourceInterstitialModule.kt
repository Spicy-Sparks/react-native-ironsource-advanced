package com.ironsourceadvanced

import com.facebook.react.bridge.*
import com.facebook.react.module.annotations.ReactModule
import com.facebook.react.modules.core.DeviceEventManagerModule
import com.ironsource.mediationsdk.IronSource
import com.ironsource.mediationsdk.adunit.adapter.utility.AdInfo
import com.ironsource.mediationsdk.logger.IronSourceError
import com.ironsource.mediationsdk.sdk.LevelPlayInterstitialListener

@ReactModule(name = IronsourceInterstitialModule.NAME)
class IronsourceInterstitialModule(reactContext: ReactApplicationContext?) :
  ReactContextBaseJavaModule(reactContext),
  LevelPlayInterstitialListener {

  companion object {
    const val NAME = "IronsourceInterstitial"
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
  fun loadInterstitial() {
    IronSource.setLevelPlayInterstitialListener(this@IronsourceInterstitialModule)
    IronSource.loadInterstitial()
  }

  @ReactMethod
  fun showInterstitial(placementName: String) {
    currentActivity?.apply {
      if(IronSource.isInterstitialReady()) {
        IronSource.showInterstitial(placementName)
      }
      else {
        sendEvent(reactApplicationContext, "INTERSTITIAL_FAILED_TO_LOAD", null)
      }
    }
  }

  @ReactMethod
  fun isInterstitialReady(promise: Promise) {
    return promise.resolve(IronSource.isInterstitialReady())
  }

  @ReactMethod
  fun addListener(eventName: String?) {}

  @ReactMethod
  fun removeListeners(count: Int?) {}

  override fun onAdReady(adInfo: AdInfo?) {
    sendEvent(reactApplicationContext, "INTERSTITIAL_LOADED", null)
  }

  override fun onAdLoadFailed(error: IronSourceError?) {
    val args = Arguments.createMap()
    if(error != null) {
      args.putInt("errorCode", error.errorCode)
      args.putString("message", error.errorMessage)
    }
    sendEvent(reactApplicationContext, "INTERSTITIAL_FAILED_TO_LOAD", args)
  }

  override fun onAdOpened(adInfo: AdInfo?) {
    sendEvent(reactApplicationContext, "INTERSTITIAL_OPENED", null)
  }

  override fun onAdShowSucceeded(adInfo: AdInfo?) {
    sendEvent(reactApplicationContext, "INTERSTITIAL_SHOWN", null)
  }

  override fun onAdShowFailed(error: IronSourceError?, adInfo: AdInfo?) {
    val args = Arguments.createMap()
    if(error != null) {
      args.putInt("errorCode", error.errorCode)
      args.putString("message", error.errorMessage)
    }
    sendEvent(reactApplicationContext, "INTERSTITIAL_FAILED_TO_SHOW", args)
  }

  override fun onAdClicked(adInfo: AdInfo?) {
    sendEvent(reactApplicationContext, "INTERSTITIAL_CLICKED", null)
  }

  override fun onAdClosed(adInfo: AdInfo?) {
    sendEvent(reactApplicationContext, "INTERSTITIAL_CLOSED", null)
  }
}
