//
//  ThumbnailsView.h
//  Fanart
//
//  Created by Jérémy chaufourier on 21/08/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@protocol ThumbnailViewDelegate;

@interface ThumbnailView : UIButton {
    NSUInteger index;
    UIActivityIndicatorView *indicatorView;
}

@property (nonatomic, assign) id <ThumbnailViewDelegate> delegate;

@property (assign) NSUInteger index;

- (id)initWithStringURL:(NSString *)string andFrame:(CGRect) frame;

@end

@protocol ThumbnailViewDelegate
- (void)launchDiaporama:(ThumbnailView *)view;
@end