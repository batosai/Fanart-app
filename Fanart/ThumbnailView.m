//
//  ThumbnailsView.m
//  Fanart
//
//  Created by Jérémy chaufourier on 21/08/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ThumbnailView.h"
#import "FanartAppDelegate.h"

/*int Random (int _iMin, int _iMax) 
{ 
    return (_iMin + (rand () % (_iMax-_iMin+1))); 
}*/

@implementation ThumbnailView

@synthesize index;
@synthesize delegate=_delegate;

- (id)initWithStringURL:(NSString *)string andFrame:(CGRect) frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        
        NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] init];
        [dictionary setObject:string forKey:@"url"];
        
        indicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        
        CGRect frame = indicatorView.frame;
        frame.origin.x = (self.frame.size.width/2) - (frame.size.width/2);
        frame.origin.y = (self.frame.size.height/2) - (frame.size.height/2);
        indicatorView.frame = frame;

        CALayer *layerRound = self.layer;
        UIColor *borderColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0];

        layerRound.cornerRadius = 5.0;
        layerRound.borderWidth = 1.0;
        layerRound.borderColor = borderColor.CGColor;
        layerRound.masksToBounds = YES;
        
        [self addSubview:indicatorView];
        [indicatorView startAnimating];

        [NSThread detachNewThreadSelector:@selector(startBackgroundLoadImage:) toTarget:self withObject:[dictionary autorelease]];
        
    }

    return self;
}

- (void) dealloc
{
    [indicatorView release];
    [super dealloc];
}
//touchesBegan
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];

    [self.delegate launchDiaporama:self];
}

- (void)startBackgroundLoadImage:(id) dictionary {
    //@synchronized(self) { // ne pas utiliser une ressource qu'un autre thread utilise.
    @try {
        //sleep(Random (1,10));
        NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];

        NSString *url = [dictionary objectForKey:@"url"];

        NSURL* aURL = [NSURL URLWithString:url];
        NSData* data = [[NSData alloc] initWithContentsOfURL:aURL];
        
        UIImage *image = [UIImage imageWithData:[data autorelease]];
        
        [[NSOperationQueue mainQueue] addOperationWithBlock:
         ^(void) {
             [[FanartAppDelegate sharedAppDelegate] didStartNetworking];
             
             if (self) {
                 [indicatorView stopAnimating];
                 [self setImage:image forState:UIControlStateNormal];
                 self.showsTouchWhenHighlighted = YES; 
             }

             [[FanartAppDelegate sharedAppDelegate] didStopNetworking];
         }
         ];
        
        [pool release];
    }
    @catch (NSException * e) {
        NSLog(@"Exception: %@", e);
    }
    @finally {
        //NSLog(@"finally");
    }
    //}	
}

@end
