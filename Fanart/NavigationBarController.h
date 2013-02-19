//
//  NavigationBarController.h
//  Fanart
//
//  Created by Jérémy chaufourier on 24/08/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

@protocol NavigationBarControllerDelegate;

@interface NavigationBarController : UIViewController {
    BOOL state;
}

@property (nonatomic, assign) id <NavigationBarControllerDelegate> delegate;
@property (assign) BOOL state;

- (id)initWithShow;
- (void)show;
- (void)hide;
- (IBAction) bt:(id)sender;

@end

@protocol NavigationBarControllerDelegate
- (void) back:(NavigationBarController *)controller;
@end