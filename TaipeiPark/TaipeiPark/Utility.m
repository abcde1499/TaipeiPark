//
//  Utility.m
//  TaipeiPark
//
//  Created by Bill Chen on 2017/5/9.
//  Copyright © 2017年 home. All rights reserved.
//

#import "Utility.h"

@implementation Utility

+ (UIImage*)imageCompressWithSimple:(UIImage*)image scaledToSize:(CGSize)size
{
    UIGraphicsBeginImageContext(size);
    [image drawInRect:CGRectMake(0,0, size.width, size.height)];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();

    return newImage;
}

@end
