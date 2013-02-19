//
//  PaginationOfThumbnail.m
//  Fanart
//
//  Created by Jérémy chaufourier on 20/08/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//
#import "PaginationOfThumbnailsView.h"

#define WIDTH 104
#define HEIGHT 158
#define MARGIN 2
#define ELEMENTSFORPAGE 9

@implementation PaginationOfThumbnailsView

@synthesize images;

- (id)initWithImages:(NSMutableArray *) array
{
    self = [super init];
    if (self) {
        images = array;

        self.pagingEnabled = YES;
        self.showsVerticalScrollIndicator = NO;
        self.showsHorizontalScrollIndicator = NO;
        self.frame = [self sizeFrame];
        self.contentSize = [self contentSize];

        row = 0;
        col = 0;
        xBounds = .0;
        pageCount = ceil([images count] / 9.0);

        imagesView  = [[NSMutableArray alloc] init];

        for (NSInteger i = 0; i < [images count]; i++)
        {
            [imagesView addObject:[NSNull null]];
        }
    }
    
    return self;
}

- (void)dealloc
{
    [images release];
    [imagesView release];

    for (NSOperation* o in [[NSOperationQueue mainQueue] operations]) {
        if ([o isKindOfClass:[ThumbnailView class]]) {
            [o cancel];
        }
    }
    [super dealloc];
}

- (CGRect)sizeFrame {
    CGRect frame = [[UIScreen mainScreen] bounds];
    frame.size.width += 20; //ajout d'une marge entre les pages

    return frame;
}

- (CGRect)frameForThumbnail:(NSUInteger) index {
    CGRect frameThumbnail;

    NSUInteger presentPage = [self pageForPosition:index];

    NSUInteger x = (col * (WIDTH + MARGIN)) + MARGIN;
    NSUInteger y = (row * (HEIGHT + MARGIN)) + MARGIN;

    if (presentPage > 1) {
        CGRect frame = [self sizeFrame];
        x += (presentPage-1) * frame.size.width;
    }

    frameThumbnail = CGRectMake(x, y, WIDTH, HEIGHT);

    if ((index+1) % 3 == 0 && index != 0) {
        row++;
        col = 0;
    }
    else {
        col++;
    }

    return frameThumbnail;
}

- (CGSize)contentSize {
    CGRect bounds = self.bounds;
    NSUInteger count = ceil([images count] / 9.0);

    return CGSizeMake(bounds.size.width * count, bounds.size.height);
}

// positionner l'image a l'index dans pagingScrollView
- (void)positionAtIndex:(NSUInteger)index {
    CGRect bounds =  self.bounds;
    CGRect pageFrame = bounds;

    pageFrame.origin.x = bounds.size.width * index;

    self.bounds =  pageFrame;

    xBounds = self.bounds.origin.x;

    [self thumbnailsAtPage:index+1];
}

- (NSUInteger) pageForPosition:(NSUInteger) index
{
    return floor(index / 9.0) + 1;
}

- (void)thumbnails:(NSUInteger)index;
{
    if (xBounds < self.bounds.origin.x)
    {//scroll direction droite
        //NSLog(@"page %i", page);
        [self thumbnailsAtPage:index+1];
        [self thumbnailsDeleteAtPage:index-10];
    }
    else
    {//scroll direction gauche
        //NSLog(@"page %i", page);
        [self thumbnailsAtPage:index-1];
        [self thumbnailsDeleteAtPage:index+10];
    }
    xBounds = self.bounds.origin.x;
}

- (void)thumbnailsAtPage:(NSUInteger)index
{
    NSUInteger last = index * ELEMENTSFORPAGE;
    NSUInteger first = last - ELEMENTSFORPAGE;

    if (last > [images count]) {
        last = [images count];
    }

    for (NSUInteger i = first; i < last; i++)
    {
        //if ([isLoadPage indexOfObject:[NSNumber numberWithInteger:i]] == NSNotFound)
        if ([imagesView objectAtIndex:i] == [NSNull null])
        {
            CGRect frame = [self frameForThumbnail:i];
            
            ThumbnailView * thumbnail = [ [ThumbnailView alloc] initWithStringURL:[[images objectAtIndex:i] objectForKey:@"thumbnails"] andFrame:frame ];

            thumbnail.index = i;

            thumbnail.accessibilityLabel = [[images objectAtIndex:i] objectForKey:@"name"];
            thumbnail.delegate =  self.delegate;
            
            [imagesView replaceObjectAtIndex:i withObject:thumbnail];
            
            [self addSubview:thumbnail];
        }
    }
    col = 0;
    row = 0;
}

- (void)thumbnailsDeleteAtPage:(NSInteger) index
{
    NSUInteger last = index * ELEMENTSFORPAGE;
    NSUInteger first = last - ELEMENTSFORPAGE;

    if (last > [images count]) {
        last = [images count];
    }

    if (index >= 0 && index < pageCount)
    {
        for (NSUInteger i = first; i < last; i++)
        {
            if ([imagesView objectAtIndex:i] != [NSNull null])
            {
                //NSLog(@"Delete at index: %i", i);
                [[imagesView objectAtIndex:i] removeFromSuperview];
                [[imagesView objectAtIndex:i] release];
                [imagesView replaceObjectAtIndex:i withObject:[NSNull null]];
            }
        }
    }
}

- (NSMutableArray *)getImageView
{
    return imagesView;
}

@end
