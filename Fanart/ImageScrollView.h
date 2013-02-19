
#import <UIKit/UIKit.h>
#import "NavigationBarController.h"

@interface ImageScrollView : UIScrollView <UIScrollViewDelegate> {
    UIImageView * imageView;
    UIActivityIndicatorView *indicatorView;
    NSUInteger index;

    NavigationBarController *navigationBarController;
}

@property (assign) NSUInteger index;
@property (assign) NavigationBarController *navigationBarController;

- (void)loadImage:(NSString *)string;
- (void)setMinZoomScalesForCurrentBounds;

@end