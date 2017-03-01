//
//  DataUtils.m
//  RGButterfly
//
//  Created by Stuart Pineo on 2/28/17.
//  Copyright © 2017 Stuart Pineo. All rights reserved.
//
#import "CoreDataUtils.h"

@interface CoreDataUtils()

//@property (nonatomic, strong) AppDelegate *appDelegate;
@property (nonatomic, strong) NSManagedObjectContext *context;

@end

@implementation CoreDataUtils

- (CoreDataUtils *)init {
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    self.context = [appDelegate managedObjectContext];
    
    return self;
}

- (int)fetchCount:(NSString *)entityName {
    NSEntityDescription *entity = [NSEntityDescription entityForName:entityName inManagedObjectContext:self.context];
    
    NSFetchRequest *fetch = [[NSFetchRequest alloc] init];
    
    [fetch setEntity:entity];
    
    NSError *error      = nil;
    int count = (int)[self.context countForFetchRequest:fetch error:&error];
    
    return count;
}

- (NSArray *)fetchEntity:(NSString *)entityName {
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    
    NSEntityDescription *entity = [NSEntityDescription entityForName:entityName inManagedObjectContext:self.context];
    [fetchRequest setEntity:entity];
    
    NSError *error = nil;
    NSArray *results = [self.context executeFetchRequest:fetchRequest error:&error];
    
    if ([results count] > 0) {
        return results;
    } else {
        return nil;
    }
}

@end
