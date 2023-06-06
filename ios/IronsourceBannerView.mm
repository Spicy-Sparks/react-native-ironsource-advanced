#import "IronsourceBannerView.h"
#import <IronSource/IronSource.h>
#import <React/RCTViewManager.h>

@implementation IronsourceBannerView

RCT_EXPORT_MODULE(IronsourceBannerView)

#define BannerLoaded @"BannerLoaded"

- (instancetype)init {
    self = [super init];
    self.loadedBannerView = FALSE;
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleBannerLoaded:) name:BannerLoaded object:nil];
    }
    return self;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    self.loadedBannerView = FALSE;
}

- (UIView *)view {
    self.bannerView = [[UIView alloc] init];
    self.bannerViewController = [[UIViewController alloc] init];
    self.bannerViewController.view = self.bannerView;
    
    dispatch_async(dispatch_get_main_queue(), ^{
        @synchronized(self) {
            ISBannerSize* size = [self getBannerSize:@"BANNER"];
            [IronSource loadBannerWithViewController:self.bannerViewController size:size];
        }
    });
    
    return self.bannerView;
}

- (void)handleBannerLoaded:(NSNotification *)notification {
    if(self.loadedBannerView)
        return;
    self.loadedBannerView = TRUE;
    dispatch_async(dispatch_get_main_queue(), ^{
        @synchronized(self) {
            ISBannerView *bannerView = notification.userInfo[@"view"];
            self.bannerView = [[UIView alloc] init];
            [self.bannerView addSubview:bannerView];

            bannerView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin |
                                       UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;

            CGPoint centerPoint = CGPointMake(CGRectGetMidX(self.bannerView.bounds), CGRectGetMidY(self.bannerView.bounds));
            bannerView.center = centerPoint;

            // Add constraints to center the subview using Auto Layout
            /*
            NSLayoutConstraint *centerXConstraint = [NSLayoutConstraint constraintWithItem:subview attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:parentView attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0.0];
            NSLayoutConstraint *centerYConstraint = [NSLayoutConstraint constraintWithItem:subview attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:parentView attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0.0];

            [parentView addConstraints:@[centerXConstraint, centerYConstraint]];
            */
            
            [self.bannerView setAccessibilityLabel:@"bannerContainer"];
            
            self.bannerViewController.view = self.bannerView;
        }
    });
}

- (ISBannerSize *)getBannerSize:(NSString *)description {
    if([description isEqualToString:@"SMART"]) {
        return ISBannerSize_SMART;
    } else if ([description isEqualToString:@"BANNER"]) {
        return ISBannerSize_BANNER;
    } else if ([description isEqualToString:@"RECTANGLE"]) {
        return ISBannerSize_RECTANGLE;
    } else if ([description isEqualToString:@"LARGE"]) {
        return ISBannerSize_LARGE;
    } else {
        return ISBannerSize_BANNER;
    }
}

@end
