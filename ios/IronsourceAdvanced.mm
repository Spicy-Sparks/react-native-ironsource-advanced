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

#pragma mark - Instance

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
    if(userId != nil)
        [IronSource setUserId:userId];
}

RCT_EXPORT_METHOD(setDynamicUserId:(NSString *)userId)
{
    if(userId != nil)
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
    [self sendEventWithName:kIronSourceInitializationCompleted body:nil];
}

#pragma mark - ISImpressionDataDelegate

- (void)impressionDataDidSucceed:(ISImpressionData *)impressionData {
    NSMutableDictionary *args = [[NSMutableDictionary alloc] init];
    if(impressionData != nil){
        if(impressionData.auction_id != nil) {
            args[@"auctionId"] = impressionData.auction_id;
        }
        if(impressionData.ad_unit != nil) {
            args[@"adUnit"] = impressionData.ad_unit;
        }
        if(impressionData.country != nil) {
            args[@"country"] = impressionData.country;
        }
        if(impressionData.ab != nil) {
            args[@"ab"] = impressionData.ab;
        }
        if(impressionData.segment_name != nil) {
            args[@"segmentName"] = impressionData.segment_name;
        }
        if(impressionData.placement != nil) {
            args[@"placement"] = impressionData.placement;
        }
        if(impressionData.ad_network != nil) {
            args[@"adNetwork"] = impressionData.ad_network;
        }
        if(impressionData.instance_name != nil) {
            args[@"instanceName"] = impressionData.instance_name;
        }
        if(impressionData.instance_id != nil) {
            args[@"instanceId"] = impressionData.instance_id;
        }
        if(impressionData.revenue != nil) {
            args[@"revenue"] = impressionData.revenue;
        }
        if(impressionData.precision != nil) {
            args[@"precision"] = impressionData.precision;
        }
        if(impressionData.lifetime_revenue != nil) {
            args[@"lifetimeRevenue"] = impressionData.lifetime_revenue;
        }
        if(impressionData.encrypted_cpm != nil) {
            args[@"encryptedCPM"] = impressionData.encrypted_cpm;
        }
    }
    [self sendEventWithName:kIronSourceImpressionDataDidSucceed body:args];
}

@end
