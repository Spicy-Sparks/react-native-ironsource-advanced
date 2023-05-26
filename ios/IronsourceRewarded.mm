#import "IronsourceRewarded.h"

#import "RCTUtils.h"

NSString *const kIronSourceRewardedVideoAvailable = @"REWARDED_AVAILABLE";
NSString *const kIronSourceRewardedVideoUnavailable = @"REWARDED_UNAVAILABLE";
NSString *const kIronSourceRewardedVideoAdRewarded = @"REWARDED_GOT_REWARD";
NSString *const kIronSourceRewardedVideoFailedToShow = @"REWARDED_FAILED_TO_SHOW";
NSString *const kIronSourceRewardedVideoDidOpened = @"REWARDED_OPENED";
NSString *const kIronSourceRewardedVideoAdClosed = @"REWARDED_CLOSED";
NSString *const kIronSourceRewardedVideoAdClicked = @"REWARDED_CLICKED";

@implementation IronsourceRewarded

- (dispatch_queue_t)methodQueue
{
    return dispatch_get_main_queue();
}

RCT_EXPORT_MODULE()

- (NSArray<NSString *> *)supportedEvents {
    return @[
        kIronSourceRewardedVideoAvailable,
        kIronSourceRewardedVideoUnavailable,
        kIronSourceRewardedVideoAdRewarded,
        kIronSourceRewardedVideoFailedToShow,
        kIronSourceRewardedVideoDidOpened,
        kIronSourceRewardedVideoAdClosed
    ];
}

RCT_EXPORT_METHOD(loadRewardedVideo)
{
    [IronSource setLevelPlayRewardedVideoDelegate:self];
    [IronSource loadRewardedVideo];
}

RCT_EXPORT_METHOD(showRewardedVideo:(NSString*)placementName)
{
    if ([IronSource hasRewardedVideo]) {
        [self sendEventWithName:kIronSourceRewardedVideoAvailable body:nil];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [IronSource showRewardedVideoWithViewController:RCTPresentedViewController() placement:placementName];
        });
    } else {
        [self sendEventWithName:kIronSourceRewardedVideoUnavailable body:nil];
    }
}

RCT_EXPORT_METHOD(isRewardedVideoAvailable:(RCTPromiseResolveBlock)resolve reject:(RCTPromiseRejectBlock)reject)
{
    @try {
        resolve(@([IronSource hasRewardedVideo]));
    }
    @catch (NSException *exception) {
        reject(@"isRewardedVideoAvailable, Error, %@", exception.reason, nil);
    }
}

#pragma mark delegate events

- (void)hasAvailableAdWithAdInfo:(ISAdInfo *)adInfo {
    [self sendEventWithName:kIronSourceRewardedVideoAvailable body:nil];
}

- (void)hasNoAvailableAd {
    [self sendEventWithName:kIronSourceRewardedVideoUnavailable body:nil];
}

- (void)didReceiveRewardForPlacement:(ISPlacementInfo *)placementInfo withAdInfo:(ISAdInfo *)adInfo {
    [self sendEventWithName:kIronSourceRewardedVideoAdRewarded body:@{
        @"placementName": [placementInfo placementName],
        @"rewardName": [placementInfo rewardName],
        @"rewardAmount": [placementInfo rewardAmount]
    }];
}

- (void)didFailToShowWithError:(NSError *)error andAdInfo:(ISAdInfo *)adInfo {
    [self sendEventWithName:kIronSourceRewardedVideoFailedToShow body:error.userInfo[@"NSLocalizedDescription"]];
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

@end
