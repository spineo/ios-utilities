//
//  BarButtonUtils.m
//  AcrylicsColorPicker
//
//  Created by Stuart Pineo on 5/19/15.
//  Copyright (c) 2015 Stuart Pineo. All rights reserved.
//
#import "BarButtonUtils.h"

@implementation BarButtonUtils

// Create 3D Button with Dark Cradient
//
+ (NSArray *)convertToDark3DButton:(NSArray *)toolbarItems refTag:(int)tag {
    
    NSArray *modToolbarItems;
    
    int index = [self getButtonIndex:toolbarItems refTag:tag];
    if (index >= 0) {
        NSMutableArray *mutToolbarItems = [NSMutableArray arrayWithArray:toolbarItems];
        NSString *title = [[modToolbarItems objectAtIndex:index] title];
    
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        
        [button setFrame:CGRectMake(0.0, 0.0, 40.0, 20.0)];
        [button setTitle:title forState:UIControlStateNormal];
        [button setBackgroundColor:[UIColor clearColor]];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        
        [button.layer setMasksToBounds:YES];
        [button.layer setCornerRadius:15.0];
        [button.layer setBorderWidth:1.0];
        [button.layer setBorderColor:[[UIColor whiteColor] CGColor]];
        
        CAGradientLayer *gradient = [CAGradientLayer layer];
        gradient.frame            = button.bounds;
        gradient.colors           = [NSArray arrayWithObjects:(id)[[UIColor blackColor] CGColor], (id)[[UIColor grayColor] CGColor], nil];
        [button.layer insertSublayer:gradient atIndex:0];
        
        [mutToolbarItems replaceObjectAtIndex:index withObject:[[UIBarButtonItem alloc] initWithCustomView:button]];
        modToolbarItems = [mutToolbarItems copy];
    }
    return modToolbarItems;
}


// setButtonImage - Given an image name set the image for button associated with refTag
//
+ (void)setButtonImage:(NSArray *)toolbarItems refTag:(int)tag imageName:(NSString *)name {
    int index = [self getButtonIndex:toolbarItems refTag:tag];
    if (index >= 0) {
        UIImage *colorRenderingImage = [UIImage imageNamed:name];
        [[toolbarItems objectAtIndex:index] setImage:colorRenderingImage];
    }
}

// setButtonName - Set the name for button associated with refTag
//
+ (void)setButtonTitle:(NSArray *)toolbarItems refTag:(int)tag title:(NSString *)title {
    int index = [self getButtonIndex:toolbarItems refTag:tag];
    if (index >= 0) {
        [[toolbarItems objectAtIndex:index] setTitle:title];
    }
}

// setButtonEnabled - Set the button state (enabled or disabled)
//
+ (void)setButtonEnabled:(NSArray *)toolbarItems refTag:(int)tag isEnabled:(BOOL)isEnabled {
    int index = [self getButtonIndex:toolbarItems refTag:tag];
    if (index >= 0) {
        [[toolbarItems objectAtIndex:index] setEnabled:isEnabled];
    }
}

// setButtonShow - Make the button visible
//
+ (void)setButtonShow:(NSArray *)toolbarItems refTag:(int)tag {
    int index = [self getButtonIndex:toolbarItems refTag:tag];
    if (index >= 0) {
        [[toolbarItems objectAtIndex:index] setEnabled:TRUE];
        [[toolbarItems objectAtIndex:index] setTintColor:nil];
    }
}

// setButtonHide - Hide the button
//
+ (void)setButtonHide:(NSArray *)toolbarItems refTag:(int)tag {
    int index = [self getButtonIndex:toolbarItems refTag:tag];
    if (index >= 0) {
        [[toolbarItems objectAtIndex:index] setEnabled:FALSE];
        [[toolbarItems objectAtIndex:index] setTintColor:[UIColor clearColor]];
    }
}

// setButtonWidth - Set the button width (usually works with show/hide)
//
+ (void)setButtonWidth:(NSArray *)toolbarItems refTag:(int)tag width:(CGFloat)width {
    int index = [self getButtonIndex:toolbarItems refTag:tag];
    if (index >= 0) {
        [[toolbarItems objectAtIndex:index] setWidth:width];
    }
}

// getButtonIndex - return toolbar index matching tag or -1 if tag not found
//
+ (int)getButtonIndex:(NSArray *)toolbarItems refTag:(int)tag {
    int buttonCount = (int)[toolbarItems count];
    
    for (int index=0; index<buttonCount; index++) {
        UIBarButtonItem *refButton = [toolbarItems objectAtIndex:index];
        int buttonTag = (int)[refButton tag];
        
        if (tag == buttonTag) {
            return index;
        }
    }
    return -1;
}

@end
