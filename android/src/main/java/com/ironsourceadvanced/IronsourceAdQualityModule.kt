package com.ironsourceadvanced

import com.facebook.react.bridge.Arguments
import com.facebook.react.bridge.ReactApplicationContext
import com.facebook.react.bridge.ReactContext
import com.facebook.react.bridge.ReactContextBaseJavaModule
import com.facebook.react.bridge.ReactMethod
import com.facebook.react.bridge.WritableMap
import com.facebook.react.module.annotations.ReactModule
import com.facebook.react.modules.core.DeviceEventManagerModule
import com.ironsource.adqualitysdk.sdk.ISAdQualityConfig
import com.ironsource.adqualitysdk.sdk.ISAdQualityInitError
import com.ironsource.adqualitysdk.sdk.ISAdQualityInitListener
import com.ironsource.adqualitysdk.sdk.IronSourceAdQuality

@ReactModule(name = IronsourceAdQualityModule.NAME)
class IronsourceAdQualityModule(reactContext: ReactApplicationContext?) :
  ReactContextBaseJavaModule(reactContext),
  ISAdQualityInitListener {

  companion object {
    const val NAME = "IronsourceAdQuality"
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
  fun init(appKey: String, userId: String?) {
    val adQualityConfigBuilder = ISAdQualityConfig.Builder()
    if(!userId.isNullOrEmpty())
      adQualityConfigBuilder.setUserId(userId)
    val adQualityConfig = adQualityConfigBuilder.build()
    IronSourceAdQuality.getInstance().initialize(reactApplicationContext, appKey, adQualityConfig)
  }

  @ReactMethod
  fun setUserId(userId: String) {
    if(!userId.isNullOrEmpty())
      IronSourceAdQuality.getInstance().changeUserId(userId)
  }

  @ReactMethod
  fun addListener(eventName: String?) {}

  @ReactMethod
  fun removeListeners(count: Int?) {}

  override fun adQualitySdkInitSuccess() {
    sendEvent(reactApplicationContext, "INIT_COMPLETED", null);
  }

  override fun adQualitySdkInitFailed(error: ISAdQualityInitError?, message: String?) {
    val args = Arguments.createMap()
    args.putString("message", message)
    sendEvent(reactApplicationContext, "INIT_FAILED", args);
  }
}
