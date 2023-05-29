#import "IronsourceBannerView.h"
#import <IronSource/IronSource.h>
#import <React/RCTViewManager.h>

@implementation IronsourceBannerView

RCT_EXPORT_MODULE(IronsourceBannerView)

- (UIView *)view
{
    dispatch_async(dispatch_get_main_queue(), ^{
            @synchronized(self) {
                NSDictionary *options = {};
                
                NSString *position = [options valueForKey:@"position"];
                if(position == nil || [[NSNull null] isEqual:position]){
                    return;
                }
                NSString *sizeDescription = [options valueForKey:@"sizeDescription"];
                BOOL hasSizeDescripton = sizeDescription != nil || ![[NSNull null] isEqual:sizeDescription];
                NSNumber *width = [options valueForKey:@"width"];
                NSNumber *height = [options valueForKey:@"height"];
                BOOL hasWidth = width != nil || ![[NSNull null] isEqual:width];
                BOOL hasHeight = height != nil || ![[NSNull null] isEqual:height];
                if(!hasSizeDescripton && !(hasWidth && hasHeight)) {
                    return;
                }
                
                ISBannerSize* size = hasSizeDescripton ? [self getBannerSize:sizeDescription]
                    : [[ISBannerSize alloc] initWithWidth:[width integerValue] andHeight:[height integerValue]];
                
                // Optional params
                NSNumber *verticalOffset = [options valueForKey:@"verticalOffset"];
                NSString *placementName = [options valueForKey:@"placementName"];
                NSNumber *isAdaptive =  [options valueForKey:@"isAdaptive"];
                size.adaptive = [isAdaptive boolValue];
                
                NSNumber *bannerVerticalOffset = (verticalOffset != nil || [[NSNull null] isEqual:verticalOffset]) ? verticalOffset : [NSNumber numberWithInt:0];
                UIViewController *bannerViewController = [self getRootViewController];
                
                // Load banner view
                // if already loaded, console error would be shown by iS SDK
                if(placementName == nil || [[NSNull null] isEqual:placementName]){
                    [IronSource loadBannerWithViewController:bannerViewController size:size];
                } else {
                    [IronSource loadBannerWithViewController:bannerViewController size:size placement:placementName];
                }
            }
        });
    
  return [[UIView alloc] init];
}

- (UIViewController *)getRootViewController {
    return [UIApplication sharedApplication].keyWindow.rootViewController;
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
