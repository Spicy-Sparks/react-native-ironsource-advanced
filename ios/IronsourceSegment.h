#import <React/RCTEventEmitter.h>

#ifdef RCT_NEW_ARCH_ENABLED
#import "RNIronsourceAdvancedSpec.h"

@interface IronsourceSegment : NSObject <NativeIronsourceAdvancedSpec>
#else
#import <React/RCTBridgeModule.h>

@interface IronsourceSegment : NSObject <RCTBridgeModule>
#endif

@end
