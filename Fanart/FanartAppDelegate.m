//
//  FanartAppDelegate.m
//  Fanart
//
//  Created by Jérémy chaufourier on 19/08/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "FanartAppDelegate.h"

#import "RootViewController.h"
#import "ReachabilityViewController.h"

@interface FanartAppDelegate ()
@property (nonatomic, assign) NSInteger networkingCount;
@end

@implementation FanartAppDelegate

+ (FanartAppDelegate *)sharedAppDelegate
{
    return (FanartAppDelegate *) [UIApplication sharedApplication].delegate;
}

@synthesize window = _window;
@synthesize viewController = _viewController;
@synthesize networkingCount = _networkingCount;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    //NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    //NSString *documentsDirectory = [paths objectAtIndex:0];
    //NSLog(@"%@", documentsDirectory);
    
    NSURLCache *sharedCache = [[NSURLCache alloc] initWithMemoryCapacity:0 diskCapacity:0 diskPath:nil];
    [NSURLCache setSharedURLCache:sharedCache];
    [sharedCache removeAllCachedResponses];
    [sharedCache release];
    
    
    // Override point for customization after application launch.
    self.window.rootViewController = self.viewController;//[[ReachabilityViewController alloc] init];
    [self.window makeKeyAndVisible];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reachabilityChanged:) name:kReachabilityChangedNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reachabilityServer:) name:@"Server detection" object:nil];

	reachability = [[Reachability reachabilityWithHostName: @"www.google.com"] retain];
	[reachability startNotifier];
	//[self updateInterfaceWithReachability: reachability];
    [self stat];

    return YES;
}

- (void) reachabilityChanged: (NSNotification* )note
{
	Reachability* curReach = [note object];
	NSParameterAssert([curReach isKindOfClass: [Reachability class]]);
	[self updateInterfaceWithReachability: curReach];
}

/*- (void) updateInterfaceWithReachability: (Reachability*) curReach
{
    if(curReach == reachability)
	{
        BOOL connectionRequired= [curReach connectionRequired];

        if(connectionRequired)
        {
            [self.viewController reachabilityWithString:@"Cette application nécessite une connexion internet."];
        }
        else
        {
            [self.viewController launch];
            [self.viewController notReachable];
        }
    }
}*/

- (void) updateInterfaceWithReachability: (Reachability*) curReach
{
    if(curReach == reachability)
	{
        NetworkStatus netStatus = [curReach currentReachabilityStatus];
        BOOL connectionRequired = [curReach connectionRequired];
        NSString* statusString= @"";
        switch (netStatus)
        {
            case NotReachable:
            {
                statusString = @"Access Not Available";
                //Minor interface detail- connectionRequired may return yes, even when the host is unreachable.  We cover that up here...
                connectionRequired= YES;  
                break;
            }
                
            case ReachableViaWWAN:
            {
                statusString = @"Reachable WWAN";
                connectionRequired= NO;  
                break;
            }
            case ReachableViaWiFi:
            {
                statusString= @"Reachable WiFi";
                connectionRequired= NO;  
                break;
            }
        }
        if(connectionRequired)
        {
            //statusString= [NSString stringWithFormat: @"%@, Connection Required", statusString];
            [self.viewController reachabilityWithString:@"Cette application nécessite une connexion internet."];
        }
        else
        {
            [self.viewController launch];
            [self.viewController notReachable];
        }
        //NSLog(@"%@", statusString);
    }
}

// Vérifie si j'autorise l'accès à l'app
- (void)reachabilityServer: (NSNotification* )note
{//NSLog(@"%@", [note object]);
    if ([note object] != nil)
    {
        NSString * url = [note object];
        [self.viewController reachabilityWithString:@"Le serveur est momentanément indisponible" forUrl:[url autorelease]];
    }
    else
    {
        [self.viewController notReachable];
    }
}

- (NSString *)reachabilityType
{
    NSString *hostName = BASEURL;
    SCNetworkReachabilityRef reach = SCNetworkReachabilityCreateWithName(NULL, [hostName UTF8String]);
    
    SCNetworkReachabilityFlags flags;
    if (SCNetworkReachabilityGetFlags(reach, &flags))
	{
        if ((flags & kSCNetworkReachabilityFlagsIsWWAN) == kSCNetworkReachabilityFlagsIsWWAN)
        {
            return @"WWAN";
        }
        return @"WIFI";
    }
    return @"";
}

- (void)stat
{
    /*NSLog(@"id : %@", [[UIDevice currentDevice] uniqueIdentifier]);
    NSLog(@"model : %@", [[UIDevice currentDevice] model]);
    NSLog(@"name : %@", [[UIDevice currentDevice]name]);
    NSLog(@"name system : %@", [[UIDevice currentDevice]systemName]);
    NSLog(@"v system : %@", [[UIDevice currentDevice]systemVersion]);
    NSLog(@"localizedModel : %@", [[UIDevice currentDevice]localizedModel]);
    NSLog(@"network : %@", [self reachabilityType]);
    NSLog(@"local : %@", [[NSLocale currentLocale] localeIdentifier]);
    NSLog(@"%@", [infos objectForKey:@"CFBundleVersion"]);*/
    
    NSDictionary *infos = [NSDictionary dictionaryWithContentsOfURL:[[NSBundle mainBundle] URLForResource:@"Info" withExtension:@"plist"]];

    HttpRequest *request = [[HttpRequest alloc] initUrl:API_LAUNCH];
    [request addParam:[[UIDevice currentDevice] uniqueIdentifier] name:@"id"];
    [request addParam:[[UIDevice currentDevice] model] name:@"model"];
    [request addParam:[[UIDevice currentDevice]name] name:@"name"];
    [request addParam:[[UIDevice currentDevice]systemName] name:@"system_name"];
    [request addParam:[[UIDevice currentDevice]systemVersion] name:@"system_version"];
    [request addParam:[[UIDevice currentDevice]localizedModel] name:@"localized_model"];
    [request addParam:[[NSLocale currentLocale] localeIdentifier] name:@"locale"];
    [request addParam:[self reachabilityType] name:@"network"];
    [request addParam:[infos objectForKey:@"CFBundleVersion"] name:@"version"];
    [request send];
    [request release];
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
     If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
     */
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    /*
     Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
     */
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    /*
     Called when the application is about to terminate.
     Save data if appropriate.
     See also applicationDidEnterBackground:.
     */
}

- (void)didStartNetworking
{
    self.networkingCount += 1;
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
}

- (void)didStopNetworking
{
    assert(self.networkingCount > 0);
    self.networkingCount -= 1;

    [UIApplication sharedApplication].networkActivityIndicatorVisible = (self.networkingCount != 0);
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [_window release];
    [_viewController release];
    [reachability release];
    [super dealloc];
}

@end
