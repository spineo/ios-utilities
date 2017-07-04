//
//  ColorUtils.m
//  AcrylicsColorPicker
//
//  Created by Stuart Pineo on 5/6/15.
//  Copyright (c) 2015 Stuart Pineo. All rights reserved.
//
#import "ColorUtils.h"

@implementation ColorUtils

// ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
// COLOR return methods
// ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

// getPixelColorAtLocation - Return the UIColor for the Pixel at image location
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

// createARGBBitmapContextFromImage - Get pixel for an image
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

// colorCategoryFromHue - Return the subjective color category that falls within the black/white threshold
// This is just one subjective definition of color category
//
+ (NSString *)colorCategoryFromHue:(int)degHue red:(int)red green:(int)green blue:(int)blue {
    
    // Arbitrary (these values can be redefined)
    //
    int black_threshold = 45;
    int white_threshold = 210;
    
    NSString *colorCategory;
    
    // Black/Off-Black
    //
    if ((red <= black_threshold) && (green <= black_threshold) && (blue <= black_threshold)) {
        colorCategory = @"Black/Dark";
        
        // White/Off-White
        //
    } else if ((red >= white_threshold) && (green >= white_threshold) && (blue >= white_threshold)) {
        colorCategory = @"White/Off-White";
        
        // Red
        //
    } else if ((degHue >= 355) || (degHue <= 10)) {
        colorCategory = @"Red";
        
        // Red-Orange
        //
    } else if ((degHue >= 11) && (degHue <= 20)) {
        colorCategory = @"Red-Orange";
        
        // Orange & Brown
        //
    } else if ((degHue >= 21) && (degHue <= 40)) {
        colorCategory = @"Orange & Brown";
        
        // Orange-Yellow
        //
    } else if ((degHue >= 41) && (degHue <= 50)) {
        colorCategory = @"Orange-Yellow";
        
        // Yellow
        //
    } else if ((degHue >= 51) && (degHue <= 60)) {
        colorCategory = @"Yellow";
        
        // Yellow-Green
        //
    } else if ((degHue >= 61) && (degHue <= 80)) {
        colorCategory = @"Yellow-Green";
        
        // Green
        //
    } else if ((degHue >= 81) && (degHue <= 140)) {
        colorCategory = @"Green";
        
        // Green-Cyan
        //
    } else if ((degHue >= 141) && (degHue <= 169)) {
        colorCategory = @"Green-Cyan";
        
        // Cyan
        //
    } else if ((degHue >= 170) && (degHue <= 200)) {
        colorCategory = @"Cyan";
        
        // Cyan-Blue
        //
    } else if ((degHue >= 201) && (degHue <= 220)) {
        colorCategory = @"Cyan-Blue";
        
        // Blue
        //
    } else if ((degHue >= 221) && (degHue <= 240)) {
        colorCategory = @"Blue";
        
        // Blue-Magenta
        //
    } else if ((degHue >= 241) && (degHue <= 280)) {
        colorCategory = @"Blue-Magenta";
        
        // Magenta
        //
    } else if ((degHue >= 281) && (degHue <= 320)) {
        colorCategory = @"Magenta";
        
        // Magenta-Pink
        //
    } else if ((degHue >= 321) && (degHue <= 330)) {
        colorCategory = @"Magenta-Pink";
        
        // Pink
        //
    } else if ((degHue >= 331) && (degHue <= 345)) {
        colorCategory = @"Pink";
        
        // Pink-Red
        //
    } else if ((degHue >= 346) && (degHue <= 355)) {
        colorCategory = @"Pink-Red";
    }
    
    return colorCategory;
}

// colorFromHexString - Return the UIColor associated with the hex value
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
+ (UIColor *)setBestColorContrast:(NSString *)colorName darkColor:(UIColor *)darkColor lightColor:(UIColor *)lightColor {
    if ([colorName isEqualToString:@"Black"] || [colorName isEqualToString:@"Blue"] ||
        [colorName isEqualToString:@"Brown"] || [colorName isEqualToString:@"Blue Violet"]) {
        
        return lightColor;
    }
    
    return darkColor;
}
/// getSuggestedLineColor - Return suggested UIColor for a border to enable contrast
//
+ (UIColor *)getSuggestedLineColor:(UIImage *)image touchPoint:(CGPoint)touchPoint suggestedLightColor:(UIColor *)lightColor suggestedDarkColor:(UIColor *)darkColor borderThreshold:(CGFloat)borderThreshold {
    
    UIImage *rgbCGImage = [UIImage imageWithCGImage:[image CGImage]];
    
    UIColor *rgbColor = [ColorUtils getPixelColorAtLocation:touchPoint image:rgbCGImage];
    
    CGFloat hue, sat, bri, alpha;
    
    [rgbColor getHue:&hue saturation:&sat brightness:&bri alpha:&alpha];
    
    if (bri < borderThreshold) {
        return lightColor;
    } else {
        return darkColor;
    }
}

// ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
// IMAGE return methods
// ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

// imageWithColor - Return color (i.e., RGB) filled shape
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

// Draw cross-hairs
//
+ (UIImage*)imageWithCrossHairs:(UIImage*)image sizeFraction:(CGFloat)sizeFraction lineColor:(UIColor *)lineColor {
    
    CGSize size = image.size;
    
    // Begin a graphics context of sufficient size
    //
    UIGraphicsBeginImageContext(size);
    
    // draw original image into the context]
    //
    [image drawAtPoint:CGPointZero];
    
    // Get the context for CoreGraphics
    //
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(ctx, 1.0);
    
    CGFloat width  = size.width  * sizeFraction;
    CGFloat height = size.height * sizeFraction ;
    
    [lineColor setStroke];
    
    CGFloat xpoint = (size.width  / 2.0) - width  / 2.0;
    CGFloat ypoint = (size.height / 2.0) - height / 2.0;
    
    // make shape 5 px from border
    //
    CGRect rect = CGRectMake(xpoint, ypoint, width, height);
    CGContextStrokeEllipseInRect(ctx, rect);
    
    // make image out of bitmap context
    //
    UIImage *retImage = UIGraphicsGetImageFromCurrentImageContext();
    
    // Free the context
    //
    UIGraphicsEndImageContext();
    
    
    return retImage;
}

// resizeImage - Return resized image
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

// renderPaint - Return image thumbnail
//
+ (UIImage *)renderPaint:(id)image_thumb cellWidth:(CGFloat)width cellHeight:(CGFloat)height {
    CGSize size = CGSizeMake(width, height);
    
    UIImage *resizedImage   = [self resizeImage:[UIImage imageWithData:image_thumb] imageSize:size];
    
    return resizedImage;
}

// drawTapAreaLabel - Draw numeric label inset image
//
+ (UIImage*)drawTapAreaLabel:(UIImage*)image count:(int)count attrs:(NSDictionary *)attrs inset:(CGFloat)inset {
    UIImage *retImage = image;
    
    NSString *countStr = [[NSString alloc] initWithFormat:@"%i", count];
    
    UIGraphicsBeginImageContext(image.size);
    
    [retImage drawInRect:CGRectMake(0.0, 0.0, image.size.width, image.size.height)];
    CGRect rect = CGRectMake(1.0, 1.0, image.size.width, image.size.height);
    
    // Default attrs are Light Text Color, Tap Area Font, Dark BG Color
    //
    if (attrs == nil)
        attrs = @{NSForegroundColorAttributeName:[UIColor colorWithRed:235.0/255.0 green:255.0/255.0 blue:255.0/255.0 alpha:1.0], NSFontAttributeName:[UIFont systemFontOfSize:10], NSBackgroundColorAttributeName:[UIColor blackColor]};

    [countStr drawInRect:CGRectInset(rect, inset, inset) withAttributes:attrs];
    
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}

// cropImage - Return cropped image
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
// ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
// View Glaze and Background Image methods
// ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

// setGlaze - Choose which view method to invoke
//
+ (void)setGlaze:(id)view {
    if ([view isMemberOfClass:[UIView class]]) {
        [self setViewGlaze:(UIView *)view];
        
    } else if ([view isMemberOfClass:[UINavigationBar class]]) {
        [self setNavBarGlaze:(UINavigationBar *)view];
        
    } else if ([view isMemberOfClass:[UIToolbar class]]) {
        [self setToolbarGlaze:(UIToolbar *)view];
    }
}

// setViewGlaze - UIView glaze
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

// setNavBarGlaze - UINavigationBar glaze
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

// setToolbarGlaze - UIToolbar glaze
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

// setBackgroundImage - Associate specified background image with UIView
//
+ (void)setBackgroundImage:(NSString *)imageName view:(UIView *)view {
    UIGraphicsBeginImageContext(view.frame.size);
    [[UIImage imageNamed:imageName] drawInRect:view.bounds];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    view.backgroundColor = [UIColor colorWithPatternImage:image];
}

@end
