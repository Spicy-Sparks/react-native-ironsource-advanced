import { NativeEventEmitter, NativeModules } from 'react-native'

const ON_INIT_COMPLETED = 'INIT_COMPLETED'
const ON_IMPRESSION_SUCCEED = 'IMPRESSION_DATA_SUCCEED'

const { IronsourceAdvanced } = NativeModules
const eventEmitter = new NativeEventEmitter(IronsourceAdvanced)

interface InitOptions {
  validateIntegration?: boolean
}

const init = (appKey: string, options: InitOptions = {}): Promise<void> => {
  return IronsourceAdvanced.init(appKey, [], options)
}

export type AdUnit = 'REWARDED_VIDEO' | 'INTERSTITIAL' | 'OFFERWALL' | 'BANNER'

const initWithAdUnits = (appKey: string, adUnits: Array<AdUnit>, options: InitOptions = {}): Promise<void> => {
  return IronsourceAdvanced.init(appKey, adUnits, options)
}

const onInitCompleted = {
  setListener: (listener: () => void) => {
    eventEmitter.removeAllListeners(ON_INIT_COMPLETED)
    eventEmitter.addListener(ON_INIT_COMPLETED, listener)
  },
  removeListener: () => eventEmitter.removeAllListeners(ON_INIT_COMPLETED)
}

const onImpressionSucceed = {
  setListener: (listener: (data: {
    auctionId?: string,
    adUnit?: string,
    country?: string,
    ab?: string,
    segmentName?: string,
    placement?: string,
    adNetwork?: string,
    instanceName?: string,
    instanceId?: string,
    revenue?: number,
    precision?: string,
    lifetimeRevenue?: number,
    encryptedCPM?: string
  }) => any) => {
    eventEmitter.removeAllListeners(ON_IMPRESSION_SUCCEED)
    eventEmitter.addListener(ON_IMPRESSION_SUCCEED, listener)
  },
  removeListener: () => eventEmitter.removeAllListeners(ON_IMPRESSION_SUCCEED)
}

const addImpressionDataDelegate = () => IronsourceAdvanced.addImpressionDataDelegate()

const setConsent = (consent: boolean) => IronsourceAdvanced.setConsent(consent)

const setUserId = (userId: string) => IronsourceAdvanced.setUserId(userId)

const setDynamicUserId = (userId: string) => IronsourceAdvanced.setDynamicUserId(userId)

const getAdvertiserId = (): Promise<string> => IronsourceAdvanced.getAdvertiserId()

const removeAllListeners = () => {
  onInitCompleted.removeListener()
  onImpressionSucceed.removeListener()
}

export default {
  init,
  initWithAdUnits,
  onInitCompleted,
  onImpressionSucceed,
  addImpressionDataDelegate,
  setConsent,
  setUserId,
  setDynamicUserId,
  getAdvertiserId,
  removeAllListeners,
}
