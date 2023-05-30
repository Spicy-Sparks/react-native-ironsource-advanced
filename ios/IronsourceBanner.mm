#import <Foundation/Foundation.h>
#import "IronsourceBanner.h"
#import "RCTUtils.h"

NSString *const kIronSourceBannerLoaded = @"BANNER_LOADED";
NSString *const kIronSourceBannerFailedToLoad = @"BANNER_FAILED_TO_LOAD";
NSString *const kIronSourceBannerClicked = @"BANNER_CLICKED";
NSString *const kIronSourceBannerPresented = @"BANNER_PRESENTED";
NSString *const kIronSourceBannerLeft = @"BANNER_LEFT";
NSString *const kIronSourceBannerDismissed = @"BANNER_DISMISSED";

@implementation IronsourceBanner

RCT_EXPORT_MODULE()

- (NSArray<NSString *> *)supportedEvents {
    return @[
        kIronSourceBannerLoaded,
        kIronSourceBannerFailedToLoad,
        kIronSourceBannerClicked,
        kIronSourceBannerPresented,
        kIronSourceBannerLeft,
        kIronSourceBannerDismissed
    ];
}

RCT_EXPORT_METHOD(addEventsDelegate)
{
    [IronSource setLevelPlayBannerDelegate:self];
}

#pragma mark - Events

- (void)didLoad:(ISBannerView *)bannerView withAdInfo:(ISAdInfo *)adInfo {
    [self sendEventWithName:kIronSourceBannerLoaded body:nil];
}

- (void)didFailToLoadWithError:(NSError *)error {
    NSMutableDictionary *args = [[NSMutableDictionary alloc] init];
    if(error != nil) {
        args[@"errorCode"] = [NSNumber numberWithInteger: error.code];
    }
    if(error != nil && error.userInfo != nil) {
        args[@"message"] = error.userInfo[NSLocalizedDescriptionKey];
    }
    [self sendEventWithName:kIronSourceBannerFailedToLoad body:args];
}

- (void)didClickWithAdInfo:(ISAdInfo *)adInfo {
    [self sendEventWithName:kIronSourceBannerClicked body:nil];
}

- (void)didLeaveApplicationWithAdInfo:(ISAdInfo *)adInfo {
    [self sendEventWithName:kIronSourceBannerLeft body:nil];
}

- (void)didPresentScreenWithAdInfo:(ISAdInfo *)adInfo {
    [self sendEventWithName:kIronSourceBannerPresented body:nil];
}

- (void)didDismissScreenWithAdInfo:(ISAdInfo *)adInfo {
    [self sendEventWithName:kIronSourceBannerDismissed body:nil];
}

@end
