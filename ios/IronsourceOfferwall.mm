#import "IronsourceOfferwall.h"
#import "RCTUtils.h"

NSString *const kIronSourceOfferwallAvailable = @"OFFERWALL_AVAILABLE";
NSString *const kIronSourceOfferwallUnavailable = @"OFFERWALL_UNAVAILABLE";
NSString *const kIronSourceOfferwallShown = @"OFFERWALL_SHOWN";
NSString *const kIronSourceOfferwallFailedToShow = @"OFFERWALL_FAILED_TO_SHOW";
NSString *const kIronSourceOfferwallClosed = @"OFFERWALL_CLOSED";
NSString *const kIronSourceOfferwallReceivedCredits = @"OFFERWALL_RECEIVED_CREDITS";
NSString *const kIronSourceOfferwallFailedToReceiveCredits = @"OFFERWALL_FAILED_TO_RECEIVE_CREDITS";

@implementation IronsourceOfferwall

- (dispatch_queue_t)methodQueue
{
    return dispatch_get_main_queue();
}

RCT_EXPORT_MODULE()

- (NSArray<NSString *> *)supportedEvents {
    return @[
        kIronSourceOfferwallAvailable,
        kIronSourceOfferwallUnavailable,
        kIronSourceOfferwallShown,
        kIronSourceOfferwallFailedToShow,
        kIronSourceOfferwallClosed,
        kIronSourceOfferwallReceivedCredits,
        kIronSourceOfferwallFailedToReceiveCredits,
    ];
}

RCT_EXPORT_METHOD(showOfferwall:(NSString*) placementName)
{
    [IronSource setOfferwallDelegate:self];
    [ISSupersonicAdsConfiguration configurations].useClientSideCallbacks = [NSNumber numberWithInt:1];
    
    if ([IronSource hasOfferwall]) {
        [self sendEventWithName:kIronSourceOfferwallAvailable body:nil];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [IronSource showOfferwallWithViewController:RCTPresentedViewController() placement:placementName];
        });
    } else {
        [self sendEventWithName:kIronSourceOfferwallUnavailable body:nil];
    }
}

RCT_EXPORT_METHOD(isOfferwallAvailable:(RCTPromiseResolveBlock)resolve reject:(RCTPromiseRejectBlock)reject)
{
    @try {
        resolve(@([IronSource hasOfferwall]));
    }
    @catch (NSException *exception) {
        reject(@"isOfferwallAvailable, Error, %@", exception.reason, nil);
    }
}

#pragma mark delegate events

#pragma mark - ISOfferwallDelegate

- (void)offerwallHasChangedAvailability:(BOOL)available {
    if(available == YES) {
        [self sendEventWithName:kIronSourceOfferwallAvailable body:nil];
    }
    else {
        [self sendEventWithName:kIronSourceOfferwallUnavailable body:nil];
    }
}

- (void)offerwallDidShow {
    [self sendEventWithName:kIronSourceOfferwallShown body:nil];
}

- (void)offerwallDidFailToShowWithError:(NSError *)error {
    [self sendEventWithName:kIronSourceOfferwallFailedToShow body:error.userInfo[@"NSLocalizedDescription"]];
}

- (void)offerwallDidClose {
    [self sendEventWithName:kIronSourceOfferwallClosed body:nil];
}

- (BOOL)didReceiveOfferwallCredits:(NSDictionary *)creditInfo {
    [self sendEventWithName:kIronSourceOfferwallReceivedCredits body:creditInfo];
    return YES;
}

- (void)didFailToReceiveOfferwallCreditsWithError:(NSError *)error {
    [self sendEventWithName:kIronSourceOfferwallFailedToReceiveCredits body:error.userInfo[@"NSLocalizedDescription"]];
}

@end
