//
//  FileUtils.h - Static File Utilities supporting App Development
//
//  Created by Stuart Pineo on 12/8/16.
//  Copyright © 2016 Stuart Pineo. All rights reserved.
//
#import <Foundation/Foundation.h>
#include <CommonCrypto/CommonDigest.h>

@interface FileUtils : NSObject

+ (BOOL)fileRemove:(NSString *)filePath fileManager:(NSFileManager *)fileManager;

+ (BOOL)fileRename:(NSString *)srcFilePath destFilePath:(NSString *)destFilePath fileManager:(NSFileManager *)fileManager;

+ (NSString *)lineFromFile:(NSString *)filePath;

+ (NSString *)md5Hash:(NSString *)path fileManager:(NSFileManager *)fileManager;

@end
