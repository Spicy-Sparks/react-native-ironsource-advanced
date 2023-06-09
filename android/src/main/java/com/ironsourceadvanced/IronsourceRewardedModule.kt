package com.ironsourceadvanced

import com.facebook.react.bridge.*
import com.facebook.react.module.annotations.ReactModule
import com.facebook.react.modules.core.DeviceEventManagerModule
import com.ironsource.mediationsdk.IronSource
import com.ironsource.mediationsdk.adunit.adapter.utility.AdInfo
import com.ironsource.mediationsdk.logger.IronSourceError
import com.ironsource.mediationsdk.model.Placement
import com.ironsource.mediationsdk.sdk.LevelPlayRewardedVideoListener

@ReactModule(name = IronsourceRewardedModule.NAME)
class IronsourceRewardedModule(reactContext: ReactApplicationContext?) :
  ReactContextBaseJavaModule(reactContext),
  LevelPlayRewardedVideoListener {

  companion object {
    const val NAME = "IronsourceRewarded"
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
  fun loadRewardedVideo() {
    IronSource.setLevelPlayRewardedVideoListener(this@IronsourceRewardedModule)
    IronSource.loadRewardedVideo()
  }

  @ReactMethod
  fun showRewardedVideo(placementName: String) {
    currentActivity?.apply {
      if(IronSource.isRewardedVideoAvailable()) {
        IronSource.showRewardedVideo(placementName);
      }
      else {
        sendEvent(reactApplicationContext, "REWARDED_UNAVAILABLE", null)
      }
    }
  }

  @ReactMethod
  fun isRewardedVideoAvailable(promise: Promise) {
    return promise.resolve(IronSource.isRewardedVideoAvailable())
  }

  @ReactMethod
  fun addListener(eventName: String?) {}

  @ReactMethod
  fun removeListeners(count: Int?) {}

  override fun onAdOpened(adInfo: AdInfo?) {
    sendEvent(reactApplicationContext, "REWARDED_OPENED", null)
  }

  override fun onAdShowFailed(error: IronSourceError?, adInfo: AdInfo?) {
    val args = Arguments.createMap()
    if(error != null) {
      args.putInt("errorCode", error.errorCode)
      args.putString("message", error.errorMessage)
    }
    sendEvent(reactApplicationContext, "REWARDED_FAILED_TO_SHOW", args)
  }

  override fun onAdClicked(placementInfo: Placement?, adInfo: AdInfo?) {
    sendEvent(reactApplicationContext, "REWARDED_CLICKED", null)
  }

  override fun onAdRewarded(placementInfo: Placement?, adInfo: AdInfo?) {
    val args = Arguments.createMap()
    if(placementInfo != null) {
      args.putString("placementName", placementInfo.placementName)
      args.putString("rewardName", placementInfo.rewardName)
      args.putInt("rewardAmount", placementInfo.rewardAmount)
    }
    sendEvent(reactApplicationContext, "REWARDED_GOT_REWARD", args)
  }

  override fun onAdClosed(adInfo: AdInfo?) {
    sendEvent(reactApplicationContext, "REWARDED_CLOSED", null)
  }

  override fun onAdAvailable(adInfo: AdInfo?) {
    sendEvent(reactApplicationContext, "REWARDED_AVAILABLE", null)
  }

  override fun onAdUnavailable() {
    sendEvent(reactApplicationContext, "REWARDED_UNAVAILABLE", null)
  }
}
