//
//  UIImage+XTEmojiImage.h
//  CustomKeyboard
//
//  Created by Tong on 2017/7/6.
//  Copyright © 2017年 Feng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (XTEmojiImage)


/**
 获取 toolBar 图片
 */
+ (UIImage *)getToolBarImageWithName:(NSString *)imageName;


/**
 获取 emoji 图片

 @param imagePath 表情路径
 @return 表情图片
 */
+ (UIImage *)getEmojiImageWithPath:(NSString *)imagePath;

@end
