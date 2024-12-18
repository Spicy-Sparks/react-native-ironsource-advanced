#import "IronsourceInterstitial.h"
#import "RCTUtils.h"

#pragma mark - Constants

NSString *const kIronSourceInterstitialLoaded = @"INTERSTITIAL_LOADED";
NSString *const kIronSourceInterstitialShown = @"INTERSTITIAL_SHOWN";
NSString *const kIronSourceInterstitialFailedToShow = @"INTERSTITIAL_FAILED_TO_SHOW";
NSString *const kIronSourceInterstitialFailedToLoad = @"INTERSTITIAL_FAILED_TO_LOAD";
NSString *const kIronSourceInterstitialClicked = @"INTERSTITIAL_CLICKED";
NSString *const kIronSourceInterstitialClosed = @"INTERSTITIAL_CLOSED";
NSString *const kIronSourceInterstitialOpened = @"INTERSTITIAL_OPENED";

@implementation IronsourceInterstitial

#pragma mark - Module Registration

RCT_EXPORT_MODULE()

#pragma mark - Supported Events

- (NSArray<NSString *> *)supportedEvents {
    return @[
        kIronSourceInterstitialLoaded,
        kIronSourceInterstitialShown,
        kIronSourceInterstitialFailedToShow,
        kIronSourceInterstitialFailedToLoad,
        kIronSourceInterstitialClicked,
        kIronSourceInterstitialClosed,
        kIronSourceInterstitialOpened
    ];
}

#pragma mark - Interstitial Methods

- (void)loadInterstitial {
    [IronSource setLevelPlayInterstitialDelegate:self];
    [IronSource loadInterstitial];
}

- (void)showInterstitial:(NSString *)placementName {
    if ([IronSource hasInterstitial]) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [IronSource showInterstitialWithViewController:RCTPresentedViewController()
                                                 placement:placementName];
        });
    } else {
        [self sendEventWithName:kIronSourceInterstitialFailedToLoad body:@{ @"message": @"Interstitial not available" }];
    }
}

- (void)isInterstitialAvailable:(RCTPromiseResolveBlock)resolve reject:(RCTPromiseRejectBlock)reject {
    @try {
        resolve(@([IronSource hasInterstitial]));
    } @catch (NSException *exception) {
        reject(@"E_IS_INTERSTITIAL", exception.reason, nil);
    }
}

#pragma mark - LevelPlayInterstitialDelegate

- (void)didLoadWithAdInfo:(ISAdInfo *)adInfo {
    [self sendEventWithName:kIronSourceInterstitialLoaded body:nil];
}

- (void)didShowWithAdInfo:(ISAdInfo *)adInfo {
    [self sendEventWithName:kIronSourceInterstitialShown body:nil];
}

- (void)didFailToShowWithError:(NSError *)error andAdInfo:(ISAdInfo *)adInfo {
    NSMutableDictionary *args = [NSMutableDictionary new];
    args[@"errorCode"] = error ? @(error.code) : @(0);
    args[@"message"] = error.userInfo[NSLocalizedDescriptionKey] ?: @"";
    [self sendEventWithName:kIronSourceInterstitialFailedToShow body:args];
}

- (void)didClickWithAdInfo:(ISAdInfo *)adInfo {
    [self sendEventWithName:kIronSourceInterstitialClicked body:nil];
}

- (void)didCloseWithAdInfo:(ISAdInfo *)adInfo {
    [self sendEventWithName:kIronSourceInterstitialClosed body:nil];
}

- (void)didOpenWithAdInfo:(ISAdInfo *)adInfo {
    [self sendEventWithName:kIronSourceInterstitialOpened body:nil];
}

- (void)didFailToLoadWithError:(NSError *)error {
    NSMutableDictionary *args = [NSMutableDictionary new];
    args[@"errorCode"] = error ? @(error.code) : @(0);
    args[@"message"] = error.userInfo[NSLocalizedDescriptionKey] ?: @"";
    [self sendEventWithName:kIronSourceInterstitialFailedToLoad body:args];
}

- (std::shared_ptr<facebook::react::TurboModule>)getTurboModule:
    (const facebook::react::ObjCTurboModule::InitParams &)params
{
    return std::make_shared<facebook::react::NativeIronsourceAdvancedSpecJSI>(params);
}

@end