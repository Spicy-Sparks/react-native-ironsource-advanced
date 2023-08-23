package com.ironsourceadvanced

import android.app.Activity
import android.app.Application
import android.content.Intent
import android.os.Bundle
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
    private var module: IronsourceBannerModule? = null

    fun registerAdListener() {
      bannerView?.levelPlayBannerListener = module
    }
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

  private fun initBanner() {
    runOnUiThread {
      var layoutParams: FrameLayout.LayoutParams? = FrameLayout.LayoutParams(
        FrameLayout.LayoutParams.MATCH_PARENT,
        FrameLayout.LayoutParams.WRAP_CONTENT
      )

      val bannerView = IronSource.createBanner(currentActivity, ISBannerSize.BANNER)
      IronsourceBannerModule.bannerView = bannerView
      registerAdListener()

      IronSource.loadBanner(IronsourceBannerModule.bannerView)

      currentActivity?.addContentView(
        IronsourceBannerModule.bannerView,
        layoutParams
      )

      IronsourceBannerModule.bannerView?.visibility = View.INVISIBLE
    }
  }

  override fun onAdLoaded(adInfo: AdInfo?) {
    sendEvent(reactApplicationContext, "BANNER_LOADED", null)
    isAdLoaded = true
    val intent = Intent("com.ironsourceadvanced.banner_loaded")
    currentActivity?.applicationContext?.sendBroadcast(intent)
  }

  override fun onAdLoadFailed(error: IronSourceError?) {
    val args = Arguments.createMap()
    if(error != null) {
      args.putInt("errorCode", error.errorCode)
      args.putString("message", error.errorMessage)
    }
    sendEvent(reactApplicationContext, "BANNER_FAILED_TO_LOAD", args)

    IronSource.destroyBanner(bannerView)
    isAdLoaded = false
    initBanner()
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

    override fun onActivityResumed(activity: Activity) {}

    override fun onActivityPaused(activity: Activity) {}

    override fun onActivityStopped(activity: Activity) {}

    override fun onActivityDestroyed(activity: Activity) {
      if(activity.componentName.toString().takeLast(18).contains(".MainActivity")) {
        isAdLoaded = false
        if (bannerView != null) IronSource.destroyBanner(bannerView)
      }
    }

    override fun onActivitySaveInstanceState(activity: Activity, outState: Bundle) {}
  }
}