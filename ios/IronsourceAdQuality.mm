#import "IronsourceAdQuality.h"

@implementation IronsourceAdQuality

RCT_EXPORT_MODULE()

- (void)init:(NSString *)appKey userId:(NSString *)userId {
    ISAdQualityConfig *adQualityConfig = [ISAdQualityConfig config];
    if (userId != nil && userId.length > 0) {
        adQualityConfig.userId = userId;
    }
    [[IronSourceAdQuality getInstance] initializeWithAppKey:appKey
                                                  andConfig:adQualityConfig];
}

- (void)setUserId:(NSString *)userId {
    if (userId != nil && userId.length > 0) {
        [[IronSourceAdQuality getInstance] changeUserId:userId];
    }
}

- (NSArray<NSString *> *)supportedEvents {
    return @[
        @"INIT_COMPLETED",
        @"INIT_FAILED"
    ];
}

- (void)adQualitySdkInitSuccess {
    [self sendEventWithName:@"INIT_COMPLETED" body:nil];
}

- (void)adQualitySdkInitFailed:(ISAdQualityInitError)error withMessage:(NSString *)message {
    NSMutableDictionary *args = [NSMutableDictionary new];
    args[@"message"] = message;
    args[@"errorCode"] = @(error);
    [self sendEventWithName:@"INIT_FAILED" body:args];
}

// TurboModule Integration
- (std::shared_ptr<facebook::react::TurboModule>)getTurboModule:
    (const facebook::react::ObjCTurboModule::InitParams &)params {
    return std::make_shared<facebook::react::NativeIronsourceAdvancedSpecJSI>(params);
}

@end