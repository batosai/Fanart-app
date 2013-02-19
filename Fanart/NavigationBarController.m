//
//  NavigationBarController.m
//  Fanart
//
//  Created by Jérémy chaufourier on 24/08/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "NavigationBarController.h"

@implementation NavigationBarController

@synthesize delegate=_delegate;
@synthesize state;

-(id)init
{
    self = [super init];
    if (self) {
        CGRect frame = self.view.frame;
        
        frame.origin.y -= frame.size.height;
        self.view.frame = frame;

        state = NO;
    }
    return self;
}

-(id)initWithShow
{
    self = [super init];

    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
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
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}

- (void)show
{
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:NO];

    CGRect frame = self.view.frame;
    
    [UIView beginAnimations:nil context:NULL];
    frame.origin.y += frame.size.height - 2 + 20; // 20 : hauteur de la bar de statut
    self.view.frame = frame; 
    [UIView commitAnimations];

    state = YES;
}

- (void)hide
{
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:YES];

    CGRect frame = self.view.frame;
    
    [UIView beginAnimations:nil context:NULL];
    frame.origin.y -= frame.size.height - 2 + 20;
    self.view.frame = frame; 
    [UIView commitAnimations];

    state = NO;
}

- (IBAction) bt:(id)sender
{
    [self.delegate back:self];
}


@end
