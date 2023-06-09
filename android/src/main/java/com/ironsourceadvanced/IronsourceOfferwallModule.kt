package com.ironsourceadvanced

import com.facebook.react.bridge.*
import com.facebook.react.module.annotations.ReactModule
import com.facebook.react.modules.core.DeviceEventManagerModule
import com.ironsource.adapters.supersonicads.SupersonicConfig
import com.ironsource.mediationsdk.IronSource
import com.ironsource.mediationsdk.logger.IronSourceError
import com.ironsource.mediationsdk.sdk.OfferwallListener

@ReactModule(name = IronsourceOfferwallModule.NAME)
class IronsourceOfferwallModule(reactContext: ReactApplicationContext?) :
  ReactContextBaseJavaModule(reactContext),
  OfferwallListener {

  companion object {
    const val NAME = "IronsourceOfferwall"
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
  fun showOfferwall(placementName: String) {
    currentActivity?.apply {
      SupersonicConfig.getConfigObj().clientSideCallbacks = true
      IronSource.setOfferwallListener(this@IronsourceOfferwallModule)
      if(IronSource.isOfferwallAvailable()) {
        IronSource.showOfferwall(placementName)
      }
      else {
        sendEvent(reactApplicationContext, "OFFERWALL_UNAVAILABLE", null)
      }
    }
  }

  @ReactMethod
  fun isOfferwallAvailable(promise: Promise) {
    promise.resolve(IronSource.isOfferwallAvailable())
  }

  @ReactMethod
  fun addListener(eventName: String?) {}

  @ReactMethod
  fun removeListeners(count: Int?) {}
  override fun onOfferwallAvailable(available: Boolean) {
    if(available) {
      sendEvent(reactApplicationContext, "OFFERWALL_AVAILABLE", null)
    }
    else {
      sendEvent(reactApplicationContext, "OFFERWALL_UNAVAILABLE", null)
    }
  }

  override fun onOfferwallOpened() {
    sendEvent(reactApplicationContext, "OFFERWALL_SHOWN", null)
  }

  override fun onOfferwallShowFailed(error: IronSourceError?) {
    val args = Arguments.createMap()
    if(error != null) {
      args.putInt("errorCode", error.errorCode);
      args.putString("message", error.errorMessage);
    }
    sendEvent(reactApplicationContext, "OFFERWALL_FAILED_TO_SHOW", args)
  }

  override fun onOfferwallAdCredited(credits: Int, totalCredits: Int, totalCreditsFlag: Boolean): Boolean {
    val args = Arguments.createMap()
    args.putInt("count", credits)
    sendEvent(reactApplicationContext, "OFFERWALL_RECEIVED_CREDITS", args)
    return true
  }

  override fun onGetOfferwallCreditsFailed(error: IronSourceError?) {
    val args = Arguments.createMap()
    if(error != null) {
      args.putInt("errorCode", error.errorCode);
      args.putString("message", error.errorMessage);
    }
    sendEvent(reactApplicationContext, "OFFERWALL_FAILED_TO_RECEIVE_CREDITS", args)
  }

  override fun onOfferwallClosed() {
    sendEvent(reactApplicationContext, "OFFERWALL_CLOSED", null)
  }
}
