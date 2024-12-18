#import <IronSource/IronSource.h>
#import <React/RCTEventEmitter.h>
#import "generated/RNIronsourceAdvancedSpec/RNIronsourceAdvancedSpec.h"

@interface IronsourceBanner : RCTEventEmitter <NativeIronsourceAdvancedSpec, LPMBannerAdViewDelegate>

@property (class, nonatomic, strong) LPMBannerAdView *bannerView;

@end