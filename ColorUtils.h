//
//  ColorUtils.h
//  AcrylicsColorPicker
//
//  Created by Stuart Pineo on 5/6/15.
//  Copyright (c) 2015 Stuart Pineo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface ColorUtils : NSObject

+ (UIColor*)getPixelColorAtLocation:(CGPoint)point image:(UIImage *)cgiImage;

+ (CGContextRef)createARGBBitmapContextFromImage:(CGImageRef)inImage;
+ (NSString *)colorCategoryFromHue:(int)degHue red:(int)red green:(int)green blue:(int)blue;
+ (UIColor *)colorFromHexString:(NSString *)hexString;
+ (UIColor *)setBestColorContrast:(NSString *)colorName darkColor:(UIColor *)darkColor lightColor:(UIColor *)lightColor;
+ (UIColor *)getSuggestedLineColor:(UIImage *)image touchPoint:(CGPoint)touchPoint suggestedLightColor:(UIColor *)lightColor suggestedDarkColor:(UIColor *)darkColor borderThreshold:(CGFloat)borderThreshold;
+ (UIImage *)imageWithColor:(UIColor *)color objWidth:(CGFloat)width objHeight:(CGFloat)height;
+ (UIImage*)imageWithCrossHairs:(UIImage*)image sizeFraction:(CGFloat)sizeFraction lineColor:(UIColor *)lineColor;
+ (UIImage*)resizeImage:(UIImage *)image imageSize:(CGSize)size;
+ (UIImage *)renderPaint:(id)image_thumb cellWidth:(CGFloat)width cellHeight:(CGFloat)height;
+ (UIImage*)drawTapAreaLabel:(UIImage*)image count:(int)count attrs:(NSDictionary *)attrs inset:(CGFloat)inset;
+ (UIImage *)cropImage:(UIImage*)image frame:(CGRect)rect;

+ (void)setGlaze:(id)view;
+ (void)setBackgroundImage:(NSString *)imageName view:(UIView *)view;

@end
