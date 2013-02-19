//
//  ToolbarViewController.m
//  AnimatedMenu
//
//  Created by Jérémy chaufourier on 13/08/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ToolbarViewController.h"

@implementation ToolbarViewController

@synthesize delegate=_delegate;
@synthesize state, actions;

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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)dealloc
{
    [actions release];
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
    [actions release];
    actions = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
/*
-(void)loadView
{
    //[self animate];
}*/

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
    [self.delegate filter:self selected:actions.selectedSegmentIndex];
}

@end
