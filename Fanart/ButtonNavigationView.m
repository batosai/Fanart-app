//
//  ButtonNavigationView.m
//  Fanart
//
//  Created by Jérémy chaufourier on 24/08/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ButtonNavigationView.h"

@implementation ButtonNavigationView

@synthesize delegate=_delegate;

- (id)init
{
    self = [super init];
    if (self) {
        UIImage *bg = [UIImage imageNamed:@"bt-menu.png"];
        CGRect boundsScreen = [[UIScreen mainScreen] bounds];
        CGRect frame = CGRectMake(boundsScreen.size.width - bg.size.width, 0, bg.size.width, bg.size.height);

        [self setImage:bg forState:UIControlStateNormal];
        self.showsTouchWhenHighlighted = YES;
        self.frame = frame;
        self.alpha = .5;
    }
    
    return self;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
    
    [self.delegate showNavigation:self];
}

@end