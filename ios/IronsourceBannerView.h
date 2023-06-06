#import <React/RCTViewManager.h>
#import <IronSource/IronSource.h>

@interface IronsourceBannerView : RCTViewManager

@property (nonatomic,strong) ISBannerView* bannerView;
@property (nonatomic,strong) UIViewController* bannerViewController;
@property (nonatomic) BOOL loadedBannerView;

@end
