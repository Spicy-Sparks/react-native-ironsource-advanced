#import "IronsourceBannerView.h"
#import "IronsourceBanner.h"
#import <Ironsource/IronSource.h>

@implementation IronsourceBannerViewController

- (instancetype)init
{
    self = [super init];
    return self;
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.delegate viewWillAppear];
}

-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.delegate viewWillDisappear];
}

@end

@implementation IronsourceBannerView

#define BannerLoaded @"BannerLoaded"

- (instancetype)init
{
    self = [super init];
    
    self.active = FALSE;
    self.viewController = [[IronsourceBannerViewController alloc] init];
    self.viewController.view = self;
    self.viewController.delegate = self;
    
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleBannerLoaded:) name:BannerLoaded object:nil];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            @synchronized(self) {
                [IronSource loadBannerWithViewController:self.viewController size:ISBannerSize_BANNER];
            }
        });
    }
    
    return self;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    self.active = FALSE;
}

- (BOOL)isVisible:(UIView *)view {
    if (view.window == nil) {
        return NO;
    }
    
    UIView *currentView = view;
    while (currentView.superview) {
        if (!CGRectIntersectsRect(currentView.superview.bounds, currentView.frame)) {
            return NO;
        }
        
        if (currentView.isHidden) {
            return NO;
        }
        
        currentView = currentView.superview;
    }
    
    return YES;
}

- (void)didMoveToWindow {
    [super didMoveToWindow];
    self.active = [self isVisible:self];
    if(self.active)
        [self attachBanner];
    else
        [self performSelector:@selector(updateVisibility) withObject:nil afterDelay:0.6];
}

- (void)didMoveToSuperview {
    [super didMoveToSuperview];
    self.active = [self isVisible:self];
    if(self.active)
        [self attachBanner];
    else
        [self performSelector:@selector(updateVisibility) withObject:nil afterDelay:0.6];
}

- (void)viewWillAppear {
    self.active = [self isVisible:self];
    if(self.active)
        [self attachBanner];
    else
        [self performSelector:@selector(updateVisibility) withObject:nil afterDelay:0.6];
}

- (void)viewWillDisappear {
    self.active = FALSE;
}

- (void)handleBannerLoaded:(NSNotification *)notification {
    if(!self.active)
        return;
    [self attachBanner];
}

- (void)updateVisibility {
    self.active = [self isVisible:self];
    if(self.active)
        [self attachBanner];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    if(!self.active)
        return;
    
    LPMBannerAdView *bannerView = [IronsourceBanner bannerView];
    
    if (bannerView != nil) {
        CGPoint centerPoint = CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds));
        bannerView.center = centerPoint;
    }
}

- (void)attachBanner {
    @try {
        LPMBannerAdView *bannerView = [IronsourceBanner bannerView];
        
        if(bannerView == nil)
            return;
        
        [bannerView loadAdWithViewController:self.viewController];
        [super addSubview:bannerView];
        
        bannerView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin |
        UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
        
        CGPoint centerPoint = CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds));
        bannerView.center = centerPoint;
        
        /*NSLayoutConstraint *centerXConstraint = [NSLayoutConstraint constraintWithItem:bannerView attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0.0];
         NSLayoutConstraint *centerYConstraint = [NSLayoutConstraint constraintWithItem:bannerView attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0.0];
         
         [super addConstraints:@[centerXConstraint, centerYConstraint]];*/
        
        [self setAccessibilityLabel:@"bannerContainer"];
    }
    @catch (NSException *exception) { }
}

@end
