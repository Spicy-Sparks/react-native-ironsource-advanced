#import "IronsourceRewarded.h"
#import "RCTUtils.h"

#pragma mark - Constants

NSString *const kIronSourceRewardedVideoAvailable = @"REWARDED_AVAILABLE";
NSString *const kIronSourceRewardedVideoUnavailable = @"REWARDED_UNAVAILABLE";
NSString *const kIronSourceRewardedVideoAdRewarded = @"REWARDED_GOT_REWARD";
NSString *const kIronSourceRewardedVideoFailedToShow = @"REWARDED_FAILED_TO_SHOW";
NSString *const kIronSourceRewardedVideoDidOpened = @"REWARDED_OPENED";
NSString *const kIronSourceRewardedVideoAdClosed = @"REWARDED_CLOSED";
NSString *const kIronSourceRewardedVideoAdClicked = @"REWARDED_CLICKED";

@implementation IronsourceRewarded

#pragma mark - Module Registration

RCT_EXPORT_MODULE()

#pragma mark - Supported Events

- (NSArray<NSString *> *)supportedEvents {
    return @[
        kIronSourceRewardedVideoAvailable,
        kIronSourceRewardedVideoUnavailable,
        kIronSourceRewardedVideoAdRewarded,
        kIronSourceRewardedVideoFailedToShow,
        kIronSourceRewardedVideoDidOpened,
        kIronSourceRewardedVideoAdClosed,
        kIronSourceRewardedVideoAdClicked
    ];
}

#pragma mark - Rewarded Video Methods

- (void)loadRewardedVideo {
    [IronSource setLevelPlayRewardedVideoDelegate:self];
    [IronSource loadRewardedVideo];
}

- (void)showRewardedVideo:(NSString *)placementName {
    if ([IronSource hasRewardedVideo]) {
        [self sendEventWithName:kIronSourceRewardedVideoAvailable body:nil];
        dispatch_async(dispatch_get_main_queue(), ^{
            [IronSource showRewardedVideoWithViewController:RCTPresentedViewController()
                                                  placement:placementName];
        });
    } else {
        [self sendEventWithName:kIronSourceRewardedVideoUnavailable body:nil];
    }
}

- (void)isRewardedVideoAvailable:(RCTPromiseResolveBlock)resolve reject:(RCTPromiseRejectBlock)reject {
    @try {
        resolve(@([IronSource hasRewardedVideo]));
    } @catch (NSException *exception) {
        reject(@"E_REWARDED_VIDEO_AVAILABLE", exception.reason, nil);
    }
}

#pragma mark - LevelPlayRewardedVideoDelegate Methods

- (void)hasAvailableAdWithAdInfo:(ISAdInfo *)adInfo {
    [self sendEventWithName:kIronSourceRewardedVideoAvailable body:nil];
}

- (void)hasNoAvailableAd {
    [self sendEventWithName:kIronSourceRewardedVideoUnavailable body:nil];
}

- (void)didReceiveRewardForPlacement:(ISPlacementInfo *)placementInfo withAdInfo:(ISAdInfo *)adInfo {
    NSMutableDictionary *args = [NSMutableDictionary new];
    args[@"placementName"] = placementInfo.placementName ?: @"";
    args[@"rewardName"] = placementInfo.rewardName ?: @"";
    args[@"rewardAmount"] = placementInfo.rewardAmount ?: @(0);
    [self sendEventWithName:kIronSourceRewardedVideoAdRewarded body:args];
}

- (void)didFailToShowWithError:(NSError *)error andAdInfo:(ISAdInfo *)adInfo {
    NSMutableDictionary *args = [NSMutableDictionary new];
    args[@"errorCode"] = error ? @(error.code) : @(0);
    args[@"message"] = error.userInfo[NSLocalizedDescriptionKey] ?: @"";
    [self sendEventWithName:kIronSourceRewardedVideoFailedToShow body:args];
}

- (void)didOpenWithAdInfo:(ISAdInfo *)adInfo {
    [self sendEventWithName:kIronSourceRewardedVideoDidOpened body:nil];
}

- (void)didCloseWithAdInfo:(ISAdInfo *)adInfo {
    [self sendEventWithName:kIronSourceRewardedVideoAdClosed body:nil];
}

- (void)didClick:(ISPlacementInfo *)placementInfo withAdInfo:(ISAdInfo *)adInfo {
    [self sendEventWithName:kIronSourceRewardedVideoAdClicked body:nil];
}

- (std::shared_ptr<facebook::react::TurboModule>)getTurboModule:
    (const facebook::react::ObjCTurboModule::InitParams &)params
{
    return std::make_shared<facebook::react::NativeIronsourceAdvancedSpecJSI>(params);
}

@end