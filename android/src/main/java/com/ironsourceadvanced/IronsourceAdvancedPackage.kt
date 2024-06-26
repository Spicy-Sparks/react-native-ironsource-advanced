package com.ironsourceadvanced

import com.facebook.react.ReactPackage
import com.facebook.react.bridge.NativeModule
import com.facebook.react.bridge.ReactApplicationContext
import com.facebook.react.uimanager.ViewManager

class IronsourceAdvancedPackage : ReactPackage {
  override fun createNativeModules(reactContext: ReactApplicationContext): List<NativeModule> {
    return listOf(
      IronsourceAdvancedModule(reactContext),
      IronsourceAdQualityModule(reactContext),
      IronsourceInterstitialModule(reactContext),
      IronsourceRewardedModule(reactContext),
      IronsourceBannerModule(reactContext)
    )
  }

  override fun createViewManagers(reactContext: ReactApplicationContext): List<ViewManager<*, *>> {
    return listOf(IronsourceBannerViewManager())
  }
}
