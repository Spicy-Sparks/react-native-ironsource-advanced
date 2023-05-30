import { NativeEventEmitter, NativeModules } from 'react-native'

const { IronsourceOfferwall } = NativeModules
const eventEmitter = new NativeEventEmitter(IronsourceOfferwall)

const ON_OFFERWALL_AVAILABLE = 'OFFERWALL_AVAILABLE'
const ON_OFFERWALL_UNAVAILABLE = 'OFFERWALL_UNAVAILABLE'
const ON_OFFERWALL_SHOWN = 'OFFERWALL_SHOWN'
const ON_OFFERWALL_FAILED_TO_SHOW = 'OFFERWALL_FAILED_TO_SHOW'
const ON_OFFERWALL_CLOSED = 'OFFERWALL_CLOSED'
const ON_OFFERWALL_RECEIVED_CREDITS = 'OFFERWALL_RECEIVED_CREDITS'
const ON_OFFERWALL_FAILED_TO_RECEIVE_CREDITS =
  'OFFERWALL_FAILED_TO_RECEIVE_CREDITS'

const show = (placementName: string) =>
  IronsourceOfferwall.showOfferwall(placementName)

const isAvailable = (): Promise<boolean> =>
  IronsourceOfferwall.isOfferwallAvailable()

const onAvailable = {
  setListener: (listener: () => void) => {
    eventEmitter.removeAllListeners(ON_OFFERWALL_AVAILABLE)
    eventEmitter.addListener(ON_OFFERWALL_AVAILABLE, listener)
  },
  removeListener: () => eventEmitter.removeAllListeners(ON_OFFERWALL_AVAILABLE),
}

const onUnavailable = {
  setListener: (listener: () => void) => {
    eventEmitter.removeAllListeners(ON_OFFERWALL_UNAVAILABLE)
    eventEmitter.addListener(ON_OFFERWALL_UNAVAILABLE, listener)
  },
  removeListener: () =>
    eventEmitter.removeAllListeners(ON_OFFERWALL_UNAVAILABLE),
}

const onShown = {
  setListener: (listener: () => void) => {
    eventEmitter.removeAllListeners(ON_OFFERWALL_SHOWN)
    eventEmitter.addListener(ON_OFFERWALL_SHOWN, listener)
  },
  removeListener: () => eventEmitter.removeAllListeners(ON_OFFERWALL_SHOWN),
}

const onFailedToShow = {
  setListener: (listener: (error: string) => void) => {
    eventEmitter.removeAllListeners(ON_OFFERWALL_FAILED_TO_SHOW)
    eventEmitter.addListener(ON_OFFERWALL_FAILED_TO_SHOW, listener)
  },
  removeListener: () =>
    eventEmitter.removeAllListeners(ON_OFFERWALL_FAILED_TO_SHOW),
}

const onClosed = {
  setListener: (listener: () => void) => {
    eventEmitter.removeAllListeners(ON_OFFERWALL_CLOSED)
    eventEmitter.addListener(ON_OFFERWALL_CLOSED, listener)
  },
  removeListener: () => eventEmitter.removeAllListeners(ON_OFFERWALL_CLOSED),
}

const onReceivedCredits = {
  setListener: (
    listener: (credits: {
      credits: number
      totalCredits: number
      totalCreditsFlag: boolean
    }) => void
  ) => {
    eventEmitter.removeAllListeners(ON_OFFERWALL_RECEIVED_CREDITS)
    eventEmitter.addListener(ON_OFFERWALL_RECEIVED_CREDITS, listener)
  },
  removeListener: () =>
    eventEmitter.removeAllListeners(ON_OFFERWALL_RECEIVED_CREDITS),
}

const onFailedToReceivedCredits = {
  setListener: (listener: (error: string) => void) => {
    eventEmitter.removeAllListeners(ON_OFFERWALL_FAILED_TO_RECEIVE_CREDITS)
    eventEmitter.addListener(ON_OFFERWALL_FAILED_TO_RECEIVE_CREDITS, listener)
  },
  removeListener: () =>
    eventEmitter.removeAllListeners(ON_OFFERWALL_FAILED_TO_RECEIVE_CREDITS),
}

const removeAllListeners = () => {
  onAvailable.removeListener()
  onUnavailable.removeListener()
  onShown.removeListener()
  onFailedToShow.removeListener()
  onClosed.removeListener()
  onReceivedCredits.removeListener()
  onFailedToReceivedCredits.removeListener()
}

export default {
  show,
  isAvailable,
  onAvailable,
  onUnavailable,
  onShown,
  onFailedToShow,
  onClosed,
  onReceivedCredits,
  onFailedToReceivedCredits,
  removeAllListeners,
}
