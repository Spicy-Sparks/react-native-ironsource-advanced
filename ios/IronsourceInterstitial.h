#import <IronSource/IronSource.h>
#import <React/RCTEventEmitter.h>
#import <React/RCTBridgeModule.h>

@interface IronsourceInterstitial : RCTEventEmitter <RCTBridgeModule, LevelPlayInterstitialDelegate>

@end
