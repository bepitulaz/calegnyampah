//
//  DDHelper.h
//  Dendang
//
//  Created by Asep Bagja on 3/10/13.
//  Copyright (c) 2013 Bagja. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DDHelper : NSObject

+ (CGFloat)screenWidth;
+ (CGFloat)screenHeight;
+ (UIColor *)colorFromRGB:(NSString *)hexString;
+ (UIImage*)imageWithImage:(UIImage*)sourceImage scaledToWidth:(float)i_width;

@end
