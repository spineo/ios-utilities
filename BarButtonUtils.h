//
//  BarButtonUtils.h
//  AcrylicsColorPicker
//
//  Created by Stuart Pineo on 5/19/15.
//  Copyright (c) 2015 Stuart Pineo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface BarButtonUtils : NSObject

+ (NSArray *)setButtonImage:(NSArray *)toolbarItems refTag:(int)tag imageName:(NSString *)name;

+ (NSArray *)setButtonName:(NSArray *)toolbarItems refTag:(int)tag buttonName:(NSString *)label;

+ (void)setButtonEnabled:(NSArray *)toolbarItems refTag:(int)refTag isEnabled:(BOOL)isEnabled;

+ (void)setButtonShow:(NSArray *)toolbarItems refTag:(int)refTag;

+ (void)setButtonHide:(NSArray *)toolbarItems refTag:(int)refTag;

+ (void)setButtonTitle:(NSArray *)toolbarItems refTag:(int)refTag title:(NSString *)title;

+ (void)setButtonWidth:(NSArray *)toolbarItems refTag:(int)refTag width:(CGFloat)width;

@end
