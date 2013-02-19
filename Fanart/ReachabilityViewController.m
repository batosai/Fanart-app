//
//  ReachabilityViewController.m
//  Fanart
//
//  Created by Jérémy chaufourier on 06/09/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ReachabilityViewController.h"

@implementation ReachabilityViewController

-(id)initWithLabel:(NSString *)text
{
    self = [super init];
    if (self) {
        label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 250, 40)];
        
        label.center = self.view.center;
        label.textColor = [[[UIColor alloc] initWithRed:41/255.0 green:51/255.0 blue:51/255.0 alpha:1.0] autorelease];
        label.textAlignment = UITextAlignmentCenter;
        label.numberOfLines = 2;
        label.text = text;
    }
    return self;
}

- (void)loadView
{
    [super loadView];

    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Reachability.png"]];


    [self.view insertSubview:imageView atIndex:0];
    [self.view insertSubview:label atIndex:1];
    [imageView release];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    [label release];
    // Release any cached data, images, etc that aren't in use.
}

- (void)dealloc
{
    [label release];
    [super dealloc];
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    [label release];
    label = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
