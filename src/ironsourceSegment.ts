import { NativeModules } from 'react-native'

const { IronsourceSegment } = NativeModules

export default class IronSourceSegment {
  constructor() {
    IronsourceSegment.create()
  }

  setSegmentName(name: string) {
    IronsourceSegment.setSegmentName(name)
  }

  setCustomValue(key: string, value: string) {
    IronsourceSegment.setCustomValue(value, key)
  }

  activate() {
    IronsourceSegment.activate()
  }
}
