import { NativeEventEmitter, NativeModules } from 'react-native'

const { IronsourceBanner } = NativeModules
const eventEmitter = new NativeEventEmitter(IronsourceBanner)

const ON_BANNER_LOADED = 'BANNER_LOADED'
const ON_BANNER_FAILED_TO_LOAD = 'BANNER_FAILED_TO_LOAD'
const ON_BANNER_CLICKED = 'BANNER_CLICKED'
const ON_BANNER_PRESENTED = 'BANNER_PRESENTED'
const ON_BANNER_LEFT = 'BANNER_LEFT'
const BANNER_EXPANDED = 'BANNER_EXPANDED'
const BANNER_COLLAPSED = 'BANNER_COLLAPSED'

const init = (
  adUnit: string,
  placementName: string
) => IronsourceBanner.addEventsDelegate(adUnit, placementName)

const onLoaded = {
  setListener: (listener: () => void) => {
    eventEmitter.removeAllListeners(ON_BANNER_LOADED)
    eventEmitter.addListener(ON_BANNER_LOADED, listener)
  },
  removeListener: () => eventEmitter.removeAllListeners(ON_BANNER_LOADED),
}

const onFailedToLoad = {
  setListener: (listener: (error: string) => void) => {
    eventEmitter.removeAllListeners(ON_BANNER_FAILED_TO_LOAD)
    eventEmitter.addListener(ON_BANNER_FAILED_TO_LOAD, listener)
  },
  removeListener: () =>
    eventEmitter.removeAllListeners(ON_BANNER_FAILED_TO_LOAD),
}

const onClicked = {
  setListener: (listener: () => void) => {
    eventEmitter.removeAllListeners(ON_BANNER_CLICKED)
    eventEmitter.addListener(ON_BANNER_CLICKED, listener)
  },
  removeListener: () => eventEmitter.removeAllListeners(ON_BANNER_CLICKED),
}

const onPresented = {
  setListener: (listener: () => void) => {
    eventEmitter.removeAllListeners(ON_BANNER_PRESENTED)
    eventEmitter.addListener(ON_BANNER_PRESENTED, listener)
  },
  removeListener: () => eventEmitter.removeAllListeners(ON_BANNER_PRESENTED),
}

const onLeft = {
  setListener: (listener: () => void) => {
    eventEmitter.removeAllListeners(ON_BANNER_LEFT)
    eventEmitter.addListener(ON_BANNER_LEFT, listener)
  },
  removeListener: () => eventEmitter.removeAllListeners(ON_BANNER_LEFT),
}

const onExpanded = {
  setListener: (listener: () => void) => {
    eventEmitter.removeAllListeners(BANNER_EXPANDED)
    eventEmitter.addListener(BANNER_EXPANDED, listener)
  },
  removeListener: () => eventEmitter.removeAllListeners(BANNER_EXPANDED),
}

const onCollapsed = {
  setListener: (listener: () => void) => {
    eventEmitter.removeAllListeners(BANNER_COLLAPSED)
    eventEmitter.addListener(BANNER_COLLAPSED, listener)
  },
  removeListener: () => eventEmitter.removeAllListeners(BANNER_COLLAPSED),
}

const removeAllListeners = () => {
  onLoaded.removeListener()
  onFailedToLoad.removeListener()
  onClicked.removeListener()
  onPresented.removeListener()
  onLeft.removeListener()
  onExpanded.removeListener()
  onCollapsed.removeListener()
}

export default {
  init,
  onLoaded,
  onFailedToLoad,
  onClicked,
  onPresented,
  onLeft,
  onExpanded,
  onCollapsed,
  removeAllListeners,
}
