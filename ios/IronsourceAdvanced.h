
#ifdef RCT_NEW_ARCH_ENABLED
#import "RNIronsourceAdvancedSpec.h"

@interface IronsourceAdvanced : NSObject <NativeIronsourceAdvancedSpec>
#else
#import <React/RCTBridgeModule.h>

@interface IronsourceAdvanced : NSObject <RCTBridgeModule>
#endif

@end
