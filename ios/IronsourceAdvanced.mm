#import "IronsourceAdvanced.h"
#import <IronSource/IronSource.h>

#pragma mark - Constants
NSString *const REWARDED_VIDEO = @"REWARDED_VIDEO";
NSString *const INTERSTITIAL = @"INTERSTITIAL";
NSString *const BANNER = @"BANNER";

NSString *const kIronSourceInitializationCompleted = @"INIT_COMPLETED";
NSString *const kIronSourceImpressionDataDidSucceed = @"IMPRESSION_DATA_SUCCEED";

@implementation IronsourceAdvanced

#pragma mark - Module Registration

RCT_EXPORT_MODULE()

#pragma mark - Event Support

- (NSArray<NSString *> *)supportedEvents {
    return @[
        kIronSourceInitializationCompleted,
        kIronSourceImpressionDataDidSucceed
    ];
}

#pragma mark - Initialization

- (void)init:(NSString *)appKey adUnits:(NSArray<NSString *> *)adUnits options:(NSDictionary *)options
      resolve:(RCTPromiseResolveBlock)resolve reject:(RCTPromiseRejectBlock)reject {
    if ([appKey length] == 0) {
        reject(@"E_ILLEGAL_ARGUMENT", @"appKey must be provided.", nil);
        return;
    }
    
    [IronSource addImpressionDataDelegate:self];
    
    NSMutableArray<NSString *> *parsedAdUnits = [NSMutableArray new];
    for (NSString *unit in adUnits) {
        if ([unit isEqualToString:REWARDED_VIDEO]) {
            [parsedAdUnits addObject:IS_REWARDED_VIDEO];
        } else if ([unit isEqualToString:INTERSTITIAL]) {
            [parsedAdUnits addObject:IS_INTERSTITIAL];
        } else if ([unit isEqualToString:BANNER]) {
            [parsedAdUnits addObject:IS_BANNER];
        } else {
            reject(@"E_ILLEGAL_ARGUMENT", [NSString stringWithFormat:@"Unsupported ad unit: %@", unit], nil);
            return;
        }
    }
    
    if (parsedAdUnits.count > 0) {
        [IronSource initWithAppKey:appKey adUnits:parsedAdUnits delegate:self];
    } else {
        [IronSource initWithAppKey:appKey delegate:self];
    }
    
    NSNumber *validateIntegration = options[@"validateIntegration"];
    if ([validateIntegration isKindOfClass:[NSNumber class]] && [validateIntegration boolValue]) {
        [ISIntegrationHelper validateIntegration];
    }
    
    resolve(nil);
}

#pragma mark - User Configuration

- (void)addImpressionDataDelegate {
    [IronSource addImpressionDataDelegate:self];
}

- (void)setConsent:(BOOL)consent {
    [IronSource setConsent:consent];
}

- (void)setUserId:(NSString *)userId {
    if (userId != nil && userId.length > 0) {
        [IronSource setUserId:userId];
    }
}

- (void)setDynamicUserId:(NSString *)userId {
    if (userId != nil && userId.length > 0) {
        [IronSource setDynamicUserId:userId];
    }
}

- (void)getAdvertiserId:(RCTPromiseResolveBlock)resolve reject:(RCTPromiseRejectBlock)reject {
    @try {
        resolve([IronSource advertiserId]);
    } @catch (NSException *exception) {
        reject(@"E_ADVERTISER_ID", exception.reason, nil);
    }
}

#pragma mark - ISInitializationDelegate

- (void)initializationDidComplete {
    [self sendEventWithName:kIronSourceInitializationCompleted body:nil];
}

#pragma mark - ISImpressionDataDelegate

- (void)impressionDataDidSucceed:(ISImpressionData *)impressionData {
    NSMutableDictionary *args = [NSMutableDictionary new];
    
    if (impressionData != nil) {
        args[@"auctionId"] = impressionData.auction_id ?: @"";
        args[@"adUnit"] = impressionData.ad_unit ?: @"";
        args[@"country"] = impressionData.country ?: @"";
        args[@"ab"] = impressionData.ab ?: @"";
        args[@"segmentName"] = impressionData.segment_name ?: @"";
        args[@"placement"] = impressionData.placement ?: @"";
        args[@"adNetwork"] = impressionData.ad_network ?: @"";
        args[@"instanceName"] = impressionData.instance_name ?: @"";
        args[@"instanceId"] = impressionData.instance_id ?: @"";
        args[@"revenue"] = impressionData.revenue ?: @(0);
        args[@"precision"] = impressionData.precision ?: @"";
        args[@"lifetimeRevenue"] = impressionData.lifetime_revenue ?: @(0);
        args[@"encryptedCPM"] = impressionData.encrypted_cpm ?: @"";
    }
    
    [self sendEventWithName:kIronSourceImpressionDataDidSucceed body:args];
}

#pragma mark - TurboModule Integration

- (std::shared_ptr<facebook::react::TurboModule>)getTurboModule:
    (const facebook::react::ObjCTurboModule::InitParams &)params {
    return std::make_shared<facebook::react::NativeIronsourceAdvancedSpecJSI>(params);
}

@end