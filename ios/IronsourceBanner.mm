#import "IronsourceBanner.h"
#import "RCTUtils.h"

#pragma mark - Constants

NSString *const kIronSourceBannerLoaded = @"BANNER_LOADED";
NSString *const kIronSourceBannerFailedToLoad = @"BANNER_FAILED_TO_LOAD";
NSString *const kIronSourceBannerClicked = @"BANNER_CLICKED";
NSString *const kIronSourceBannerPresented = @"BANNER_PRESENTED";
NSString *const kIronSourceBannerLeft = @"BANNER_LEFT";
NSString *const kIronSourceBannerExpanded = @"BANNER_EXPANDED";
NSString *const kIronSourceBannerCollapsed = @"BANNER_COLLAPSED";

@implementation IronsourceBanner

#pragma mark - Module Registration

RCT_EXPORT_MODULE()

#pragma mark - Supported Events

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

#pragma mark - Banner View Configuration

static LPMBannerAdView *_bannerView = nil;

+ (LPMBannerAdView *)bannerView {
    return _bannerView;
}

+ (void)setBannerView:(LPMBannerAdView *)value {
    _bannerView = value;
}

- (void)addEventsDelegate:(NSString *)adUnit placementName:(NSString *)placementName {
    LPMAdSize *bannerSize = [LPMAdSize bannerSize];
    
    _bannerView = [[LPMBannerAdView alloc] initWithAdUnitId:adUnit];
    [_bannerView setAdSize:bannerSize];
    [_bannerView setDelegate:self];
}

#pragma mark - Events Handling

- (void)didLoadAdWithAdInfo:(LPMAdInfo *)adInfo {
    _bannerView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin |
                                   UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
    [self sendEventWithName:kIronSourceBannerLoaded body:nil];
}

- (void)didFailToLoadAdWithAdUnitId:(NSString *)adUnitId error:(NSError *)error {
    NSMutableDictionary *args = [NSMutableDictionary new];
    if (error) {
        args[@"errorCode"] = @(error.code);
        args[@"message"] = error.userInfo[NSLocalizedDescriptionKey] ?: @"";
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
    NSMutableDictionary *args = [NSMutableDictionary new];
    if (error) {
        args[@"errorCode"] = @(error.code);
        args[@"message"] = error.userInfo[NSLocalizedDescriptionKey] ?: @"";
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

#pragma mark - TurboModule Integration

- (std::shared_ptr<facebook::react::TurboModule>)getTurboModule:
    (const facebook::react::ObjCTurboModule::InitParams &)params {
    return std::make_shared<facebook::react::NativeIronsourceAdvancedSpecJSI>(params);
}

@end