#import <IronSource/IronSource.h>
#import <React/RCTEventEmitter.h>
#import <React/RCTBridgeModule.h>

@interface IronsourceBanner : RCTEventEmitter <RCTBridgeModule, LevelPlayBannerDelegate>

@property (class, nonatomic, strong) ISBannerView *bannerView;

@end
