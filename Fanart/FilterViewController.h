//
//  FilterViewController.h
//  Fanart
//
//  Created by Jérémy chaufourier on 25/08/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Services.h"
#import "config.h"

@protocol FilterViewControllerDelegate;

@interface FilterViewController : UITableViewController
{
    Services *categoriesServices;
}

@property (nonatomic, assign) id <FilterViewControllerDelegate> delegate;

@end

@protocol FilterViewControllerDelegate
- (void) filterWidthCategory:(FilterViewController *)controller category:(NSString *)index;
@end