//
//  UIImage+XTEmojiImage.m
//  CustomKeyboard
//
//  Created by Tong on 2017/7/6.
//  Copyright © 2017年 Feng. All rights reserved.
//

#import "UIImage+XTEmojiImage.h"

#import "NSBundle+XTEmojiRecources.h"

@implementation UIImage (XTEmojiImage)


/**
 获取 toolBar 图片
 */
+ (UIImage *)getToolBarImageWithName:(NSString *)imageName
{
    NSString *path = [[NSBundle XTEmojiRecourcesBundle] pathForResource:@"toolbarImage" ofType:nil];
    NSString *imagePath = [path stringByAppendingPathComponent:imageName];
    return [UIImage imageWithContentsOfFile:imagePath];
}



/**
 获取 emoji 图片
 
 @param imagePath 表情路径
 @return 表情图片
 */
+ (UIImage *)getEmojiImageWithPath:(NSString *)imagePath
{
    return [UIImage imageNamed:imagePath inBundle:[NSBundle XTEmojiRecourcesBundle] compatibleWithTraitCollection:nil];
}

@end
