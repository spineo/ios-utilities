//
//  BarButtonUtils.m
//  AcrylicsColorPicker
//
//  Created by Stuart Pineo on 5/19/15.
//  Copyright (c) 2015 Stuart Pineo. All rights reserved.
//

#import "BarButtonUtils.h"

@implementation BarButtonUtils

// setButtonImage - Given an image name set the image for button associated with refTag
//
+ (NSArray *)setButtonImage:(NSArray *)toolbarItems refTag:(int)tag imageName:(NSString *)name {

    int buttonCount = (int)toolbarItems.count;
    
    UIImage *colorRenderingImage;
    
    for (int i=0; i<buttonCount; i++) {
        UIBarButtonItem *refButton = [toolbarItems objectAtIndex:i];
        int refTag = (int)refButton.tag;
        
        if (refTag == tag) {
            colorRenderingImage = [UIImage imageNamed:name];

            [[toolbarItems objectAtIndex:i] setImage:colorRenderingImage];
            
            break;
        }
    }
    return toolbarItems;
}

// setButtonName - Set the name for button associated with refTag
//
+ (NSArray *)setButtonName:(NSArray *)toolbarItems refTag:(int)tag buttonName:(NSString *)label {
    
    int buttonCount = (int)toolbarItems.count;
    
    for (int i=0; i<buttonCount; i++) {
        UIBarButtonItem *refButton = [toolbarItems objectAtIndex:i];
        int refTag = (int)refButton.tag;
        
        if (refTag == tag) {
            [[toolbarItems objectAtIndex:i] setTitle:label];
            
            break;
        }
    }
    return toolbarItems;
}

+ (void)setButtonEnabled:(NSArray *)toolbarItems refTag:(int)refTag isEnabled:(BOOL)isEnabled {

    int buttonCount = (int)toolbarItems.count;

    for (int i=0; i<buttonCount; i++) {
        UIBarButtonItem *refButton = [toolbarItems objectAtIndex:i];
        int buttonTag = (int)refButton.tag;
        
        if (refTag == buttonTag) {
            [ [toolbarItems objectAtIndex:i ] setEnabled:isEnabled ];
        }
    }
}

+ (void)setButtonShow:(NSArray *)toolbarItems refTag:(int)refTag {
    
    int buttonCount = (int)toolbarItems.count;
    
    for (int i=0; i<buttonCount; i++) {
        UIBarButtonItem *refButton = [toolbarItems objectAtIndex:i];
        int buttonTag = (int)refButton.tag;
        
        if (refTag == buttonTag) {
            [[toolbarItems objectAtIndex:i] setEnabled:TRUE ];
            [[toolbarItems objectAtIndex:i] setTintColor:nil];
        }
    }
}

+ (void)setButtonHide:(NSArray *)toolbarItems refTag:(int)refTag {
    
    int buttonCount = (int)toolbarItems.count;
    
    for (int i=0; i<buttonCount; i++) {
        UIBarButtonItem *refButton = [toolbarItems objectAtIndex:i];
        int buttonTag = (int)refButton.tag;
        
        if (refTag == buttonTag) {
            [[toolbarItems objectAtIndex:i] setEnabled:FALSE];
            [[toolbarItems objectAtIndex:i] setTintColor:[UIColor clearColor]];
        }
    }
}

+ (void)setButtonTitle:(NSArray *)toolbarItems refTag:(int)refTag title:(NSString *)title {
    
    int buttonCount = (int)toolbarItems.count;
    
    for (int i=0; i<buttonCount; i++) {
        UIBarButtonItem *refButton = [toolbarItems objectAtIndex:i];
        int buttonTag = (int)refButton.tag;
        
        if (refTag == buttonTag) {
            [[toolbarItems objectAtIndex:i] setTitle:title];
        }
    }
}

+ (void)setButtonWidth:(NSArray *)toolbarItems refTag:(int)refTag width:(CGFloat)width {
    
    int buttonCount = (int)toolbarItems.count;
    
    for (int i=0; i<buttonCount; i++) {
        UIBarButtonItem *refButton = [toolbarItems objectAtIndex:i];
        int buttonTag = (int)refButton.tag;
        
        if (refTag == buttonTag) {
            [[toolbarItems objectAtIndex:i] setWidth:width ];
        }
    }
}

@end
