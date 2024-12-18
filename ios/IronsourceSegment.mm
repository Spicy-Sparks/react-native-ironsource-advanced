#import "IronsourceSegment.h"
#import <IronSource/IronSource.h>

@implementation IronsourceSegment {
    ISSegment *segment;
}

#pragma mark - Module Registration

RCT_EXPORT_MODULE()

#pragma mark - Segment Methods

- (void)create {
    segment = [[ISSegment alloc] init];
}

- (void)setSegmentName:(NSString *)name {
    if (segment && name) {
        [segment setSegmentName:name];
    }
}

- (void)setCustomValue:(NSString *)value forKey:(NSString *)key {
    if (segment && value && key) {
        [segment setCustomValue:value forKey:key];
    }
}

- (void)activate {
    if (segment) {
        [IronSource setSegment:segment];
    }
}

- (std::shared_ptr<facebook::react::TurboModule>)getTurboModule:
    (const facebook::react::ObjCTurboModule::InitParams &)params
{
    return std::make_shared<facebook::react::NativeIronsourceAdvancedSpecJSI>(params);
}

@end