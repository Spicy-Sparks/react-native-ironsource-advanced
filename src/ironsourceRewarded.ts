import { NativeEventEmitter, NativeModules } from 'react-native'

const { IronsourceRewarded } = NativeModules
const eventEmitter = new NativeEventEmitter(IronsourceRewarded)

const ON_REWARDED_AVAILABLE = 'REWARDED_AVAILABLE'
const ON_REWARDED_UNAVAILABLE = 'REWARDED_UNAVAILABLE'
const ON_REWARDED_GOT_REWARD = 'REWARDED_GOT_REWARD'
const ON_REWARDED_FAILED_TO_SHOW = 'REWARDED_FAILED_TO_SHOW'
const ON_REWARDED_OPENED = 'REWARDED_OPENED'
const ON_REWARDED_CLOSED = 'REWARDED_CLOSED'
const ON_REWARDED_CLICKED = 'REWARDED_CLICKED'

const load = () => IronsourceRewarded.loadRewardedVideo()

const show = (placementName: string) =>
  IronsourceRewarded.showRewardedVideo(placementName)

const isAvailable = (): Promise<boolean> =>
  IronsourceRewarded.isRewardedVideoAvailable()

const onAvailable = {
  setListener: (listener: () => void) => {
    eventEmitter.removeAllListeners(ON_REWARDED_AVAILABLE)
    eventEmitter.addListener(ON_REWARDED_AVAILABLE, listener)
  },
  removeListener: () => eventEmitter.removeAllListeners(ON_REWARDED_AVAILABLE),
}

const onUnavailable = {
  setListener: (listener: () => void) => {
    eventEmitter.removeAllListeners(ON_REWARDED_UNAVAILABLE)
    eventEmitter.addListener(ON_REWARDED_UNAVAILABLE, listener)
  },
  removeListener: () =>
    eventEmitter.removeAllListeners(ON_REWARDED_UNAVAILABLE),
}

const onGotReward = {
  setListener: (
    listener: (reward: {
      placementName: string
      rewardName: string
      rewardAmount: number
    }) => void
  ) => {
    eventEmitter.removeAllListeners(ON_REWARDED_GOT_REWARD)
    eventEmitter.addListener(ON_REWARDED_GOT_REWARD, listener)
  },
  removeListener: () => eventEmitter.removeAllListeners(ON_REWARDED_GOT_REWARD),
}

const onFailedToShow = {
  setListener: (listener: (error: string) => void) => {
    eventEmitter.removeAllListeners(ON_REWARDED_FAILED_TO_SHOW)
    eventEmitter.addListener(ON_REWARDED_FAILED_TO_SHOW, listener)
  },
  removeListener: () =>
    eventEmitter.removeAllListeners(ON_REWARDED_FAILED_TO_SHOW),
}

const onOpened = {
  setListener: (listener: (error: string) => void) => {
    eventEmitter.removeAllListeners(ON_REWARDED_OPENED)
    eventEmitter.addListener(ON_REWARDED_OPENED, listener)
  },
  removeListener: () => eventEmitter.removeAllListeners(ON_REWARDED_OPENED),
}

const onClosed = {
  setListener: (listener: (error: string) => void) => {
    eventEmitter.removeAllListeners(ON_REWARDED_CLOSED)
    eventEmitter.addListener(ON_REWARDED_CLOSED, listener)
  },
  removeListener: () => eventEmitter.removeAllListeners(ON_REWARDED_CLOSED),
}

const onClicked = {
  setListener: (listener: (error: string) => void) => {
    eventEmitter.removeAllListeners(ON_REWARDED_CLICKED)
    eventEmitter.addListener(ON_REWARDED_CLICKED, listener)
  },
  removeListener: () => eventEmitter.removeAllListeners(ON_REWARDED_CLICKED),
}

const removeAllListeners = () => {
  onAvailable.removeListener()
  onUnavailable.removeListener()
  onGotReward.removeListener()
  onFailedToShow.removeListener()
  onOpened.removeListener()
  onClosed.removeListener()
  onClicked.removeListener()
}

export default {
  load,
  show,
  isAvailable,
  onAvailable,
  onUnavailable,
  onGotReward,
  onFailedToShow,
  onOpened,
  onClosed,
  onClicked,
  removeAllListeners,
}
