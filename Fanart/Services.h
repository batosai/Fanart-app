//
//  CategoriesServices.h
//  Fanart
//
//  Created by Jérémy chaufourier on 28/08/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SBJson.h"

@interface Services : NSObject
{
    SBJsonParser *json;
    NSError *jsonError;
    NSDictionary *jsonResults;
    NSString *response;
    
    NSMutableArray *list;
    NSUInteger count;
}

@property (assign) NSUInteger count;
@property (assign) NSMutableArray *list;
@property (assign) NSDictionary *jsonResults;

- (id)initWithStringURL:(NSString *)string;

@end
