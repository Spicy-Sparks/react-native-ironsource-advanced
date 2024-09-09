package com.ironsourceadvanced

import android.app.Activity
import android.app.Application
import android.content.Intent
import android.os.Bundle
import android.os.Handler
import android.os.Looper
import android.view.View
import android.widget.FrameLayout
import com.facebook.react.bridge.*
import com.facebook.react.bridge.UiThreadUtil.runOnUiThread
import com.facebook.react.module.annotations.ReactModule
import com.facebook.react.modules.core.DeviceEventManagerModule
import com.ironsource.mediationsdk.ISBannerSize
import com.ironsource.mediationsdk.IronSource
import com.ironsource.mediationsdk.IronSourceBannerLayout
import com.ironsource.mediationsdk.adunit.adapter.utility.AdInfo
import com.ironsource.mediationsdk.logger.IronSourceError
import com.ironsource.mediationsdk.sdk.LevelPlayBannerListener
import com.unity3d.mediation.LevelPlayAdError
import com.unity3d.mediation.LevelPlayAdInfo
import com.unity3d.mediation.LevelPlayAdSize
import com.unity3d.mediation.banner.LevelPlayBannerAdView
import com.unity3d.mediation.banner.LevelPlayBannerAdViewListener

@ReactModule(name = IronsourceBannerModule.NAME)
class IronsourceBannerModule(reactContext: ReactApplicationContext?) :
  ReactContextBaseJavaModule(reactContext),
  LifecycleEventListener,
  LevelPlayBannerAdViewListener {

  private var appLifecycleListener: AppLifecycleListener? = null
  private var createBannerTimestamp: Long = 0
  private var adUnit: String = ""
  private var placementName: String = ""

  init {
    appLifecycleListener = AppLifecycleListener()
    val application = reactApplicationContext?.applicationContext as? Application
    application?.registerActivityLifecycleCallbacks(appLifecycleListener)
    module = this
  }

  companion object {
    const val NAME = "IronsourceBanner"
    var bannerView: LevelPlayBannerAdView? = null
    var isAdLoaded = false
    var bannerInitScheduled = false
    var isAppInForeground: Boolean = true
    var refreshBannerOnResume: Boolean = false
    private var module: LevelPlayBannerAdViewListener? = null
  }

  override fun onHostResume() {
    val application = reactApplicationContext?.applicationContext as? Application
    application?.registerActivityLifecycleCallbacks(appLifecycleListener)
  }

  override fun onHostPause() {
    val application = reactApplicationContext?.applicationContext as? Application
    application?.unregisterActivityLifecycleCallbacks(appLifecycleListener)
  }

  override fun onHostDestroy() {
    val application = reactApplicationContext?.applicationContext as? Application
    application?.unregisterActivityLifecycleCallbacks(appLifecycleListener)
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
  fun addEventsDelegate(adUnit: String, placementName: String) {
    this.adUnit = adUnit;
    this.placementName = placementName;
    initBanner()
  }

  @ReactMethod
  fun addListener(eventName: String?) {}

  @ReactMethod
  fun removeListeners(count: Int?) {}

  private fun registerAdListener() {
    bannerView?.setBannerListener(module);
  }

  private fun initBanner() {
    runOnUiThread {
      val layoutParams: FrameLayout.LayoutParams = FrameLayout.LayoutParams(
        FrameLayout.LayoutParams.MATCH_PARENT,
        FrameLayout.LayoutParams.WRAP_CONTENT
      )

      if(bannerView == null) {
        bannerView = LevelPlayBannerAdView(reactApplicationContext, this.adUnit)
        if (bannerView != null) {
          bannerView!!.setAdSize(LevelPlayAdSize.BANNER)
          bannerView!!.setPlacementName(this.placementName)

          registerAdListener()

          createBannerTimestamp = System.currentTimeMillis()

          bannerView!!.loadAd()

          currentActivity?.addContentView(
            bannerView,
            layoutParams
          )

          bannerView?.visibility = View.INVISIBLE
        }
      }
    }
  }

  private fun scheduleBannerInitIfNeeded() {
    val currentTime = System.currentTimeMillis()
    val timeElapsed = currentTime - createBannerTimestamp
    val timeRemaining = 10000 - timeElapsed

    if (timeElapsed >= 10000) {
      initBanner()
    } else if (!bannerInitScheduled) {
      bannerInitScheduled = true

      val handler = Handler(Looper.getMainLooper())
      handler.postDelayed({
        initBanner()
        bannerInitScheduled = false
      }, timeRemaining)
    }
  }

  override fun onAdClicked(adInfo: LevelPlayAdInfo) {
    super.onAdClicked(adInfo)
    sendEvent(reactApplicationContext, "BANNER_CLICKED", null)
  }

  override fun onAdCollapsed(adInfo: LevelPlayAdInfo) {
    super.onAdCollapsed(adInfo)
    sendEvent(reactApplicationContext, "BANNER_COLLAPSED", null)
  }

  override fun onAdDisplayed(adInfo: LevelPlayAdInfo) {
    super.onAdDisplayed(adInfo)
    sendEvent(reactApplicationContext, "BANNER_PRESENTED", null)
  }

  override fun onAdLeftApplication(adInfo: LevelPlayAdInfo) {
    super.onAdLeftApplication(adInfo)
    sendEvent(reactApplicationContext, "BANNER_LEFT", null)
  }

  override fun onAdExpanded(adInfo: LevelPlayAdInfo) {
    super.onAdExpanded(adInfo)
    sendEvent(reactApplicationContext, "BANNER_EXPANDED", null)
  }

  override fun onAdDisplayFailed(adInfo: LevelPlayAdInfo, error: LevelPlayAdError) {
    super.onAdDisplayFailed(adInfo, error)
    val args = Arguments.createMap()
    if(error != null) {
      args.putInt("errorCode", error.getErrorCode())
      args.putString("message", error.getErrorMessage())
    }
    sendEvent(reactApplicationContext, "BANNER_FAILED_TO_LOAD", args)
  }

  override fun onAdLoadFailed(error: LevelPlayAdError) {
    val args = Arguments.createMap()
    if(error != null) {
      args.putInt("errorCode", error.getErrorCode())
      args.putString("message", error.getErrorMessage())
    }
    sendEvent(reactApplicationContext, "BANNER_FAILED_TO_LOAD", args)

    if (bannerView != null) {
      bannerView!!.destroy();
      bannerView = null
    }
    isAdLoaded = false

    scheduleBannerInitIfNeeded()
  }

  override fun onAdLoaded(adInfo: LevelPlayAdInfo) {
    sendEvent(reactApplicationContext, "BANNER_LOADED", null)
    isAdLoaded = true
    if (isAppInForeground) {
      val intent = Intent("com.ironsourceadvanced.banner_loaded")
      currentActivity?.applicationContext?.sendBroadcast(intent)
    } else {
      refreshBannerOnResume = true
    }
  }

  class AppLifecycleListener() : Application.ActivityLifecycleCallbacks {

    override fun onActivityCreated(activity: Activity, savedInstanceState: Bundle?) {}

    override fun onActivityStarted(activity: Activity) {}

    override fun onActivityResumed(activity: Activity) {
      if(activity.componentName.toString().takeLast(18).contains(".MainActivity")) {
        isAppInForeground = true
        if (refreshBannerOnResume) {
          val intent = Intent("com.ironsourceadvanced.banner_loaded")
          activity.applicationContext?.sendBroadcast(intent)
        }
      }
    }

    override fun onActivityPaused(activity: Activity) {
      if(activity.componentName.toString().takeLast(18).contains(".MainActivity")) {
        isAppInForeground = false
      }
    }

    override fun onActivityStopped(activity: Activity) {}

    override fun onActivityDestroyed(activity: Activity) {
      if(activity.componentName.toString().takeLast(18).contains(".MainActivity")) {
        if (bannerView != null) {
          bannerView!!.destroy();
          bannerView = null
        }
        isAdLoaded = false
        bannerInitScheduled = false
        isAppInForeground = true
        refreshBannerOnResume = false
      }
    }

    override fun onActivitySaveInstanceState(activity: Activity, outState: Bundle) {}
  }
}