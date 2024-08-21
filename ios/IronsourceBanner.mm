#import <Foundation/Foundation.h>
#import "IronsourceBanner.h"
#import "RCTUtils.h"

NSString *const kIronSourceBannerLoaded = @"BANNER_LOADED";
NSString *const kIronSourceBannerFailedToLoad = @"BANNER_FAILED_TO_LOAD";
NSString *const kIronSourceBannerClicked = @"BANNER_CLICKED";
NSString *const kIronSourceBannerPresented = @"BANNER_PRESENTED";
NSString *const kIronSourceBannerLeft = @"BANNER_LEFT";
NSString *const kIronSourceBannerExpanded = @"BANNER_EXPANDED";
NSString *const kIronSourceBannerCollapsed = @"BANNER_COLLAPSED";

@implementation IronsourceBanner

RCT_EXPORT_MODULE()

- (NSArray<NSString *> *)supportedEvents {
    return @[
        kIronSourceBannerLoaded,
        kIronSourceBannerFailedToLoad,
        kIronSourceBannerClicked,
        kIronSourceBannerPresented,
        kIronSourceBannerLeft,
        kIronSourceBannerExpanded,
        kIronSourceBannerCollapsed
    ];
}

RCT_EXPORT_METHOD(addEventsDelegate)
{
    // Create the ad size
    LPMAdSize *bannerSize = [LPMAdSize bannerSize];
    
    // Create the banner ad view object with required & optional params
    _bannerView = [[LPMBannerAdView alloc] initWithAdUnitId:@"adUnitId"];
    [_bannerView setPlacementName:@"PlacementName"];
    [_bannerView setAdSize:bannerSize];
    
    // See delegate implementation
    [_bannerView setDelegate:self];
}

static LPMBannerAdView *_bannerView = nil;

+ (LPMBannerAdView *)bannerView {
    return _bannerView;
}

+ (void)setBannerView:(LPMBannerAdView *)value {
    _bannerView = value;
}

#pragma mark - Events

#define BannerLoaded @"BannerLoaded"

- (void)didLoadAdWithAdInfo:(nonnull LPMAdInfo *)adInfo {
    _bannerView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin |
                               UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
    [self sendEventWithName:kIronSourceBannerLoaded body:nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:BannerLoaded object:nil userInfo:nil];
}

- (void)didFailToLoadAdWithAdUnitId:(nonnull NSString *)adUnitId error:(nonnull NSError *)error {
    NSMutableDictionary *args = [[NSMutableDictionary alloc] init];
    if(error != nil) {
        args[@"errorCode"] = [NSNumber numberWithInteger: error.code];
    }
    if(error != nil && error.userInfo != nil) {
        args[@"message"] = error.userInfo[NSLocalizedDescriptionKey];
    }
    [self sendEventWithName:kIronSourceBannerFailedToLoad body:args];
}

- (void)didClickAdWithAdInfo:(LPMAdInfo *)adInfo {
    [self sendEventWithName:kIronSourceBannerClicked body:nil];
}

- (void)didDisplayAdWithAdInfo:(LPMAdInfo *)adInfo {
    [self sendEventWithName:kIronSourceBannerPresented body:nil];
}

- (void)didFailToDisplayAdWithAdInfo:(LPMAdInfo *)adInfo error:(NSError *)error {
    NSMutableDictionary *args = [[NSMutableDictionary alloc] init];
    if(error != nil) {
        args[@"errorCode"] = [NSNumber numberWithInteger: error.code];
    }
    if(error != nil && error.userInfo != nil) {
        args[@"message"] = error.userInfo[NSLocalizedDescriptionKey];
    }
    [self sendEventWithName:kIronSourceBannerFailedToLoad body:args];
}

- (void)didLeaveAppWithAdInfo:(LPMAdInfo *)adInfo {
    [self sendEventWithName:kIronSourceBannerLeft body:nil];
}

- (void)didExpandAdWithAdInfo:(LPMAdInfo *)adInfo {
    [self sendEventWithName:kIronSourceBannerExpanded body:nil];
}

- (void)didCollapseAdWithAdInfo:(LPMAdInfo *)adInfo {
    [self sendEventWithName:kIronSourceBannerCollapsed body:nil];
}

@end
