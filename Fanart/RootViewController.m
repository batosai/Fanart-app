//
//  FanartViewController.m
//  Fanart
//
//  Created by Jérémy chaufourier on 19/08/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "RootViewController.h"
#import "FanartAppDelegate.h"

@implementation RootViewController

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

- (void)dealloc
{
    [paginationOfThumbnailsView release];
    [toolbarViewController release];
    [diapoZoomViewController release];
    [buttonNavigationView release];
    [filterViewController release];
    [reachabilityViewController release];
    [super dealloc];
}

#pragma mark - View lifecycle

/*
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
}
*/

- (void)loadView 
{
    [super loadView];

    toolbarViewController = [[ToolbarViewController alloc] init];
    toolbarViewController.delegate = self;

    [self.view addSubview:toolbarViewController.view];

    buttonNavigationView = [[ButtonNavigationView alloc] init];
    buttonNavigationView.delegate = self;

    [self.view addSubview:buttonNavigationView];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    [paginationOfThumbnailsView release];
    paginationOfThumbnailsView = nil;
    [toolbarViewController release];
    toolbarViewController = nil;
    [diapoZoomViewController release];
    diapoZoomViewController = nil;
    [buttonNavigationView release];
    buttonNavigationView = nil;
    [filterViewController release];
    filterViewController = nil;
    [reachabilityViewController release];
    reachabilityViewController = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)launch
{
    if (!paginationOfThumbnailsView)
        [NSThread detachNewThreadSelector:@selector(insertPaginationWithStringURL:) toTarget:self withObject:API_DRAWINGS];
}

- (void)insertPaginationWithStringURL:(id)stringUrl
{
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];

    CGRect frameThumbnail = CGRectMake(60, 165, 200, 150);
    Indicator *indicator = [[Indicator alloc] initWithFrame:frameThumbnail];
    [self.view insertSubview:indicator atIndex:1];

    NSString * url = stringUrl;

    [[NSOperationQueue mainQueue] addOperationWithBlock:
        ^(void) {
            [[FanartAppDelegate sharedAppDelegate] didStartNetworking];
            if (paginationOfThumbnailsView != nil) {
                [paginationOfThumbnailsView removeFromSuperview];
                [paginationOfThumbnailsView release];
                paginationOfThumbnailsView = nil;
            }

            diapoZoomViewController = nil;
            drawingsServices = [[Services alloc] initWithStringURL:url];
            
            paginationOfThumbnailsView = [[PaginationOfThumbnailsView alloc] initWithImages:drawingsServices.list];

            [self.view insertSubview:paginationOfThumbnailsView atIndex:0];
            paginationOfThumbnailsView.delegate = self;
            //[paginationOfThumbnailsView indicatorsAtPage:1];
            [paginationOfThumbnailsView thumbnailsAtPage:1];
            [paginationOfThumbnailsView thumbnailsAtPage:2];
            //[paginationOfThumbnailsView indicatorsAtPage:2];
            [[FanartAppDelegate sharedAppDelegate] didStopNetworking];
            [indicator removeFromSuperview];
            [indicator release];
        }
     ];

    [pool release];
}

/* Modal pour la perte de connexion au net */
- (void)reachabilityWithString:(NSString *)text
{
    reachabilityViewController = [[ReachabilityViewController alloc] initWithLabel:text];
    
    [self dismissModalViewControllerAnimated:NO];
    
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:NO];
    
    if (toolbarViewController.state)
    {
        [toolbarViewController hide];
        buttonNavigationView.hidden = NO;   
    }

    //dans le cas ou un modal est déjà lancé, il faut laisser le temps quelle se ferme avant de lancer la nouvelle.
    [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(reachabilityModal) userInfo:nil repeats:NO];
}

- (void)reachabilityModal
{
    if (reachabilityViewController != nil)
    {
        [self presentModalViewController:reachabilityViewController animated:YES];
    }
}

/* Modal pour la perte de connexion au serveur */
- (void)reachabilityWithString:(NSString *)text forUrl:(NSString *)url
{
    reachabilityViewController = [[ReachabilityViewController alloc] initWithLabel:text];
    
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:NO];
    
    if (toolbarViewController.state)
    {
        [toolbarViewController hide];
        buttonNavigationView.hidden = NO;   
    }

    [self reachabilityModal];

    [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(launchForUrl:) userInfo:url repeats:NO];
}

- (void)launchForUrl:(NSTimer *)theTimer
{
    NSString *url = [theTimer userInfo];
    [NSThread detachNewThreadSelector:@selector(insertPaginationWithStringURL:) toTarget:self withObject:url];
}

- (void)notReachable
{
    [self dismissModalViewControllerAnimated:YES];
}


#pragma mark - delegate
#warning TODO NSLog(@"add loader.");NSLog(@"Thread."); -> a prevoir.
- (void)launchDiaporama:(ThumbnailView *)view
{
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:NO];

    if (diapoZoomViewController == nil)
    {
        diapoZoomViewController = [[DiapoZoomViewController alloc] initWithImages:drawingsServices.list position:view.index];
        
        diapoZoomViewController.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        diapoZoomViewController.navigationBarController.delegate = self;
    }
    else
    {
        [diapoZoomViewController showFramePosition:view.index];
        [diapoZoomViewController.navigationBarController hide];
    }

    [self presentModalViewController:diapoZoomViewController animated:YES];
#warning TODO - (void)presentViewController:(UIViewController *)viewControllerToPresent animated:(BOOL)flag completion:(void (^)(void))completion
}

- (void) filter:(ToolbarViewController *)controller selected:(NSUInteger)index
{
    if (filterViewController.view != nil) {
        filterViewController.view = nil;
    }

    [[FanartAppDelegate sharedAppDelegate] didStartNetworking];
    if (index == 2) //filtre
    {
        filterViewController = [[FilterViewController alloc] initWithStyle:UITableViewStyleGrouped];
        filterViewController.view.alpha = 0;
        filterViewController.delegate = self;
        [self.view addSubview:filterViewController.view];

        [UIView beginAnimations:nil context:NULL];
        filterViewController.view.alpha += 1;
        [UIView commitAnimations];
    }
    else if(index == 1) // top
    {
        //[self insertPaginationWithStringURL:API_DRAWINGS_FILTER];
        //[paginationOfThumbnailsView removeFromSuperview];
        [NSThread detachNewThreadSelector:@selector(insertPaginationWithStringURL:) toTarget:self withObject:API_DRAWINGS_FILTER];
    }
    else // recent
    {
        //[self insertPaginationWithStringURL:API_DRAWINGS];
        //[paginationOfThumbnailsView removeFromSuperview];
        [NSThread detachNewThreadSelector:@selector(insertPaginationWithStringURL:) toTarget:self withObject:API_DRAWINGS];
    }
    [[FanartAppDelegate sharedAppDelegate] didStopNetworking];
}

- (void) filterWidthCategory:(FilterViewController *)controller category:(NSString *)index
{
    filterViewController.view = nil;
    toolbarViewController.actions.selectedSegmentIndex = UISegmentedControlNoSegment;

    NSString *myString = API_DRAWINGS_CATEGORIES;
    NSString *url = [myString stringByAppendingString: [NSString stringWithFormat:@"%@", index]];

    [paginationOfThumbnailsView removeFromSuperview];
    //[self insertPaginationWithStringURL:url];
    [NSThread detachNewThreadSelector:@selector(insertPaginationWithStringURL:) toTarget:self withObject:url];
}

- (void)back:(NavigationBarController *)controller
{
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:NO];

    NSUInteger index = floor(diapoZoomViewController.positionFrame / 9.0);
    //[paginationOfThumbnailsView indicatorsAtPage:index+1];//page = index + 1, index commence à 0 page à 1
    [paginationOfThumbnailsView positionAtIndex:index];
    [paginationOfThumbnailsView thumbnailsAtPage:index+1];
    [paginationOfThumbnailsView thumbnailsAtPage:index-1];

    if (toolbarViewController.state)
    {
        [toolbarViewController hide];
        buttonNavigationView.hidden = NO;
    }

    [self dismissModalViewControllerAnimated:YES];
}

- (void)showNavigation:(ButtonNavigationView *)view
{
    [toolbarViewController show];
    view.hidden = YES;
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{   
    if (toolbarViewController.state)
    {
        [toolbarViewController hide];
        buttonNavigationView.hidden = NO;   
    }
    
    CGFloat offset = paginationOfThumbnailsView.contentOffset.x;
    CGFloat pageWidth = paginationOfThumbnailsView.bounds.size.width;
    
    int position = [[NSNumber numberWithFloat: floorf( (offset / pageWidth) ) ] intValue] + 1;

    [paginationOfThumbnailsView thumbnails:position];
}

// changement de page 
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    CGFloat offset = paginationOfThumbnailsView.contentOffset.x;
    CGFloat pageWidth = paginationOfThumbnailsView.bounds.size.width;

    int position = [[NSNumber numberWithFloat: floorf( (offset / pageWidth) ) ] intValue] + 1;

    //[paginationOfThumbnailsView indicators:position];// au cas ou on scroll trop vite et que l'on passe pas dans scrollViewWillBeginDragging
    [paginationOfThumbnailsView thumbnailsAtPage:position];
}

@end
