#import <IronSource/IronSource.h>
#import <React/RCTEventEmitter.h>

#ifdef RCT_NEW_ARCH_ENABLED
#import "RNIronsourceAdvancedSpec.h"

@interface IronsourceBanner : RCTEventEmitter <NativeIronsourceAdvancedSpec, LPMBannerAdViewDelegate>
#else
#import <React/RCTBridgeModule.h>

@interface IronsourceBanner : RCTEventEmitter <RCTBridgeModule, LPMBannerAdViewDelegate>
#endif

@property (class, nonatomic, strong) LPMBannerAdView *bannerView;

@end
