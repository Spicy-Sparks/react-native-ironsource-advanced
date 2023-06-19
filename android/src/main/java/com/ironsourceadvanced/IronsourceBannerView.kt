package com.ironsourceadvanced

import android.graphics.Color
import android.view.Gravity
import android.view.View
import android.widget.FrameLayout
import com.facebook.react.bridge.UiThreadUtil.runOnUiThread
import com.facebook.react.uimanager.ThemedReactContext
import com.ironsource.mediationsdk.ISBannerSize
import com.ironsource.mediationsdk.IronSource

class IronsourceBannerView(context: ThemedReactContext) : FrameLayout(context) {

  init {
    setBackgroundColor(Color.BLUE)
    fitsSystemWindows = true
    layoutParams = LayoutParams(LayoutParams.MATCH_PARENT, LayoutParams.MATCH_PARENT, Gravity.CENTER)

    runOnUiThread {
      try {
        setBackgroundColor(Color.BLUE)
        fitsSystemWindows = true
        layoutParams = LayoutParams(LayoutParams.MATCH_PARENT, LayoutParams.MATCH_PARENT, Gravity.CENTER)

        /*val mBannerContainer = FrameLayout(context)
        mBannerContainer.setBackgroundColor(Color.YELLOW)

        val layoutParamsTest = LayoutParams(200, 200)
        layoutParamsTest.gravity = Gravity.CENTER;
        mBannerContainer?.layoutParams = layoutParamsTest

        // context.currentActivity?.addContentView(mBannerContainer, LayoutParams(LayoutParams.MATCH_PARENT, 200))
        addView(mBannerContainer)*/

        /*val mBanner = IronSource.createBanner(context.currentActivity, ISBannerSize.BANNER)
        val layoutParamsBanner = LayoutParams(LayoutParams.MATCH_PARENT, LayoutParams.MATCH_PARENT)
        layoutParamsBanner.gravity = Gravity.CENTER;
        mBanner.layoutParams = layoutParamsBanner

        // mBannerContainer?.addView(mBanner, LayoutParams(LayoutParams.MATCH_PARENT, LayoutParams.WRAP_CONTENT, Gravity.CENTER))

        IronSource.loadBanner(mBanner)*/

        val myView = FrameLayout(context)
        myView.setBackgroundColor(Color.GREEN)
        val layoutParamsTest = LayoutParams(200, 200)
        layoutParamsTest.gravity = Gravity.CENTER;
        myView.layoutParams = layoutParamsTest
        addView(myView)
        
        setBackgroundColor(Color.BLUE)
        fitsSystemWindows = true
        layoutParams = LayoutParams(LayoutParams.MATCH_PARENT, LayoutParams.MATCH_PARENT, Gravity.CENTER)

      } catch (e: Throwable) {}
    }
  }

  fun attachBanner () {
    addView(IronsourceBannerModule.bannerView)
  }
}
