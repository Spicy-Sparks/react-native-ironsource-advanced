#import "IronsourceBannerViewManager.h"
#import "IronsourceBannerView.h"
#import <IronSource/IronSource.h>

@implementation IronsourceBannerViewManager

RCT_EXPORT_MODULE(IronsourceBannerViewManager)

- (UIView *)view {
    return [[IronsourceBannerView alloc] init];
}

@end