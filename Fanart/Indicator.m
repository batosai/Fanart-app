//
//  Indicator.m
//  Fanart
//
//  Created by Jérémy chaufourier on 31/12/11.
//  Copyright (c) 2011 Jérémy Chaufourier. All rights reserved.
//

#import "Indicator.h"

@implementation Indicator

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor blackColor];
        self.alpha = .85;
        
        UIActivityIndicatorView *indicatorView = [[[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge] autorelease];
        UILabel *label = [[[UILabel alloc] initWithFrame:CGRectMake(50, 100, 150, 20)] autorelease];
        
        label.text = @"Chargement...";
        label.backgroundColor = [UIColor clearColor];
        label.textColor = [UIColor whiteColor];
        
        CGRect frame = indicatorView.frame;
        CALayer *layerRound = self.layer;
        UIColor *borderColor = [UIColor whiteColor];
        
        frame.origin.x = (self.frame.size.width/2) - (frame.size.width/2);
        frame.origin.y = (self.frame.size.height/2) - (frame.size.height/2);
        indicatorView.frame = frame;
        
        layerRound.cornerRadius = 10.0;
        layerRound.borderWidth = 2.0;
        layerRound.borderColor = borderColor.CGColor;
        layerRound.masksToBounds = YES;
        
        [self addSubview:indicatorView];
        [self addSubview:label];
        [indicatorView startAnimating];    }
    return self;
}

@end
