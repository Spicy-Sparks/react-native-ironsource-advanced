#import "IronsourceSegment.h"
#import <IronSource/IronSource.h>

@implementation IronsourceSegment {
    ISSegment *segment;
}

RCT_EXPORT_MODULE()

RCT_EXPORT_METHOD(create) {
    segment = [[ISSegment alloc] init];
}

RCT_EXPORT_METHOD(setSegmentName:(NSString *)name) {
    [segment setSegmentName:name];
}

RCT_EXPORT_METHOD(setCustomValue:(NSString *)value forKey:(NSString *)key) {
    [segment setCustomValue:value forKey:key];
}

RCT_EXPORT_METHOD(activate) {
    if (segment) {
        [IronSource setSegment:segment];
    }
}

@end
