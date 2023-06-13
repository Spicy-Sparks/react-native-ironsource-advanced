#import <UIKit/UIKit.h>
#import <React/RCTViewManager.h>
#import <IronSource/IronSource.h>

@protocol IronsourceBannerViewControllerDelegate <NSObject>

- (void)viewWillAppear;
- (void)viewWillDisappear;

@end

@interface IronsourceBannerViewController : UIViewController

@property (nonatomic, weak) id<IronsourceBannerViewControllerDelegate> delegate;

@end

@interface IronsourceBannerView : UIView <IronsourceBannerViewControllerDelegate>

@property (nonatomic,strong) IronsourceBannerViewController* viewController;
@property (nonatomic,assign) BOOL active;

@end
