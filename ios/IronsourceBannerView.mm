#import "IronsourceBannerView.h"
#import "IronsourceBanner.h"
#import <IronSource/IronSource.h>

@implementation IronsourceBannerViewController

- (instancetype)init {
    self = [super init];
    return self;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if ([self.delegate respondsToSelector:@selector(viewWillAppear)]) {
        [self.delegate viewWillAppear];
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    if ([self.delegate respondsToSelector:@selector(viewWillDisappear)]) {
        [self.delegate viewWillDisappear];
    }
}

@end

@implementation IronsourceBannerView

#define BannerLoaded @"BannerLoaded"

- (instancetype)init {
    self = [super init];
    if (self) {
        self.active = NO;
        self.viewController = [[IronsourceBannerViewController alloc] init];
        self.viewController.view = self;
        self.viewController.delegate = self;
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(handleBannerLoaded:)
                                                     name:BannerLoaded
                                                   object:nil];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            @synchronized (self) {
                [IronSource loadBannerWithViewController:self.viewController size:ISBannerSize_BANNER];
            }
        });
    }
    return self;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    self.active = NO;
}

- (BOOL)isVisible:(UIView *)view {
    if (view.window == nil) return NO;

    UIView *currentView = view;
    while (currentView.superview) {
        if (!CGRectIntersectsRect(currentView.superview.bounds, currentView.frame) || currentView.isHidden) {
            return NO;
        }
        currentView = currentView.superview;
    }
    return YES;
}

- (void)didMoveToWindow {
    [super didMoveToWindow];
    [self updateVisibility];
}

- (void)didMoveToSuperview {
    [super didMoveToSuperview];
    [self updateVisibility];
}

- (void)viewWillAppear {
    [self updateVisibility];
}

- (void)viewWillDisappear {
    self.active = NO;
}

- (void)handleBannerLoaded:(NSNotification *)notification {
    if (self.active) {
        [self attachBanner];
    }
}

- (void)updateVisibility {
    self.active = [self isVisible:self];
    if (self.active) {
        [self attachBanner];
    } else {
        [self performSelector:@selector(updateVisibility) withObject:nil afterDelay:0.6];
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    if (!self.active) return;
    
    LPMBannerAdView *bannerView = [IronsourceBanner bannerView];
    if (bannerView) {
        CGPoint centerPoint = CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds));
        bannerView.center = centerPoint;
    }
}

- (void)attachBanner {
    @try {
        LPMBannerAdView *bannerView = [IronsourceBanner bannerView];
        if (!bannerView) return;
        
        [bannerView loadAdWithViewController:self.viewController];
        [super addSubview:bannerView];
        
        bannerView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin |
                                      UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
        
        CGPoint centerPoint = CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds));
        bannerView.center = centerPoint;
        
        [self setAccessibilityLabel:@"bannerContainer"];
    }
    @catch (NSException *exception) {
        NSLog(@"Failed to attach banner: %@", exception.reason);
    }
}

@end