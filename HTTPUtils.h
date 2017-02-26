//
//  HTTPUtils.h - Static HTTP Utilities supporting App Development
//
//  Created by Stuart Pineo on 12/8/16.
//  Copyright © 2016 Stuart Pineo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HTTPUtils : NSObject

+ (BOOL)networkIsReachable;
+ (BOOL)urlIsReachable:(NSString *)urlStr;
+ (BOOL)HTTPGet:(NSString *)urlStr contentType:(NSString *)contentType fileName:(NSString *)fileName authToken:(NSString *)authToken;

@end
