package com.ironsourceadvanced

import android.annotation.SuppressLint
import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.content.IntentFilter
import android.view.*
import android.widget.RelativeLayout
import com.facebook.react.bridge.UiThreadUtil.runOnUiThread
import com.facebook.react.uimanager.ThemedReactContext
import java.util.*
import kotlin.math.abs

@SuppressLint("ViewConstructor")
class IronsourceBannerView(context: ThemedReactContext) : RelativeLayout(context) {
  private var mContext: ThemedReactContext? = null

  private val bannerLayoutParams = LayoutParams(width, height).apply {
    gravity = Gravity.CENTER
  }

  companion object {
    var lastBannerParent: IronsourceBannerView? = null
  }

  init {
    mContext = context

    val intentFilter = IntentFilter()
    intentFilter.addAction("com.ironsourceadvanced.banner_loaded")
    intentFilter.addAction("com.navigation.bottom_tab_selected")

    val receiver = object : BroadcastReceiver() {
      override fun onReceive(context: Context?, intent: Intent) {
        if (intent.action === "com.ironsourceadvanced.banner_loaded") {
          if (isLayoutVisible()) onLayoutAppear(isRefresh = true)
        } else if (intent.action === "com.navigation.bottom_tab_selected") {
          if (isLayoutVisible()) onLayoutAppear(bottomTabSelected = true)
        }
      }
    }
    mContext?.registerReceiver(receiver, intentFilter)
  }

  fun isLayoutVisible(): Boolean {
    if (visibility != View.VISIBLE || alpha == 0f) {
      return false
    }

    var parent = parent as? View
    while (parent != null) {
      if (parent.visibility != View.VISIBLE || parent.alpha == 0f) {
        return false
      }
      parent = parent.parent as? View
    }

    return true
  }

  private fun onLayoutAppear(isRefresh: Boolean = false, bottomTabSelected: Boolean = false) {
    if (isRefresh) {
      attachBanner(isRefresh = true)
    } else if (bottomTabSelected) {
      attachBanner(bottomTabSelected = true)
    } else {
      val timer = Timer()
      timer.schedule(object : TimerTask() {
        override fun run() {
          post {
            try {
              attachBanner()
            } catch (_: Throwable) {}
          }
        }
      }, 750L)
    }
  }

  override fun onAttachedToWindow() {
    super.onAttachedToWindow()
    if (isLayoutVisible()) onLayoutAppear()
  }

  private fun attachBanner (isRefresh: Boolean = false, bottomTabSelected: Boolean = false) {
    if(lastBannerParent == this && !isRefresh && !bottomTabSelected)
      return

    runOnUiThread {
      try {
        if(IronsourceBannerModule.isAdLoaded) {
          if(IronsourceBannerModule.bannerView?.parent != null) {
            val bannerParentView = IronsourceBannerModule.bannerView?.parent as? ViewGroup
            bannerParentView?.removeView(IronsourceBannerModule.bannerView)
          }

          val activityBannerLayoutParams = LayoutParams(width, height).apply {
            gravity = Gravity.CENTER
            bottomMargin = abs(1000)
          }

          layoutParams = bannerLayoutParams

          mContext?.currentActivity?.addContentView(
            IronsourceBannerModule.bannerView,
            activityBannerLayoutParams
          )

          IronsourceBannerModule.bannerView?.visibility = View.INVISIBLE

          val timer = Timer()
          timer.schedule(object : TimerTask() {
            override fun run() {
              post {
                try {
                  if(IronsourceBannerModule.bannerView?.parent != null) {
                    val bannerParentView = IronsourceBannerModule.bannerView?.parent as? ViewGroup
                    bannerParentView?.removeView(IronsourceBannerModule.bannerView)
                  }
                  IronsourceBannerModule.bannerView?.visibility = View.VISIBLE
                  addView(IronsourceBannerModule.bannerView, bannerLayoutParams)
                  lastBannerParent = this@IronsourceBannerView
                } catch (_: Throwable) {}
              }
            }
          }, 1L)
        }
      } catch (_: Throwable) {}
    }
  }
}