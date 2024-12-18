import { NativeEventEmitter, NativeModules } from 'react-native';

const ON_INIT_COMPLETED = 'INIT_COMPLETED';
const ON_INIT_FAILED = 'INIT_FAILED';

const { IronsourceAdQuality } = NativeModules;
const eventEmitter = new NativeEventEmitter(IronsourceAdQuality);

const init = (appKey: string, userId?: string): Promise<void> => {
  return IronsourceAdQuality.init(appKey, userId);
};

const onInitCompleted = {
  setListener: (listener: () => void) => {
    eventEmitter.removeAllListeners(ON_INIT_COMPLETED);
    eventEmitter.addListener(ON_INIT_COMPLETED, listener);
  },
  removeListener: () => eventEmitter.removeAllListeners(ON_INIT_COMPLETED),
};

const onInitFailed = {
  setListener: (listener: () => void) => {
    eventEmitter.removeAllListeners(ON_INIT_FAILED);
    eventEmitter.addListener(ON_INIT_FAILED, listener);
  },
  removeListener: () => eventEmitter.removeAllListeners(ON_INIT_FAILED),
};

const setUserId = (userId: string) => IronsourceAdQuality.setUserId(userId);

const removeAllListeners = () => {
  onInitCompleted.removeListener();
  onInitFailed.removeListener();
};

export default {
  init,
  onInitCompleted,
  onInitFailed,
  setUserId,
  removeAllListeners,
};
