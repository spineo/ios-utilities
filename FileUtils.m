//
//  FileUtils.m
//
//  Created by Stuart Pineo on 12/8/16.
//  Copyright © 2016 Stuart Pineo. All rights reserved.
//
#import "FileUtils.h"

@implementation FileUtils


// Default sleep duration for asynchronous threads
//
NSTimeInterval const ASYNC_THREAD_SLEEP = .5;


// fileRemove - Remove a file
// Parameters:
// filePath   : Path/file of file to remove
// fileManager: NSFileManager is Foundation’s high-level API for working with file systems
//
+ (BOOL)fileRemove:(NSString *)filePath fileManager:(NSFileManager *)fileManager {
    if (fileManager == nil)
        fileManager = [NSFileManager defaultManager];
    
    if ([fileManager isDeletableFileAtPath:filePath]) {
        NSError *error = nil;
        [fileManager removeItemAtPath:filePath error:&error];
        
        // Ensure that file is fully removed (this needs a time out)
        //
        while([fileManager isReadableFileAtPath:filePath]) {
            [NSThread sleepForTimeInterval:ASYNC_THREAD_SLEEP];
        }

        if (error == nil) {
            NSLog(@"Successfully removed file '%@'", filePath);
            return TRUE;
            
        } else {
            NSLog(@"Failed to remove file '%@', ERROR: %@\n", filePath, [error localizedDescription]);
            return FALSE;
        }
    }
    return FALSE;
}

// fileRename - Rename a file
// Parameters:
// srcFilePath : Path/file of the the file to copy
// destFilePath: Path/file to the destination file
// fileManager : NSFileManager is Foundation’s high-level API for working with file systems
//
+ (BOOL)fileRename:(NSString *)srcFilePath destFilePath:(NSString *)destFilePath fileManager:(NSFileManager *)fileManager {
    
    if (fileManager == nil)
        fileManager = [NSFileManager defaultManager];
    
    // Remove first
    //
    if ([self fileRemove:destFilePath fileManager:fileManager] == FALSE) {
        NSLog(@"ERROR: Failed to remove file '%@'", destFilePath);
    }
    
    NSError *error = nil;
    [fileManager copyItemAtPath:srcFilePath toPath:destFilePath error:&error];
    
    if (error == nil) {
        NSLog(@"Successfully renamed file '%@' to '%@'", srcFilePath, destFilePath);
        return TRUE;
        
    } else {
        NSLog(@"Failed to rename file '%@' to '%@'. ERROR: %@\n", srcFilePath, destFilePath, [error localizedDescription]);
        return FALSE;
    }
}

// lineFromFile - Return the first line from a file (useful for extracting version, md5, authtoken, etc. coded in a file)
// Parameters:
// filePath: Path/file
//
+ (NSString *)lineFromFile:(NSString *)filePath {
    return [[NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil] stringByReplacingOccurrencesOfString:@"\n" withString:@""];
}

// md5Hash - Compute and return the md5 checksum value associated with a file
// Parameters:
// filePath   : File/path of the file for which the md5 checksum value is computed
// fileManager: NSFileManager is Foundation’s high-level API for working with file systems
//
+ (NSString *)md5Hash:(NSString *)filePath fileManager:(NSFileManager *)fileManager {
    
    if (fileManager == nil)
        fileManager = [NSFileManager defaultManager];
    
    if( [fileManager fileExistsAtPath:filePath isDirectory:nil] ) {
        NSData *data = [NSData dataWithContentsOfFile:filePath];
        unsigned char digest[CC_MD5_DIGEST_LENGTH];
        CC_MD5( data.bytes, (CC_LONG)data.length, digest );
        
        NSMutableString *output = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
        
        for( int i = 0; i < CC_MD5_DIGEST_LENGTH; i++ ) {
            [output appendFormat:@"%02x", digest[i]];
        }
        
        return output;
        
    } else {
        return @"";
    }
}

@end
