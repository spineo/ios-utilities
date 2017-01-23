//
//  ColorUtils.m
//  AcrylicsColorPicker
//
//  Created by Stuart Pineo on 5/6/15.
//  Copyright (c) 2015 Stuart Pineo. All rights reserved.
//
#import "ColorUtils.h"

@implementation ColorUtils

#define DEF_LIGHT_TEXT_COLOR   [UIColor colorWithRed:235.0/255.0 green:255.0/255.0 blue:255.0/255.0 alpha:1.0]

// ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
// COLOR return methods
// ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

// getPixelColorAtLocation
//
+ (UIColor *)getPixelColorAtLocation:(CGPoint)point image:(UIImage *)cgiImage {
    UIColor* color = nil;
    CGImageRef inImage = cgiImage.CGImage;

    CGContextRef cgctx = [self createARGBBitmapContextFromImage:inImage];
    if (cgctx == NULL) { return nil; /* error */ }
    
    size_t w = CGImageGetWidth(inImage);
    size_t h = CGImageGetHeight(inImage);
    CGRect rect = {{0,0},{w,h}};
    
    CGContextDrawImage(cgctx, rect, inImage);
    
    unsigned char* data = CGBitmapContextGetData (cgctx);
    if (data != NULL) {
        int offset = 4*((w*round(point.y))+round(point.x));
        int alpha =  data[offset];
        int red = data[offset+1];
        int green = data[offset+2];
        int blue = data[offset+3];

        color = [UIColor colorWithRed:(red/255.0f) green:(green/255.0f) blue:(blue/255.0f) alpha:(alpha/255.0f)];
    }
    
    CGContextRelease(cgctx);
    if (data) { free(data); }
    
    return color;
}

// createARGBBitmapContextFromImage
//
+ (CGContextRef)createARGBBitmapContextFromImage:(CGImageRef)inImage {
    CGContextRef    context = NULL;
    CGColorSpaceRef colorSpace;
    void *          bitmapData;
    long            bitmapByteCount;
    long            bitmapBytesPerRow;
    
    size_t pixelsWide = CGImageGetWidth(inImage);
    size_t pixelsHigh = CGImageGetHeight(inImage);
    
    bitmapBytesPerRow   = (pixelsWide * 4);
    bitmapByteCount     = (bitmapBytesPerRow * pixelsHigh);
    
    colorSpace = CGColorSpaceCreateDeviceRGB();
    if (colorSpace == NULL) {
        fprintf(stderr, "Error allocating color space\n");
        return NULL;
    }

    bitmapData = malloc( bitmapByteCount );
    if (bitmapData == NULL) {
        fprintf (stderr, "Memory not allocated!");
        CGColorSpaceRelease( colorSpace );
        return NULL;
    }

    context = CGBitmapContextCreate(bitmapData,
                                    pixelsWide,
                                    pixelsHigh,
                                    8,
                                    bitmapBytesPerRow,
                                    colorSpace,
                                    (CGBitmapInfo)kCGImageAlphaPremultipliedFirst);
    if (context == NULL) {
        free (bitmapData);
        fprintf (stderr, "Context not created!");
    }

    CGColorSpaceRelease( colorSpace );
    
    return context;
}

// colorFromHexString
//
+ (UIColor *)colorFromHexString:(NSString *)hexString {
    unsigned rgbValue = 0;
    NSScanner *scanner = [NSScanner scannerWithString:hexString];
    [scanner setScanLocation:1]; // bypass '#' character
    [scanner scanHexInt:&rgbValue];
    return [UIColor colorWithRed:((rgbValue & 0xFF0000) >> 16)/255.0 green:((rgbValue & 0xFF00) >> 8)/255.0 blue:(rgbValue & 0xFF)/255.0 alpha:1.0];
}

// setBestColorContrast - Method assumes an arbitrary color map (customize as needed)
//
+ (UIColor *)setBestColorContrast:(NSString *)colorName {
    // Dark Text Color
    //
    UIColor *textColor = [UIColor blackColor];
    if ([colorName isEqualToString:@"Black"] || [colorName isEqualToString:@"Blue"] ||
        [colorName isEqualToString:@"Brown"] || [colorName isEqualToString:@"Blue Violet"]) {
        
        // Light Text Color
        //
        textColor = [UIColor colorWithRed:235.0/255.0 green:255.0/255.0 blue:255.0/255.0 alpha:1.0];
    }
    
    return textColor;
}

// ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
// IMAGE return methods
// ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

// imageWithColor
//
+ (UIImage *)imageWithColor:(UIColor *)color objWidth:(CGFloat)width objHeight:(CGFloat)height {
    CGRect rect = CGRectMake(0.0, 0.0, width, height);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    //CGContextStrokeEllipseInRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

// resizeImage
//
+ (UIImage*)resizeImage:(UIImage *)image imageSize:(CGSize)size {
    UIGraphicsBeginImageContext(size);
    
    [image drawInRect:CGRectMake(0,0,size.width,size.height)];
    
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    // Here is the scaled image which has been changed to the size specified
    //
    UIGraphicsEndImageContext();
    
    return newImage;
}

// renderPaint
//
+ (UIImage *)renderPaint:(id)image_thumb cellWidth:(CGFloat)width cellHeight:(CGFloat)height {
    CGSize size = CGSizeMake(width, height);
    
    UIImage *resizedImage   = [self resizeImage:[UIImage imageWithData:image_thumb] imageSize:size];
    
    return resizedImage;
}

// drawTapAreaLabel
//
+ (UIImage*)drawTapAreaLabel:(UIImage*)image count:(int)count {
    UIImage *retImage = image;
    
    NSString *countStr = [[NSString alloc] initWithFormat:@"%i", count];
    
    UIGraphicsBeginImageContext(image.size);
    
    [retImage drawInRect:CGRectMake(0.0, 0.0, image.size.width, image.size.height)];
    CGRect rect = CGRectMake(1.0, 1.0, image.size.width, image.size.height);
    
    // Light Text Color
    // Tap Area Font
    // Dark BG Color
    //
    NSDictionary *attr = @{NSForegroundColorAttributeName:[UIColor colorWithRed:235.0/255.0 green:255.0/255.0 blue:255.0/255.0 alpha:1.0], NSFontAttributeName:[UIFont systemFontOfSize:10], NSBackgroundColorAttributeName:[UIColor blackColor]};
    
    [countStr drawInRect:CGRectInset(rect, 2.0, 2.0) withAttributes:attr];
    
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}

// drawLabel
//
+ (UIImage*)drawLabel:(UIImage*)image label:(NSString *)label {
    UIImage *retImage = image;

    UIGraphicsBeginImageContext(image.size);
    
    [retImage drawInRect:CGRectMake(0.0, 0.0, image.size.width, image.size.height)];
    CGRect rect = CGRectMake(1.0, 1.0, image.size.width, image.size.height);
    
    // Light Text Color
    // Large Tap Area Font
    // Dark BG Color
    //
    NSDictionary *attr = @{NSForegroundColorAttributeName:[UIColor colorWithRed:235.0/255.0 green:255.0/255.0 blue:255.0/255.0 alpha:1.0], NSFontAttributeName:[UIFont systemFontOfSize:12], NSBackgroundColorAttributeName:[UIColor blackColor]};
    
    [label drawInRect:CGRectInset(rect, 2.0, 2.0) withAttributes:attr];
    
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}

// cropImage
//
+ (UIImage *)cropImage:(UIImage*)image frame:(CGRect)rect {
    rect = CGRectMake(rect.origin.x    * image.scale,
                      rect.origin.y    * image.scale,
                      rect.size.width  * image.scale,
                      rect.size.height * image.scale);
    
    CGImageRef imageRef = CGImageCreateWithImageInRect([image CGImage], rect);
    
    UIImage *croppedImage = [UIImage imageWithCGImage:imageRef
                                                scale:image.scale
                                          orientation:image.imageOrientation];
    
    CGImageRelease(imageRef);
    
    return croppedImage;
}

// setViewGlaze
//

// setNavBarGlaze
//
+ (void)setNavBarGlaze:(UINavigationBar *)navigationBar {
    CGRect bounds = navigationBar.bounds;
    UIVisualEffectView *visualEffectView = [[UIVisualEffectView alloc] initWithEffect:[UIBlurEffect effectWithStyle:UIBlurEffectStyleLight]];
    visualEffectView.frame = bounds;
    visualEffectView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [navigationBar addSubview:visualEffectView];
    navigationBar.backgroundColor = [UIColor clearColor];
    [navigationBar sendSubviewToBack:visualEffectView];
}

// setToolbarGlaze
//
+ (void)setToolbarGlaze:(UIToolbar *)toolbar {
    CGRect bounds = toolbar.bounds;
    UIVisualEffectView *visualEffectView = [[UIVisualEffectView alloc] initWithEffect:[UIBlurEffect effectWithStyle:UIBlurEffectStyleLight]];
    visualEffectView.frame = bounds;
    visualEffectView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [toolbar addSubview:visualEffectView];
    toolbar.backgroundColor = [UIColor clearColor];
    [toolbar sendSubviewToBack:visualEffectView];
}

// setViewGlaze
//
+ (void)setViewGlaze:(UIView *)view {
    CGRect bounds = view.bounds;
    UIVisualEffectView *visualEffectView = [[UIVisualEffectView alloc] initWithEffect:[UIBlurEffect effectWithStyle:UIBlurEffectStyleLight]];
    visualEffectView.frame = bounds;
    visualEffectView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [view addSubview:visualEffectView];
    view.backgroundColor = [UIColor clearColor];
    [view sendSubviewToBack:visualEffectView];
}

// setBackgroundImage
//
+ (void)setBackgroundImage:(NSString *)imageName view:(UIView *)view {
    UIGraphicsBeginImageContext(view.frame.size);
    [[UIImage imageNamed:imageName] drawInRect:view.bounds];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    view.backgroundColor = [UIColor colorWithPatternImage:image];
}

@end
