package com.ironsourceadvanced

import android.annotation.SuppressLint
import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.content.IntentFilter
import android.content.res.Resources
import android.graphics.Rect
import android.view.*
import android.widget.RelativeLayout
import androidx.viewpager.widget.ViewPager
import com.facebook.react.bridge.UiThreadUtil.runOnUiThread
import com.facebook.react.uimanager.ThemedReactContext
import com.ironsource.mediationsdk.IronSource
import java.util.*
import kotlin.math.abs

@SuppressLint("ViewConstructor")
class IronsourceBannerView(context: ThemedReactContext) : RelativeLayout(context) {
  private var mContext: ThemedReactContext? = null

  private val bannerLayoutParams = LayoutParams(width, height).apply {
    gravity = Gravity.CENTER
  }

  init {
    mContext = context

    viewTreeObserver.addOnGlobalLayoutListener {
      if (isLayoutVisible()) onLayoutAppear()
    }

    addOnAttachStateChangeListener(object : OnAttachStateChangeListener {
      override fun onViewAttachedToWindow(v: View) {
        if (isLayoutVisible()) onLayoutAppear()
      }

      override fun onViewDetachedFromWindow(v: View) {
        if (isLayoutVisible()) onLayoutAppear()
      }
    })
    val viewPager: ViewPager? = findViewPager()

    viewPager?.addOnPageChangeListener(object : ViewPager.OnPageChangeListener {
      override fun onPageSelected(position: Int) {
        if (isLayoutVisible()) onLayoutAppear()
      }

      override fun onPageScrolled(position: Int, positionOffset: Float, positionOffsetPixels: Int) {}

      override fun onPageScrollStateChanged(state: Int) {}
    })

    val intentFilter = IntentFilter()
    intentFilter.addAction("com.ironsourceadvanced.banner_loaded")
    intentFilter.addAction("com.navigation.bottom_tab_selected")

    val receiver = object : BroadcastReceiver() {
      override fun onReceive(context: Context?, intent: Intent) {
        if (intent.action === "com.ironsourceadvanced.banner_loaded") {
          if (isLayoutVisible()) {
            val bannerParentView = IronsourceBannerModule.bannerView?.parent as? ViewGroup
            IronsourceBannerModule.bannerView?.visibility = View.VISIBLE
            bannerParentView?.removeView(IronsourceBannerModule.bannerView)
            addView(IronsourceBannerModule.bannerView, bannerLayoutParams)
          }
        } else if (intent.action === "com.navigation.bottom_tab_selected") {
          if (isLayoutVisible()) onLayoutAppear()
        }
      }
    }
    mContext?.registerReceiver(receiver, intentFilter)
  }

  private fun findViewPager(): ViewPager? {
    var parentView: View? = this

    while (parentView != null) {
      if (parentView is ViewPager) {
        return parentView
      }
      parentView = parentView.parent as? View
    }

    return null
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
    }, 750L)
  }

  override fun onAttachedToWindow() {
    super.onAttachedToWindow()
    if (isLayoutVisible()) onLayoutAppear()
  }

  override fun onLayout(changed: Boolean, l: Int, t: Int, r: Int, b: Int) {
    super.onLayout(changed, l, t, r, b)
    if (isLayoutVisible()) onLayoutAppear()
  }

  private fun attachBanner () {
    if(IronsourceBannerModule.bannerView?.parent == this)
      return

    runOnUiThread {
      try {
        if (IronsourceBannerModule.bannerView?.parent != null)
          (IronsourceBannerModule.bannerView?.parent as RelativeLayout).removeView(IronsourceBannerModule.bannerView)

        if (!IronsourceBannerModule.isAdLoaded) {

          val activityBannerLayoutParams = LayoutParams(width, height).apply {
            gravity = Gravity.CENTER
            bottomMargin = abs(1000)
          }

          layoutParams = bannerLayoutParams

          IronSource.loadBanner(IronsourceBannerModule.bannerView)

          mContext?.currentActivity?.addContentView(
            IronsourceBannerModule.bannerView,
            activityBannerLayoutParams
          )

          IronsourceBannerModule.bannerView?.visibility = View.INVISIBLE

        } else {
          addView(IronsourceBannerModule.bannerView, bannerLayoutParams)
        }
      } catch (_: Throwable) {}
    }
  }
}
