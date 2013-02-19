//
//  ToolbarViewController.h
//  AnimatedMenu
//
//  Created by Jérémy chaufourier on 13/08/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ToolbarViewControllerDelegate;

@interface ToolbarViewController : UIViewController {
    BOOL state;

    IBOutlet UISegmentedControl *actions;
}

@property (nonatomic, assign) id <ToolbarViewControllerDelegate> delegate;
@property (assign) BOOL state;
@property (nonatomic, assign) IBOutlet UISegmentedControl *actions;

- (void)show;
- (void)hide;
- (IBAction) bt:(id)sender;

@end

@protocol ToolbarViewControllerDelegate
- (void) filter:(ToolbarViewController *)controller selected:(NSUInteger)index;
@end
