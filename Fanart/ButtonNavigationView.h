//
//  ButtonNavigationView.h
//  Fanart
//
//  Created by Jérémy chaufourier on 24/08/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ButtonNavigationViewDelegate;

@interface ButtonNavigationView : UIButton {
}

@property (nonatomic, assign) id <ButtonNavigationViewDelegate> delegate;

@end

@protocol ButtonNavigationViewDelegate
- (void)showNavigation:(ButtonNavigationView *)view;
@end