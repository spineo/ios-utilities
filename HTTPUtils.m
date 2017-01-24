//
//  HTTPUtils.m
//
//  Created by Stuart Pineo on 12/8/16.
//  Copyright © 2016 Stuart Pineo. All rights reserved.
//

#import "HTTPUtils.h"

// Requires these External Utilities
//
#import "Reachability.h"
#import "NSData+Base64.h"

@implementation HTTPUtils

// networkIsReachable - Check for network connectivity
//
+ (BOOL)networkIsReachable {
    Reachability *networkReachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus networkStatus = [networkReachability currentReachabilityStatus];
    if (networkStatus == NotReachable) {
        return FALSE;
    } else {
        return TRUE;
    }
}

// HTTPGet - HTTP GET wrapper that optionally enables Basic Authorization
// Parameters:
// urlStr     : Target URL
// contentType: HTTP Content-Type
// fileName   : Name of file writting content to
// authToken  : Optional authorization token (i.e., colon delimited user and password)
//
+ (BOOL)HTTPGet:(NSString *)urlStr contentType:(NSString *)contentType fileName:(NSString *)fileName authToken:(NSString *)authToken {
    
    __block BOOL stat = FALSE;
    
    // Need to extends URL string encoding (use a generic method)
    //
    urlStr = [urlStr stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
    
    NSURL *url = [NSURL URLWithString:urlStr];
    
    NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:config];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
    
    request.HTTPMethod = @"GET";
    [request setValue:[[NSString alloc] initWithFormat:@"%@", contentType] forHTTPHeaderField:@"Content-Type"];

    if (authToken != nil) {
        NSData *authData = [authToken dataUsingEncoding:NSASCIIStringEncoding];
        NSString *authValue = [NSString stringWithFormat:@"Basic %@", [authData base64EncodingWithLineLength:80]];
        [request setValue:authValue forHTTPHeaderField:@"Authorization"];
    } else {
        NSLog(@"Note: The value for 'authToken' is nil");
    }

    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);

    NSURLSessionTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (data) {
            NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse*)response;

            if (httpResponse.statusCode == 200) {
                [data writeToFile:fileName atomically:YES];
                stat = TRUE;
            } else {
                NSLog(@"File write error for file '%@'\n", fileName);
            }
        }
        dispatch_semaphore_signal(semaphore);
        
    }];
    
    [task resume];
    
    dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
    
    return stat;
}

@end