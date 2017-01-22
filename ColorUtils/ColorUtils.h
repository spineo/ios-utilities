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
+ (UIColor *)colorFromHexString:(NSString *)hexString;
+ (UIImage *)imageWithColor:(UIColor *)color objWidth:(CGFloat)width objHeight:(CGFloat)height;
+ (UIImage*)resizeImage:(UIImage *)image imageSize:(CGSize)size;
+ (UIImage *)renderPaint:(id)image_thumb cellWidth:(CGFloat)width cellHeight:(CGFloat)height;
+ (UIImage*)drawTapAreaLabel:(UIImage*)image count:(int)count;
+ (UIImage*)drawLabel:(UIImage*)image label:(NSString *)label;
+ (UIImage *)cropImage:(UIImage*)image frame:(CGRect)rect;
+ (UIColor *)setBestColorContrast:(NSString *)colorName;
+ (void)setNavBarGlaze:(UINavigationBar *)navigationBar;
+ (void)setToolbarGlaze:(UIToolbar *)toolbar;
+ (void)setViewGlaze:(UIView *)view;
+ (void)setBackgroundImage:(NSString *)imageName view:(UIView *)view;

@end
