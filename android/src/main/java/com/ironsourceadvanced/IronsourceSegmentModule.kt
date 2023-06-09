package com.ironsourceadvanced

import com.facebook.react.bridge.ReactApplicationContext
import com.facebook.react.bridge.ReactContextBaseJavaModule
import com.facebook.react.bridge.ReactMethod
import com.facebook.react.module.annotations.ReactModule
import com.ironsource.mediationsdk.IronSource
import com.ironsource.mediationsdk.IronSourceSegment

@ReactModule(name = IronsourceSegmentModule.NAME)
class IronsourceSegmentModule(reactContext: ReactApplicationContext?) : ReactContextBaseJavaModule(reactContext) {

  companion object {
    const val NAME = "IronsourceSegment"
  }

  override fun getName(): String {
    return NAME
  }

  private var segment: IronSourceSegment? = null
  @ReactMethod
  fun create() {
    segment = IronSourceSegment()
  }

  @ReactMethod
  fun setSegmentName(name: String?) {
    segment!!.segmentName = name
  }

  @ReactMethod
  fun setCustomValue(value: String?, key: String?) {
    segment!!.setCustom(key, value)
  }

  @ReactMethod
  fun activate() {
    if (segment != null) {
      IronSource.setSegment(segment)
    }
  }

  @ReactMethod
  fun addListener(eventName: String?) {}

  @ReactMethod
  fun removeListeners(count: Int?) {}
}
