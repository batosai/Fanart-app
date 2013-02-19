//
//  PaginationOfThumbnail.h
//  Fanart
//
//  Created by Jérémy chaufourier on 20/08/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ThumbnailView.h"

@interface PaginationOfThumbnailsView : UIScrollView {
    NSMutableArray * images;
    NSMutableArray *imagesView;

    NSUInteger row;
    NSUInteger col;
    NSUInteger pageCount;

    float xBounds;
}

@property (nonatomic,retain) NSArray *images;

- (id)initWithImages:(NSArray *) array;
- (CGRect)sizeFrame;
- (CGRect)frameForThumbnail:(NSUInteger) index;
- (CGSize)contentSize;
- (void)positionAtIndex:(NSUInteger)index;
- (NSUInteger)pageForPosition:(NSUInteger)index;

- (void)thumbnails:(NSUInteger)index;
- (void)thumbnailsAtPage:(NSUInteger)index;
- (void)thumbnailsDeleteAtPage:(NSInteger) index;

- (NSMutableArray *)getImageView;

@end