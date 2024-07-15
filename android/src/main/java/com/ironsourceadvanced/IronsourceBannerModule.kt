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

@ReactModule(name = IronsourceBannerModule.NAME)
class IronsourceBannerModule(reactContext: ReactApplicationContext?) :
  ReactContextBaseJavaModule(reactContext),
  LevelPlayBannerListener,
  LifecycleEventListener{

  private var appLifecycleListener: AppLifecycleListener? = null
  private var createBannerTimestamp: Long = 0

  init {
    appLifecycleListener = AppLifecycleListener()
    val application = reactApplicationContext?.applicationContext as? Application
    application?.registerActivityLifecycleCallbacks(appLifecycleListener)
    module = this
  }

  companion object {
    const val NAME = "IronsourceBanner"
    var bannerView: IronSourceBannerLayout? = null
    var isAdLoaded = false
    var bannerInitScheduled = false
    var isAppInForeground: Boolean = true
    var refreshBannerOnResume: Boolean = false
    private var module: IronsourceBannerModule? = null
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
  fun addEventsDelegate() {
    initBanner()
  }

  @ReactMethod
  fun addListener(eventName: String?) {}

  @ReactMethod
  fun removeListeners(count: Int?) {}

  private fun registerAdListener() {
    bannerView?.levelPlayBannerListener = module
  }

  private fun initBanner() {
    runOnUiThread {
      val layoutParams: FrameLayout.LayoutParams = FrameLayout.LayoutParams(
        FrameLayout.LayoutParams.MATCH_PARENT,
        FrameLayout.LayoutParams.WRAP_CONTENT
      )

      if(bannerView == null) {
        bannerView = IronSource.createBanner(currentActivity, ISBannerSize.BANNER)
        if (bannerView != null) {
          registerAdListener()

          createBannerTimestamp = System.currentTimeMillis()

          IronSource.loadBanner(bannerView)

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

  override fun onAdLoaded(adInfo: AdInfo?) {
    sendEvent(reactApplicationContext, "BANNER_LOADED", null)
    isAdLoaded = true
    if (isAppInForeground) {
      val intent = Intent("com.ironsourceadvanced.banner_loaded")
      currentActivity?.applicationContext?.sendBroadcast(intent)
    } else {
      refreshBannerOnResume = true
    }
  }

  override fun onAdLoadFailed(error: IronSourceError?) {
    val args = Arguments.createMap()
    if(error != null) {
      args.putInt("errorCode", error.errorCode)
      args.putString("message", error.errorMessage)
    }
    sendEvent(reactApplicationContext, "BANNER_FAILED_TO_LOAD", args)

    if (bannerView != null) {
      IronSource.destroyBanner(bannerView)
      bannerView = null
    }
    isAdLoaded = false

    scheduleBannerInitIfNeeded()
  }

  override fun onAdClicked(adInfo: AdInfo?) {
    sendEvent(reactApplicationContext, "BANNER_LOADED", null)
  }

  override fun onAdLeftApplication(adInfo: AdInfo?) {
    sendEvent(reactApplicationContext, "BANNER_LEFT", null)
  }

  override fun onAdScreenPresented(adInfo: AdInfo?) {
    sendEvent(reactApplicationContext, "BANNER_PRESENTED", null)
  }

  override fun onAdScreenDismissed(adInfo: AdInfo?) {
    sendEvent(reactApplicationContext, "BANNER_DISMISSED", null)
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
          IronSource.destroyBanner(bannerView)
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