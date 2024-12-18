import { TurboModuleRegistry } from 'react-native';
import type { TurboModule } from 'react-native';

export interface Spec extends TurboModule {
  init(appKey: string, userId?: string): Promise<void>;
  setUserId(userId: string): void;
  addListener: (eventType: string) => void;
  removeListener: (eventType: string) => void;
  removeListeners: (count: number) => void;
}

const IronsourceAdQuality = TurboModuleRegistry.getEnforcing<Spec>('IronsourceAdQuality');

const ON_INIT_COMPLETED = 'INIT_COMPLETED';
const ON_INIT_FAILED = 'INIT_FAILED';

const init = (appKey: string, userId?: string): Promise<void> => {
  return IronsourceAdQuality?.init(appKey, userId);
};

const onInitCompleted = {
  setListener: (listener: () => void) => {
    IronsourceAdQuality.removeListener(ON_INIT_COMPLETED);
    IronsourceAdQuality.addListener(ON_INIT_COMPLETED, listener);
  },
  removeListener: () => IronsourceAdQuality.removeListener(ON_INIT_COMPLETED),
};

const onInitFailed = {
  setListener: (listener: () => void) => {
    IronsourceAdQuality.removeListener(ON_INIT_FAILED);
    IronsourceAdQuality.addListener(ON_INIT_FAILED, listener);
  },
  removeListener: () => IronsourceAdQuality.removeListener(ON_INIT_FAILED),
};

const setUserId = (userId: string) => IronsourceAdQuality?.setUserId(userId);

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
