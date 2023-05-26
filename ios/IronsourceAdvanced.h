#import <IronSource/IronSource.h>
#import <React/RCTEventEmitter.h>

#ifdef RCT_NEW_ARCH_ENABLED
#import "RNIronsourceAdvancedSpec.h"

@interface IronsourceAdvanced : RCTEventEmitter <NativeIronsourceAdvancedSpec, ISImpressionDataDelegate, ISInitializationDelegate>
#else
#import <React/RCTBridgeModule.h>

@interface IronsourceAdvanced : RCTEventEmitter <RCTBridgeModule, ISImpressionDataDelegate, ISInitializationDelegate>
#endif

@end
