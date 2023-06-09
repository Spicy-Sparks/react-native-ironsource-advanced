package com.ironsourceadvanced

import android.view.View
import com.facebook.react.uimanager.SimpleViewManager
import com.facebook.react.uimanager.ThemedReactContext

class IronsourceBannerViewManager : SimpleViewManager<View>() {
  override fun getName() = "IronsourceBannerViewManager"

  override fun createViewInstance(reactContext: ThemedReactContext): View {
    return IronsourceBannerView(reactContext)
  }
}
