//
//  HttpRequest.h
//  PhotoGrabber
//
//  Created by Jérémy chaufourier on 12/07/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface HttpRequest : NSObject {
    NSString *url, *method, *boundary;
    NSMutableURLRequest *request;
    NSMutableData *body;
}

@property (nonatomic,retain) NSString *url, *method, *boundary;
@property (nonatomic,retain) NSMutableURLRequest *request;
@property (nonatomic,retain) NSMutableData *body;

- (id) initUrl:(NSString *) urlString;
- (id) initUrl:(NSString *) urlString method:(NSString *) methodString;
- (NSString *) send;
- (void) addParam:(NSString *) valueString name:(NSString *) nameString;
- (void) addImage:(UIImage *) file name:(NSString *) nameString;

@end
