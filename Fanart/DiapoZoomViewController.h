//
//  DiapoZoomViewController.h
//  DiapoZoom
//
//  Created by Jérémy chaufourier on 08/08/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NavigationBarController.h"
#import "HttpRequest.h"
#import "config.h"

@interface DiapoZoomViewController : UIViewController <UIScrollViewDelegate> {
    UIScrollView *pagingScrollView;
    
    NSMutableArray *imagesArray;
    NSMutableArray *imagesView;

    NSInteger positionFrame;
    int firstVisiblePageIndexBeforeRotation;
    CGFloat percentScrolledIntoFirstVisiblePage;
    int imageCount;

    float xBounds;

    NavigationBarController *navigationBarController;
}

@property (assign) NSInteger positionFrame;
@property (nonatomic,retain) NSArray *imagesArray;
@property (assign) NavigationBarController *navigationBarController;

- (id)initWithImages:(NSMutableArray *) array position:(NSUInteger) index;
- (CGRect)frameForPagingScrollView;
- (CGRect)frameForPageAtIndex:(NSUInteger)index;
- (CGSize)contentSizeForPagingScrollView;
- (void)showFramePosition:(NSUInteger)index;
- (void)pagesWithPosition:(NSInteger)index;
- (void)pageDeleteAtIndex:(NSInteger) index;

- (void) statWithId:(NSUInteger)index;

@end