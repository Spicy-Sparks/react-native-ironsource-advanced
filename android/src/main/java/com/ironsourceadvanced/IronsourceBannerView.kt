package com.ironsourceadvanced

import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.content.IntentFilter
import android.content.res.Resources
import android.graphics.Color
import android.graphics.Rect
import android.util.Log
import android.view.*
import android.widget.RelativeLayout
import com.facebook.react.bridge.UiThreadUtil.runOnUiThread
import com.facebook.react.uimanager.ThemedReactContext
import com.ironsource.mediationsdk.IronSource
import java.util.*
import kotlin.math.abs

class IronsourceBannerView(context: ThemedReactContext) : RelativeLayout(context) {
  private var mContext: ThemedReactContext? = null
  private var isLayoutVisible = false
  private var isActive = false
  private var firstTime = true
  private var randomNumber = 0


  init {
    mContext = context

    randomNumber = (1000..1000000).random()

    viewTreeObserver.addOnGlobalLayoutListener {
      val isVisible = isLayoutVisible()
      if (isVisible != isLayoutVisible) {
        if (isVisible) {
          onLayoutAppear()
        } else {
          onLayoutDisappear()
        }
      }
      isLayoutVisible = isVisible
    }

    addOnAttachStateChangeListener(object : OnAttachStateChangeListener {
      override fun onViewAttachedToWindow(v: View) {
        val isVisible = isLayoutVisible()
        if (isVisible != isLayoutVisible) {
          if (isVisible) {
            onLayoutAppear()
          } else {
            onLayoutDisappear()
          }
        }
        isLayoutVisible = isVisible
      }

      override fun onViewDetachedFromWindow(v: View) {
        val isVisible = isLayoutVisible()
        if (isVisible != isLayoutVisible) {
          if (isVisible) {
            onLayoutAppear()
          } else {
            onLayoutDisappear()
          }
        }
        isLayoutVisible = isVisible
      }
    })

    val intentFilter = IntentFilter()
    intentFilter.addAction("com.esound.banner_loaded")
    intentFilter.addAction("com.esound.tab_selected")

    val receiver = object : BroadcastReceiver() {
      override fun onReceive(context: Context?, intent: Intent) {

        if (intent?.action  === "com.esound.banner_loaded") {
          Log.d("rreceived", "rreceived")
          if (isLayoutVisible()) {
            val bannerLayoutParams = LayoutParams(width, height).apply {
              gravity = Gravity.CENTER
            }
            val bannerParentView = IronsourceBannerModule.bannerView?.parent as? ViewGroup
            IronsourceBannerModule.bannerView?.visibility = View.VISIBLE
            bannerParentView?.removeView(IronsourceBannerModule.bannerView)

            addView(IronsourceBannerModule.bannerView, bannerLayoutParams)
          }

        } else if (intent?.action  === "com.esound.tab_selected") {
          Log.d("tabvisible???", "tabvisible???" + isLayoutVisible() + randomNumber)
        }
      }
    }

    mContext?.registerReceiver(receiver, intentFilter)
  }

  fun isLayoutVisible(): Boolean {
    if (visibility != View.VISIBLE || alpha == 0f) {
      return false
    }

    val screenRect = Rect(0, 0, Resources.getSystem().displayMetrics.widthPixels, Resources.getSystem().displayMetrics.heightPixels)
    val viewRect = Rect()
    getGlobalVisibleRect(viewRect)

    if (!screenRect.intersect(viewRect)) {
      return false
    }

    var parent = parent as? View
    while (parent != null) {
      if (parent.visibility != View.VISIBLE || parent.alpha == 0f) {
        return false
      }
      parent.getGlobalVisibleRect(viewRect)
      if (!screenRect.intersect(viewRect)) {
        return false
      }
      parent = parent.parent as? View
    }

    return true
  }

  private fun onLayoutAppear() {
    val timer = Timer()

    timer.schedule(object : TimerTask() {
      override fun run() {
        post {
          attachBanner()
        }
      }
    }, 1000L)

    Log.d("visible???appear", "visible???appear" + isLayoutVisible() + randomNumber)
  }

  private fun onLayoutDisappear() {
    isActive = false

//    if (IronsourceBannerModule.bannerView?.parent != null)
      removeView(IronsourceBannerModule.bannerView)

    Log.d("visible???disappear", "visible???disappear" + isLayoutVisible() + randomNumber)
  }

  override fun onAttachedToWindow() {
    super.onAttachedToWindow()
    val isVisible = isLayoutVisible()
    if (isVisible != isLayoutVisible) {
      if (isVisible) {
        onLayoutAppear()
      } else {
        onLayoutDisappear()
      }
    }
    isLayoutVisible = isVisible
  }


  private fun attachBanner () {
    if(isActive)
      return

    isActive = true

    runOnUiThread {
      try {
//        if (!IronsourceBannerModule.isAdLoaded) {

          val bannerLayoutParams = LayoutParams(width, height).apply {
            gravity = Gravity.CENTER
          }

          val activityBannerLayoutParams = LayoutParams(width, height).apply {
            gravity = Gravity.CENTER
            bottomMargin = abs(1000)
          }

          layoutParams = bannerLayoutParams
          clipChildren = false

          //         var mBanner = IronSource.createBanner(mContext?.currentActivity, ISBannerSize.BANNER)
          IronsourceBannerModule.bannerView?.setBackgroundColor(Color.BLUE)

          IronSource.loadBanner(IronsourceBannerModule.bannerView)

          mContext?.currentActivity?.addContentView(
            IronsourceBannerModule.bannerView,
            activityBannerLayoutParams
          )

          IronsourceBannerModule.bannerView?.visibility = View.INVISIBLE

       /* } else {
          addView(IronsourceBannerModule.bannerView, bannerLayoutParams)
        }*/
      } catch (e: Throwable) {}
    }
  }
}
