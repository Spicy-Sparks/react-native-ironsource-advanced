#import <IronSourceAdQualitySDK/IronSourceAdQuality.h>
#import <React/RCTEventEmitter.h>

#ifdef RCT_NEW_ARCH_ENABLED

@interface IronsourceAdQuality : RCTEventEmitter <NativeIronsourceAdvancedSpec, ISAdQualityInitDelegate>
#else
#import <React/RCTBridgeModule.h>

@interface IronsourceAdQuality : RCTEventEmitter <RCTBridgeModule, ISAdQualityInitDelegate>
#endif

@end
