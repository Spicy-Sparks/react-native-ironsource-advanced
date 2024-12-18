#import <IronSource/IronSource.h>
#import <React/RCTEventEmitter.h>
#import <React/RCTBridgeModule.h>

@interface IronsourceAdvanced : RCTEventEmitter <RCTBridgeModule, ISImpressionDataDelegate, ISInitializationDelegate>

@end
