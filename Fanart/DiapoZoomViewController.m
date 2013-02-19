//
//  DiapoZoomViewController.m
//  DiapoZoom
//
//  Created by Jérémy chaufourier on 08/08/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "DiapoZoomViewController.h"
#import "ImageScrollView.h"

#define PADDING  0
#define MARGIN  20

@implementation DiapoZoomViewController

@synthesize positionFrame, imagesArray, navigationBarController;

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
    UIAlertView *alert = [[UIAlertView alloc]
                          initWithTitle:@"Warning" 
                          message:@"Your device is low on memory..." 
                          delegate:nil 
                          cancelButtonTitle:@"OK" 
                          otherButtonTitles:nil];
    [alert show];
    [alert release];
}

- (id) initWithImages:(NSMutableArray *) array position:(NSUInteger) index
{
    self = [super init];
    if (self) {
        xBounds = .0;
        positionFrame = index;
        imagesArray = array;
        imageCount = [imagesArray count];
        navigationBarController = [[NavigationBarController alloc] init];

        imagesView  = [[NSMutableArray alloc] init];
        for (NSInteger i = 0; i < imageCount; i++)
        {
            [imagesView addObject:[NSNull null]];
        }
    }
    
    return self;
}

- (void)loadView 
{
    [super loadView];
    
    CGRect pagingScrollViewFrame = [self frameForPagingScrollView];
    pagingScrollView = [[UIScrollView alloc] initWithFrame:pagingScrollViewFrame];
    pagingScrollView.pagingEnabled = YES;
    pagingScrollView.backgroundColor = [[[UIColor alloc] initWithRed:41/255.0 green:51/255.0 blue:51/255.0 alpha:1.0] autorelease];
    pagingScrollView.showsVerticalScrollIndicator = NO;
    pagingScrollView.showsHorizontalScrollIndicator = NO;
    pagingScrollView.contentSize = [self contentSizeForPagingScrollView];
    pagingScrollView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    //pagingScrollView.bounces = NO;//interdit les rebonds
    pagingScrollView.delegate = self;

    [self showFramePosition:positionFrame];

    [self.view addSubview:pagingScrollView];
    [self.view addSubview:navigationBarController.view];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    [pagingScrollView release];
    pagingScrollView = nil;
    [imagesArray release];
    imagesArray = nil;
    [imagesView release];
    imagesView = nil;
    [navigationBarController release];
    navigationBarController = nil;
}

- (void)dealloc
{
    [pagingScrollView release];
    [imagesArray release];
    [imagesView release];
    [navigationBarController release];
    [super dealloc];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    //return (interfaceOrientation == UIInterfaceOrientationPortrait);
    return YES;
}

// au début de l'orientation, récupérer l'index de la page visible
- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    CGFloat offset = pagingScrollView.contentOffset.x;
    CGFloat pageWidth = pagingScrollView.bounds.size.width;
    
    if (offset >= 0) {
        firstVisiblePageIndexBeforeRotation = floorf(offset / pageWidth);
        percentScrolledIntoFirstVisiblePage = (offset - (firstVisiblePageIndexBeforeRotation * pageWidth)) / pageWidth;
    } else {
        firstVisiblePageIndexBeforeRotation = 0;
        percentScrolledIntoFirstVisiblePage = offset / pageWidth;
    }
    //NSLog(@"%i", navigationBarController.state);
    if (navigationBarController.state) {
        [navigationBarController hide];
    }
}

// après l'animation de la rotation, on recalcule la taille par rapport à l'écran, 
// on se replace sur la page visible, on reposition correctement les images
- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    pagingScrollView.contentSize = [self contentSizeForPagingScrollView];
    
    for (NSUInteger i = 0; i < imageCount; i++)
    {
        if ([imagesView objectAtIndex:i] != [NSNull null])
        {
            ImageScrollView *page = [imagesView objectAtIndex:i];
            page.frame = [self frameForPageAtIndex:page.index];
            [page setMinZoomScalesForCurrentBounds];
        }
    }

    // adjust contentOffset to preserve page location based on values collected prior to location
    CGFloat pageWidth = pagingScrollView.bounds.size.width;
    CGFloat newOffset = (firstVisiblePageIndexBeforeRotation * pageWidth) + (percentScrolledIntoFirstVisiblePage * pageWidth);
    pagingScrollView.contentOffset = CGPointMake(newOffset, 0);
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{   
    CGFloat offset = scrollView.contentOffset.x;
    CGFloat pageWidth = scrollView.bounds.size.width;

    int position = [[NSNumber numberWithFloat: floorf( (offset / pageWidth) ) ] intValue];

    if (xBounds < pagingScrollView.bounds.origin.x)
    {//scroll direction droite
        [self pagesWithPosition:position+1];
        [self pageDeleteAtIndex:position-5];
    }
    else
    {//scroll direction gauche
        [self pagesWithPosition:position-1];
        [self pageDeleteAtIndex:position+5];
    }
    xBounds = pagingScrollView.bounds.origin.x;
}

// changement de page, remise à l'état initiale du zoom sur toute les pages.
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    CGFloat offset = pagingScrollView.contentOffset.x;
    CGFloat pageWidth = pagingScrollView.bounds.size.width;

    int position = [[NSNumber numberWithFloat: floorf( (offset / pageWidth) ) ] intValue];
    positionFrame = position;

    [self pagesWithPosition:positionFrame];
    
    [self statWithId:position];

    for (NSUInteger i = 0; i < imageCount; i++)
    {
        if ([imagesView objectAtIndex:i] != [NSNull null])
        {
            ImageScrollView *page = [imagesView objectAtIndex:i];
            if( page.index != position) {
                page.zoomScale = page.minimumZoomScale;   
            }
        }
    }
}

// positionnement de pagingScrollView à l'écran (dimension)
- (CGRect)frameForPagingScrollView {
    CGRect frame = [[UIScreen mainScreen] bounds];

    frame.size.width += MARGIN; //ajout d'une marge entre les pages

    return frame;
}

// positionner l'image a l'index dans pagingScrollView
- (CGRect)frameForPageAtIndex:(NSUInteger)index {
    CGRect bounds =  pagingScrollView.bounds;
    CGRect pageFrame = bounds;

    pageFrame.size.width -= MARGIN;
    pageFrame.size.width -= (2 * PADDING);
    pageFrame.origin.x = (bounds.size.width * index) + PADDING;

    return pageFrame;
}

// taille de la zone interne de pagingScrollView
- (CGSize)contentSizeForPagingScrollView {
    CGRect bounds = pagingScrollView.bounds;

    return CGSizeMake(bounds.size.width * imageCount, bounds.size.height);
}

// affiche la page index
- (void)showFramePosition:(NSUInteger)index
{
    CGRect bounds = pagingScrollView.bounds;
    bounds.origin.x = pagingScrollView.frame.size.width * index;
    pagingScrollView.bounds = bounds;
    positionFrame = index;

    [self pagesWithPosition:positionFrame];
    [self pagesWithPosition:positionFrame+1];
    [self pagesWithPosition:positionFrame-1];
    
    [self statWithId:index];
}

// remplissage de pagingScrollView
- (void)pagesWithPosition:(NSInteger)index
{
    if (index < 0)
        index = 0;

    if (index >= imageCount)
        index = imageCount-1;
    
    if ([imagesView objectAtIndex:index] == [NSNull null])
    {
        NSString *type;
        if ([[UIScreen mainScreen] respondsToSelector:@selector(scale)]
            && [[UIScreen mainScreen] scale] == 2.0) {
            type = @"fullRetina";
        } else {
            type = @"full";
        }

        ImageScrollView *page = [[[ImageScrollView alloc] initWithFrame:[self frameForPageAtIndex:index]] autorelease];
        page.index = index;
        page.navigationBarController = navigationBarController;

        [page loadImage:[[imagesArray objectAtIndex:index] objectForKey:type]];

        [pagingScrollView addSubview:page];

        [imagesView replaceObjectAtIndex:index withObject:page];
    }
}

- (void)pageDeleteAtIndex:(NSInteger) index
{
    index--;// page 1 est a l'index 0 etc

    if (index >= 0 && index < imageCount)
    {
        if ([imagesView objectAtIndex:index] != [NSNull null])
        {
            [[imagesView objectAtIndex:index] removeFromSuperview];
            [imagesView replaceObjectAtIndex:index withObject:[NSNull null]];
        }
    }
}

- (void) statWithId:(NSUInteger)index
{
    /*
     * l'id est concidérer comme int pour stringByAppendingString,
     * je le convertit avec stringWithFormat mais lui le voit bien en string...
     */
    NSString *myString = API_VIEW_DRAWING;

    NSString *url = [myString stringByAppendingString:[NSString stringWithFormat:@"%@", [[imagesArray objectAtIndex:index] objectForKey:@"id"]]];

    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
    [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
}

@end
