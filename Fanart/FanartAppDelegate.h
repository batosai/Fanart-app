//
//  FanartAppDelegate.h
//  Fanart
//
//  Created by Jérémy chaufourier on 19/08/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Reachability.h"
#import "HttpRequest.h"
#import "config.h"

@class RootViewController;

@interface FanartAppDelegate : NSObject <UIApplicationDelegate>
{
    Reachability* reachability;
    
    NSInteger     _networkingCount;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet RootViewController *viewController;

+ (FanartAppDelegate *)sharedAppDelegate;

- (void) reachabilityChanged: (NSNotification* )note;
- (void) updateInterfaceWithReachability: (Reachability*) curReach;
- (void)reachabilityServer: (NSNotification* )note;
- (NSString *)reachabilityType;
- (void)stat;

- (void)didStartNetworking;
- (void)didStopNetworking;

@end
