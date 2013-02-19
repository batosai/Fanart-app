//
//  CategoriesServices.m
//  Fanart
//
//  Created by Jérémy chaufourier on 28/08/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "Services.h"
#import "config.h"

@implementation Services

@synthesize count, list, jsonResults;

- (id)initWithStringURL:(NSString *)string
{
    self = [super init];
    if (self) {

        // Construction de l'url à récupérer
        NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:string]];
        
        // execution de la requête et récupération du JSON via un objet NSData
        NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
        
        // On récupère le JSON en NSString depuis la réponse
        response = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        
        json = [ [ SBJsonParser new ] autorelease ];
        jsonResults = [ json objectWithString:response error:&jsonError ];

        NSUInteger reachable = [[jsonResults objectForKey:@"id"] intValue];
        jsonResults = [ jsonResults objectForKey:@"result" ];

        if (jsonResults == nil || !reachable) {
            //NSLog(@"Erreur lors de la lecture du code JSON (%@).", [ jsonError localizedDescription ]);
            [[NSNotificationCenter defaultCenter] postNotificationName:@"Server detection" object:string];
        }
        else
        {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"Server detection" object:nil];
            count = [jsonResults count];

            list = [[NSMutableArray alloc] init];

            for (NSDictionary *result in jsonResults) {
                [list addObject:result];
            }
        }

    }
    
    return self;
}

- (void)dealloc
{
    [jsonError release];
    [response release];
    [list release];

    [super dealloc];
}

@end
