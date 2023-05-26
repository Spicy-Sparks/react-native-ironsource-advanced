#import <IronSource/IronSource.h>
#import <React/RCTEventEmitter.h>

#ifdef RCT_NEW_ARCH_ENABLED
#import "RNIronsourceAdvancedSpec.h"

@interface IronsourceRewarded : RCTEventEmitter <NativeIronsourceAdvancedSpec, LevelPlayRewardedVideoDelegate>
#else
#import <React/RCTBridgeModule.h>

@interface IronsourceRewarded : RCTEventEmitter <RCTBridgeModule, LevelPlayRewardedVideoDelegate>
#endif

@end
