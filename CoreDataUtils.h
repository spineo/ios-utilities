//
//  DataUtils.h
//  RGButterfly
//
//  Created by Stuart Pineo on 2/28/17.
//  Copyright © 2017 Stuart Pineo. All rights reserved.
//
#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "AppDelegate.h"

@interface CoreDataUtils : NSObject

// ManagedObject (requires the 'AppDelegate.h' for the application)
//
+ (int)fetchCount:(NSString *)entityName;

@end
