#import "IronsourceAdvanced.h"
#import "IronsourceInterstitial.h"
#import <IronSource/IronSource.h>

#pragma mark - constants
NSString *const REWARDED_VIDEO = @"REWARDED_VIDEO";
NSString *const INTERSTITIAL = @"INTERSTITIAL";
NSString *const OFFERWALL = @"OFFERWALL";
NSString *const BANNER = @"BANNER";

NSString *const kIronSourceInitializationCompleted = @"INIT_COMPLETED";
NSString *const kIronSourceImpressionDataDidSucceed = @"IMPRESSION_DATA_SUCCEED";

@implementation IronsourceAdvanced {
    RCTResponseSenderBlock _requestRewardedVideoCallback;
}

#pragma mark - instance

+ (instancetype)sharedInstance {
    static IronsourceAdvanced *instance = nil;
    static dispatch_once_t onceToken = 0;
    dispatch_once(&onceToken, ^{
      if (instance == nil) {
          instance = [[IronsourceAdvanced alloc] init];
      }
    });

    return instance;
}

- (dispatch_queue_t)methodQueue
{
    return dispatch_get_main_queue();
}

RCT_EXPORT_MODULE()

- (NSArray<NSString *> *)supportedEvents {
    return @[
        kIronSourceInitializationCompleted,
        kIronSourceImpressionDataDidSucceed
    ];
}

RCT_EXPORT_METHOD(init:(nonnull NSString *)appKey
                  adUnits:(nonnull NSArray<NSString*> *)adUnits
                  options:(NSDictionary *)options
                  withResolver:(RCTPromiseResolveBlock)resolve
                  withRejecter:(RCTPromiseRejectBlock)reject) {
    if([appKey length] == 0){
        return reject(@"E_ILLEGAL_ARGUMENT", @"appKey must be provided.", nil);
    }
    
    [IronSource addImpressionDataDelegate:self];
    
    if(adUnits.count){
        NSMutableArray<NSString*> *parsedAdUnits = [[NSMutableArray alloc]init];
        for(NSString *unit in adUnits){
            if([unit isEqualToString:REWARDED_VIDEO]){
                [parsedAdUnits addObject:IS_REWARDED_VIDEO];
            } else if ([unit isEqualToString:INTERSTITIAL]){
                [parsedAdUnits addObject:IS_INTERSTITIAL];
            } else if ([unit isEqualToString:OFFERWALL]){
                [parsedAdUnits addObject:IS_OFFERWALL];
            } else if ([unit isEqualToString:BANNER]){
                [parsedAdUnits addObject:IS_BANNER];
            } else {
                return reject(@"E_ILLEGAL_ARGUMENT", [NSString stringWithFormat: @"Unsupported ad unit: %@", unit], nil);
            }
        }
    
        [IronSource initWithAppKey:appKey adUnits:parsedAdUnits delegate:self];
    } else {
        [IronSource initWithAppKey:appKey delegate:self];
    }
    
    NSNumber *validateIntegration = options[@"validateIntegration"];
    
    if ([validateIntegration isKindOfClass:[NSNumber class]] && [validateIntegration boolValue]) {
        [ISIntegrationHelper validateIntegration];
    }
    
    return resolve(nil);
}

RCT_EXPORT_METHOD(addImpressionDataDelegate)
{
    [IronSource addImpressionDataDelegate:self];
}

RCT_EXPORT_METHOD(setConsent:(BOOL)consent)
{
    [IronSource setConsent:consent];
}

RCT_EXPORT_METHOD(setUserId:(NSString *)userId)
{
    [IronSource setUserId:userId];
}

RCT_EXPORT_METHOD(setDynamicUserId:(NSString *)userId)
{
    [IronSource setDynamicUserId:userId];
}

RCT_EXPORT_METHOD(getAdvertiserId:(RCTPromiseResolveBlock)resolve reject:(RCTPromiseRejectBlock)reject)
{
    @try {
        resolve([IronSource advertiserId]);
    }
    @catch (NSException *exception) {
        resolve(nil);
    }
}

#pragma mark - ISInitializationDelegate

- (void)initializationDidComplete {
    [self sendEventWithName:kIronSourceInitializationSucceed body:nil];
}

#pragma mark - ISImpressionDataDelegate

- (void)impressionDataDidSucceed:(ISImpressionData *)impressionData {
    [self sendEventWithName:kIronSourceImpressionDataDidSucceed body:@{
        @"auctionId": impressionData.auction_id,
        @"adUnit": impressionData.ad_unit,
        @"country": impressionData.country,
        @"ab": impressionData.ab,
        @"segmentName": impressionData.segment_name,
        @"placement": impressionData.placement,
        @"adNetwork": impressionData.ad_network,
        @"instanceName": impressionData.instance_name,
        @"instanceId": impressionData.instance_id,
        @"revenue": impressionData.revenue,
        @"precision": impressionData.precision,
        @"lifetimeRevenue": impressionData.lifetime_revenue,
        @"encryptedCPM": impressionData.encrypted_cpm
    }];
}

@end
