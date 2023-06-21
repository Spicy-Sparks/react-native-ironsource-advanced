package com.ironsourceadvanced

import com.facebook.react.bridge.*
import com.facebook.react.module.annotations.ReactModule
import com.facebook.react.modules.core.DeviceEventManagerModule
import com.ironsource.mediationsdk.IronSource
import com.ironsource.mediationsdk.impressionData.ImpressionData
import com.ironsource.mediationsdk.impressionData.ImpressionDataListener
import com.ironsource.mediationsdk.sdk.InitializationListener
import java.util.concurrent.Executors

@ReactModule(name = IronsourceAdvancedModule.NAME)
class IronsourceAdvancedModule(reactContext: ReactApplicationContext?) :
  ReactContextBaseJavaModule(reactContext),
  InitializationListener,
  ImpressionDataListener {

  companion object {
    const val NAME = "IronsourceAdvanced"
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
  fun init(appKey: String, adUnits: ReadableArray, options: ReadableMap?, promise: Promise) {
    if (currentActivity == null) {
      promise.reject("E_ACTIVITY_IS_NULL", "Current Activity does not exist.")
      return
    }
    if (appKey.isEmpty()) {
      promise.reject("E_ILLEGAL_ARGUMENT", "appKey must be provided.")
      return
    }
    val adUnitsList = adUnits.toArrayList()
    if (adUnitsList.size > 0) {
      val parsed = adUnitsList.map {
        when (it) {
          "REWARDED_VIDEO" -> IronSource.AD_UNIT.REWARDED_VIDEO
          "INTERSTITIAL" -> IronSource.AD_UNIT.INTERSTITIAL
          "OFFERWALL" -> IronSource.AD_UNIT.OFFERWALL
          "BANNER" -> IronSource.AD_UNIT.BANNER
          else -> return promise.reject(
            "E_ILLEGAL_ARGUMENT",
            "Unsupported ad unit: $it"
          )
        }
      }.toTypedArray()
      IronSource.init(currentActivity, appKey, this@IronsourceAdvancedModule, *parsed)
    } else {
      IronSource.init(currentActivity, appKey, this@IronsourceAdvancedModule)
    }
    promise.resolve(null)
  }

  @ReactMethod
  fun addImpressionDataDelegate() {
    IronSource.addImpressionDataListener(this)
  }

  @ReactMethod
  fun setConsent(consent: Boolean) {
    IronSource.setConsent(consent)
  }

  @ReactMethod
  fun setUserId(userId: String) {
    if(userId != null)
      IronSource.setUserId(userId)
  }

  @ReactMethod
  fun setDynamicUserId(userId: String) {
    if(userId != null)
      IronSource.setDynamicUserId(userId)
  }

  @ReactMethod
  fun getAdvertiserId(promise: Promise) {
    currentActivity?.apply {
      val executor = Executors.newSingleThreadExecutor()
      executor.execute {
        // this API MUST be called on a background thread
        val idStr = IronSource.getAdvertiserId(this)
        runOnUiThread { promise.resolve(idStr) }
      }
    } ?: return promise.reject(
      "E_ACTIVITY_IS_NULL",
      "Current Activity does not exist."
    )
  }

  @ReactMethod
  fun addListener(eventName: String?) {}

  @ReactMethod
  fun removeListeners(count: Int?) {}

  override fun onInitializationComplete() {
    sendEvent(reactApplicationContext, "INIT_COMPLETED", null);
  }

  override fun onImpressionSuccess(impressionData: ImpressionData?) {
    val args = Arguments.createMap()
    if(impressionData != null) {
      if(impressionData.auctionId != null) {
        args.putString("auctionId", impressionData.auctionId)
      }
      if(impressionData.adUnit != null) {
        args.putString("adUnit", impressionData.adUnit)
      }
      if(impressionData.country != null) {
        args.putString("country", impressionData.country)
      }
      if(impressionData.ab != null) {
        args.putString("ab", impressionData.ab)
      }
      if(impressionData.segmentName != null) {
        args.putString("segmentName", impressionData.segmentName)
      }
      if(impressionData.placement != null) {
        args.putString("placement", impressionData.placement)
      }
      if(impressionData.adNetwork != null) {
        args.putString("adNetwork", impressionData.adNetwork)
      }
      if(impressionData.instanceName != null) {
        args.putString("instanceName", impressionData.instanceName)
      }
      if(impressionData.instanceId != null) {
        args.putString("instanceId", impressionData.instanceId)
      }
      if(impressionData.revenue != null) {
        args.putDouble("revenue", impressionData.revenue)
      }
      if(impressionData.precision != null) {
        args.putString("precision", impressionData.precision)
      }
      if(impressionData.lifetimeRevenue != null) {
        args.putDouble("lifetimeRevenue", impressionData.lifetimeRevenue)
      }
      if(impressionData.encryptedCPM != null) {
        args.putString("encryptedCPM", impressionData.encryptedCPM)
      }
    }
    sendEvent(reactApplicationContext, "ON_IMPRESSION_SUCCESS", args)
  }
}
