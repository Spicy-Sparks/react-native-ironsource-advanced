#import <IronSource/IronSource.h>
#import <React/RCTEventEmitter.h>

#ifdef RCT_NEW_ARCH_ENABLED
#import "RNIronsourceAdvancedSpec.h"

@interface IronsourceOfferwall : RCTEventEmitter <NativeIronsourceAdvancedSpec, ISOfferwallDelegate>
#else
#import <React/RCTBridgeModule.h>

@interface IronsourceOfferwall : RCTEventEmitter <RCTBridgeModule, ISOfferwallDelegate>
#endif

@end
