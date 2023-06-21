#import "IronsourceAdQuality.h"
#import <IronSourceAdQualitySDK/IronSourceAdQuality.h>

NSString *const kIronSourceAdQualityInitializationCompleted = @"INIT_COMPLETED";
NSString *const kIronSourceAdQualityInitializationFailed = @"INIT_FAILED";

@implementation IronsourceAdQuality

RCT_EXPORT_MODULE()

- (NSArray<NSString *> *)supportedEvents {
    return @[
        kIronSourceAdQualityInitializationCompleted,
        kIronSourceAdQualityInitializationFailed
    ];
}

RCT_EXPORT_METHOD(init:(NSString*) appKey
                  userId:(NSString*)userId) {
    ISAdQualityConfig *adQualityConfig = [ISAdQualityConfig config];
    if(userId != nil && userId.length > 0)
        adQualityConfig.userId = userId;
    [[IronSourceAdQuality getInstance] initializeWithAppKey:appKey andConfig:adQualityConfig];
}

RCT_EXPORT_METHOD(setUserId:(NSString *)userId) {
    if(userId != nil && userId.length > 0)
        [[IronSourceAdQuality getInstance] changeUserId:userId];
}

- (void)adQualitySdkInitSuccess {
    [self sendEventWithName:kIronSourceAdQualityInitializationCompleted body:nil];
}

- (void)adQualitySdkInitFailed:(ISAdQualityInitError) error withMessage:(NSString *)message {
    NSMutableDictionary *args = [[NSMutableDictionary alloc] init];
    args[@"message"] = message;
    [self sendEventWithName:kIronSourceAdQualityInitializationFailed body:args];
}

@end
