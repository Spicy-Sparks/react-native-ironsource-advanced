import { NativeEventEmitter, NativeModules } from 'react-native';

const { IronsourceInterstitial } = NativeModules;
const eventEmitter = new NativeEventEmitter(IronsourceInterstitial);

const ON_INTERSTITIAL_LOADED = 'INTERSTITIAL_LOADED';
const ON_INTERSTITIAL_SHOWN = 'INTERSTITIAL_SHOWN';
const ON_INTERSTITIAL_FAILED_TO_SHOW = 'INTERSTITIAL_FAILED_TO_SHOW';
const ON_INTERSTITIAL_FAILED_TO_LOAD = 'INTERSTITIAL_FAILED_TO_LOAD';
const ON_INTERSTITIAL_CLICKED = 'INTERSTITIAL_CLICKED';
const ON_INTERSTITIAL_CLOSED = 'INTERSTITIAL_CLOSED';
const ON_INTERSTITIAL_OPENED = 'INTERSTITIAL_OPENED';

const load = () => IronsourceInterstitial.loadInterstitial();

const show = (placementName: string) =>
  IronsourceInterstitial.showInterstitial(placementName);

const isAvailable = (): Promise<boolean> =>
  IronsourceInterstitial.isInterstitialAvailable();

const onLoaded = {
  setListener: (listener: () => void) => {
    eventEmitter.removeAllListeners(ON_INTERSTITIAL_LOADED);
    eventEmitter.addListener(ON_INTERSTITIAL_LOADED, listener);
  },
  removeListener: () => eventEmitter.removeAllListeners(ON_INTERSTITIAL_LOADED),
};

const onShown = {
  setListener: (listener: () => void) => {
    eventEmitter.removeAllListeners(ON_INTERSTITIAL_SHOWN);
    eventEmitter.addListener(ON_INTERSTITIAL_SHOWN, listener);
  },
  removeListener: () => eventEmitter.removeAllListeners(ON_INTERSTITIAL_SHOWN),
};

const onFailedToShow = {
  setListener: (listener: (error: string) => void) => {
    eventEmitter.removeAllListeners(ON_INTERSTITIAL_FAILED_TO_SHOW);
    eventEmitter.addListener(ON_INTERSTITIAL_FAILED_TO_SHOW, listener);
  },
  removeListener: () =>
    eventEmitter.removeAllListeners(ON_INTERSTITIAL_FAILED_TO_SHOW),
};

const onFailedToLoad = {
  setListener: (listener: (error: string) => void) => {
    eventEmitter.removeAllListeners(ON_INTERSTITIAL_FAILED_TO_LOAD);
    eventEmitter.addListener(ON_INTERSTITIAL_FAILED_TO_LOAD, listener);
  },
  removeListener: () =>
    eventEmitter.removeAllListeners(ON_INTERSTITIAL_FAILED_TO_LOAD),
};

const onClicked = {
  setListener: (listener: () => void) => {
    eventEmitter.removeAllListeners(ON_INTERSTITIAL_CLICKED);
    eventEmitter.addListener(ON_INTERSTITIAL_CLICKED, listener);
  },
  removeListener: () =>
    eventEmitter.removeAllListeners(ON_INTERSTITIAL_CLICKED),
};

const onOpened = {
  setListener: (listener: () => void) => {
    eventEmitter.removeAllListeners(ON_INTERSTITIAL_OPENED);
    eventEmitter.addListener(ON_INTERSTITIAL_OPENED, listener);
  },
  removeListener: () => eventEmitter.removeAllListeners(ON_INTERSTITIAL_OPENED),
};

const onClosed = {
  setListener: (listener: () => void) => {
    eventEmitter.removeAllListeners(ON_INTERSTITIAL_CLOSED);
    eventEmitter.addListener(ON_INTERSTITIAL_CLOSED, listener);
  },
  removeListener: () => eventEmitter.removeAllListeners(ON_INTERSTITIAL_CLOSED),
};

const removeAllListeners = () => {
  onLoaded.removeListener();
  onShown.removeListener();
  onFailedToShow.removeListener();
  onFailedToLoad.removeListener();
  onClicked.removeListener();
  onOpened.removeListener();
  onClosed.removeListener();
};

export default {
  load,
  show,
  isAvailable,
  onLoaded,
  onShown,
  onFailedToShow,
  onFailedToLoad,
  onClicked,
  onOpened,
  onClosed,
  removeAllListeners,
};
