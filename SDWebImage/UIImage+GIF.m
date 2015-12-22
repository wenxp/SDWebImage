//
//  UIImage+GIF.m
//  LBGIFImage
//
//  Created by Laurin Brandner on 06.01.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "UIImage+GIF.h"
#import <ImageIO/ImageIO.h>
#import "FLAnimatedImage.h"

@implementation UIImage (GIF)


+ (UIImage *)sd_animatedGIFWithData:(NSData *)data
{
    if (!data)
    {
        return nil;
    }
    
    CGImageSourceRef source = CGImageSourceCreateWithData((__bridge CFDataRef)data, NULL);
    
    size_t count = CGImageSourceGetCount(source);
    
    if (count <= 1)
    {
        CFRelease(source);
        return [UIImage imageWithData:data];
    }
    else if (count>500)
    {
        CFRelease(source);
        return nil;
    }
    else
    {
        CFRelease(source);
        return [FLAnimatedImage imageWithData:data];
    }
    return nil;
}

+ (UIImage *)sd_animatedGIFNamed:(NSString *)name {
    CGFloat scale = [UIScreen mainScreen].scale;
    
    //set up possible paths
    NSString *threeTimesResName = [name stringByAppendingString:@"@3x"];
    NSString *twoTimesResName = [name stringByAppendingString:@"@2x"];
    NSString *normalResName = name;
    
    NSData *data;
    NSString *path;
    
    //get gif for @3x display
    if (scale > 2.0f) {
        path = [[NSBundle mainBundle] pathForResource:threeTimesResName ofType:@"gif"];
        data = [NSData dataWithContentsOfFile:path];
    }
    
    //get gif for 2x display or if there is no @3x resource
    if (scale > 1.0f && !data) {
        path = [[NSBundle mainBundle] pathForResource:twoTimesResName ofType:@"gif"];
        data = [NSData dataWithContentsOfFile:path];
    }
    
    //get gif for non-retina display or if there is no @2x or 3x resource
    if (!data) {
        path = [[NSBundle mainBundle] pathForResource:normalResName ofType:@"gif"];
        data = [NSData dataWithContentsOfFile:path];
    }
    
    //no data yet? maybe there is only a @2x image
    if (!data) {
        path = [[NSBundle mainBundle] pathForResource:twoTimesResName ofType:@"gif"];
        data = [NSData dataWithContentsOfFile:path];
    }
    
    //still no data? could be only a @3x image is provided
    if (!data) {
        path = [[NSBundle mainBundle] pathForResource:threeTimesResName ofType:@"gif"];
        data = [NSData dataWithContentsOfFile:path];
    }
    
    if (data) {
        return [UIImage sd_animatedGIFWithData:data];
    }
    
    //still no resource found --> try to return non-gif image
    return [UIImage imageNamed:name];
}

@end
