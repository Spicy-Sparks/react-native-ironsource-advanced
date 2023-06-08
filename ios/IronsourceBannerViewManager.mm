#import "IronsourceBannerViewManager.h"
#import "IronsourceBanner.h"
#import <IronSource/IronSource.h>
#import <React/RCTViewManager.h>
#import "IronsourceBannerView.h"

@implementation IronsourceBannerViewManager

RCT_EXPORT_MODULE(IronsourceBannerViewManager)
    
- (UIView *)view {
    return [[IronsourceBannerView alloc] init];
}

@end
