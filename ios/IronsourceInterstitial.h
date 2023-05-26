#import <IronSource/IronSource.h>
#import <React/RCTEventEmitter.h>

#ifdef RCT_NEW_ARCH_ENABLED
#import "RNIronsourceAdvancedSpec.h"

@interface IronsourceInterstitial : RCTEventEmitter <NativeIronsourceAdvancedSpec, LevelPlayInterstitialDelegate>
#else
#import <React/RCTBridgeModule.h>

@interface IronsourceInterstitial : RCTEventEmitter <RCTBridgeModule, LevelPlayInterstitialDelegate>
#endif

@end
