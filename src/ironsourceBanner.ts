import { NativeEventEmitter, NativeModules } from 'react-native'

const { IronsourceBanner } = NativeModules
const eventEmitter = new NativeEventEmitter(IronsourceBanner)

const ON_BANNER_LOADED = 'BANNER_LOADED'
const ON_BANNER_FAILED_TO_LOAD = 'BANNER_FAILED_TO_LOAD'
const ON_BANNER_CLICKED = 'BANNER_CLICKED'
const ON_BANNER_PRESENTED = 'BANNER_PRESENTED'
const ON_BANNER_LEFT = 'BANNER_LEFT'
const ON_BANNER_DISMISSED = 'BANNER_DISMISSED'

const init = () => IronsourceBanner.addEventsDelegate()

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

const onDismissed = {
  setListener: (listener: () => void) => {
    eventEmitter.removeAllListeners(ON_BANNER_DISMISSED)
    eventEmitter.addListener(ON_BANNER_DISMISSED, listener)
  },
  removeListener: () => eventEmitter.removeAllListeners(ON_BANNER_DISMISSED),
}

const removeAllListeners = () => {
  onLoaded.removeListener()
  onFailedToLoad.removeListener()
  onClicked.removeListener()
  onPresented.removeListener()
  onLeft.removeListener()
  onDismissed.removeListener()
}

export default {
  init,
  onLoaded,
  onFailedToLoad,
  onClicked,
  onPresented,
  onLeft,
  onDismissed,
  removeAllListeners,
}
