#import <IronSource/IronSource.h>
#import <React/RCTEventEmitter.h>

#ifdef RCT_NEW_ARCH_ENABLED
#import "RNIronsourceAdvancedSpec.h"

@interface IronsourceBanner : RCTEventEmitter <NativeIronsourceAdvancedSpec, LevelPlayBannerDelegate>
#else
#import <React/RCTBridgeModule.h>

@interface IronsourceBanner : RCTEventEmitter <RCTBridgeModule, LevelPlayBannerDelegate>
#endif

@end
