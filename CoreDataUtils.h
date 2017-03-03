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
- (CoreDataUtils *)init;
- (int)fetchCount:(NSString *)entityName;
- (NSArray *)fetchEntity:(NSString *)entityName;
- (NSArray *)fetchedEntityHasId:(NSString *)entityName attrName:(NSString *)attrName value:(int)value;
- (id)queryDictionary:(NSString *)entityName nameValue:(NSString *)nameValue;

@end
