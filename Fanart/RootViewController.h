//
//  FanartViewController.h
//  Fanart
//
//  Created by Jérémy chaufourier on 19/08/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PaginationOfThumbnailsView.h"
#import "ThumbnailView.h"
#import "DiapoZoomViewController.h"
#import "ImageScrollView.h"
#import "ButtonNavigationView.h"
#import "ToolbarViewController.h"
#import "NavigationBarController.h"
#import "FilterViewController.h"
#import "ReachabilityViewController.h"
#import "Indicator.h"

#import "config.h"
#import "Services.h"

@interface RootViewController : UIViewController <ThumbnailViewDelegate, ToolbarViewControllerDelegate, NavigationBarControllerDelegate, ButtonNavigationViewDelegate, UIScrollViewDelegate, FilterViewControllerDelegate> {
    Services *drawingsServices;
    PaginationOfThumbnailsView *paginationOfThumbnailsView;
    ToolbarViewController *toolbarViewController;
    ButtonNavigationView *buttonNavigationView;
    DiapoZoomViewController *diapoZoomViewController;
    FilterViewController *filterViewController;
    ReachabilityViewController *reachabilityViewController;
}

- (void)launch;
- (void)insertPaginationWithStringURL:(id)stringUrl;
- (void)reachabilityModal;
- (void)reachabilityWithString:(NSString *)text;
- (void)reachabilityWithString:(NSString *)text forUrl:(NSString *)url;
- (void)notReachable;


@end