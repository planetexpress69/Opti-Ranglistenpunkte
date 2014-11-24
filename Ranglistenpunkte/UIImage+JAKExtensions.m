//
//  UIImage+JAKExtensions.m
//  Ranglistenpunkte
//
//  Created by Martin Kautz on 21.11.14.
//  Copyright (c) 2014 Martin Kautz. All rights reserved.
//

#import "UIImage+JAKExtensions.h"

@implementation UIImage (JAKExtensions)
+ (UIImage *)imageWithColor:(UIColor *)color {
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();

    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);

    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();

    return image;
}
@end
