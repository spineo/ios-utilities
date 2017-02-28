//
//  DataUtils.m
//  RGButterfly
//
//  Created by Stuart Pineo on 2/28/17.
//  Copyright © 2017 Stuart Pineo. All rights reserved.
//
#import "CoreDataUtils.h"

@implementation CoreDataUtils

+ (int)fetchCount:(NSString *)entityName {
    
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context = [appDelegate managedObjectContext];
    
    NSEntityDescription *entity = [NSEntityDescription entityForName:entityName inManagedObjectContext:context];
    
    NSFetchRequest *fetch = [[NSFetchRequest alloc] init];
    
    [fetch setEntity:entity];
    
    NSError *error      = nil;
    int count = (int)[context countForFetchRequest:fetch error:&error];
    
    return count;
}

@end
