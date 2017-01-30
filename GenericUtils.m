//
//  GenericUtils.m
//  AcrylicsColorPicker
//
//  Created by Stuart Pineo on 2/13/16.
//  Copyright © 2016 Stuart Pineo. All rights reserved.
//
#import "GenericUtils.h"

@implementation GenericUtils

// For random float between 0 and 1 generation
//
#define ARC4RANDOM_MAX      0x100000000


// trimStrings - Remove whitespace characters from both ends of each string of an array of strings
//
+ (NSMutableArray *)trimStrings:(NSArray *)stringList {
    NSMutableArray *trimmedStrings = [[NSMutableArray alloc] init];
    for (NSString *string in stringList) {
        [trimmedStrings addObject:[self trimString:string]];
    }
    return trimmedStrings;
}

// trimString - Remove whitespace characters from both ends of a single string
//
+ (NSString *)trimString:(NSString *)string {
    return [string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
}

// removeSpaces - Remove all spaces within a string
//
+ (NSString *)removeSpaces:(NSString *)string {
    return [string stringByReplacingOccurrencesOfString:@" " withString:@""];
}

// getCurrDateString - Return the current date string in a specified format (i.e., @"YYYY-MM-dd HH:mm:ss")
//
+ (NSString *)getCurrDateString:(NSString *)dateFormat {
    NSDate *currentDate = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
    [dateFormatter setDateFormat:dateFormat];

    return [dateFormatter stringFromDate:currentDate];
}

// getRandomVal - Return a random float between 0 and 1
//
+ (float)getRandomVal {
    return (float)((double)arc4random() / ARC4RANDOM_MAX);
}

@end
