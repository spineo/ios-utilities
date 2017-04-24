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

+ (NSArray *)convertToDark3DButton:(NSArray *)toolbarItems refTag:(int)tag;

+ (void)setButtonTitle:(NSArray *)toolbarItems refTag:(int)tag title:(NSString *)title;

+ (void)setButtonImage:(NSArray *)toolbarItems refTag:(int)tag imageName:(NSString *)name;

+ (void)setButtonEnabled:(NSArray *)toolbarItems refTag:(int)tag isEnabled:(BOOL)isEnabled;

+ (void)setButtonShow:(NSArray *)toolbarItems refTag:(int)tag;

+ (void)setButtonHide:(NSArray *)toolbarItems refTag:(int)tag;

+ (void)setButtonWidth:(NSArray *)toolbarItems refTag:(int)tag width:(CGFloat)width;

@end
