#import <Foundation/Foundation.h>
#import "IronsourceInterstitial.h"
#import "RCTUtils.h"

NSString *const kIronSourceInterstitialLoaded = @"INTERSTITIAL_LOADED";
NSString *const kIronSourceInterstitialShown = @"INTERSTITIAL_SHOWN";
NSString *const kIronSourceInterstitialFailedToShow = @"INTERSTITIAL_FAILED_TO_SHOW";
NSString *const kIronSourceInterstitialFailedToLoad = @"INTERSTITIAL_FAILED_TO_LOAD";
NSString *const kIronSourceInterstitialClicked = @"INTERSTITIAL_CLICKED";
NSString *const kIronSourceInterstitialClosed = @"INTERSTITIAL_CLOSED";
NSString *const kIronSourceInterstitialOpened = @"INTERSTITIAL_OPENED";

@implementation IronsourceInterstitial

RCT_EXPORT_MODULE()

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

RCT_EXPORT_METHOD(loadInterstitial)
{
    [IronSource setLevelPlayInterstitialDelegate:self];
    [IronSource loadInterstitial];
}

RCT_EXPORT_METHOD(showInterstitial:(NSString*) placementName)
{
    if ([IronSource hasInterstitial]) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [IronSource showInterstitialWithViewController:RCTPresentedViewController() placement:placementName];
        });
    }
    else {
        [self sendEventWithName:kIronSourceInterstitialFailedToLoad body:nil];
    }
}

RCT_EXPORT_METHOD(isInterstitialAvailable:(RCTPromiseResolveBlock)resolve reject:(RCTPromiseRejectBlock)reject)
{
    @try {
        resolve(@([IronSource hasInterstitial]));
    }
    @catch (NSException *exception) {
        reject(@"isInterstitialAvailable, Error, %@", exception.reason, nil);
    }
}

#pragma mark - ISInterstitialDelegate

- (void)didLoadWithAdInfo:(ISAdInfo *)adInfo {
    [self sendEventWithName:kIronSourceInterstitialLoaded body:nil];
}

- (void)didShowWithAdInfo:(ISAdInfo *)adInfo {
    [self sendEventWithName:kIronSourceInterstitialShown body:nil];
}

- (void)didFailToShowWithError:(NSError *)error andAdInfo:(ISAdInfo *)adInfo {
    [self sendEventWithName:kIronSourceInterstitialFailedToShow body:error.userInfo[@"NSLocalizedDescription"]];
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
    [self sendEventWithName:kIronSourceInterstitialFailedToLoad body:error.userInfo[@"NSLocalizedDescription"]];
}

@end
