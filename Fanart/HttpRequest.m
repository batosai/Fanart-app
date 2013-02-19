//
//  HttpRequest.m
//  PhotoGrabber
//
//  Created by Jérémy chaufourier on 12/07/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "HttpRequest.h"


@implementation HttpRequest

@synthesize url, method, request, body, boundary;

- (id) initUrl:(NSString *) urlString
{
    return [self initUrl:urlString method:@"POST"];
}

- (id) initUrl:(NSString *) urlString
        method:(NSString *) methodString
{
    self = [super init];
    
    if (self) {
        self.url = urlString;
        self.method = methodString;
        self.request = [[NSMutableURLRequest alloc] init];

        [self.request setURL:[NSURL URLWithString:self.url]];
        [self.request setHTTPMethod:self.method];

        self.body = [NSMutableData data];

        self.boundary = [NSString stringWithString:@"---------------------------14737809831466499882746641449"];
        NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@", self.boundary];
        [self.request addValue:contentType forHTTPHeaderField:@"Content-Type"];
    }

    return self;
}

- (NSString *) send
{
    [self.body appendData:[[NSString stringWithFormat:@"--%@--\r\n", self.boundary] dataUsingEncoding:NSUTF8StringEncoding]];

    [self.request setHTTPBody:self.body];

    NSData *returnData = [NSURLConnection sendSynchronousRequest:self.request returningResponse:nil error:nil];
    NSString *returnString = [[NSString alloc] initWithData:returnData encoding:NSUTF8StringEncoding];
    return [returnString autorelease];
}

- (void) addParam:(NSString *) valueString
             name:(NSString *) nameString
{
    [self.body appendData:[[NSString stringWithFormat:@"--%@\r\n", self.boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [self.body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n", nameString] dataUsingEncoding:NSUTF8StringEncoding]];
    [self.body appendData:[[NSString stringWithString:valueString] dataUsingEncoding:NSUTF8StringEncoding]];
    [self.body appendData:[[NSString stringWithString:@"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
}

- (void) addImage:(UIImage *) file
            name:(NSString *) nameString;
{
    NSData *imageData = UIImageJPEGRepresentation(file, 90);
    
    [self.body appendData:[[NSString stringWithFormat:@"--%@\r\n", self.boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [self.body appendData:[[NSString stringWithFormat:@"Content-Disposition: attachment; name=\"userfile\"; filename=\"%@.jpg\"\r\n", nameString] dataUsingEncoding:NSUTF8StringEncoding]];
    [self.body appendData:[[NSString stringWithString:@"Content-Type: application/octet-stream\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
    [self.body appendData:[NSData dataWithData:imageData]];
    [self.body appendData:[[NSString stringWithString:@"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
}

- (void)dealloc
{
    [url release];
    [method release];
    [boundary release];
    [request release];
    [body release];
    [super dealloc];
}

- (NSString *)description
{
    return @"description";
}

@end
